import request from 'supertest';
import { afterEach, describe, expect, it, vi } from 'vitest';

import { createApp } from '../src/app.js';

describe('Beach Talk API', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
  });

  it('responds to health checks', async () => {
    const app = createApp();

    const response = await request(app).get('/health');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ ok: true, service: 'beach-talk-api' });
  });

  it('exposes the app token to the web app via /app-config', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');

    const app = createApp();

    const response = await request(app).get('/app-config');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ appToken: 'mobile-app-token' });
  });

  it('fails closed on /app-config when the app token is not configured', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', '');

    const app = createApp();

    const response = await request(app).get('/app-config');

    expect(response.status).toBe(500);
    expect(response.body.error).toBe('APP_CLIENT_TOKEN is not configured');
  });

  it('creates an OpenAI Realtime client secret', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');
    vi.stubEnv('OPENAI_API_KEY', 'test-api-key');
    vi.stubEnv('OPENAI_REALTIME_MODEL', 'gpt-realtime-2');

    const fetchMock = vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(
        JSON.stringify({
          value: 'ephemeral-secret',
          expires_at: 123,
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } },
      ),
    );

    const app = createApp();

    const response = await request(app)
      .post('/realtime/client-secret')
      .set('x-beach-talk-app-token', 'mobile-app-token');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      clientSecret: 'ephemeral-secret',
      expiresAt: 123,
    });
    expect(fetchMock).toHaveBeenCalledWith(
      'https://api.openai.com/v1/realtime/client_secrets',
      expect.objectContaining({
        method: 'POST',
        headers: expect.objectContaining({
          Authorization: 'Bearer test-api-key',
          'Content-Type': 'application/json',
        }),
      }),
    );
  });

  it('requires the app token when APP_CLIENT_TOKEN is configured', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');
    vi.stubEnv('OPENAI_API_KEY', 'test-api-key');

    const app = createApp();

    const missingTokenResponse = await request(app).post(
      '/realtime/client-secret',
    );

    expect(missingTokenResponse.status).toBe(401);
    expect(missingTokenResponse.body.error).toBe('Invalid app token');
  });

  it('returns a configuration error when the OpenAI key is missing', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');
    vi.stubEnv('OPENAI_API_KEY', '');
    const app = createApp();

    const response = await request(app)
      .post('/realtime/client-secret')
      .set('x-beach-talk-app-token', 'mobile-app-token');

    expect(response.status).toBe(500);
    expect(response.body.error).toBe('OPENAI_API_KEY is not configured');
  });

  it('fails closed when the app token is not configured', async () => {
    vi.stubEnv('OPENAI_API_KEY', 'test-api-key');
    vi.stubEnv('APP_CLIENT_TOKEN', '');
    const app = createApp();

    const response = await request(app).post('/realtime/client-secret');

    expect(response.status).toBe(500);
    expect(response.body.error).toBe('APP_CLIENT_TOKEN is not configured');
  });

  it('generates speech audio for a phrase', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');
    vi.stubEnv('OPENAI_API_KEY', 'test-api-key');
    vi.stubEnv('OPENAI_SPEECH_MODEL', 'gpt-4o-mini-tts');
    vi.stubEnv('OPENAI_SPEECH_VOICE', 'coral');

    const audioBytes = new Uint8Array([1, 2, 3, 4]);
    const fetchMock = vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(audioBytes, {
        status: 200,
        headers: { 'Content-Type': 'audio/mpeg' },
      }),
    );

    const app = createApp();

    const response = await request(app)
      .post('/phrases/speech')
      .set('x-beach-talk-app-token', 'mobile-app-token')
      .send({ text: 'That makes sense.' });

    expect(response.status).toBe(200);
    expect(response.header['content-type']).toContain('audio/mpeg');
    expect([...response.body]).toEqual([1, 2, 3, 4]);
    expect(fetchMock).toHaveBeenCalledWith(
      'https://api.openai.com/v1/audio/speech',
      expect.objectContaining({
        method: 'POST',
        headers: expect.objectContaining({
          Authorization: 'Bearer test-api-key',
          'Content-Type': 'application/json',
        }),
        body: expect.stringContaining('That makes sense.'),
      }),
    );
  });

  it('rejects long speech text before calling OpenAI', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');
    vi.stubEnv('OPENAI_API_KEY', 'test-api-key');
    process.env.APP_CLIENT_TOKEN = 'mobile-app-token';
    process.env.OPENAI_API_KEY = 'test-api-key';
    const fetchMock = vi.spyOn(globalThis, 'fetch');
    const app = createApp();
    const appToken = 'mobile-app-token';

    const response = await request(app)
      .post('/phrases/speech')
      .set('x-beach-talk-app-token', appToken)
      .send({ text: 'a'.repeat(201) });

    expect(response.status).toBe(400);
    expect(response.body.error).toBe('Phrase text must be 200 characters or less');
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('rate limits speech generation requests', async () => {
    vi.stubEnv('APP_CLIENT_TOKEN', 'mobile-app-token');
    vi.stubEnv('OPENAI_API_KEY', 'test-api-key');
    process.env.APP_CLIENT_TOKEN = 'mobile-app-token';
    process.env.OPENAI_API_KEY = 'test-api-key';
    vi.spyOn(globalThis, 'fetch').mockImplementation(async () => {
      return new Response(new Uint8Array([1, 2, 3]), {
        status: 200,
        headers: { 'Content-Type': 'audio/mpeg' },
      });
    });
    const app = createApp();
    const appToken = 'mobile-app-token';

    for (var index = 0; index < 10; index++) {
      await request(app)
        .post('/phrases/speech')
        .set('x-beach-talk-app-token', appToken)
        .send({ text: 'That makes sense.' })
        .expect(200);
    }

    const response = await request(app)
      .post('/phrases/speech')
      .set('x-beach-talk-app-token', appToken)
      .send({ text: 'That makes sense.' });

    expect(response.status).toBe(429);
    expect(response.body.error).toBe('Too many speech requests');
  });
});
