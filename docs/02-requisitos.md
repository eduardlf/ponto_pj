# 02 — Requisitos

Este documento é a fonte de verdade sobre **o que** o sistema faz. O **como** está em
[09 — Arquitetura](09-arquitetura-tecnica.md) e nos documentos de especificação 10, 11 e 12.

Prioridade segue MoSCoW: **E** = essencial (*must*), **I** = importante (*should*),
**D** = desejável (*could*).

---

## 2.1 Requisitos funcionais

### Módulo Perfil e preferências

| ID | Requisito | Prio |
|----|-----------|------|
| RF-01 | Cadastrar e editar o perfil do usuário: nome, matrícula, cargo, empresa e e-mail. Esses dados alimentam as células fixas da planilha e as variáveis do e-mail. | E |
| RF-02 | Alternar o tema entre claro, escuro e automático (seguindo o sistema). | I |
| RF-03 | Executar um assistente de configuração inicial na primeira abertura, cobrindo perfil, jornada, modelo de planilha e e-mail, com possibilidade de pular etapas e retomar depois. | E |

### Módulo Jornada de trabalho

| ID | Requisito | Prio |
|----|-----------|------|
| RF-04 | Configurar, para cada dia da semana, se é dia de trabalho e quais são os turnos previstos (pares de entrada e saída). | E |
| RF-05 | Calcular e exibir automaticamente a carga horária de cada dia a partir dos turnos previstos, permitindo sobrescrevê-la manualmente. | I |
| RF-06 | Definir a tolerância em minutos e se turnos podem cruzar a meia-noite. | I |
| RF-07 | Exibir o resumo da jornada semanal com a carga horária total da semana. | D |

### Módulo Registro de ponto

| ID | Requisito | Prio |
|----|-----------|------|
| RF-08 | Registrar uma marcação com o horário atual através de um único botão, inferindo automaticamente se é entrada ou saída. | E |
| RF-09 | Adicionar uma marcação manualmente, informando o horário e, opcionalmente, corrigindo o tipo. | E |
| RF-10 | Editar o horário de uma marcação existente. | E |
| RF-11 | Excluir uma marcação, com confirmação. | E |
| RF-12 | Visualizar o dia como linha do tempo, mostrando marcações, duração de cada turno, duração de cada intervalo e a previsão de saída quando o dia ainda está aberto. | E |
| RF-13 | Definir o status do dia (normal, folga, feriado, férias, atestado, falta, abono, compensação) e registrar uma observação em texto livre. | E |
| RF-14 | Sinalizar visualmente dias inconsistentes, isto é, com número ímpar de marcações. | I |
| RF-15 | Marcar um dia como fechado e reabri-lo mediante confirmação. | D |

### Módulo Calendário e consolidação

| ID | Requisito | Prio |
|----|-----------|------|
| RF-16 | Visualizar a semana com as marcações e o total trabalhado de cada dia, mais o total e o saldo da semana. | I |
| RF-17 | Visualizar o mês em formato de calendário, com as marcações resumidas e um indicador de status em cada dia. | I |
| RF-18 | Navegar entre períodos anterior e seguinte em qualquer das três visões, e saltar direto para "hoje". | E |
| RF-19 | Exibir, no cabeçalho de cada visão, o total trabalhado, o saldo do período e o banco de horas acumulado. | E |

### Módulo Feriados e ausências

| ID | Requisito | Prio |
|----|-----------|------|
| RF-20 | Cadastrar, editar e excluir feriados, informando data, descrição e se a recorrência é anual. | I |
| RF-21 | Aplicar automaticamente o status FERIADO aos dias que coincidem com um feriado cadastrado, sem sobrescrever um status definido manualmente pelo usuário. | I |
| RF-22 | Carregar, na configuração inicial, uma lista pré-definida de feriados nacionais brasileiros, que o usuário pode editar livremente. | D |

### Módulo Modelo de planilha

