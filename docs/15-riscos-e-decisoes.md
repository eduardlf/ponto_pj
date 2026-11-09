# 15 — Riscos, Decisões e Evolução

## 15.1 Decisões de arquitetura (ADRs)

Cada decisão registra o contexto que a motivou, a alternativa descartada e a consequência aceita.
São o material de defesa do projeto: um professor ou um revisor que discorde de uma escolha
encontra aqui o raciocínio completo, e não precisa deduzi-lo do código.

---

### ADR-01 — Persistência local em SQLite com Drift

**Contexto.** O app precisa guardar meses de marcações, consultar por dia, semana e mês, e somar
saldos acumulados. Nada disso exige rede.

**Decisão.** SQLite local via Drift, sem qualquer backend.

**Alternativas descartadas.**
- *Firebase ou Supabase*: traria conta de usuário, sincronização e custo de infraestrutura para
  resolver um problema que não existe — o usuário tem um aparelho e usa um aparelho. Violaria
  [RNF-05](02-requisitos.md).
- *Hive ou JSON em arquivo*: mais rápido de começar, mas as consultas de intervalo e a soma do banco
  de horas virariam varredura em memória, e o diagrama ER — artefato exigido pela disciplina de
  análise — perderia sentido.

**Consequências.** Nenhum custo, funciona offline, backup é responsabilidade do usuário (RF-48).
Perder o aparelho sem backup perde os dados; é o preço aceito, mitigado por R-04.

---

### ADR-02 — Abrir o cliente de e-mail em vez de enviar por SMTP

**Contexto.** O objetivo OE-4 é reduzir o envio a poucos toques. SMTP direto seria literalmente um
toque; abrir o cliente são dois.

**Decisão.** O app monta a mensagem com anexo e entrega ao cliente de e-mail do usuário.

**Alternativa descartada.** *SMTP com o pacote `mailer`*: exigiria armazenar servidor, porta,
usuário e senha de aplicativo no dispositivo. Um app de registro de ponto passaria a ser
custodiante da credencial de e-mail do usuário — responsabilidade desproporcional ao ganho de um
toque por mês, e incompatível com [RNF-05](02-requisitos.md). Também exigiria a permissão de
internet, abrindo mão da garantia estrutural de privacidade descrita em
[09, seção 9.3](09-arquitetura-tecnica.md).

**Consequências.** O app não sabe se o e-mail foi enviado, o que obriga à confirmação de
[RN-23](02-requisitos.md) — ver ADR-09. Em compensação, não há senha para vazar, não há conta para
configurar e não há falha de autenticação para depurar.

---

### ADR-03 — Marcações como lista ordenada, não como colunas fixas

**Contexto.** A planilha da empresa tem colunas fixas: entrada 1, saída 1, entrada 2, saída 2. Seria
tentador modelar o banco do mesmo jeito.

**Decisão.** `dia_trabalho` tem uma lista de `marcacao`. Ordem e tipo são derivados da ordenação por
horário ([RN-01](02-requisitos.md)).

**Alternativa descartada.** *Quatro colunas em `dia_trabalho`*: mais simples de escrever na planilha,
mas incapaz de representar três turnos, e produtora de uma classe inteira de bugs — qualquer código
que escrevesse `saida1` sem verificar `entrada1` criaria um estado impossível.

**Consequências.** A linha do tempo de TL-06, os turnos e os intervalos saem de graça do modelo. O
preenchimento da planilha ganha um passo de achatamento — a lista vira colunas em
[10, seção 10.4](10-especificacao-planilha.md) — e um caso de truncamento quando há mais marcações
que colunas. Troca vantajosa: a complexidade fica em um lugar só, num algoritmo testado.

---

### ADR-04 — Domínio em português, pastas de arquitetura em inglês

**Contexto.** O trabalho é acadêmico e será lido em português por professores. O código é Dart, cujo
ecossistema é inteiramente em inglês.

**Decisão.** Entidades, tabelas, campos, classes de negócio e interface em pt-BR, sem acento nos
identificadores. Pastas de camada em inglês: `domain/`, `data/`, `presentation/`, `core/`.

**Alternativa descartada.** *Tudo em inglês*: distanciaria o código do vocabulário do domínio
brasileiro — "banco de horas", "abono", "competência" não têm tradução direta — e do texto dos
documentos. *Tudo em português, inclusive pastas*: `apresentacao/` e `dominio/` destoariam de
qualquer projeto Flutter e de toda a documentação de terceiros consultada durante a implementação.

