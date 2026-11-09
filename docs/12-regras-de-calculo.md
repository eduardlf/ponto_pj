# 12 — Regras de Cálculo

Especificação executável do serviço `CalculadoraPonto` ([09](09-arquitetura-tecnica.md)), que
implementa o fluxo [A5](07-fluxos-atividade.md) e as regras RN-01 a RN-16 de
[02](02-requisitos.md).

Este é o componente mais testável e o mais crítico do sistema: um erro aqui não trava o app — ele
produz um número errado que vai parar em uma planilha entregue ao RH. As tabelas de casos deste
documento são a especificação dos testes unitários obrigatórios de [14](14-testes-e-qualidade.md);
cada linha vira um `test()`.

---

## 12.1 Unidades e invariantes

| Grandeza | Unidade | Observação |
|----------|---------|------------|
| Hora do dia | `Duration` desde a meia-noite | `08:30` é `Duration(minutes: 510)` |
| Duração e carga | `Duration` em minutos | Sempre positiva |
| Saldo | `Duration` em minutos | **Pode ser negativa** |
| Precisão | 1 minuto | Segundos são descartados na entrada, nunca arredondados |

**Invariantes que o cálculo nunca viola**

1. As marcações são ordenadas por hora crescente e os tipos alternam a partir de `ENTRADA` (RN-01).
   Ordem e tipo são **derivados**, jamais informados.
2. Os campos persistidos de `dia_trabalho` **não dependem do relógio**. Dois cálculos do mesmo dia,
   com as mesmas marcações, em momentos diferentes, produzem o mesmo resultado. É o que torna a
   visão de mês estável e os testes determinísticos.
3. `calcularDia` é uma função pura: mesma entrada, mesma saída. `agora` é sempre um parâmetro
   injetado, nunca `DateTime.now()` lido de dentro.

---

## 12.2 Valores persistidos e valores vivos

Distinção que resolve um conflito real: durante o expediente, o dia ainda não terminou, mas o
usuário quer ver o total subindo em tempo real.

| Valor | Persistido? | Depende de `agora`? | Definição |
|-------|:---:|:---:|-----------|
| `minutosTrabalhados` | Sim | Não | Soma dos **pares completos** (RN-07) |
| `saldo` | Sim | Não | Calculado sobre `minutosTrabalhados` (RN-11 a RN-14) |
| `inconsistente` | Sim | Só para distinguir hoje de ontem | RN-02 |
| `minutosEmCurso` | Não | Sim | `agora − última entrada aberta`, ou zero |
| `minutosTrabalhadosAgora` | Não | Sim | `minutosTrabalhados + minutosEmCurso` |
| `saldoAgora` | Não | Sim | Calculado sobre `minutosTrabalhadosAgora` |
| `previsaoSaida` | Não | Sim | RN-16 |

A tela do Dia exibe os valores vivos quando a data é hoje e o dia está em andamento; nas demais
situações, exibe os persistidos — que são iguais, porque `minutosEmCurso` é zero. As visões de
semana e mês sempre usam os persistidos, com uma única exceção: o **banco de horas** usa `saldoAgora`
para o dia corrente, para não exibir um mergulho artificial no meio do expediente.

---

## 12.3 Algoritmo principal

