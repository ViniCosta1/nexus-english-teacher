import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';

dotenv.config();

const currentDir = path.dirname(fileURLToPath(import.meta.url));
// Flutter web build is copied here by scripts/build-web.sh. Resolves to
// api/public in both dev (src/) and production (dist/) layouts.
const publicDir = path.join(currentDir, '..', 'public');

const openAIRealtimeUrl = 'https://api.openai.com/v1/realtime/client_secrets';
const openAISpeechUrl = 'https://api.openai.com/v1/audio/speech';
const maxSpeechTextLength = 200;
const speechRateLimitWindowMs = 60_000;
const speechRateLimitMaxRequests = 10;

type ClientSecretResponse = {
  value?: string;
  expires_at?: number;
};

export function createApp() {
  const app = express();
  const speechRequestCounts = new Map<
    string,
    { count: number; resetAt: number }
  >();
  const allowedOrigins =
    process.env.APP_ALLOWED_ORIGINS?.split(',')
      .map((origin) => origin.trim())
      .filter(Boolean) ?? [];

  app.use(cors({ origin: allowedOrigins.length > 0 ? allowedOrigins : false }));
  app.use(express.json());

  const hasWebBuild = fs.existsSync(path.join(publicDir, 'index.html'));
  if (hasWebBuild) {
    app.use(express.static(publicDir));
  }

  app.get('/health', (_req, res) => {
    res.json({ ok: true, service: 'beach-talk-api' });
  });

  // The web app is served from this same origin and fetches the shared app
  // token here at runtime instead of having it baked in at build time. A token
  // inside a public web bundle is readable by anyone anyway, and this keeps
  // the server's APP_CLIENT_TOKEN as the single source of truth — the build
  // pipeline no longer needs to know the secret.
  app.get('/app-config', (_req, res) => {
    const appToken = process.env.APP_CLIENT_TOKEN;
    if (!appToken) {
      res.status(500).json({ error: 'APP_CLIENT_TOKEN is not configured' });
      return;
    }

    res.json({ appToken });
  });

  app.post('/realtime/client-secret', async (req, res) => {
    const appToken = process.env.APP_CLIENT_TOKEN;
    if (!appToken) {
      res.status(500).json({ error: 'APP_CLIENT_TOKEN is not configured' });
      return;
    }

    if (req.header('x-beach-talk-app-token') !== appToken) {
      res.status(401).json({ error: 'Invalid app token' });
      return;
    }

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      res.status(500).json({ error: 'OPENAI_API_KEY is not configured' });
      return;
    }

    const model = process.env.OPENAI_REALTIME_MODEL ?? 'gpt-realtime-2';
    const voice = process.env.OPENAI_REALTIME_VOICE ?? 'marin';

    try {
      const response = await fetch(openAIRealtimeUrl, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${apiKey}`,
          'Content-Type': 'application/json',
          'OpenAI-Safety-Identifier': 'fernanda-beach-talk',
        },
        body: JSON.stringify({
          session: {
            type: 'realtime',
            model,
            instructions:
              'You are Fernanda’s English conversation teacher. Speak only in English during the conversation. Be patient, practical, and concise. Correct pronunciation and word choice gently. Use daily situations such as work, travel, restaurants, shopping, workouts, and small talk. When Fernanda hesitates, offer a natural phrase for her to repeat.',
            audio: {
              output: { voice },
            },
          },
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        res.status(response.status).json({
          error: 'Failed to create OpenAI Realtime client secret',
          detail: errorText,
        });
        return;
      }

      const data = (await response.json()) as ClientSecretResponse;
      const value = data.value;

      if (!value) {
        res.status(502).json({
          error: 'OpenAI response did not include a client secret',
        });
        return;
      }

      res.json({
        clientSecret: value,
        expiresAt: data.expires_at,
      });
    } catch (error) {
      res.status(500).json({
        error: 'Failed to create OpenAI Realtime client secret',
        detail: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  });

  app.post('/phrases/speech', async (req, res) => {
    const appToken = process.env.APP_CLIENT_TOKEN;
    if (!appToken) {
      res.status(500).json({ error: 'APP_CLIENT_TOKEN is not configured' });
      return;
    }

    if (req.header('x-beach-talk-app-token') !== appToken) {
      res.status(401).json({ error: 'Invalid app token' });
      return;
    }

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      res.status(500).json({ error: 'OPENAI_API_KEY is not configured' });
      return;
    }

    const text = typeof req.body.text === 'string' ? req.body.text.trim() : '';
    if (!text) {
      res.status(400).json({ error: 'Phrase text is required' });
      return;
    }

    if (text.length > maxSpeechTextLength) {
      res.status(400).json({
        error: 'Phrase text must be 200 characters or less',
      });
      return;
    }

    const rateLimitKey = `${appToken}:${req.ip ?? 'unknown'}`;
    const now = Date.now();
    const current = speechRequestCounts.get(rateLimitKey);
    if (!current || current.resetAt <= now) {
      speechRequestCounts.set(rateLimitKey, {
        count: 1,
        resetAt: now + speechRateLimitWindowMs,
      });
    } else {
      current.count++;
      if (current.count > speechRateLimitMaxRequests) {
        res.status(429).json({ error: 'Too many speech requests' });
        return;
      }
    }

    const model = process.env.OPENAI_SPEECH_MODEL ?? 'gpt-4o-mini-tts';
    const voice = process.env.OPENAI_SPEECH_VOICE ?? 'coral';

    try {
      const response = await fetch(openAISpeechUrl, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${apiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model,
          voice,
          input: text,
          instructions:
            'Speak clearly in natural American English at a moderate pace for an English learner.',
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        res.status(response.status).json({
          error: 'Failed to create phrase speech audio',
          detail: errorText,
        });
        return;
      }

      const audioBuffer = Buffer.from(await response.arrayBuffer());
      res.setHeader('Content-Type', 'audio/mpeg');
      res.setHeader('Cache-Control', 'private, max-age=86400');
      res.send(audioBuffer);
    } catch (error) {
      res.status(500).json({
        error: 'Failed to create phrase speech audio',
        detail: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  });

  if (hasWebBuild) {
    // Serve the Flutter SPA for any non-API GET so deep links work.
    app.use((req, res, next) => {
      if (req.method !== 'GET') {
        next();
        return;
      }
      res.sendFile(path.join(publicDir, 'index.html'));
    });
  }

  return app;
}
