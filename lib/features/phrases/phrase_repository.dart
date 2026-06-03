import 'phrase.dart';

class PhraseRepository {
  const PhraseRepository();

  List<Phrase> get all => _phrases;

  List<String> get categories {
    return _phrases.map((phrase) => phrase.category).toSet().toList()..sort();
  }

  List<Phrase> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return all;
    }

    return _phrases.where((phrase) {
      return phrase.text.toLowerCase().contains(normalizedQuery) ||
          phrase.meaningPtBr.toLowerCase().contains(normalizedQuery) ||
          phrase.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}

const _phrases = [
  Phrase(
    text: 'Good morning!',
    meaningPtBr: 'Bom dia!',
    pronunciationHint: 'gud mór-ning',
    examples: ['Good morning! How did you sleep?'],
    category: 'daily',
  ),
  Phrase(
    text: 'How are you doing?',
    meaningPtBr: 'Como você está?',
    pronunciationHint: 'rau ar iú dú-ing',
    examples: ['Hey, how are you doing today?'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'I am on my way.',
    meaningPtBr: 'Estou a caminho.',
    pronunciationHint: 'ai ém on mai uêi',
    examples: ['I am on my way to the office.'],
    category: 'daily',
  ),
  Phrase(
    text: 'Could you help me?',
    meaningPtBr: 'Você poderia me ajudar?',
    pronunciationHint: 'cud iú rélp mi',
    examples: ['Could you help me with this form?'],
    category: 'daily',
  ),
  Phrase(
    text: 'What do you mean?',
    meaningPtBr: 'O que você quer dizer?',
    pronunciationHint: 'uát du iú míin',
    examples: ['Sorry, what do you mean by that?'],
    category: 'daily',
  ),
  Phrase(
    text: 'That sounds great.',
    meaningPtBr: 'Isso parece ótimo.',
    pronunciationHint: 'dét sáunds greit',
    examples: ['Dinner at seven? That sounds great.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'I would like a coffee.',
    meaningPtBr: 'Eu gostaria de um café.',
    pronunciationHint: 'ai ud laik a có-fi',
    examples: ['I would like a coffee, please.'],
    category: 'food',
  ),
  Phrase(
    text: 'Can I get the check?',
    meaningPtBr: 'Posso pedir a conta?',
    pronunciationHint: 'ken ai guét de tchék',
    examples: ['Can I get the check, please?'],
    category: 'food',
  ),
  Phrase(
    text: 'I have a meeting.',
    meaningPtBr: 'Tenho uma reunião.',
    pronunciationHint: 'ai rév a mí-ding',
    examples: ['I have a meeting at ten.'],
    category: 'work',
  ),
  Phrase(
    text: 'Let me check.',
    meaningPtBr: 'Deixe-me verificar.',
    pronunciationHint: 'lét mi tchék',
    examples: ['Let me check my calendar.'],
    category: 'work',
  ),
  Phrase(
    text: 'I will be right back.',
    meaningPtBr: 'Já volto.',
    pronunciationHint: 'ai uil bi ráit bék',
    examples: ['I will be right back in five minutes.'],
    category: 'daily',
  ),
  Phrase(
    text: 'Where is the bathroom?',
    meaningPtBr: 'Onde fica o banheiro?',
    pronunciationHint: 'uér iz de béth-rum',
    examples: ['Excuse me, where is the bathroom?'],
    category: 'travel',
  ),
  Phrase(
    text: 'How much is this?',
    meaningPtBr: 'Quanto custa isso?',
    pronunciationHint: 'ráu match iz dis',
    examples: ['How much is this jacket?'],
    category: 'shopping',
  ),
  Phrase(
    text: 'I am just looking.',
    meaningPtBr: 'Estou só olhando.',
    pronunciationHint: 'ai ém djâst lú-king',
    examples: ['Thanks, I am just looking.'],
    category: 'shopping',
  ),
  Phrase(
    text: 'Nice to meet you.',
    meaningPtBr: 'Prazer em conhecer você.',
    pronunciationHint: 'nais tu míit iú',
    examples: ['Hi, I am Fernanda. Nice to meet you.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'See you later.',
    meaningPtBr: 'Até mais tarde.',
    pronunciationHint: 'sí iú lêi-der',
    examples: ['I need to go. See you later!'],
    category: 'daily',
  ),
  Phrase(
    text: 'I agree with you.',
    meaningPtBr: 'Eu concordo com você.',
    pronunciationHint: 'ai a-grí uith iú',
    examples: ['I agree with you on this point.'],
    category: 'work',
  ),
  Phrase(
    text: 'I do not understand.',
    meaningPtBr: 'Eu não entendo.',
    pronunciationHint: 'ai du not an-der-sténd',
    examples: ['Sorry, I do not understand the question.'],
    category: 'daily',
  ),
  Phrase(
    text: 'Could you repeat that?',
    meaningPtBr: 'Você poderia repetir?',
    pronunciationHint: 'cud iú ri-pít dét',
    examples: ['Could you repeat that more slowly?'],
    category: 'daily',
  ),
  Phrase(
    text: 'What time is it?',
    meaningPtBr: 'Que horas são?',
    pronunciationHint: 'uát taim iz it',
    examples: ['Excuse me, what time is it?'],
    category: 'daily',
  ),
  Phrase(
    text: 'I am running late.',
    meaningPtBr: 'Estou atrasada.',
    pronunciationHint: 'ai ém râ-ning leit',
    examples: ['I am sorry, I am running late.'],
    category: 'daily',
  ),
  Phrase(
    text: 'No worries.',
    meaningPtBr: 'Sem problemas.',
    pronunciationHint: 'nô uó-riz',
    examples: ['No worries, take your time.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'It was nice talking to you.',
    meaningPtBr: 'Foi bom conversar com você.',
    pronunciationHint: 'it uaz nais tó-king tu iú',
    examples: ['I have to go, but it was nice talking to you.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'Can you recommend a place?',
    meaningPtBr: 'Você pode recomendar um lugar?',
    pronunciationHint: 'ken iú ré-co-mend a pleis',
    examples: ['Can you recommend a place for dinner?'],
    category: 'travel',
  ),
  Phrase(
    text: 'I need directions.',
    meaningPtBr: 'Preciso de direções.',
    pronunciationHint: 'ai nid di-rék-shons',
    examples: ['I need directions to the train station.'],
    category: 'travel',
  ),
  Phrase(
    text: 'I am allergic to peanuts.',
    meaningPtBr: 'Sou alérgica a amendoim.',
    pronunciationHint: 'ai ém a-lér-djik tu pí-nats',
    examples: ['I am allergic to peanuts. Does this have peanuts?'],
    category: 'food',
  ),
  Phrase(
    text: 'Can we reschedule?',
    meaningPtBr: 'Podemos remarcar?',
    pronunciationHint: 'ken ui ri-skéd-jul',
    examples: ['Can we reschedule the meeting for tomorrow?'],
    category: 'work',
  ),
  Phrase(
    text: 'I will send it today.',
    meaningPtBr: 'Vou enviar isso hoje.',
    pronunciationHint: 'ai uil send it tu-dêi',
    examples: ['I will send it today after lunch.'],
    category: 'work',
  ),
  Phrase(
    text: 'Do you have this in another size?',
    meaningPtBr: 'Você tem isso em outro tamanho?',
    pronunciationHint: 'du iú rév dis in a-nâ-der saiz',
    examples: ['Do you have this in another size?'],
    category: 'shopping',
  ),
  Phrase(
    text: 'That is exactly what I need.',
    meaningPtBr: 'É exatamente disso que eu preciso.',
    pronunciationHint: 'dét iz eg-záct-li uát ai nid',
    examples: ['Yes, that is exactly what I need.'],
    category: 'work',
  ),
  Phrase(
    text: 'That makes sense.',
    meaningPtBr: 'Isso faz sentido.',
    pronunciationHint: 'dét meiks séns',
    examples: ['Now I understand. That makes sense.'],
    category: 'daily',
  ),
  Phrase(
    text: "I'm down.",
    meaningPtBr: 'Eu topo.',
    pronunciationHint: 'aim dáun',
    examples: ["Dinner tonight? I'm down."],
    category: 'smallTalk',
  ),
  Phrase(
    text: "I'll figure it out.",
    meaningPtBr: 'Eu vou dar um jeito / vou descobrir.',
    pronunciationHint: 'ail fí-guer it áut',
    examples: ["I do not know yet, but I'll figure it out."],
    category: 'daily',
  ),
  Phrase(
    text: 'No big deal.',
    meaningPtBr: 'Sem problema / não é nada demais.',
    pronunciationHint: 'nô big díl',
    examples: ['Do not worry about it. No big deal.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'It slipped my mind.',
    meaningPtBr: 'Eu acabei esquecendo.',
    pronunciationHint: 'it slípt mai máind',
    examples: ['Sorry, it slipped my mind.'],
    category: 'daily',
  ),
  Phrase(
    text: 'I am not sure yet.',
    meaningPtBr: 'Ainda não tenho certeza.',
    pronunciationHint: 'ai ém not shúr iét',
    examples: ['I am not sure yet, but I will let you know.'],
    category: 'daily',
  ),
  Phrase(
    text: 'Let me know.',
    meaningPtBr: 'Me avise / me diga.',
    pronunciationHint: 'lét mi nôu',
    examples: ['Let me know when you get there.'],
    category: 'daily',
  ),
  Phrase(
    text: 'I am looking forward to it.',
    meaningPtBr: 'Estou ansiosa por isso.',
    pronunciationHint: 'ai ém lú-king fór-uard tu it',
    examples: ['The trip is next week. I am looking forward to it.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'It depends.',
    meaningPtBr: 'Depende.',
    pronunciationHint: 'it di-pénds',
    examples: ['It depends on the weather.'],
    category: 'daily',
  ),
  Phrase(
    text: 'I am in a hurry.',
    meaningPtBr: 'Estou com pressa.',
    pronunciationHint: 'ai ém in a râ-ri',
    examples: ['I am in a hurry. Can we talk later?'],
    category: 'daily',
  ),
  Phrase(
    text: 'Take your time.',
    meaningPtBr: 'Sem pressa / leve o tempo que precisar.',
    pronunciationHint: 'teik iór taim',
    examples: ['Take your time. I can wait.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'I get it.',
    meaningPtBr: 'Entendi.',
    pronunciationHint: 'ai guét it',
    examples: ['Oh, I get it now.'],
    category: 'daily',
  ),
  Phrase(
    text: 'What have you been up to?',
    meaningPtBr: 'O que você tem feito?',
    pronunciationHint: 'uát rév iú bin ap tu',
    examples: ['Long time no see! What have you been up to?'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'I will keep that in mind.',
    meaningPtBr: 'Vou lembrar disso / vou levar isso em consideração.',
    pronunciationHint: 'ai uil kip dét in máind',
    examples: ['That is good advice. I will keep that in mind.'],
    category: 'work',
  ),
  Phrase(
    text: 'Can you walk me through it?',
    meaningPtBr: 'Você pode me explicar passo a passo?',
    pronunciationHint: 'ken iú uók mi thru it',
    examples: ['I am new to this. Can you walk me through it?'],
    category: 'work',
  ),
  Phrase(
    text: 'I am craving something sweet.',
    meaningPtBr: 'Estou com vontade de comer algo doce.',
    pronunciationHint: 'ai ém crêi-ving sâm-thing suíit',
    examples: ['I am craving something sweet after lunch.'],
    category: 'food',
  ),
  Phrase(
    text: 'I am just browsing.',
    meaningPtBr: 'Estou só dando uma olhada.',
    pronunciationHint: 'ai ém djâst bráu-zing',
    examples: ['Thanks, I am just browsing.'],
    category: 'shopping',
  ),
  Phrase(
    text: 'Could you speak a little slower?',
    meaningPtBr: 'Você poderia falar um pouco mais devagar?',
    pronunciationHint: 'cud iú spík a lí-dol slôu-er',
    examples: ['Could you speak a little slower, please?'],
    category: 'daily',
  ),
];