```
função calcularDia(dia, jornada, agora) -> DiaTrabalho

  // ── 1. Carga prevista (RN-10) ──────────────────────────────────────────────
  jornadaDoDia ← jornada.paraDiaSemana(dia.data.weekday)
  cargaPrevista ← jornadaDoDia.trabalha ? jornadaDoDia.carga : 0

  // ── 2. Ordenação e tipagem (RN-01) ─────────────────────────────────────────
  marcacoes ← dia.marcacoes ordenadas por hora crescente
  se jornada.permiteViradaDia:                                // RN-08, ver 12.5
      marcacoes ← rotação que começa logo depois do maior intervalo entre
                  horários consecutivos (o intervalo que cruza a meia-noite
                  vence os empates, preservando a ordem crescente)
  para i de 0 até marcacoes.length - 1:
      marcacoes[i].ordem ← i + 1
      marcacoes[i].tipo  ← (i % 2 == 0) ? ENTRADA : SAIDA

  // ── 3. Consistência (RN-02) ────────────────────────────────────────────────
  ehHoje       ← mesmaData(dia.data, agora)
  qtdePar      ← marcacoes.length % 2 == 0
  emAndamento  ← não qtdePar e ehHoje e marcacoes.ultima.tipo == ENTRADA
  inconsistente ← não qtdePar e não emAndamento

  // ── 4. Turnos e minutos trabalhados (RN-07, RN-08) ─────────────────────────
  minutosTrabalhados ← 0
  para cada par (entrada, saida) em marcacoes agrupadas de dois em dois:
      se saida.hora > entrada.hora:
          duracao ← saida.hora - entrada.hora
      senão se jornada.permiteViradaDia:
          duracao ← saida.hora + 24h - entrada.hora          // RN-08
      senão:
          inconsistente ← verdadeiro                          // par inválido
          continua                                            // não soma nada
      minutosTrabalhados ← minutosTrabalhados + duracao

  // ── 5. Saldo (RN-11, RN-12, RN-13) ─────────────────────────────────────────
  escolha dia.status:
      FOLGA, FERIADO, FERIAS, ATESTADO, ABONO:
          saldo ← minutosTrabalhados                          // carga abonada, RN-12
      FALTA:
          saldo ← -cargaPrevista                              // RN-13
      NORMAL, COMPENSACAO:
          saldo ← minutosTrabalhados - cargaPrevista          // RN-11

  // ── 6. Tolerância (RN-14) ──────────────────────────────────────────────────
  se abs(saldo) <= jornada.tolerancia:
      saldo ← 0

  retorna dia.copiaCom(
      marcacoes, cargaPrevista, minutosTrabalhados, saldo, inconsistente)
```

```
função previsaoSaida(dia, jornada, agora) -> Duration?      // RN-16

  se não dia.emAndamento(agora): retorna nulo

  ultimaEntrada ← dia.marcacoes.ultima.hora
  faltando      ← max(0, dia.cargaPrevista - dia.minutosTrabalhados)
  retorna ultimaEntrada + faltando
```

```
função calcularPeriodo(dias, jornada, agora) -> ResumoPeriodo

  trabalhado    ← soma de dia.minutosTrabalhados, usando o valor vivo para o dia corrente
  cargaPrevista ← soma de dia.cargaPrevista
  saldo         ← soma de dia.saldo, usando saldoAgora para o dia corrente
  diasUteis     ← contagem de dias com cargaPrevista > 0
  bancoHoras    ← bancoAcumuladoAte(ultimoDiaDoPeriodo, jornada)       // RN-15
  pendencias    ← levantarPendencias(dias)

  retorna ResumoPeriodo(...)
```

**Dias futuros.** Um dia depois de `agora` ainda não aconteceu: entra em `cargaPrevista` e em
`diasUteis` (são propriedades do período), mas não soma trabalho, saldo nem banco, e não gera
pendência. Sem essa regra, a visão da semana mostraria na segunda-feira um saldo de −32 h. Pelo
mesmo motivo, o dia de hoje só vira "dia útil sem registro" depois que termina. O trabalhado do
dia corrente também usa o valor vivo, para ficar coerente com o saldo ao lado dele.

**Dias antes do início do acompanhamento.** O início do banco de RN-15 —
`data_inicio_banco` ou, sem ela, o primeiro dia registrado; sem registro nenhum, hoje — também
delimita os totais e as pendências dos períodos. Um dia anterior a ele nunca passou pelo app: é
tratado como os dias futuros. A regra apareceu no primeiro teste em aparelho: instalado em 09/11,
o app abria o fechamento de outubro com 22 dias úteis sem registro e saldo de −176 h. Quem quiser
contar dias anteriores define o início do banco na tela da jornada.

```
função bancoAcumuladoAte(data, jornada) -> Duration          // RN-15

  inicio ← jornada.dataInicioBanco ?? data do primeiro dia registrado
  retorna soma de saldo de todos os dias entre inicio e data, inclusive
```

```
função levantarPendencias(dias) -> List<Pendencia>

  para cada dia:
      se dia.inconsistente:
          adiciona MARCACOES_INCOMPLETAS
      senão se dia.cargaPrevista > 0 e dia.status == NORMAL e dia.marcacoes vazio:
          adiciona DIA_UTIL_SEM_REGISTRO
      senão se dia.status == FALTA e dia.marcacoes não vazio:
          adiciona FALTA_COM_MARCACOES        // contradição, RN-13
```