| ID | Requisito | Prio |
|----|-----------|------|
| RF-23 | Importar um arquivo `.xlsx` do dispositivo e guardá-lo como modelo base, preservando o arquivo original intacto. | E |
| RF-24 | Selecionar a aba de trabalho, a linha de cabeçalho e a primeira linha de dados, com pré-visualização do conteúdo real da planilha. | E |
| RF-25 | Escolher a estratégia de linha: sequencial (o dia 1 vai na primeira linha de dados, o dia 2 na seguinte) ou por data (cada dia é escrito na linha cuja coluna de data corresponde). | E |
| RF-26 | Mapear as colunas dos campos por dia: data, entrada 1, saída 1, entrada 2, saída 2, entrada 3, saída 3, total do dia, saldo do dia, observação e status. Nenhum campo além da data é obrigatório. | E |
| RF-27 | Mapear células fixas por referência absoluta (ex.: `C3`), para nome, matrícula, cargo, empresa, competência, mês, ano, total do mês, saldo do mês e um texto livre. | I |
| RF-28 | Definir o texto que será escrito na planilha para cada status de dia não trabalhado. | I |
| RF-29 | Definir o formato de escrita da data e da hora, escolhendo entre texto formatado e valor nativo de data/hora do Excel. | I |
| RF-30 | Pré-visualizar, antes de salvar, como ficará o preenchimento de uma competência real ou de exemplo. | E |
| RF-31 | Consultar e editar o mapeamento salvo a qualquer momento pelas configurações, sem precisar reimportar o arquivo. | E |
| RF-32 | Substituir o arquivo modelo mantendo o mapeamento existente, alertando quando o novo arquivo for incompatível com ele. | I |

### Módulo Geração da planilha

| ID | Requisito | Prio |
|----|-----------|------|
| RF-33 | Gerar o arquivo `.xlsx` de uma competência, preenchendo o modelo com os dados dos dias e as células fixas, preservando toda a formatação, fórmulas e demais conteúdos do arquivo original. | E |
| RF-34 | Apresentar, antes de gerar, a lista de pendências da competência: dias inconsistentes, dias úteis sem nenhum registro e dias com status pendente de definição. | E |
| RF-35 | Permitir gerar mesmo com pendências, mediante confirmação explícita do usuário. | I |
| RF-36 | Salvar o arquivo gerado no dispositivo com nome derivado de um template configurável e registrar a geração no histórico. | E |
| RF-37 | Compartilhar o arquivo gerado por qualquer aplicativo do sistema, além do e-mail. | D |

### Módulo E-mail

| ID | Requisito | Prio |
|----|-----------|------|
| RF-38 | Configurar destinatários, cópia, assunto, corpo da mensagem e template do nome do arquivo, todos aceitando variáveis como `{nome}` e `{competencia}`. | E |
| RF-39 | Pré-visualizar o e-mail com todas as variáveis já resolvidas para a competência em questão. | I |
| RF-40 | Abrir o cliente de e-mail do dispositivo com destinatários, cópia, assunto, corpo e o arquivo já anexado. | E |
| RF-41 | Registrar o envio como concluído mediante confirmação explícita do usuário após o retorno do cliente de e-mail. | E |
| RF-42 | Consultar o histórico de envios por competência, com data de geração, data de envio, status e acesso ao arquivo gerado. | I |
| RF-43 | Regenerar e reenviar uma competência já enviada, criando um novo registro no histórico. | D |

### Módulo Notificações

| ID | Requisito | Prio |
|----|-----------|------|
| RF-44 | Configurar lembretes de jornada (hora de começar, hora do intervalo, hora de retornar, hora de sair), com antecedência opcional e respeitando os dias de trabalho configurados. | I |
| RF-45 | Configurar o lembrete de fechamento do mês, escolhendo o dia (do mês ou os últimos dias) e o horário. | E |
| RF-46 | Notificar o usuário quando um dia de trabalho terminar com registro incompleto ou inexistente. | D |
| RF-47 | Suprimir os lembretes de jornada em dias marcados como folga, feriado, férias ou atestado. | I |

### Módulo Backup

| ID | Requisito | Prio |
|----|-----------|------|
| RF-48 | Exportar todos os dados do aplicativo, incluindo o arquivo modelo, para um único arquivo de backup. | I |
| RF-49 | Restaurar os dados a partir de um arquivo de backup, substituindo o conteúdo atual mediante confirmação. | I |

---

## 2.2 Requisitos não funcionais

