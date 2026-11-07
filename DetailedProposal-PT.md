# Proteger uma app Android no dispositivo do atacante

_Protecting an Android app on the attacker’s device_

Mestrado em Cibersegurança. Orientador: Vítor Fonte. Proposta já atribuída a um estudante.

## Contexto

O Kouci é uma aplicação de análise de polo aquático para treinadores e equipas, desenvolvida pelo mestrando. Regista jogos e dados de observação de adversários e inclui funcionalidades pagas. Funciona offline-first: durante a utilização, parte da lógica, dos dados e da verificação da licença tem de estar no dispositivo, sem consulta contínua a um servidor de confiança. Um atacante com controlo do seu dispositivo pode analisar e modificar a aplicação. A ofuscação, a verificação local da assinatura e a proteção de chaves podem dificultar ataques concretos; a utilidade de cada medida depende do objetivo e das capacidades do atacante [1-4]. O Kouci dá contexto a uma avaliação limitada e reprodutível; a dissertação não exige o endurecimento comercial do produto.

## Pergunta

Num caso Android offline-first, que esforço observa o próprio programador para ativar uma funcionalidade paga sem licença válida, na versão de base, na versão com R8 e na versão com verificação local do certificado de assinatura? Que esforço observa para recuperar em claro um conjunto fixo de dados de observação, guardado sem cifra ou cifrado com uma chave do Android Keystore? E que custos de implementação, tamanho e desempenho acompanham cada variante?

## O que se faz

Definem-se os ativos, os dois objetivos de ataque e as capacidades do atacante. Para cada tentativa, registam-se as condições de partida: acesso root, instrumentação do processo, estado da aplicação e da licença e requisitos e estado da autenticação para usar a chave. No ataque aos dados, a aplicação processa um conjunto sintético fixo e mostra resultados agregados, sem oferecer ao atacante acesso ou exportação autorizados ao conjunto completo. Recuperação significa obter os dados completos em claro fora desse percurso normal. Há dois percursos: extrair os ficheiros em repouso sem executar a aplicação e intercetar os dados durante o processamento, depois da decifragem na variante com Keystore. As pré-condições e a evidência de sucesso de cada percurso ficam fixadas antes da medição. O acesso legítimo à interface ou a exportação autorizada não contam como ataque.

Constrói-se um pequeno banco de ensaios Android com os fluxos de licença e de dados do Kouci, para permitir uma comparação controlada. O banco preserva a tecnologia e o comportamento relevantes de cada fluxo; as simplificações face ao Kouci são documentadas. A versão de base tem os mesmos fluxos, mas guarda os dados em claro e não inclui as três proteções avaliadas. Preparam-se três variantes separadas: (1) ofuscação com R8 [5], indicando se a configuração também reduz ou otimiza o código; (2) verificação, pela própria aplicação, do certificado que assinou o APK contra um certificado esperado, para detetar reempacotamento e nova assinatura [6]; (3) cifra dos dados com uma chave não exportável do Android Keystore [4]. Mantêm-se iguais os dados, o dispositivo, a funcionalidade e as definições de compilação não relacionadas com cada proteção. Todas as alterações próprias de cada variante ficam registadas. O nível de segurança da chave efetivamente usada é obtido e reportado, sem o inferir apenas das capacidades do dispositivo. A ofuscação adicional com ferramentas abertas é opcional.

Faz-se primeiro um piloto de calibração numa amostra separada (por exemplo, uma aplicação ou um fluxo de treino), cujos tempos não entram nos resultados. Antes de qualquer medição, incluindo a da versão de base, congela-se um protocolo com a ordem das variantes, as classes de ferramentas e técnicas permitidas (por exemplo, descompilação estática ou instrumentação dinâmica), as regras de adaptação a obstáculos, o orçamento T de horas ativas por tentativa (por exemplo, 20 horas) e a evidência exigida para cada sucesso (por exemplo, a funcionalidade paga a funcionar sem licença ou o conjunto recuperado igual ao conjunto sintético). O protocolo permite escolhas dentro dessas regras, sem impor uma sequência rígida de passos. Um diário datado regista o tempo ativo de cada passo, a ferramenta, a operação, os obstáculos e os insucessos. O conhecimento prévio do analista sobre a implementação e o que aprendeu entre tentativas também se declara.

No objetivo da licença, atacam-se a versão de base, a versão com R8 e a versão com verificação do certificado; no objetivo dos dados, a versão de base e a versão com Keystore. Para cada tentativa, reportam-se o resultado, o tempo ativo até ao sucesso, a classe de ferramentas, a necessidade de análise estática ou dinâmica, as pré-condições do dispositivo, o número de passos e a dimensão dos scripts ou alterações usados. Uma tentativa que não atinge o objetivo dentro do orçamento é reportada como “sem sucesso em T horas ativas”: é uma observação censurada (a tentativa parou em T horas sem sucesso; T é um limite inferior para o tempo até ao sucesso), separada dos tempos até ao sucesso. Do lado da implementação, registam-se separadamente o tempo de aprendizagem e o tempo de integração da proteção. Medem-se o tamanho do APK, o tempo de arranque e o tempo de acesso aos dados, em condições a frio e a quente, com repetições, mediana e dispersão. A chave não exportável dificulta obter o material criptográfico. Um processo comprometido ainda pode observar os dados quando a aplicação os usa [4]. Esse limite é parte da comparação.