---

## 12.4 Casos de teste — minutos trabalhados

Jornada: segunda a sexta, 480 min (08:00–12:00 e 13:00–17:00). Tolerância 0. Virada de dia
desligada, salvo indicação.

| # | Data | Marcações | Status | Trabalhado | Saldo | Inconsistente | Regras |
|---|------|-----------|--------|-----------:|------:|:---:|--------|
| C01 | qui | 08:00 12:00 13:00 17:00 | NORMAL | 480 | 0 | não | RN-07, RN-11 |
| C02 | qui | 08:00 12:00 13:00 17:30 | NORMAL | 510 | +30 | não | RN-07, RN-11 |
| C03 | qui | 08:00 12:00 13:00 16:30 | NORMAL | 450 | −30 | não | RN-11 |
| C04 | qui | 08:00 17:00 | NORMAL | 540 | +60 | não | turno único sem intervalo |
| C05 | qui | *(vazio)* | NORMAL | 0 | −480 | não | dia útil sem registro |
| C06 | qui (passado) | 08:00 12:00 13:00 | NORMAL | 240 | −240 | **sim** | RN-02, RN-07 |
| C07 | qui (hoje) | 08:00 | NORMAL | 0 | −480 | não | em andamento, não é inconsistente |
| C08 | qui (hoje) | 08:00 12:00 13:00 | NORMAL | 240 | −240 | não | em andamento |
| C09 | qui | 08:00 12:00 13:00 17:00 18:00 20:00 | NORMAL | 600 | +120 | não | três turnos |
| C10 | sáb | 09:00 13:00 | NORMAL | 240 | +240 | não | RN-10: carga 0, tudo é crédito |
| C11 | sáb | *(vazio)* | NORMAL | 0 | 0 | não | dia não trabalhado |

**Marcações fora de ordem.** Informar 13:00, depois 08:00, produz exatamente C01: a ordenação de
RN-01 acontece antes de tudo. Isso é caso de teste próprio, porque é a proteção contra a classe
inteira de bugs de "saída antes da entrada".

---

## 12.5 Casos de teste — virada de dia (RN-08)

| # | Marcações | `permiteViradaDia` | Trabalhado | Inconsistente | Observação |
|---|-----------|:---:|-----------:|:---:|---|
| V01 | 22:00 06:00 | sim | 480 | não | `06:00 + 24h − 22:00 = 8h` |
| V02 | 22:00 06:00 | **não** | 960 | não | sem virada, lidos em ordem: 06:00 → 22:00 |
| V03 | 22:00 02:00 03:00 06:00 | sim | 420 | não | 4h + 3h |
| V04 | 08:00 12:00 22:00 02:00 | sim | 480 | não | turno normal + turno virado |
| V05 | 08:00 08:00 | qualquer | — | — | recusado na entrada por RN-04 |

> **Nota de revisão (implementação da F-2).** A primeira versão desta tabela esperava V02 com 0
> minutos e dia inconsistente, como se os horários fossem pareados na ordem em que foram digitados.
> Isso contradiz RN-01 — "as marcações são sempre ordenadas por horário crescente" — e o caso de
> teste das marcações fora de ordem de 12.4: depois de ordenar, a saída nunca fica antes da entrada,
> e o ramo de virada do algoritmo nunca era alcançado. Como o modelo guarda só a hora do dia, a
> única forma de um turno cruzar a meia-noite sem violar RN-01 é escolher onde a sequência começa.
> Com a virada ligada, ela começa logo depois do **maior intervalo** entre horários consecutivos,
> que é o período de descanso: em `22:00 06:00`, o maior intervalo vai de 06:00 a 22:00, então o
> dia começa às 22:00. V01, V03 e V04 continuam com os mesmos totais. Com a virada desligada, nada
> muda em relação a RN-01.

A virada de dia continua **desligada por padrão**, agora por outro motivo: com ela ligada, um dia
diurno com um único turno de mais de 12 horas (07:00 às 20:00, por exemplo) é lido como turno
noturno, porque o maior intervalo passa a ser o da jornada. Para quem trabalha de dia, a ordem
crescente nunca erra; a opção existe para quem trabalha à noite.