| ID | Categoria | Requisito | Como verificar |
|----|-----------|-----------|----------------|
| RNF-01 | Disponibilidade | Nenhuma funcionalidade pode depender de conexão de rede. O app funciona integralmente em modo avião, exceto o envio do e-mail, que é responsabilidade do cliente externo. | Executar a suíte de aceite com o aparelho em modo avião |
| RNF-02 | Desempenho | Abrir a visão de mês com 31 dias preenchidos em menos de 300 ms; gerar a planilha de uma competência completa em menos de 3 s em aparelho de entrada. | Medição com `Stopwatch` nos testes de integração |
| RNF-03 | Acessibilidade | Alvos de toque de no mínimo 48 dp; contraste mínimo 4.5:1 para texto normal; todo ícone acionável com rótulo `Semantics`; layout íntegro com fonte ampliada até 200%. | Checklist em [04](04-ux-navegacao-telas.md) e inspeção com TalkBack |
| RNF-04 | Aparência | Tema claro e escuro completos, seguindo a preferência do sistema por padrão. | Inspeção visual nas duas variantes de todas as telas |
| RNF-05 | Privacidade | Nenhum dado do usuário é transmitido para qualquer servidor. Sem telemetria, sem analytics, sem conta. O único dado que deixa o aparelho é o anexo que o próprio usuário envia. | Auditoria de dependências e ausência de permissão de internet no manifesto |
| RNF-06 | Robustez | Falha na leitura ou na escrita de um arquivo `.xlsx` nunca pode corromper o modelo salvo, travar o aplicativo ou perder dados de ponto. Toda falha resulta em mensagem explicativa e estado íntegro. | Testes com arquivos corrompidos, vazios e de formato errado |
| RNF-07 | Localização | Interface, datas, horas e números em português do Brasil, no fuso horário do dispositivo. | Inspeção; testes de formatação em [12](12-regras-de-calculo.md) |
| RNF-08 | Compatibilidade | Android 8.0 (API 26) ou superior. | Configuração de `minSdk` e teste em emulador API 26 |
| RNF-09 | Integridade | Toda alteração de dados é transacional. O esquema do banco é versionado com migrações que preservam os dados existentes. | Teste de migração entre versões consecutivas do esquema |
| RNF-10 | Testabilidade | A camada de domínio não importa nada de `package:flutter`. Regras de cálculo e preenchimento de planilha são testáveis sem emulador. | `flutter test` roda o domínio inteiro sem widget test |
| RNF-11 | Manutenibilidade | Nenhuma regra de negócio duplicada entre camadas. Toda regra de cálculo vive num único serviço de domínio. | Revisão de código conforme [14](14-testes-e-qualidade.md) |
| RNF-12 | Usabilidade | Um usuário sem treinamento configura um modelo de planilha real em até 5 minutos. | Teste de usabilidade descrito em [03](03-ux-personas-jornadas.md) |
| RNF-13 | Resiliência | O app restaura a tela e o estado de edição após ser encerrado pelo sistema em segundo plano. | Teste manual com "não manter atividades" ligado |

---

## 2.3 Regras de negócio

As regras marcadas com ★ têm algoritmo detalhado e tabela de casos em
[12 — Regras de cálculo](12-regras-de-calculo.md).

### Marcações e consistência

| ID | Regra |
|----|-------|
| RN-01 | As marcações de um dia são sempre ordenadas por horário crescente, e os tipos alternam começando por ENTRADA. A ordem e o tipo são derivados da posição, nunca informados livremente. |
| RN-02 | Um dia com número ímpar de marcações é **inconsistente**, exceto quando é o dia corrente e a última marcação é uma entrada — nesse caso o dia está **em andamento**. |
| RN-03 | Não se registra marcação com data futura. |
| RN-04 | Não podem existir duas marcações com o mesmo horário no mesmo dia. |
| RN-05 | Ao excluir uma marcação, as demais são reordenadas e seus tipos recalculados conforme RN-01. |
| RN-06 | O botão de bater ponto infere o tipo pela quantidade de marcações já existentes: par resulta em ENTRADA, ímpar resulta em SAÍDA. |

### Cálculo ★

| ID | Regra |
|----|-------|
| RN-07 | Minutos trabalhados no dia = soma da duração de todos os pares completos de marcações. Uma marcação sem par não contribui. |
| RN-08 | Se, dentro de um par, o horário de saída for menor que o de entrada, considera-se virada de dia e soma-se 24 horas — apenas quando a jornada permitir cruzar a meia-noite; caso contrário o par é inválido e o dia fica inconsistente. |
| RN-09 | Intervalo é a diferença entre a saída de um par e a entrada do par seguinte no mesmo dia. |
| RN-10 | A carga prevista de um dia vem da configuração do seu dia da semana. É zero nos dias marcados como não trabalhados. |
| RN-11 | Saldo do dia = minutos trabalhados − carga prevista. |
| RN-12 | Nos status FOLGA, FERIADO, FERIAS, ATESTADO e ABONO a carga prevista é abonada: o saldo é igual aos minutos trabalhados, que normalmente são zero. |
| RN-13 | No status FALTA o saldo é igual a menos a carga prevista, independentemente de haver marcações. |
| RN-14 | Se o valor absoluto do saldo do dia for menor ou igual à tolerância configurada, o saldo é tratado como zero para efeito de acumulação. |
| RN-15 | Banco de horas = soma dos saldos de todos os dias entre a data de início do banco e a data de referência, inclusive. |
| RN-16 | A previsão de saída só existe quando o dia está em andamento, e equivale ao horário da última entrada somado aos minutos que faltam para completar a carga prevista. |