O autor das proteções é também quem executa os ataques. O seu conhecimento prévio da implementação declara-se. O conhecimento do código e a aprendizagem entre tentativas podem influenciar os tempos e impedem generalizar os resultados para outros atacantes. As diferenças observadas descrevem este analista, estas versões e estas condições; não isolam uma contribuição causal de cada proteção nem um efeito do suporte da chave por hardware. O piloto separado, o protocolo congelado antes da versão de base, a ordem declarada, os indicadores observáveis e o registo do tempo por passo reduzem a margem de decisão durante a medição e tornam a limitação verificável.

## Mínimo viável

Um banco de ensaios Android com os dois fluxos, a versão de base e as três proteções em variantes individuais; um modelo de ameaça e um protocolo congelado; as tentativas pertinentes para cada objetivo; e uma comparação do esforço observado com os custos de implementação, tamanho e desempenho. Um resultado negativo rigoroso, incluindo tentativas sem sucesso dentro do orçamento, é suficiente. O estudo da chave do Keystore reporta o nível de segurança disponível no dispositivo de teste, sem prometer uma comparação isolada entre hardware e software. Combinações de proteções, um segundo dispositivo Android, iOS, attestation remota com ligação ocasional e deteção de adulteração em runtime são extensões opcionais.

## Fora do âmbito

Endurecimento comercial completo do Kouci; avaliação aprofundada em desktop; criptografia de caixa branca; serviço de licenciamento em produção; verificações online contínuas; segurança do pipeline de compilação; dados reais de equipas ou clientes. Attestation remota e deteção em runtime ficam fora do mínimo.

## Primeiro dia

Acesso aos fluxos de licença e de dados do Kouci para os reproduzir no banco de ensaios; ambiente de desenvolvimento Android; um dispositivo físico de teste; ferramentas correntes de análise de APK e de instrumentação; e um conjunto sintético de dados. O primeiro trabalho é definir o modelo de ameaça e preparar o piloto e o protocolo de medição.

## Perfil

À vontade com desenvolvimento Android e linha de comandos; interesse por engenharia inversa e avaliação empírica de segurança. O mestrando já desenvolve o Kouci. Nas primeiras semanas há prática orientada de análise estática de APK e instrumentação dinâmica.

## Como decorre

De novembro de 2026 a julho de 2027. O estado da arte prepara-se e apresenta-se na UC de Seminários. O trabalho propriamente dito corre em paralelo: no fim de janeiro, o banco de ensaios está operacional, o modelo de ameaça está definido, o piloto terminou e o protocolo está congelado. A versão de base mede-se até meados de fevereiro e a primeira variante protegida fica pronta no fim de fevereiro ou no início de março.

O mínimo basta para a dissertação. Um resultado negativo rigoroso é um resultado completo; a falta de dados ou uma avaliação por terminar levam a uma alteração de âmbito acordada. Reuniões regulares (semanais nos primeiros meses) e uma nota quinzenal de uma página. Rota curta: um rascunho completo da dissertação com o âmbito mínimo no fim de maio, para entrega antecipada se o calendário do curso o permitir, sem extensões.

Palavras-chave: segurança Android, engenharia inversa, aplicações offline-first, ofuscação, Android Keystore, avaliação empírica; Keywords: Android security, reverse engineering, offline-first applications, obfuscation, Android Keystore, empirical evaluation

## Referências

[1] C. S. Collberg e C. Thomborson. “Watermarking, Tamper-Proofing, and Obfuscation: Tools for Software Protection.” IEEE Transactions on Software Engineering, 28(8), 2002. https://doi.org/10.1109/TSE.2002.1027797 [2] S. Schrittwieser, S. Katzenbeisser, J. Kinder, G. Merzdovnik e E. Weippl. “Protecting Software through Obfuscation: Can It Keep Pace with Progress in Code Analysis?” ACM Computing Surveys, 49(1), artigo 4, 2016. https://doi.org/10.1145/2886012 [3] OWASP. Mobile Application Security Verification Standard (MASVS) e Mobile Application Security Testing Guide (MASTG). https://mas.owasp.org/ [4] Android Developers. “Android Keystore system.” https://developer.android.com/privacy-and-security/keystore [5] Android Developers. “Enable app optimization with R8.” https://developer.android.com/topic/performance/app-optimization/enable-app-optimization [6] Android Developers. “PackageManager”, método `hasSigningCertificate`. https://developer.android.com/reference/android/content/pm/PackageManager.html

Mestrado em Cibersegurança, Universidade do Minho. Proposta de dissertação para 2026/2027.