---

## 12.6 Casos de teste — status e abono

Jornada de segunda a sexta com 480 min; todos os casos em uma quinta-feira.

| # | Status | Marcações | Carga prevista | Trabalhado | Saldo | Regra |
|---|--------|-----------|---------------:|-----------:|------:|-------|
| S01 | NORMAL | 08:00 12:00 13:00 17:00 | 480 | 480 | 0 | RN-11 |
| S02 | FOLGA | *(vazio)* | 480 | 0 | **0** | RN-12 — carga abonada |
| S03 | FERIADO | *(vazio)* | 480 | 0 | 0 | RN-12 |
| S04 | FERIADO | 08:00 12:00 | 480 | 240 | **+240** | RN-12 — trabalho em feriado é crédito integral |
| S05 | FERIAS | *(vazio)* | 480 | 0 | 0 | RN-12 |
| S06 | ATESTADO | *(vazio)* | 480 | 0 | 0 | RN-12 |
| S07 | ABONO | 08:00 10:00 | 480 | 120 | +120 | RN-12 |
| S08 | FALTA | *(vazio)* | 480 | 0 | **−480** | RN-13 |
| S09 | FALTA | 08:00 12:00 | 480 | 240 | **−480** | RN-13 — status vence; gera pendência |
| S10 | COMPENSACAO | 08:00 12:00 | 480 | 240 | −240 | tratado como NORMAL |

S09 é intencionalmente contraditório e por isso vira uma pendência `FALTA_COM_MARCACOES` no
fechamento: um dia marcado como falta com horários registrados quase sempre é um status esquecido,
não uma decisão. O app não adivinha — sinaliza.

---

## 12.7 Casos de teste — tolerância (RN-14)

| # | Saldo bruto | Tolerância | Saldo final |
|---|------------:|-----------:|------------:|
| T01 | +3 | 5 | 0 |
| T02 | −3 | 5 | 0 |
| T03 | +5 | 5 | 0 |
| T04 | +6 | 5 | +6 |
| T05 | −6 | 5 | −6 |
| T06 | +3 | 0 | +3 |

A comparação é `abs(saldo) <= tolerancia`, inclusiva. A tolerância zera o saldo por completo, não
o reduz — é assim que a regra funciona na prática trabalhista que o app modela.

---

## 12.8 Casos de teste — previsão de saída (RN-16)

Carga prevista 480 min em todos os casos.

| # | Marcações | `agora` | Trabalhado | Faltam | Previsão | Observação |
|---|-----------|---------|-----------:|-------:|----------|---|
| P01 | 08:00 | 09:30 | 0 | 480 | **16:00** | `08:00 + 8h` |
| P02 | 08:00 12:00 13:00 | 14:00 | 240 | 240 | **17:00** | caso típico |
| P03 | 08:00 12:00 13:00 | 17:30 | 240 | 240 | **17:00** | já passou; a UI mostra "carga cumprida" |
| P04 | 08:00 12:00 13:00 17:00 | 17:30 | 480 | — | **nulo** | dia fechado, não há previsão |
| P05 | 08:00 12:00 | 12:30 | 240 | — | **nulo** | não está em andamento: última é SAÍDA |
| P06 | 09:00 12:00 13:00 | 14:00 | 180 | 300 | **18:00** | entrada atrasada empurra a previsão |
| P07 | 08:00 (sábado, carga 0) | 10:00 | 0 | 0 | **08:00** | carga zero: previsão igual à entrada |

P03 mostra por que a previsão não é limitada por `agora`: ela responde "a que horas a carga
termina", e essa resposta continua sendo 17:00 mesmo às 17:30. A tela troca o rótulo de "Previsão
de saída" para "Carga cumprida" quando a previsão está no passado.

---

## 12.9 Casos de teste — banco de horas (RN-15)

Jornada de 480 min de segunda a sexta, tolerância 0, `data_inicio_banco` nula.