### Planilha e envio

| ID | Regra |
|----|-------|
| RN-17 | Existe no máximo um modelo de planilha ativo por vez. |
| RN-18 | Só é possível gerar a planilha de uma competência se houver um modelo ativo cujo arquivo base ainda exista e cujo mapeamento inclua, no mínimo, a coluna de data. |
| RN-19 | Pendências não impedem a geração, mas exigem confirmação explícita do usuário (RF-35). |
| RN-20 | Na estratégia POR_DATA, um dia cuja data não é encontrada em nenhuma linha da planilha é reportado como erro de preenchimento e não interrompe o restante da geração. |
| RN-21 | Na estratégia SEQUENCIAL, se a quantidade de dias da competência exceder o número de linhas disponíveis até o fim da área de dados, a geração é interrompida com erro explicativo. |
| RN-22 | A geração nunca altera o arquivo modelo original. Ela sempre produz um novo arquivo. |
| RN-23 | Um envio só passa ao status ENVIADO por confirmação explícita do usuário, porque o Android não informa ao app se o e-mail foi de fato enviado. |
| RN-24 | Cada geração de uma competência cria ou atualiza um registro de envio; regerar uma competência já enviada cria um novo registro, preservando o anterior no histórico. |
| RN-25 | A competência é sempre um par mês/ano completo. Não existem períodos personalizados nesta versão. |

### Feriados, status e configuração

| ID | Regra |
|----|-------|
| RN-26 | Um feriado marcado como recorrente vale para o mesmo dia e mês de todos os anos. |
| RN-27 | O status FERIADO é aplicado automaticamente aos dias correspondentes, mas nunca sobrescreve um status já definido manualmente pelo usuário. |
| RN-28 | Reabrir um dia fechado exige confirmação e dispara o recálculo completo daquele dia. |
| RN-29 | Alterar a configuração de jornada não recalcula retroativamente dias já fechados; recalcula apenas os dias abertos a partir da data da alteração. |
| RN-30 | Os lembretes de jornada não são disparados em dias cujo status seja FOLGA, FERIADO, FERIAS ou ATESTADO (RF-47). |

> ⚠️ EM ABERTO — RN-29 assume que a jornada não tem histórico de versões. Se o usuário mudar de
> horário no meio do vínculo e precisar que meses antigos continuem corretos, será necessário
> versionar `configuracao_jornada` por período de vigência. Ficou fora desta versão por
> simplicidade; está registrado como evolução em [15](15-riscos-e-decisoes.md).

---

## 2.4 Matriz de rastreabilidade

Cada requisito funcional é realizado por pelo menos um caso de uso, aparece em pelo menos uma tela
e é implementado em exatamente uma fase. Telas em [04](04-ux-navegacao-telas.md), casos de uso em
[05](05-casos-de-uso.md), fases em [13](13-plano-de-implementacao.md).

