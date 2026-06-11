import 'phrase.dart';

class PhraseRepository {
  const PhraseRepository();

  List<Phrase> get all => _phrases;

  List<PhraseCategory> get orderedCategories => _categories;

  List<String> get categories {
    return _phrases.map((p) => p.category).toSet().toList()..sort();
  }

  List<Phrase> byCategory(String categoryId) =>
      _phrases.where((p) => p.category == categoryId).toList();

  List<Phrase> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return _phrases.where((p) {
      return p.text.toLowerCase().contains(q) ||
          p.meaningPtBr.toLowerCase().contains(q) ||
          p.pronunciationHint.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }
}

const _categories = [
  PhraseCategory(id: 'positioning', label: 'Posicionamento'),
  PhraseCategory(id: 'ball_technique', label: 'Bola e técnica'),
  PhraseCategory(id: 'intensity', label: 'Intensidade'),
  PhraseCategory(id: 'rhythm_calm', label: 'Ritmo e calma'),
  PhraseCategory(id: 'game_reading', label: 'Leitura de jogo'),
  PhraseCategory(id: 'on_court', label: 'Em quadra'),
  PhraseCategory(id: 'competition', label: 'Competição'),
  PhraseCategory(id: 'daily_pro', label: 'Cotidiano profissional'),
  PhraseCategory(id: 'advanced_game', label: 'Avançado — jogo', isAdvanced: true),
  PhraseCategory(id: 'advanced_daily', label: 'Avançado — dia a dia', isAdvanced: true),
  PhraseCategory(id: 'daily', label: 'Dia a dia'),
  PhraseCategory(id: 'smallTalk', label: 'Bate-papo'),
  PhraseCategory(id: 'food', label: 'Alimentação'),
  PhraseCategory(id: 'work', label: 'Trabalho'),
  PhraseCategory(id: 'travel', label: 'Viagem'),
  PhraseCategory(id: 'shopping', label: 'Compras'),
];

const _phrases = [
  // ── POSICIONAMENTO ─────────────────────────────────────────────────
  Phrase(
    text: "Let's play more down the line.",
    meaningPtBr: 'Vamos jogar mais na paralela.',
    pronunciationHint: 'LETS PLEI mor DAUN dê LAIN',
    category: 'positioning',
    words: [
      PhraseWord(word: "Let's", translation: 'vamos'),
      PhraseWord(word: 'play', translation: 'jogar'),
      PhraseWord(word: 'more', translation: 'mais'),
      PhraseWord(word: 'down the line', translation: 'na paralela'),
    ],
    vars: [
      ['Keep it down the line!', 'Mantém na paralela!'],
      ['More down the line, less cross-court!', 'Mais paralela, menos diagonal!'],
      ['Go straight!', 'Vai direto!'],
    ],
  ),
  Phrase(
    text: 'Play more cross-court.',
    meaningPtBr: 'Joga mais na diagonal.',
    pronunciationHint: 'PLEI mor CROSS-CORT',
    category: 'positioning',
    words: [
      PhraseWord(word: 'Play', translation: 'joga'),
      PhraseWord(word: 'more', translation: 'mais'),
      PhraseWord(word: 'cross-court', translation: 'na diagonal'),
    ],
    vars: [
      ['Open it up cross-court!', 'Abre na diagonal!'],
      ['Hit it wide!', 'Bate aberto!'],
      ['Use the angle!', 'Usa o ângulo!'],
    ],
  ),
  Phrase(
    text: 'Stay more inside the court.',
    meaningPtBr: 'Fica mais dentro da quadra.',
    pronunciationHint: 'STEI mor in-SAID dê CORT',
    category: 'positioning',
    words: [
      PhraseWord(word: 'Stay', translation: 'fica'),
      PhraseWord(word: 'more', translation: 'mais'),
      PhraseWord(word: 'inside', translation: 'dentro'),
      PhraseWord(word: 'the court', translation: 'da quadra'),
    ],
    vars: [
      ['Step in!', 'Entra pra dentro!'],
      ['Move forward!', 'Avança!'],
      ['Get closer to the net!', 'Chega mais perto da net!'],
    ],
  ),
  Phrase(
    text: 'Step back a little.',
    meaningPtBr: 'Recua um pouco.',
    pronunciationHint: 'STEP BAK a LIT-ol',
    category: 'positioning',
    words: [
      PhraseWord(word: 'Step back', translation: 'recua'),
      PhraseWord(word: 'a little', translation: 'um pouco'),
    ],
    vars: [
      ['Give yourself more space!', 'Dá mais espaço pra você!'],
      ['Get off the net!', 'Sai da net!'],
      ['Drop back!', 'Cai pra trás!'],
    ],
  ),
  Phrase(
    text: 'Cover the middle.',
    meaningPtBr: 'Cobre o meio.',
    pronunciationHint: 'CAV-er dê MID-ol',
    category: 'positioning',
    words: [
      PhraseWord(word: 'Cover', translation: 'cobre'),
      PhraseWord(word: 'the middle', translation: 'o meio'),
    ],
    vars: [
      ["Watch the center!", 'Olha o centro!'],
      ['Take the middle!', 'Pega o meio!'],
      ["Don't leave the middle open!", 'Não deixa o meio aberto!'],
    ],
  ),

  // ── BOLA E TÉCNICA ─────────────────────────────────────────────────
  Phrase(
    text: 'That ball could be a little lower.',
    meaningPtBr: 'Essa bola pode ser um pouco mais baixa.',
    pronunciationHint: 'DHAT BOL KUD bi a LIT-ol LÔU-er',
    category: 'ball_technique',
    words: [
      PhraseWord(word: 'That ball', translation: 'essa bola'),
      PhraseWord(word: 'could be', translation: 'poderia ser'),
      PhraseWord(word: 'a little', translation: 'um pouco'),
      PhraseWord(word: 'lower', translation: 'mais baixa'),
    ],
    vars: [
      ['Keep it lower!', 'Mantém mais baixa!'],
      ['Aim lower on that shot.', 'Mira mais baixo nessa bola.'],
      ["Don't give them height!", 'Não dá altura pra elas!'],
    ],
  ),
  Phrase(
    text: 'Hit it deeper.',
    meaningPtBr: 'Coloca mais profundo.',
    pronunciationHint: 'HIT it DÍP-er',
    category: 'ball_technique',
    words: [
      PhraseWord(word: 'Hit it', translation: 'coloca / bate'),
      PhraseWord(word: 'deeper', translation: 'mais profundo'),
    ],
    vars: [
      ['Push it back!', 'Joga pra trás!'],
      ['Make her run!', 'Faz ela correr!'],
      ['Aim for the baseline!', 'Mira na linha de fundo!'],
    ],
  ),
  Phrase(
    text: 'Put more spin on it.',
    meaningPtBr: 'Bota mais efeito.',
    pronunciationHint: 'PUT mor SPIN on it',
    category: 'ball_technique',
    words: [
      PhraseWord(word: 'Put', translation: 'bota / coloca'),
      PhraseWord(word: 'more spin', translation: 'mais efeito'),
      PhraseWord(word: 'on it', translation: 'nela'),
    ],
    vars: [
      ['More topspin!', 'Mais topspin!'],
      ['Add some slice!', 'Coloca um slice!'],
      ['Spin it!', 'Gira a bola!'],
    ],
  ),
  Phrase(
    text: 'Open up the angle more.',
    meaningPtBr: 'Abre mais o ângulo.',
    pronunciationHint: 'ÔU-pen AP dê ANG-gol mor',
    category: 'ball_technique',
    words: [
      PhraseWord(word: 'Open up', translation: 'abre'),
      PhraseWord(word: 'the angle', translation: 'o ângulo'),
      PhraseWord(word: 'more', translation: 'mais'),
    ],
    vars: [
      ['Go wider!', 'Vai mais aberto!'],
      ['Use the sideline!', 'Usa a linha lateral!'],
      ['Stretch her out!', 'Abre ela pra fora!'],
    ],
  ),
  Phrase(
    text: 'Serve at her body.',
    meaningPtBr: 'Serve no corpo dela.',
    pronunciationHint: 'SERV at her BOD-i',
    category: 'ball_technique',
    words: [
      PhraseWord(word: 'Serve', translation: 'saca / serve'),
      PhraseWord(word: 'at her body', translation: 'no corpo dela'),
    ],
    vars: [
      ['Hit her body!', 'Ataca o corpo!'],
      ['Jam her!', 'Trava ela!'],
      ['Go straight at her!', 'Vai direto nela!'],
    ],
  ),

  // ── INTENSIDADE ────────────────────────────────────────────────────
  Phrase(
    text: 'We can be more aggressive.',
    meaningPtBr: 'Podemos ser mais agressivas.',
    pronunciationHint: 'UI KAN bi mor a-GRES-iv',
    category: 'intensity',
    words: [
      PhraseWord(word: 'We can', translation: 'podemos'),
      PhraseWord(word: 'be', translation: 'ser'),
      PhraseWord(word: 'more aggressive', translation: 'mais agressivas'),
    ],
    vars: [
      ["Let's step it up!", 'Vamos intensificar!'],
      ['Go for it!', 'Arrisca!'],
      ['Be bolder!', 'Seja mais ousada!'],
    ],
  ),
  Phrase(
    text: "Let's attack the net.",
    meaningPtBr: 'Vamos atacar a net.',
    pronunciationHint: 'LETS a-TAK dê NET',
    category: 'intensity',
    words: [
      PhraseWord(word: "Let's", translation: 'vamos'),
      PhraseWord(word: 'attack', translation: 'atacar'),
      PhraseWord(word: 'the net', translation: 'a net'),
    ],
    vars: [
      ['Rush the net!', 'Corre pra net!'],
      ['Take the net!', 'Domina a net!'],
      ['Go forward!', 'Vai pra frente!'],
    ],
  ),
  Phrase(
    text: "Don't give her any space.",
    meaningPtBr: 'Não dá espaço pra ela.',
    pronunciationHint: 'DÔUNT GIV her EN-i SPEIS',
    category: 'intensity',
    words: [
      PhraseWord(word: "Don't give", translation: 'não dá'),
      PhraseWord(word: 'her', translation: 'pra ela'),
      PhraseWord(word: 'any space', translation: 'espaço nenhum'),
    ],
    vars: [
      ['Close her down!', 'Fecha o espaço!'],
      ['Pressure her!', 'Pressiona ela!'],
      ['Keep her tight!', 'Mantém ela sem espaço!'],
    ],
  ),
  Phrase(
    text: 'Finish the point.',
    meaningPtBr: 'Termina o ponto.',
    pronunciationHint: 'FIN-ich dê POINT',
    category: 'intensity',
    words: [
      PhraseWord(word: 'Finish', translation: 'termina / fecha'),
      PhraseWord(word: 'the point', translation: 'o ponto'),
    ],
    vars: [
      ['Put it away!', 'Mata a bola!'],
      ['Close it out!', 'Fecha!'],
      ['End it now!', 'Acaba logo!'],
    ],
  ),

  // ── RITMO E CALMA ──────────────────────────────────────────────────
  Phrase(
    text: 'We need to stay calmer.',
    meaningPtBr: 'Precisamos ter mais calma.',
    pronunciationHint: 'UI NÍD tu STEI CAM-er',
    category: 'rhythm_calm',
    words: [
      PhraseWord(word: 'We need', translation: 'precisamos'),
      PhraseWord(word: 'to stay', translation: 'ficar / ter'),
      PhraseWord(word: 'calmer', translation: 'mais calmas'),
    ],
    vars: [
      ['Slow it down.', 'Desacelera.'],
      ['Breathe, reset, next point.', 'Respira, reseta, próximo ponto.'],
      ['Take your time.', 'Sem pressa.'],
    ],
  ),
  Phrase(
    text: 'No rush. Build the point.',
    meaningPtBr: 'Sem pressa. Constrói o ponto.',
    pronunciationHint: 'NÔU RACH. BILD dê POINT',
    category: 'rhythm_calm',
    words: [
      PhraseWord(word: 'No rush', translation: 'sem pressa'),
      PhraseWord(word: 'Build', translation: 'constrói'),
      PhraseWord(word: 'the point', translation: 'o ponto'),
    ],
    vars: [
      ['Be patient!', 'Tem paciência!'],
      ['Wait for the right ball!', 'Espera a bola certa!'],
      ["Don't force it!", 'Não força!'],
    ],
  ),
  Phrase(
    text: 'Breathe. Next point.',
    meaningPtBr: 'Respira. Próximo ponto.',
    pronunciationHint: 'BRÍDH. NEKST POINT',
    category: 'rhythm_calm',
    words: [
      PhraseWord(word: 'Breathe', translation: 'respira'),
      PhraseWord(word: 'Next point', translation: 'próximo ponto'),
    ],
    vars: [
      ['Reset!', 'Reseta!'],
      ['Let it go, focus forward.', 'Esquece, foca no próximo.'],
      ['One point at a time.', 'Um ponto de cada vez.'],
    ],
  ),
  Phrase(
    text: "Let's cut down the errors.",
    meaningPtBr: 'Vamos diminuir os erros.',
    pronunciationHint: 'LETS KAT DAUN dê ER-orz',
    category: 'rhythm_calm',
    words: [
      PhraseWord(word: "Let's cut down", translation: 'vamos diminuir'),
      PhraseWord(word: 'the errors', translation: 'os erros'),
    ],
    vars: [
      ['Play safe!', 'Joga segura!'],
      ['Keep it in!', 'Mantém dentro!'],
      ["Less mistakes, more consistency.", 'Menos erros, mais consistência.'],
    ],
  ),

  // ── LEITURA DE JOGO ────────────────────────────────────────────────
  Phrase(
    text: "She's pushing us back.",
    meaningPtBr: 'Ela está nos empurrando para trás.',
    pronunciationHint: 'CHÍZ PUCH-ing as BAK',
    category: 'game_reading',
    words: [
      PhraseWord(word: "She's", translation: 'ela está'),
      PhraseWord(word: 'pushing', translation: 'empurrando'),
      PhraseWord(word: 'us', translation: 'a gente'),
      PhraseWord(word: 'back', translation: 'pra trás'),
    ],
    vars: [
      ["She's driving us deep!", 'Ela tá nos jogando fundo!'],
      ["Don't let her control the pace!", 'Não deixa ela controlar o ritmo!'],
      ['We need to counter-attack!', 'Precisamos contra-atacar!'],
    ],
  ),
  Phrase(
    text: "She's reading us too well.",
    meaningPtBr: 'Ela tá antecipando muito.',
    pronunciationHint: 'CHÍZ RÍD-ing as TU UEL',
    category: 'game_reading',
    words: [
      PhraseWord(word: "She's reading", translation: 'ela tá antecipando'),
      PhraseWord(word: 'us', translation: 'a gente'),
      PhraseWord(word: 'too well', translation: 'muito bem'),
    ],
    vars: [
      ["She knows where we're going!", 'Ela sabe pra onde vamos!'],
      ['Change direction!', 'Muda a direção!'],
      ['Be unpredictable!', 'Seja imprevisível!'],
    ],
  ),
  Phrase(
    text: 'We need to change our strategy.',
    meaningPtBr: 'Precisamos mudar a estratégia.',
    pronunciationHint: 'UI NÍD tu CHEINDJ AUR STRAT-e-dji',
    category: 'game_reading',
    words: [
      PhraseWord(word: 'We need', translation: 'precisamos'),
      PhraseWord(word: 'to change', translation: 'mudar'),
      PhraseWord(word: 'our strategy', translation: 'nossa estratégia'),
    ],
    vars: [
      ['New plan!', 'Novo plano!'],
      ["Let's switch it up.", 'Vamos mudar as coisas.'],
      ["This isn't working.", 'Isso não tá funcionando.'],
    ],
  ),
  Phrase(
    text: "She's tired. Let's exploit that.",
    meaningPtBr: 'Ela tá cansada. Vamos explorar.',
    pronunciationHint: 'CHÍZ TAI-erd. LETS eks-PLOIT DHAT',
    category: 'game_reading',
    words: [
      PhraseWord(word: "She's tired", translation: 'ela tá cansada'),
      PhraseWord(word: "Let's exploit", translation: 'vamos explorar'),
      PhraseWord(word: 'that', translation: 'isso'),
    ],
    vars: [
      ['Make her move more!', 'Faz ela se mexer mais!'],
      ['Go to her!', 'Vai em cima dela!'],
      ["She's dropping — attack!", 'Ela tá baixando — ataca!'],
    ],
  ),
  Phrase(
    text: 'They keep going cross-court. Close the line.',
    meaningPtBr: 'Elas estão jogando muito na diagonal. Fecha a paralela.',
    pronunciationHint: 'DHEI KÍP GÔU-ing CROSS-CORT. CLÔUZ dê LAIN',
    category: 'game_reading',
    words: [
      PhraseWord(word: 'They keep going', translation: 'elas ficam indo'),
      PhraseWord(word: 'cross-court', translation: 'na diagonal'),
      PhraseWord(word: 'Close the line', translation: 'fecha a paralela'),
    ],
    vars: [
      ['Cover the line!', 'Cobre a paralela!'],
      ['Anticipate the cross!', 'Antecipa a diagonal!'],
      ['She always goes cross — be ready.', 'Ela sempre vai na diagonal — fica pronta.'],
    ],
  ),

  // ── EM QUADRA ──────────────────────────────────────────────────────
  Phrase(
    text: 'My ball!',
    meaningPtBr: 'Minha bola!',
    pronunciationHint: 'MAI BOL',
    category: 'on_court',
    words: [PhraseWord(word: 'My ball', translation: 'minha bola')],
  ),
  Phrase(
    text: 'Your ball! / Take it!',
    meaningPtBr: 'Sua bola! / Pega!',
    pronunciationHint: 'IOR BOL / TEIK it',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Your ball', translation: 'sua bola'),
      PhraseWord(word: 'Take it', translation: 'pega'),
    ],
  ),
  Phrase(
    text: 'Leave it for me!',
    meaningPtBr: 'Deixa pra mim!',
    pronunciationHint: 'LIV it for MI',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Leave it', translation: 'deixa'),
      PhraseWord(word: 'for me', translation: 'pra mim'),
    ],
  ),
  Phrase(
    text: 'Cover the diagonal!',
    meaningPtBr: 'Cobre a diagonal!',
    pronunciationHint: 'CAV-er dê dai-AG-o-nal',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Cover', translation: 'cobre'),
      PhraseWord(word: 'the diagonal', translation: 'a diagonal'),
    ],
  ),
  Phrase(
    text: 'Close the net!',
    meaningPtBr: 'Fecha a net!',
    pronunciationHint: 'CLÔUZ dê NET',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Close', translation: 'fecha'),
      PhraseWord(word: 'the net', translation: 'a net'),
    ],
  ),
  Phrase(
    text: 'Stay back!',
    meaningPtBr: 'Fica por baixo!',
    pronunciationHint: 'STEI BAK',
    category: 'on_court',
    words: [PhraseWord(word: 'Stay back', translation: 'fica por baixo / atrás')],
  ),
  Phrase(
    text: 'Come up with me!',
    meaningPtBr: 'Sobe comigo!',
    pronunciationHint: 'CAM AP uidh MI',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Come up', translation: 'sobe'),
      PhraseWord(word: 'with me', translation: 'comigo'),
    ],
  ),
  Phrase(
    text: 'Watch the lob!',
    meaningPtBr: 'Atenção no lob!',
    pronunciationHint: 'UOTCH dê LOB',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Watch', translation: 'atenção / cuida'),
      PhraseWord(word: 'the lob', translation: 'o lob'),
    ],
  ),
  Phrase(
    text: 'Get to the net!',
    meaningPtBr: 'Pega na net!',
    pronunciationHint: 'GET tu dê NET',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Get to', translation: 'pega / vai pra'),
      PhraseWord(word: 'the net', translation: 'a net'),
    ],
  ),
  Phrase(
    text: "Let's go, partner!",
    meaningPtBr: 'Vamos, parceira!',
    pronunciationHint: 'LETS GÔU, PAR-ner',
    category: 'on_court',
    words: [
      PhraseWord(word: "Let's go", translation: 'vamos'),
      PhraseWord(word: 'partner', translation: 'parceira'),
    ],
  ),
  Phrase(
    text: 'Great shot!',
    meaningPtBr: 'Boa bola!',
    pronunciationHint: 'GREIT CHOT',
    category: 'on_court',
    words: [PhraseWord(word: 'Great shot', translation: 'boa bola')],
  ),
  Phrase(
    text: 'Breathe and focus!',
    meaningPtBr: 'Respira e foca!',
    pronunciationHint: 'BRÍDH and FÔU-cas',
    category: 'on_court',
    words: [
      PhraseWord(word: 'Breathe', translation: 'respira'),
      PhraseWord(word: 'and focus', translation: 'e foca'),
    ],
  ),
  Phrase(
    text: "We'll bounce back!",
    meaningPtBr: 'A gente dá a volta!',
    pronunciationHint: 'UIL BAUNS BAK',
    category: 'on_court',
    words: [PhraseWord(word: "We'll bounce back", translation: 'a gente dá a volta')],
  ),

  // ── COMPETIÇÃO ─────────────────────────────────────────────────────
  Phrase(
    text: "What's their game plan?",
    meaningPtBr: 'Qual o esquema de jogo delas?',
    pronunciationHint: 'UOTS dêr GEIM PLAN',
    category: 'competition',
    words: [
      PhraseWord(word: "What's", translation: 'qual é'),
      PhraseWord(word: 'their game plan', translation: 'o esquema de jogo delas'),
    ],
  ),
  Phrase(
    text: 'She has a very heavy smash.',
    meaningPtBr: 'Ela tem smash muito pesado.',
    pronunciationHint: 'CHI HAZ a VER-i HEV-i SMACH',
    category: 'competition',
    words: [
      PhraseWord(word: 'She has', translation: 'ela tem'),
      PhraseWord(word: 'a very heavy', translation: 'muito pesado'),
      PhraseWord(word: 'smash', translation: 'smash'),
    ],
  ),
  Phrase(
    text: 'Pay attention to the wind.',
    meaningPtBr: 'Presta atenção no vento.',
    pronunciationHint: 'PEI a-TEN-chon tu dê UIND',
    category: 'competition',
    words: [
      PhraseWord(word: 'Pay attention', translation: 'presta atenção'),
      PhraseWord(word: 'to the wind', translation: 'ao vento'),
    ],
  ),
  Phrase(
    text: 'I have a cramp.',
    meaningPtBr: 'Tô com cãibra.',
    pronunciationHint: 'AI HAV a KRAMP',
    category: 'competition',
    words: [
      PhraseWord(word: 'I have', translation: 'tô com'),
      PhraseWord(word: 'a cramp', translation: 'uma cãibra'),
    ],
  ),
  Phrase(
    text: 'Good match!',
    meaningPtBr: 'Boa partida!',
    pronunciationHint: 'GUD METCH',
    category: 'competition',
    words: [PhraseWord(word: 'Good match', translation: 'boa partida')],
  ),
  Phrase(
    text: "We're going to super tie-break!",
    meaningPtBr: 'Vamos pro super tie-break!',
    pronunciationHint: 'UIR GÔU-ing tu SÚPER TAI-breik',
    category: 'competition',
    words: [
      PhraseWord(word: "We're going", translation: 'vamos'),
      PhraseWord(word: 'to super tie-break', translation: 'pro super tie-break'),
    ],
  ),

  // ── COTIDIANO PROFISSIONAL ─────────────────────────────────────────
  Phrase(
    text: 'What time is practice?',
    meaningPtBr: 'Que horas é o treino?',
    pronunciationHint: 'UOT TAIM iz PRAK-tis',
    category: 'daily_pro',
    words: [
      PhraseWord(word: 'What time', translation: 'que horas'),
      PhraseWord(word: 'is practice', translation: 'é o treino'),
    ],
  ),
  Phrase(
    text: 'I need physiotherapy.',
    meaningPtBr: 'Preciso de fisioterapia.',
    pronunciationHint: 'AI NÍD fiz-i-ou-THER-a-pi',
    category: 'daily_pro',
    words: [
      PhraseWord(word: 'I need', translation: 'preciso de'),
      PhraseWord(word: 'physiotherapy', translation: 'fisioterapia'),
    ],
  ),
  Phrase(
    text: 'I have shoulder pain.',
    meaningPtBr: 'Tô com dor no ombro.',
    pronunciationHint: 'AI HAV CHÔUL-der PEIN',
    category: 'daily_pro',
    words: [
      PhraseWord(word: 'I have', translation: 'tô com'),
      PhraseWord(word: 'shoulder pain', translation: 'dor no ombro'),
    ],
  ),
  Phrase(
    text: 'Hydration is key.',
    meaningPtBr: 'Hidratação é fundamental.',
    pronunciationHint: 'hai-DREI-chon IZ KÍ',
    category: 'daily_pro',
    words: [
      PhraseWord(word: 'Hydration', translation: 'hidratação'),
      PhraseWord(word: 'is key', translation: 'é fundamental'),
    ],
  ),
  Phrase(
    text: "I'm negotiating with a brand.",
    meaningPtBr: 'Tô negociando com uma marca.',
    pronunciationHint: 'AIM ni-GÔU-chi-ei-ting UIDH a BRAND',
    category: 'daily_pro',
    words: [
      PhraseWord(word: "I'm negotiating", translation: 'tô negociando'),
      PhraseWord(word: 'with a brand', translation: 'com uma marca'),
    ],
  ),
  Phrase(
    text: 'I want to grow in the international circuit.',
    meaningPtBr: 'Quero crescer no circuito internacional.',
    pronunciationHint: 'AI UONT tu GRÔU in dê in-ter-NACH-o-nal SER-kit',
    category: 'daily_pro',
    words: [
      PhraseWord(word: 'I want to grow', translation: 'quero crescer'),
      PhraseWord(word: 'in the international circuit', translation: 'no circuito internacional'),
    ],
  ),
  Phrase(
    text: 'Record this point so I can post it.',
    meaningPtBr: 'Grava esse ponto pra eu postar.',
    pronunciationHint: 'ri-CORD dhis POINT sou AI kan PÔUST it',
    category: 'daily_pro',
    words: [
      PhraseWord(word: 'Record', translation: 'grava'),
      PhraseWord(word: 'this point', translation: 'esse ponto'),
      PhraseWord(word: 'so I can post it', translation: 'pra eu postar'),
    ],
  ),

  // ── AVANÇADO — JOGO ────────────────────────────────────────────────
  Phrase(
    text: "We need to neutralize their net dominance — let's push them back with deep, heavy topspin shots.",
    meaningPtBr: "Precisamos neutralizar a dominância delas na net — jogá-las pra trás com bolas profundas e com bastante topspin.",
    pronunciationHint: "UI NÍD tu NIÚ-tra-laiz dêr NET DOM-i-nans — LETS PUCH dhem BAK uidh DÍP HEV-i TOP-spin CHOTS",
    category: 'advanced_game',
  ),
  Phrase(
    text: 'Their weak side is clearly the backhand on the deuce court — keep targeting that corner.',
    meaningPtBr: 'O lado fraco delas é claramente o backhand no lado do deuce — continua mirando naquele canto.',
    pronunciationHint: 'dêr UIK SAID iz KLIR-li dê BAK-hand on dê DIÚS CORT — KÍP TAR-ge-ting DHAT COR-ner',
    category: 'advanced_game',
  ),
  Phrase(
    text: 'Stay composed — pressure is a privilege, it means we\'re in the right moment.',
    meaningPtBr: 'Fica tranquila — pressão é um privilégio, significa que estamos no momento certo.',
    pronunciationHint: 'STEI com-PÔUZD — PRECH-er IZ a PRIV-i-ledj, it MÍNZ UIR in dê RAIT MÔU-ment',
    category: 'advanced_game',
  ),
  Phrase(
    text: "Don't overthink it — trust your muscle memory and let the game flow naturally.",
    meaningPtBr: 'Não pensa demais — confia na memória muscular e deixa o jogo fluir naturalmente.',
    pronunciationHint: 'DÔUNT ÔU-ver-TINK it — TRAST ior MAS-ol MEM-o-ri and LET dê GEIM FLÔU NACH-o-ral-i',
    category: 'advanced_game',
  ),
  Phrase(
    text: "We've been in tighter spots than this — reset mentally and come back stronger.",
    meaningPtBr: 'Já estivemos em situações piores — reseta mentalmente e volta mais forte.',
    pronunciationHint: 'UIV BÍN in TAIT-er SPOTS dhan dhis — ri-SET men-TAL-i and CAM BAK STRONG-er',
    category: 'advanced_game',
  ),

  // ── AVANÇADO — DIA A DIA ───────────────────────────────────────────
  Phrase(
    text: 'This tournament has been incredibly demanding, but our preparation has made a real difference.',
    meaningPtBr: 'Esse torneio foi incrivelmente exigente, mas nossa preparação fez uma diferença enorme.',
    pronunciationHint: 'dhis TOR-na-ment HAZ BÍN in-KRED-i-bli di-MAND-ing, bat AUR prep-a-REI-chon HAZ MEID a RÍL DIF-er-ens',
    category: 'advanced_daily',
  ),
  Phrase(
    text: "I think what sets us apart is the chemistry we've built over years of playing together.",
    meaningPtBr: 'O que nos diferencia é a química que construímos ao longo de anos jogando juntas.',
    pronunciationHint: 'AI THINK UOT SETS as a-PART iz dê KEM-is-tri UIV BILT ÔU-ver IÍRZ of PLEI-ing tu-GUETH-er',
    category: 'advanced_daily',
  ),
  Phrase(
    text: "We're open to a long-term partnership, but we'd need more visibility in the contract terms.",
    meaningPtBr: 'Estamos abertos a uma parceria de longo prazo, mas precisaríamos de mais visibilidade nos termos do contrato.',
    pronunciationHint: "UIR ÔU-pen tu a LONG-TERM PART-ner-chip, bat uid NÍD mor viz-i-BIL-i-ti in dê CON-trakt TERMZ",
    category: 'advanced_daily',
  ),
  Phrase(
    text: 'Finding the right doubles partner is like finding a business partner — values and communication are everything.',
    meaningPtBr: 'Encontrar a parceira certa de duplas é como encontrar uma sócia — valores e comunicação são tudo.',
    pronunciationHint: 'FAIND-ing dê RAIT DAB-olz PART-ner iz LAIK FAIND-ing a BIZ-nes PART-ner — VAL-iuz and ko-MIU-ni-kei-chon ar EV-ri-thing',
    category: 'advanced_daily',
  ),

  // ── DIA A DIA (geral) ──────────────────────────────────────────────
  Phrase(
    text: 'Good morning!',
    meaningPtBr: 'Bom dia!',
    pronunciationHint: 'gud mór-ning',
    examples: ['Good morning! How did you sleep?'],
    category: 'daily',
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
    text: 'I will be right back.',
    meaningPtBr: 'Já volto.',
    pronunciationHint: 'ai uil bi ráit bék',
    examples: ['I will be right back in five minutes.'],
    category: 'daily',
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
    text: 'That makes sense.',
    meaningPtBr: 'Isso faz sentido.',
    pronunciationHint: 'dét meiks séns',
    examples: ['Now I understand. That makes sense.'],
    category: 'daily',
  ),
  Phrase(
    text: "I'll figure it out.",
    meaningPtBr: 'Eu vou dar um jeito / vou descobrir.',
    pronunciationHint: 'ail fí-guer it áut',
    examples: ["I do not know yet, but I'll figure it out."],
    category: 'daily',
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
    text: 'I get it.',
    meaningPtBr: 'Entendi.',
    pronunciationHint: 'ai guét it',
    examples: ['Oh, I get it now.'],
    category: 'daily',
  ),
  Phrase(
    text: 'Could you speak a little slower?',
    meaningPtBr: 'Você poderia falar um pouco mais devagar?',
    pronunciationHint: 'cud iú spík a lí-dol slôu-er',
    examples: ['Could you speak a little slower, please?'],
    category: 'daily',
  ),

  // ── BATE-PAPO ──────────────────────────────────────────────────────
  Phrase(
    text: 'How are you doing?',
    meaningPtBr: 'Como você está?',
    pronunciationHint: 'rau ar iú dú-ing',
    examples: ['Hey, how are you doing today?'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'That sounds great.',
    meaningPtBr: 'Isso parece ótimo.',
    pronunciationHint: 'dét sáunds greit',
    examples: ['Dinner at seven? That sounds great.'],
    category: 'smallTalk',
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
    category: 'smallTalk',
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
    text: "I'm down.",
    meaningPtBr: 'Eu topo.',
    pronunciationHint: 'aim dáun',
    examples: ["Dinner tonight? I'm down."],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'No big deal.',
    meaningPtBr: 'Sem problema / não é nada demais.',
    pronunciationHint: 'nô big díl',
    examples: ['Do not worry about it. No big deal.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'I am looking forward to it.',
    meaningPtBr: 'Estou ansiosa por isso.',
    pronunciationHint: 'ai ém lú-king fór-uard tu it',
    examples: ['The trip is next week. I am looking forward to it.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'Take your time.',
    meaningPtBr: 'Sem pressa / leve o tempo que precisar.',
    pronunciationHint: 'teik iór taim',
    examples: ['Take your time. I can wait.'],
    category: 'smallTalk',
  ),
  Phrase(
    text: 'What have you been up to?',
    meaningPtBr: 'O que você tem feito?',
    pronunciationHint: 'uát rév iú bin ap tu',
    examples: ['Long time no see! What have you been up to?'],
    category: 'smallTalk',
  ),

  // ── ALIMENTAÇÃO ────────────────────────────────────────────────────
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
    text: 'I am allergic to peanuts.',
    meaningPtBr: 'Sou alérgica a amendoim.',
    pronunciationHint: 'ai ém a-lér-djik tu pí-nats',
    examples: ['I am allergic to peanuts. Does this have peanuts?'],
    category: 'food',
  ),
  Phrase(
    text: 'I am craving something sweet.',
    meaningPtBr: 'Estou com vontade de comer algo doce.',
    pronunciationHint: 'ai ém crêi-ving sâm-thing suíit',
    examples: ['I am craving something sweet after lunch.'],
    category: 'food',
  ),

  // ── TRABALHO ───────────────────────────────────────────────────────
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
    text: 'I agree with you.',
    meaningPtBr: 'Eu concordo com você.',
    pronunciationHint: 'ai a-grí uith iú',
    examples: ['I agree with you on this point.'],
    category: 'work',
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
    text: 'That is exactly what I need.',
    meaningPtBr: 'É exatamente disso que eu preciso.',
    pronunciationHint: 'dét iz eg-záct-li uát ai nid',
    examples: ['Yes, that is exactly what I need.'],
    category: 'work',
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

  // ── VIAGEM ─────────────────────────────────────────────────────────
  Phrase(
    text: 'Where is the bathroom?',
    meaningPtBr: 'Onde fica o banheiro?',
    pronunciationHint: 'uér iz de béth-rum',
    examples: ['Excuse me, where is the bathroom?'],
    category: 'travel',
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

  // ── COMPRAS ────────────────────────────────────────────────────────
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
    text: 'Do you have this in another size?',
    meaningPtBr: 'Você tem isso em outro tamanho?',
    pronunciationHint: 'du iú rév dis in a-nâ-der saiz',
    examples: ['Do you have this in another size?'],
    category: 'shopping',
  ),
  Phrase(
    text: 'I am just browsing.',
    meaningPtBr: 'Estou só dando uma olhada.',
    pronunciationHint: 'ai ém djâst bráu-zing',
    examples: ['Thanks, I am just browsing.'],
    category: 'shopping',
  ),
];