**Consequências.** Um leve hibridismo, deliberado e documentado. `domain/entidades/dia_trabalho.dart`
lê bem nos dois sentidos.

---

### ADR-05 — Escrita cirúrgica do XML em vez de reserialização da pasta de trabalho

**Contexto.** O arquivo gerado precisa ser aceito por quem o recebe, com fórmulas e formatação
intactas ([RN-22](02-requisitos.md), persona Renata).

**Decisão.** `EscritorXlsxZip` altera apenas `xl/worksheets/sheetN.xml` dentro do zip, preservando
todas as demais entradas. Detalhes em [10, seção 10.5](10-especificacao-planilha.md).

**Alternativa descartada.** *Escrever com o pacote `excel`*: reserializa a pasta inteira e descarta
o que seu modelo não representa — formatação condicional, imagens, validação de dados e fórmulas.
O arquivo abriria e teria os dados certos, e ainda assim seria rejeitado.

**Consequências.** Mais código de baixo nível e um risco técnico real ([R-01](#152-riscos)),
mitigado pelo spike S-01 antes de qualquer outra implementação. Em troca, fidelidade que nenhuma
biblioteca de alto nível entrega. O pacote `excel` continua sendo usado — apenas para **ler**, onde
é ótimo.

---

### ADR-06 — Campos calculados persistidos em `dia_trabalho`

**Contexto.** A visão de mês precisa exibir 31 dias com totais em menos de 300 ms
([RNF-02](02-requisitos.md)).

**Decisão.** `minutos_trabalhados`, `saldo_minutos` e `inconsistente` são calculados e gravados.

**Alternativa descartada.** *Calcular sempre na leitura*: normalizado e sem risco de divergência,
mas exigiria carregar todas as marcações de todos os dias a cada rolagem do calendário.

**Consequências.** Duplicação controlada. A integridade depende de um único ponto de escrita — o
serviço de cálculo — que recalcula o dia após qualquer alteração. É a razão de
[RN-29](02-requisitos.md) existir e de `dia_trabalho` guardar sua própria carga prevista em vez de
referenciar a jornada ([06, seção 6.2](06-modelo-de-dados.md)).

---

### ADR-07 — Riverpod sem geração de código

**Contexto.** O projeto já usa `build_runner` para o Drift.

**Decisão.** Providers escritos à mão, sem `riverpod_generator`.

**Alternativa descartada.** *Riverpod com anotações*: menos código repetitivo, mas acrescentaria
outra rodada de geração ao ciclo de build e uma camada de indireção a mais para quem for ler o
trabalho.

**Consequências.** Alguns providers verbosos, em troca de um código que se lê de cima a baixo sem
precisar entender o que o gerador produziu.

---

### ADR-08 — Datas como texto ISO, horas como minutos desde a meia-noite

**Contexto.** Registro de ponto é sensível a fuso horário e a horário de verão. Um `DateTime`
armazenado como instante UTC pode "mudar de dia" ao ser lido em outro fuso.

**Decisão.** Datas civis em `TEXT` no formato `AAAA-MM-DD`; horas do dia em `INTEGER` de minutos.

**Alternativa descartada.** *`DateTime` nativo do Drift*: idiomático, mas carrega hora e fuso onde
nenhum dos dois faz sentido. O dia 7 de maio é o dia 7 de maio em qualquer lugar do planeta.

**Consequências.** Dois conversores em `data/local/conversores.dart` e aritmética de horas trivial.
O sistema fica imune a viagem, a mudança de fuso e a horário de verão — ver
[12, seção 12.11](12-regras-de-calculo.md).

---

### ADR-09 — Confirmação humana do envio

**Contexto.** O Android não informa ao app se um e-mail disparado por intenção foi enviado.

**Decisão.** O status só passa a `ENVIADO` quando o usuário confirma
([RN-23](02-requisitos.md)).

**Alternativa descartada.** *Assumir o envio ao retornar do cliente*: produziria falso positivo e
silenciaria o lembrete de uma competência que nunca chegou ao RH — reintroduzindo a dor D1, que é a
razão de o produto existir.

**Consequências.** Um toque a mais por mês e um histórico que nunca mente. Justificativa completa em
[11, seção 11.4](11-especificacao-email-e-envio.md).

---

### ADR-10 — Sem permissão de internet

**Contexto.** [RNF-05](02-requisitos.md) promete que nenhum dado sai do aparelho.

**Decisão.** `android.permission.INTERNET` não é declarada no manifesto.

**Consequências.** A promessa deixa de ser uma intenção e passa a ser uma garantia verificável por
qualquer pessoa que inspecione o APK — inclusive o professor. Nenhuma dependência futura que exija
rede pode entrar sem revisitar esta decisão, o que é exatamente o comportamento desejado.

**Verificação.** `aapt dump permissions` no APK de release da primeira entrega lista apenas
`br.com.pontopj.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, que o androidx adiciona sozinho. Nenhum
plugin trouxe `INTERNET`. O manifesto de depuração continua com ela, porque o `flutter run` precisa
da rede para o hot reload — e ele não vai para o APK de release.

---

### ADR-11 — Leitura do `.xlsx` com `archive` e `xml`, sem o pacote `excel`

**Contexto.** A especificação previa o pacote `excel` só para **ler** a planilha no wizard. A
escrita já trata o `.xlsx` como um zip de XML (ADR-05).

**Decisão.** `LeitorPlanilhaXml` lê abas, células, textos compartilhados, fórmulas, mesclagens e
formatos de número direto do XML, com os mesmos `archive` e `xml` da escrita, e os dois
compartilham `PacoteXlsx`, que resolve os relacionamentos do pacote.

**Alternativa descartada.** *Pacote `excel`*: uma dependência a mais, e pesada; reconstrói a pasta
inteira em memória; e não expõe, de forma simples, o que o wizard precisa saber — se uma célula
**vazia** já está formatada como data ou hora (é o que permite sugerir valores nativos) e quais
células são mescladas (é o que permite achar o campo ao lado de "Nome:").

**Consequências.** Leitor e escritor enxergam o arquivo do mesmo jeito, e um teste garante que o
arquivo gerado é relido corretamente. Em troca, cerca de 300 linhas de código próprio, cobertas
pelos testes de `test/data/`.

---

### ADR-12 — Período da competência configurável no modelo

**Contexto.** RN-25 previa só o mês civil. A planilha real que originou o projeto, preenchida
antes por um script em Python, cobre de 26 do mês anterior a 25 do mês da competência — e com o
mês civil o app escreveria as datas erradas.

**Decisão.** `modelo_planilha.dia_inicio_competencia` (1 a 28, padrão 1). A `Competencia` recebe
esse dia: com 26, a competência 10/2026 vai de 26/09 a 25/10. A pergunta fica no passo 2 do wizard.

**Alternativas descartadas.** *Guardar o dia em `preferencia_app` ou na jornada*: o período é uma
propriedade da planilha da empresa, não do horário de trabalho. *Período totalmente livre (data
inicial e final)*: complexidade sem caso real que a justifique; o limite de 28 garante que o dia
exista em todos os meses.

**Consequências.** O fechamento, a sugestão de competência e o cartão de competência pendente usam
o período do modelo ativo; a visão de Mês continua sendo o mês do calendário.

---

### ADR-13 — Virada de dia pela rotação no maior intervalo

**Contexto.** RN-01 ordena as marcações por horário, e a tabela 12.5 esperava turnos cruzando a
meia-noite. As duas coisas eram incompatíveis: depois de ordenar, a saída nunca fica antes da
entrada. Detalhes na nota de revisão de [12, seção 12.5](12-regras-de-calculo.md).

**Decisão.** Com a virada ligada, a sequência começa logo depois do maior intervalo entre
horários consecutivos; desligada, vale a ordem crescente pura.

**Alternativa descartada.** *Guardar a hora além de 24 h ou a data real de cada batida*: mudaria o
modelo de dados (06, seção 6.1) para atender um caso raro, e o botão de bater ponto continuaria
gravando a saída das 06:00 no dia seguinte.

**Consequências.** Com a virada ligada, um turno diurno único de mais de 12 h é lido como noturno.
Por isso ela continua desligada por padrão — e, ligada, um horário digitado errado não vira mais um
turno de 23 h.

---

## 15.2 Riscos

Probabilidade e impacto em alta, média e baixa.

### R-01 — A escrita do `.xlsx` não preserva a planilha da empresa
**Prob.** Média · **Impacto** Alto · **Fase** F-5

Se `EscritorXlsxZip` corromper o arquivo ou perder formatação em algum arranjo real, o produto falha
no seu objetivo central: o RH rejeita o arquivo, e o usuário volta a preencher à mão.

**Mitigação.** O spike [S-01](13-plano-de-implementacao.md) é executado **antes** de qualquer outra
implementação, com a planilha real da empresa. Os testes de preservação byte a byte de
[14](14-testes-e-qualidade.md) travam regressão. A ordem de recuo está em
[10, seção 10.5](10-especificacao-planilha.md).

**Sinal de alerta.** O Excel exibir "encontramos um problema com algum conteúdo" ao abrir o arquivo
gerado — mesmo que consiga repará-lo.

---

### R-02 — O modelo de mapeamento não cobre a planilha real
**Prob.** Média · **Impacto** Alto · **Fase** F-4

O mapeamento pressupõe planilhas tabulares (premissa P1 de [01](01-visao-e-escopo.md)). Uma planilha
com blocos por semana, uma aba por semana, ou duas linhas por dia não cabe no modelo.

**Mitigação.** Validar o modelo contra a planilha real **antes** de F-4, no mesmo momento de S-01.
A estratégia `POR_DATA` já absorve boa parte da variação (linhas intercaladas, tabelas anuais). Se a
planilha real não couber, a correção é ampliar o modelo em [10](10-especificacao-planilha.md) antes
de codificar — não improvisar durante a implementação.

---

### R-03 — Lembretes suprimidos por otimização de bateria
**Prob.** Alta · **Impacto** Médio · **Fase** F-7

Fabricantes Android — Xiaomi, Samsung, Motorola — matam alarmes de apps em segundo plano de forma
agressiva. O lembrete de fechamento pode simplesmente não chegar, e é justamente ele que resolve a
dor D1.

**Mitigação.** Usar alarme exato quando permitido; orientar o usuário na tela de notificações a
isentar o app da otimização de bateria, com atalho para os ajustes do sistema (UC-13, exceção E2).
Como rede de segurança, ao abrir o app em qualquer dia após o fim de uma competência não enviada, a
aba Dia exibe um cartão de competência pendente — que independe de notificação.

---

### R-04 — Perda de dados por perda do aparelho
**Prob.** Baixa · **Impacto** Alto · **Fase** F-7

Sem nuvem (ADR-01), o aparelho é o único lugar onde os dados existem.

**Mitigação.** Backup manual (RF-48) e sugestão de backup ao final de cada fechamento mensal — o
momento em que o usuário já está pensando no assunto e o custo psicológico é mínimo.

---

### R-05 — O onboarding assusta e o usuário abandona
**Prob.** Média · **Impacto** Médio · **Fase** F-1, F-4

O wizard de planilha é a etapa de nota 3 na jornada futura de
[03](03-ux-personas-jornadas.md), e acontece quando a confiança no app ainda é zero.

**Mitigação.** Todas as etapas podem ser puladas ([A1](07-fluxos-atividade.md)); o registro diário
funciona sem nenhuma configuração de planilha. A pré-visualização do passo 5 existe especificamente
para terminar a etapa mais difícil com uma sensação de sucesso. O teste de usabilidade de
[03, seção 3.6](03-ux-personas-jornadas.md) mede se funcionou.

---

### R-06 — Divergência entre os campos calculados e as marcações
**Prob.** Baixa · **Impacto** Médio · **Fase** F-2

Consequência aceita de ADR-06: um caminho de escrita que esqueça de recalcular deixa o dia com
totais errados que ninguém percebe.

**Mitigação.** O recálculo mora no repositório, não nos controllers — é impossível gravar uma
marcação sem passar por ele. Teste de repositório específico para cada operação de escrita. Como
verificação adicional, o fechamento do mês recalcula todos os dias da competência antes de gerar.

---

### R-07 — Versões de pacotes incompatíveis com Flutter 3.24.4
**Prob.** Média · **Impacto** Baixo · **Fase** F-0

As versões de [09, seção 9.3](09-arquitetura-tecnica.md) são as linhas conhecidamente compatíveis,
mas o ecossistema se move.

**Mitigação.** Resolver com `flutter pub add` na F-0 e fixar o que o resolvedor escolher. Se algum
pacote exigir um SDK mais novo, atualizar o Flutter é preferível a fixar uma versão antiga com
falhas conhecidas.

---

### R-08 — Escopo acadêmico crescendo além do executável
**Prob.** Média · **Impacto** Médio · **Todas as fases**

A tentação de implementar adicional noturno, sobreaviso e valor-hora "já que estamos aqui" é real, e
é o modo clássico de um trabalho de faculdade não ser entregue.

**Mitigação.** A lista de fora de escopo de [01, seção 1.6](01-visao-e-escopo.md) e a regra 6 de
[13, seção 13.1](13-plano-de-implementacao.md). Cada fase é entregável por si só: o projeto tem
valor demonstrável mesmo parando na F-5.

---

## 15.3 Spikes técnicos

| ID | Pergunta | Quando | Prazo | Detalhamento |
|----|----------|--------|-------|--------------|
| **S-01** | É possível escrever em um `.xlsx` real preservando formatação, fórmulas e demais abas? | **Antes da F-0** | 3 dias | [13](13-plano-de-implementacao.md). **Executado:** sim, com a ressalva de abrir no Excel — resultado em [10, seção 10.5](10-especificacao-planilha.md) |
| **S-02** | O modelo de mapeamento de [10](10-especificacao-planilha.md) cobre a planilha real da empresa? | Junto de S-01 | 1 dia | Preencher o modelo à mão em papel, campo por campo, com a planilha aberta. **Executado:** cobre, desde que o período comece no dia 26 (ADR-12); o wizard sugere sozinho todo o resto do mapeamento |
| **S-03** | `flutter_local_notifications` dispara de forma confiável com o app fechado no aparelho do autor? | Antes da F-7 | 1 dia | Agendar para 24h à frente, fechar o app, verificar. Se falhar, R-03 se materializou |

Um spike não produz código de produção. Ele produz uma resposta e, se necessário, uma ADR nova.

---

## 15.4 Backlog futuro

Itens deliberadamente fora desta versão, com o registro do porquê e do que seria necessário.

### Cálculo e remuneração
| Item | O que exigiria |
|------|----------------|
| Adicional noturno | Faixa horária configurável e percentual; recorte dos turnos que a cruzam |
| Sobreaviso | Nova entidade de período de sobreaviso, independente das marcações |
| Regras de hora extra por tipo de dia | Percentuais por dia útil, domingo e feriado; mudança em RN-11 |
| Valor da hora e prévia de remuneração | Campo no perfil e novos campos calculados no resumo |
| Meta semanal e meta de banco de horas | Novo resumo por semana com progresso |

### Jornada e histórico
| Item | O que exigiria |
|------|----------------|
| **Vigência da jornada** | Versionar `configuracao_jornada` por período, resolvendo a limitação de RN-29 anotada em [02](02-requisitos.md). É o item de maior valor desta lista |
| Feriados móveis | Cálculo da Páscoa e derivados (Carnaval, Sexta-feira Santa, Corpus Christi) |
| Múltiplos vínculos | Remover RN-17; escopo por vínculo em quase todas as tabelas |

### Planilha e entrega
| Item | O que exigiria |
|------|----------------|
| Reconhecimento automático do layout | Heurística ou modelo que proponha o mapeamento; o wizard vira revisão em vez de preenchimento |
| Modelos multi-aba | Mapeamento por aba, uma por competência |
| Exportação em PDF | Novo gerador, útil quando a empresa aceita PDF assinado |
| Envio por SMTP | Reverter ADR-02; exigiria armazenamento seguro de credenciais |

### Plataforma e experiência
| Item | O que exigiria |
|------|----------------|
| iOS | Substituir a integração de e-mail e revisar o acesso a arquivos |
| Sincronização em nuvem | Reverter ADR-01 e ADR-10; conta, resolução de conflitos, política de privacidade |
| Internacionalização | Extrair os textos para ARB; hoje são literais em pt-BR ([09, 9.8](09-arquitetura-tecnica.md)) |
| Widget na tela inicial | Bater ponto sem abrir o app |
| Importar histórico de outro app | Leitor de CSV com mapeamento, reaproveitando a ideia do wizard |

Nenhum destes itens é implementado nesta versão, e a regra 6 de
[13, seção 13.1](13-plano-de-implementacao.md) existe para garantir isso.
