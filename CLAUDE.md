# CLAUDE.md — Instruções de implementação

Aplicativo Flutter de registro de ponto que preenche a planilha Excel da empresa e a envia por
e-mail. Trabalho acadêmico multidisciplinar (UX + Análise de Sistemas) que resolve um problema real.

**A especificação completa está em [`docs/`](docs/) e é obrigatória.** Ela foi escrita antes do
código e é a fonte de verdade. Divergiu do documento? O código está errado — ou o documento precisa
ser atualizado primeiro, de propósito, e não como efeito colateral.

## Estado atual

Primeira entrega pronta: o núcleo funcional, de F-0 a F-6, sem feriados (T-306/T-307) e sem
fechar/reabrir o dia (T-308). F-7 (notificações, backup) não começou; só o tema existe. O spike
S-01 foi executado com a planilha real; falta abrir o arquivo gerado no Excel. O quadro tarefa a
tarefa está em [`docs/13`, seção 13.5](docs/13-plano-de-implementacao.md). Próximo passo: F-7,
começando pelo lembrete de fechamento (T-704).

## Comandos

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # após mexer em tabelas Drift
flutter analyze
flutter test
flutter test integration_test/                              # precisa de emulador ou aparelho
flutter run
flutter build apk --release
dart run tool/spike_xlsx.dart <modelo.xlsx> <saida.xlsx>        # S-01: preenche uma planilha real
```

Ambiente: Flutter 3.24.4 / Dart 3.5.4. Alvo: Android 8.0 (API 26)+. Windows e Web estão no
scaffold, mas **fora de escopo**.

## Antes de começar qualquer tarefa

1. Achar a tarefa em [`docs/13-plano-de-implementacao.md`](docs/13-plano-de-implementacao.md) — ela
   tem um ID `T-xxx` e aponta o documento que a especifica.
2. Ler os documentos indicados na tabela "ordem de leitura por tipo de tarefa" (seção 13.4).
3. Implementar. Nada de inventar comportamento não especificado — se faltar informação, perguntar
   ou registrar como ponto em aberto no documento correspondente.
4. Rodar `flutter analyze` e `flutter test`.
5. Percorrer a "Definição de pronto" (seção 13.3) e o checklist de revisão de
   [`docs/14-testes-e-qualidade.md`](docs/14-testes-e-qualidade.md).

## Onde está cada coisa

| Preciso de… | Documento |
|-------------|-----------|
| Requisitos, regras de negócio, rastreabilidade | [02](docs/02-requisitos.md) |
| Wireframe, microcopy, cores, acessibilidade | [04](docs/04-ux-navegacao-telas.md) |
| Fluxo detalhado de um caso de uso | [05](docs/05-casos-de-uso.md) e [07](docs/07-fluxos-atividade.md) |
| **Tabelas, campos, tipos, enums** | [06](docs/06-modelo-de-dados.md) |
| Camadas, pastas, pacotes, contratos, erros | [09](docs/09-arquitetura-tecnica.md) |
| **Mapeamento e escrita da planilha** | [10](docs/10-especificacao-planilha.md) |
| E-mail, variáveis, histórico, lembretes | [11](docs/11-especificacao-email-e-envio.md) |
| **Cálculo de horas e casos de teste** | [12](docs/12-regras-de-calculo.md) |
| Ordem das fases e critérios de aceite | [13](docs/13-plano-de-implementacao.md) |
| O que testar e com quais dados | [14](docs/14-testes-e-qualidade.md) |
| Por que uma decisão foi tomada | [15](docs/15-riscos-e-decisoes.md) |

## Convenções

**Idioma.** Domínio, tabelas, campos, classes de negócio e toda a interface em **português**, sem
acento nos identificadores: `DiaTrabalho`, `Marcacao`, `configuracao_jornada`, `observacao`.
Pastas de camada em inglês: `domain/`, `data/`, `presentation/`, `core/` ([ADR-04](docs/15-riscos-e-decisoes.md)).

**Camadas.** Dependência em sentido único:
- `domain/` é Dart puro — **nunca** importa `package:flutter`, `package:drift`, `data/` nem `presentation/`.
- `presentation/` acessa `data/` somente por providers do Riverpod.
- `core/` não importa nenhuma outra camada do projeto.

**Erros.** Operações que dependem do mundo externo (arquivo, banco, sistema operacional) retornam
`Resultado<T>`, não lançam exceção. Toda `Falha` nasce com a mensagem em português que o usuário vai
ler — a interface exibe `falha.mensagem`, nunca monta texto de erro
([09, 9.5](docs/09-arquitetura-tecnica.md)).

**Tempo.** Datas civis são texto ISO `AAAA-MM-DD`; horas do dia são `Duration` em minutos desde a
meia-noite ([ADR-08](docs/15-riscos-e-decisoes.md)). `DateTime.now()` só é chamado no serviço de
relógio e no agendador, e é sempre injetável.

**Formatação.** Só através de `core/formatadores.dart`. Nenhum widget monta string de data,
hora ou duração por conta própria.

## Regras rígidas

1. **Não criar campo, tabela ou enum que não esteja em [`docs/06`](docs/06-modelo-de-dados.md).**
   Se faltar, atualizar o documento 06 primeiro e dizer que fez isso.
2. **Não escrever cálculo de horas fora de `CalculadoraPonto`.** As regras estão em
   [`docs/12`](docs/12-regras-de-calculo.md) e cada tabela de casos de lá vira teste.
3. **Não implementar o que está fora de escopo** em [`docs/01`, seção 1.6](docs/01-visao-e-escopo.md):
   adicional noturno, sobreaviso, valor-hora, meta semanal, nuvem, iOS, SMTP. Estão no backlog de
   [`docs/15`](docs/15-riscos-e-decisoes.md) e lá devem ficar.
4. **Não pular fases.** A ordem de [`docs/13`](docs/13-plano-de-implementacao.md) existe porque cada
   fase depende da anterior.
5. **Não adicionar `android.permission.INTERNET`** ao manifesto
   ([ADR-10](docs/15-riscos-e-decisoes.md)). O app não acessa a rede, e essa é uma garantia
   verificável, não uma intenção. Confira no APK de release com
   `aapt dump permissions build/app/outputs/flutter-apk/app-release.apk`.
6. **Não usar o pacote `excel` para escrever** arquivos. Ele serve apenas para **ler** no wizard.
   A escrita é feita por `EscritorXlsxZip`, conforme [`docs/10`, seção 10.5](docs/10-especificacao-planilha.md)
   e [ADR-05](docs/15-riscos-e-decisoes.md).
7. **Não afirmar que um e-mail foi enviado.** O app pergunta ao usuário
   ([RN-23](docs/02-requisitos.md), [ADR-09](docs/15-riscos-e-decisoes.md)).
8. **Não deixar texto de interface em inglês**, nem mensagem de erro com código técnico, `null` ou
   stack trace.

## Armadilhas conhecidas

- **Anexo de e-mail chega vazio** → falta o `FileProvider` e o `res/xml/file_paths.xml`
  ([11, 11.3](docs/11-especificacao-email-e-envio.md), tarefa T-604).
- **"Nenhum app de e-mail encontrado" com o Gmail instalado** → falta o bloco `<queries>` no
  manifesto (Android 11+), mesma seção.
- **Excel pede para reparar o arquivo gerado** → ordem de linhas ou de colunas violada no
  `sheetN.xml`, ou XML sem escape ([10, 10.5](docs/10-especificacao-planilha.md)).
- **Total do mês zerado na planilha, com os dias preenchidos** → faltou remover `calcChain.xml` e
  marcar `fullCalcOnLoad="1"`, mesma seção.
- **Saldo do mês muda sozinho ao longo do dia** → algum lugar está usando `saldoAgora` onde deveria
  usar o valor persistido ([12, 12.2](docs/12-regras-de-calculo.md)).
- **Teste que passa de manhã e falha à noite** → `DateTime.now()` dentro do domínio em vez de
  `agora` injetado.
- **`flutter build apk` falha com `isolateDebugLog`** → `drift_flutter` acima da 0.2.4 com
  `drift` 2.23. As duas versões andam juntas; o `pubspec.yaml` explica ([09, 9.3](docs/09-arquitetura-tecnica.md)).
- **Teste de repositório falha no Windows ao abrir o banco** → falta a DLL do SQLite; use
  `abrirBancoDeTeste()` de `test/helpers/banco_teste.dart`, que cai para a `winsqlite3.dll`.
- **Data "pula" um dia ou dá diferença de 23 h** → `DateTime` local onde deveria ser data civil.
  Datas do domínio são meia-noite UTC: use `dataCivil()`, `apenasData` e `somarDias()` de
  `core/extensoes/data_extensoes.dart`.
- **Nova escrita no banco e a tela não atualiza** → faltou incrementar `versaoDadosProvider`
  depois da escrita; é ele que avisa as outras telas.