| RF | Caso de uso | Tela(s) | Regras | Fase |
|----|-------------|---------|--------|------|
| RF-01 | UC-02 | TL-02, TL-12 | — | F-1 |
| RF-02 | UC-14 | TL-12 | — | F-7 |
| RF-03 | UC-01 | TL-01…TL-05 | — | F-1 |
| RF-04 | UC-03 | TL-03, TL-13, TL-14 | RN-10 | F-1 |
| RF-05 | UC-03 | TL-14 | RN-10 | F-1 |
| RF-06 | UC-03 | TL-13 | RN-08, RN-14 | F-1 |
| RF-07 | UC-03 | TL-13 | — | F-1 |
| RF-08 | UC-04 | TL-06 | RN-01, RN-03, RN-06 | F-2 |
| RF-09 | UC-04 | TL-09 | RN-01, RN-03, RN-04 | F-2 |
| RF-10 | UC-05 | TL-09 | RN-01, RN-04 | F-2 |
| RF-11 | UC-05 | TL-06, TL-09 | RN-05 | F-2 |
| RF-12 | UC-08 | TL-06 | RN-07, RN-09, RN-16 | F-2 |
| RF-13 | UC-06 | TL-10 | RN-12, RN-13, RN-27 | F-2 |
| RF-14 | UC-08 | TL-06, TL-08 | RN-02 | F-2 |
| RF-15 | UC-06 | TL-10 | RN-28 | F-3 |
| RF-16 | UC-08 | TL-07 | RN-11, RN-14 | F-3 |
| RF-17 | UC-08 | TL-08 | RN-11 | F-3 |
| RF-18 | UC-08 | TL-06, TL-07, TL-08 | — | F-2 |
| RF-19 | UC-08 | TL-06, TL-07, TL-08 | RN-11, RN-15 | F-2 e F-3 ¹ |
| RF-20 | UC-09 | TL-15 | RN-26 | F-3 |
| RF-21 | UC-09 | TL-06, TL-08 | RN-27 | F-3 |
| RF-22 | UC-01, UC-09 | TL-15 | RN-26 | F-3 |
| RF-23 | UC-07 | TL-16 | RN-17, RN-22 | F-4 |
| RF-24 | UC-07 | TL-17 | — | F-4 |
| RF-25 | UC-07 | TL-17 | RN-20, RN-21 | F-4 |
| RF-26 | UC-07 | TL-18 | RN-18 | F-4 |
| RF-27 | UC-07 | TL-19 | — | F-4 |
| RF-28 | UC-07 | TL-19 | — | F-4 |
| RF-29 | UC-07 | TL-19 | — | F-4 |
| RF-30 | UC-07 | TL-20 | — | F-4 |
| RF-31 | UC-07 | TL-12, TL-16…TL-20 | RN-17 | F-4 |
| RF-32 | UC-07 | TL-16 | RN-17 | F-4 |
| RF-33 | UC-10 | TL-21 | RN-18, RN-20, RN-21, RN-22 | F-5 |
| RF-34 | UC-10 | TL-21 | RN-02, RN-19 | F-5 |
| RF-35 | UC-10 | TL-21 | RN-19 | F-5 |
| RF-36 | UC-10 | TL-21 | RN-24 | F-5 |
| RF-37 | UC-10 | TL-21, TL-23 | — | F-5 |
| RF-38 | UC-11 | TL-22 | — | F-6 |
| RF-39 | UC-11 | TL-21, TL-22 | — | F-6 |
| RF-40 | UC-11 | TL-21 | RN-23 | F-6 |
| RF-41 | UC-11 | TL-21 | RN-23, RN-24 | F-6 |
| RF-42 | UC-12 | TL-23 | — | F-6 |
| RF-43 | UC-12 | TL-23 | RN-24 | F-6 |
| RF-44 | UC-13 | TL-24 | RN-30 | F-7 |
| RF-45 | UC-13 | TL-24 | — | F-7 |
| RF-46 | UC-13 | TL-24 | RN-02 | F-7 |
| RF-47 | UC-13 | TL-24 | RN-30 | F-7 |
| RF-48 | UC-14 | TL-25 | — | F-7 |
| RF-49 | UC-14 | TL-25 | — | F-7 |

¹ RF-19 é o único requisito que atravessa duas fases: o total trabalhado e o saldo do período
aparecem já na F-2, mas o banco de horas acumulado depende de `bancoAcumuladoAte`, que só existe
na F-3.

**Cobertura reversa** — todo caso de uso realiza pelo menos um RF:

| UC | RFs realizados |
|----|----------------|
| UC-01 | RF-03, RF-22 |
| UC-02 | RF-01 |
| UC-03 | RF-04, RF-05, RF-06, RF-07 |
| UC-04 | RF-08, RF-09 |
| UC-05 | RF-10, RF-11 |
| UC-06 | RF-13, RF-15 |
| UC-07 | RF-23…RF-32 |
| UC-08 | RF-12, RF-14, RF-16, RF-17, RF-18, RF-19 |
| UC-09 | RF-20, RF-21, RF-22 |
| UC-10 | RF-33…RF-37 |
| UC-11 | RF-38, RF-39, RF-40, RF-41 |
| UC-12 | RF-42, RF-43 |
| UC-13 | RF-44…RF-47 |
| UC-14 | RF-02, RF-48, RF-49 |