| Data | Dia | Marcações / status | Saldo do dia | Banco acumulado |
|------|-----|--------------------|-------------:|----------------:|
| 04/05 | seg | 08:00 12:00 13:00 17:30 | +30 | +30 |
| 05/05 | ter | 08:00 12:00 13:00 17:00 | 0 | +30 |
| 06/05 | qua | 08:00 12:00 13:00 16:00 | −60 | −30 |
| 07/05 | qui | FERIADO | 0 | −30 |
| 08/05 | sex | 08:00 12:00 13:00 18:00 | +60 | +30 |
| 09/05 | sáb | 09:00 13:00 | +240 | +270 |
| 10/05 | dom | *(vazio)* | 0 | +270 |
| 11/05 | seg | FALTA | −480 | −210 |

Com `data_inicio_banco = 06/05`, o mesmo conjunto acumula: 06/05 = −60, 07/05 = −60, 08/05 = 0,
09/05 = +240, 11/05 = −240. Dias anteriores ao início do banco não entram — é o que permite ao
usuário começar a contar de um marco combinado com a empresa, sem apagar o histórico.

---

## 12.10 Formatação

Implementada em `core/formatadores.dart` ([09, seção 9.8](09-arquitetura-tecnica.md)). Nenhum
widget monta essas strings por conta própria.

| Função | Entrada | Saída |
|--------|---------|-------|
| `formatarDuracao` | 510 min | `08h 30m` |
| `formatarDuracao` | 0 min | `00h 00m` |
| `formatarDuracao` | 1500 min | `25h 00m` |
| `formatarDuracaoComSinal` | +30 min | `+ 00h 30m` |
| `formatarDuracaoComSinal` | −75 min | `- 01h 15m` |
| `formatarDuracaoComSinal` | 0 min | `00h 00m` |
| `formatarHora` | 510 min | `08:00` |
| `formatarHora` | 1439 min | `23:59` |
| `formatarDataCurta` | 07/05/2026 | `07/05/2026` |
| `formatarDataExtensa` | 07/05/2026 | `qui., 07 mai. 2026` |
| `formatarCompetencia` | 2026-05 | `maio/2026` |

**Regras de formatação**

- Duração usa `HHh MMm` com dois dígitos em cada parte e **nunca** transborda para dias: 25 horas
  são `25h 00m`, jamais `1d 01h`.
- Saldo zero é exibido sem sinal.
- O sinal é separado do valor por um espaço (`+ 00h 30m`), o que melhora a leitura em fonte pequena
  e evita a confusão entre `-01h` e `01h` em telas com pouco contraste.
- Duração negativa nunca aparece sem sinal em lugar nenhum da interface.

---

## 12.11 Casos de borda catalogados

| Situação | Comportamento definido |
|----------|------------------------|
| Marcação exatamente à meia-noite (`00:00`) | Válida, `Duration.zero`. É uma entrada às 0h, não uma ausência de valor |
| Marcação às `23:59` seguida de saída às `00:01` | Com virada de dia ligada, resulta em 2 minutos; desligada, os horários são lidos em ordem e resultam em 23h58 (00:01 → 23:59) |
| Saída às 12:00 seguida de nova entrada às 13:00, ainda sem a saída | O intervalo de 1 h já existe (RN-09): o almoço aconteceu, mesmo com o segundo turno aberto |
| Dia com uma única marcação em data passada | Inconsistente, trabalhado 0, saldo `−carga` (C06) |
| Dia com marcações e carga prevista 0 | Todo o trabalhado vira crédito (C10) |
| Alteração da jornada com dias já calculados | Dias fechados não são recalculados (RN-29); os abertos são recalculados na próxima leitura |
| Fuso horário do aparelho alterado | Nenhum efeito: datas são texto ISO e horas são minutos desde a meia-noite ([06, seção 6.1](06-modelo-de-dados.md)) |
| Horário de verão iniciando ou terminando | Nenhum efeito, pela mesma razão. Um dia de 23 horas reais continua tendo carga prevista de 8 horas |
| Virada da meia-noite com o app aberto | O dia em andamento passa a inconsistente na próxima leitura; dispara o lembrete `DIA_INCOMPLETO` |
| Competência sem nenhum dia registrado | Resumo com zeros; a geração é permitida e produz a planilha com todos os dias vazios |
| Mês com 28, 29, 30 ou 31 dias | `Competencia.totalDias()` é a única fonte; nenhum cálculo assume 30 ou 31 |
| Ano bissexto | Coberto pelo item acima; caso de teste explícito para fevereiro de 2028 |
