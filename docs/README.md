# Ponto PJ — Pacote de Especificação

Documentação completa do aplicativo **Ponto PJ**: registro de ponto pessoal com preenchimento
automático da planilha de horários da empresa e envio por e-mail.

Este pacote foi escrito **antes** de qualquer linha de código de produção. Ele é, ao mesmo tempo:

1. o material de avaliação das disciplinas de **UX** e de **Análise e Projeto de Sistemas**;
2. a base que o autor refina manualmente antes de programar;
3. a especificação executável que um **agente de IA** usa para implementar o app.

---

## Índice

| # | Documento | Conteúdo |
|---|-----------|----------|
| 01 | [Visão e escopo](01-visao-e-escopo.md) | Problema, objetivo, escopo, premissas, glossário |
| 02 | [Requisitos](02-requisitos.md) | RF, RNF, RN e matriz de rastreabilidade |
| 03 | [UX — Personas e jornadas](03-ux-personas-jornadas.md) | Personas, cenários, jornada as-is e to-be |
| 04 | [UX — Navegação e telas](04-ux-navegacao-telas.md) | Mapa de navegação, wireframes, design system, microcopy |
| 05 | [Casos de uso](05-casos-de-uso.md) | Atores, diagrama e UCs detalhados |
| 06 | [Modelo de dados](06-modelo-de-dados.md) | ER, classes de domínio, dicionário de dados, DDL |
| 07 | [Fluxos de atividade](07-fluxos-atividade.md) | Diagramas de atividade dos seis fluxos principais |
| 08 | [Sequência e estados](08-sequencia-e-estados.md) | Diagramas de sequência e máquinas de estado |
| 09 | [Arquitetura técnica](09-arquitetura-tecnica.md) | Camadas, pastas, stack, contratos, erros |
| 10 | [Especificação da planilha](10-especificacao-planilha.md) | Modelo de mapeamento, wizard, algoritmo, riscos |
| 11 | [Especificação de e-mail e envio](11-especificacao-email-e-envio.md) | Templates, integração, histórico, lembretes |
| 12 | [Regras de cálculo](12-regras-de-calculo.md) | Algoritmos de horas, saldo e banco de horas |
| 13 | [Plano de implementação](13-plano-de-implementacao.md) | Fases, backlog para IA, critérios de aceite |
| 14 | [Testes e qualidade](14-testes-e-qualidade.md) | Estratégia, casos de teste, massa de dados |
| 15 | [Riscos e decisões](15-riscos-e-decisoes.md) | ADRs, riscos, spikes, backlog futuro |

Instruções operacionais para quem for implementar estão em [`../CLAUDE.md`](../CLAUDE.md).

---

## Mapa de leitura por público

**Professor(a) de UX** → 01 → 03 → 04
Concentram a pesquisa, a jornada do usuário, os wireframes, o design system e a justificativa
de cada decisão de interface.

**Professor(a) de Análise e Projeto** → 01 → 02 → 05 → 06 → 07 → 08
Concentram requisitos, casos de uso e todos os diagramas UML (entidade-relacionamento, classes,
atividade, sequência e estado).

**Implementador (humano ou IA)** → `../CLAUDE.md` → 13 → 09 → 06 → 12 → 10 → 11
O documento 13 define a ordem das fases; os demais são consultados sob demanda por tarefa.

**Leitura rápida (10 minutos)** → 01, depois o diagrama A4 em 07 e o wizard em 10.

---

## Convenções

**Identificadores rastreáveis.** Todo item recebe um código estável, usado em referências cruzadas:

| Prefixo | Significado | Definido em |
|---------|-------------|-------------|
| `RF-xx` | Requisito funcional | 02 |
| `RNF-xx` | Requisito não funcional | 02 |
| `RN-xx` | Regra de negócio | 02 |
| `UC-xx` | Caso de uso | 05 |
| `TL-xx` | Tela | 04 |
| `A-x` | Fluxo de atividade | 07 |
| `F-x` | Fase de implementação | 13 |
| `T-xxx` | Tarefa de implementação | 13 |
| `R-xx` | Risco | 15 |
| `S-xx` | Spike técnico | 15 |
| `ADR-xx` | Decisão de arquitetura | 15 |

**Idioma.** Documentos, entidades, tabelas, campos, classes de domínio e interface em **português
do Brasil**. Identificadores de código são escritos **sem acentos e sem cedilha**, como exige o
bom senso em Dart e SQL: `Marcacao`, `observacao`, `configuracao_jornada`. Apenas os nomes de
pastas de arquitetura seguem a convenção do ecossistema Flutter em inglês (`domain/`, `data/`,
`presentation/`) — a justificativa está em [ADR-04](15-riscos-e-decisoes.md).

**Diagramas.** Todos em [Mermaid](https://mermaid.js.org), em blocos ` ```mermaid `. Renderizam
direto no GitHub, no preview do VS Code (extensão *Markdown Preview Mermaid Support*) e em
<https://mermaid.live>. Nenhuma imagem binária é usada, para que o material continue versionável
e editável em texto.

**Estado do documento.** Todo o pacote está na versão 1.0 — completo e coerente, porém
deliberadamente aberto a refinamento. Pontos ainda em aberto estão marcados com `> ⚠️ EM ABERTO`
no corpo do texto.

---

## Contexto do projeto

| Item | Valor |
|------|-------|
| Nome | Ponto PJ |
| Plataforma alvo | Android 8.0 (API 26) ou superior |
| Framework | Flutter 3.24.4 / Dart 3.5.4 |
| Persistência | SQLite local (Drift), 100% offline |
| Distribuição | Instalação direta / uso pessoal, sem publicação em loja nesta fase |
