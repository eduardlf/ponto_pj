# 07 — Diagramas de Atividade

Seis fluxos que cobrem todo o comportamento do sistema. Cada um corresponde a um ou mais casos de
uso de [05](05-casos-de-uso.md) e cita as regras de [02](02-requisitos.md) que aplica.

Convenção dos diagramas: losango é decisão, retângulo é ação do sistema, retângulo arredondado é
ação do usuário, e nós em vermelho são caminhos de erro ou de recusa.

---

## A1 — Configuração inicial (onboarding)

**Caso de uso:** UC-01 · **Telas:** TL-01 a TL-05 · **Requisitos:** RF-03, RF-22

```mermaid
flowchart TD
    INI(["Abertura do app"]) --> Q1{"Existe perfil<br/>cadastrado?"}
    Q1 -->|Sim| DIA(["Abre a aba Dia"])
    Q1 -->|Nao| BV["Exibe TL-01 boas-vindas"]

    BV --> P1["TL-02 - dados pessoais"]
    P1 --> Q2{"Preencheu?"}
    Q2 -->|Sim| SALVA1["Grava perfil_usuario"]
    Q2 -->|Pulou| PEND1["Registra pendencia<br/>'Seus dados'"]
    SALVA1 --> P2
    PEND1 --> P2

    P2["TL-03 - jornada da semana"] --> Q3{"Confirmou<br/>a jornada?"}
    Q3 -->|Sim| SALVA2["Atualiza configuracao_jornada<br/>e jornada_dia_semana"]
    Q3 -->|Pulou| PEND2["Mantem a jornada<br/>padrao semeada"]
    SALVA2 --> FER
    PEND2 --> FER

    FER["Semeia feriados nacionais<br/>de data fixa - RF-22"] --> P3

    P3["TL-04 - explica a planilha"] --> Q4{"Tem o arquivo<br/>em maos?"}
    Q4 -->|Sim| WIZ["Executa A2<br/>wizard de mapeamento"]
    Q4 -->|Agora nao| PEND3["Registra pendencia<br/>'Sua planilha'"]
    WIZ --> Q5{"Concluiu<br/>o wizard?"}
    Q5 -->|Sim| P4
    Q5 -->|Cancelou| PEND3
    PEND3 --> P4

    P4["TL-05 - e-mail padrao"] --> Q6{"Informou o<br/>destinatario?"}
    Q6 -->|Sim| SALVA3["Atualiza configuracao_email"]
    Q6 -->|Pulou| PEND4["Registra pendencia<br/>'Seu e-mail'"]
    SALVA3 --> FIM
    PEND4 --> FIM

    FIM["Grava onboarding_concluido = true"] --> Q7{"Ha pendencias?"}
    Q7 -->|Sim| CARD["Exibe cartoes de pendencia<br/>no topo de TL-12"]
    Q7 -->|Nao| DIA
    CARD --> DIA

    style PEND1 fill:#fff8e1,stroke:#f9a825
    style PEND2 fill:#fff8e1,stroke:#f9a825
    style PEND3 fill:#fff8e1,stroke:#f9a825
    style PEND4 fill:#fff8e1,stroke:#f9a825
    style DIA fill:#e8f5e9,stroke:#2e7d32
```

**Notas de projeto.** Nenhuma etapa é obrigatória. Um usuário que só quer bater ponto hoje consegue
chegar à tela do Dia em dois toques, e a configuração da planilha continua disponível até o
fechamento do mês. Isso atende ao princípio 1 de [04](04-ux-navegacao-telas.md) e evita o abandono
na primeira execução, que é o momento de menor confiança.

---

## A2 — Importação e mapeamento da planilha

**Caso de uso:** UC-07 · **Telas:** TL-16 a TL-20 · **Requisitos:** RF-23 a RF-32 ·
**Regras:** RN-17, RN-18, RN-21, RN-22

```mermaid
flowchart TD
    INI(["Inicia o wizard"]) --> SEL(["P1 - escolhe arquivo<br/>no seletor do sistema"])
    SEL --> EXT{"Extensao<br/>e .xlsx?"}
    EXT -->|Nao| ERR1["Recusa e orienta a converter<br/>'Este arquivo e .xls...'"]
    ERR1 --> SEL
    EXT -->|Sim| LER["Le a estrutura do arquivo"]

    LER --> OK1{"Leitura<br/>bem sucedida?"}
    OK1 -->|Nao| ERR2["Informa causa provavel<br/>senha ou arquivo danificado"]
    ERR2 --> SEL
    OK1 -->|Sim| COPIA["Copia para a area privada do app<br/>e calcula o hash SHA-256"]

    COPIA --> SUB{"Ja existe<br/>modelo salvo?"}
    SUB -->|Nao| P2
    SUB -->|Sim| COMP{"Estrutura compativel<br/>com o mapeamento atual?"}
    COMP -->|Sim| OFER(["Oferece manter<br/>o mapeamento"])
    COMP -->|Nao| AVISO["Mostra o que mudou<br/>nas colunas"]
    AVISO --> P2
    OFER -->|Aceita| PREV
    OFER -->|Refaz| P2

    P2(["P2 - escolhe aba,<br/>toca na linha de cabecalho<br/>e confirma a 1a linha de dados"])
    P2 --> ESTR(["Escolhe a estrategia de linha<br/>SEQUENCIAL ou POR_DATA"])
    ESTR --> P3(["P3 - mapeia as colunas<br/>dos campos por dia"])

    P3 --> VAL1{"Coluna de DATA<br/>mapeada?"}
    VAL1 -->|Nao| BLOQ["Desabilita 'Continuar'<br/>e explica a obrigatoriedade - RN-18"]
    BLOQ --> P3
    VAL1 -->|Sim| DUP{"Alguma coluna<br/>repetida?"}
    DUP -->|Sim| ALERTA["Alerta e informa<br/>a regra de prioridade"]
    ALERTA --> P4
    DUP -->|Nao| P4

    P4(["P4 - mapeia celulas fixas,<br/>textos de status e formatos"])
    P4 --> PREV["P5 - monta a pre-visualizacao<br/>com dados reais ou de exemplo"]

    PREV --> VAL2{"Os dias cabem nas<br/>linhas disponiveis? - RN-21"}
    VAL2 -->|Nao| ERR3["Mostra a contagem exata<br/>de dias e de linhas livres"]
    ERR3 --> P2
    VAL2 -->|Sim| MOSTRA["Exibe a planilha preenchida<br/>com os valores destacados"]

    MOSTRA --> CONF(["Usuario confere e salva"])
    CONF --> DESAT["Desativa o modelo anterior - RN-17"]
    DESAT --> GRAVA["Grava modelo_planilha,<br/>mapeamento_coluna, celula_fixa<br/>e texto_status em transacao"]
    GRAVA --> FIM(["Modelo ativo e valido"])

    CONF -.->|"Cancela em<br/>qualquer passo"| CANC{"Confirma<br/>descartar?"}
    CANC -->|Sim| NADA["Descarta o progresso.<br/>Modelo anterior intacto - RN-22"]
    CANC -->|Nao| MOSTRA

    style ERR1 fill:#ffebee,stroke:#c62828
    style ERR2 fill:#ffebee,stroke:#c62828
    style ERR3 fill:#ffebee,stroke:#c62828
    style BLOQ fill:#ffebee,stroke:#c62828
    style FIM fill:#e8f5e9,stroke:#2e7d32
    style MOSTRA fill:#e8f5e9,stroke:#2e7d32
```

**Nota de projeto.** Nada é gravado antes do passo 5. Um wizard abandonado no meio não deixa
resíduo, e um modelo já existente nunca é degradado por uma tentativa incompleta de substituí-lo —
exigência direta de [RNF-06](02-requisitos.md).

---

## A3 — Registrar, editar e excluir marcação

**Casos de uso:** UC-04, UC-05 · **Telas:** TL-06, TL-09 ·
**Regras:** RN-01 a RN-06

```mermaid
flowchart TD
    INI(["Usuario aciona<br/>uma acao de marcacao"]) --> TIPO{"Qual acao?"}

    TIPO -->|"Bater ponto"| AGORA["Obtem a hora atual"]
    AGORA --> INFERE["Infere o tipo pela paridade<br/>da quantidade existente - RN-06"]
    INFERE --> VALIDA

    TIPO -->|"Adicionar manual"| SHEET(["TL-09 - informa o horario"])
    SHEET --> VALIDA

    TIPO -->|"Editar"| SHEET2(["TL-09 - altera o horario"])
    SHEET2 --> MARCAED["Marca editada = true"]
    MARCAED --> VALIDA

    TIPO -->|"Excluir"| CONFIRM{"Confirma<br/>a exclusao?"}
    CONFIRM -->|Nao| CANC(["Nada acontece"])
    CONFIRM -->|Sim| REMOVE["Remove a marcacao"]
    REMOVE --> RECALC

    VALIDA{"Horario no futuro?<br/>RN-03"} -->|Sim| E1["Recusa - 'Nao da para registrar<br/>um horario que ainda nao aconteceu'"]
    E1 --> INI
    VALIDA -->|Nao| DUPL{"Ja existe marcacao<br/>nesse horario? RN-04"}
    DUPL -->|Sim| E2["Recusa - 'Ja existe uma<br/>marcacao as 08:00 neste dia'"]
    E2 --> INI
    DUPL -->|Nao| STATUS{"Dia tem status<br/>nao trabalhado?"}

    STATUS -->|Sim| PERG{"Registrar<br/>mesmo assim?"}
    PERG -->|Nao| CANC
    PERG -->|Sim| GRAVA
    STATUS -->|Nao| GRAVA

    GRAVA["Persiste a marcacao<br/>com a origem correspondente"] --> RECALC

    RECALC["Reordena por hora e recalcula<br/>ordem e tipo - RN-01 e RN-05"]
    RECALC --> CALC["Executa A5<br/>calculo do dia"]
    CALC --> UI["Atualiza linha do tempo<br/>e cartao de resumo"]
    UI --> UNDO(["Aviso breve com 'Desfazer'<br/>por 5 segundos"])
    UNDO -->|"Usuario desfaz"| REVERTE["Reverte a operacao<br/>e recalcula novamente"]
    REVERTE --> UI
    UNDO -->|"Expira"| FIM(["Dia consistente<br/>e persistido"])

    style E1 fill:#ffebee,stroke:#c62828
    style E2 fill:#ffebee,stroke:#c62828
    style FIM fill:#e8f5e9,stroke:#2e7d32
```

**Nota de projeto.** Ordem e tipo **nunca** são informados pelo usuário: são sempre derivados da
ordenação por horário. Isso elimina por construção a classe inteira de bugs de "saída antes da
entrada" e mantém RN-01 como invariante do sistema, não como validação a ser lembrada.

---

## A4 — Fechamento do mês: gerar e enviar

**Casos de uso:** UC-10, UC-11 · **Tela:** TL-21 ·
**Regras:** RN-18 a RN-24 · Este é o fluxo que justifica o produto.

```mermaid
flowchart TD
    INI(["Abre o Fechamento do mes"]) --> DEF["Seleciona a competencia padrao<br/>ate o dia 10 usa o mes anterior"]
    DEF --> CARGA["Carrega os dias da competencia<br/>e calcula o resumo"]
    CARGA --> PEND["Levanta pendencias:<br/>dias inconsistentes, dias uteis<br/>sem registro, status indefinido"]
    PEND --> MOSTRA["Exibe resumo, pendencias<br/>e a configuracao em uso"]

    MOSTRA --> ACAO(["Usuario aciona<br/>'Gerar planilha'"])
    ACAO --> MOD{"Existe modelo<br/>ativo? RN-18"}
    MOD -->|Nao| E1["Bloqueia e oferece<br/>configurar a planilha"]
    E1 --> WIZ(["Vai para A2"])
    MOD -->|Sim| ARQ{"Arquivo base<br/>existe e o hash confere?"}
    ARQ -->|Nao| E2["Informa e oferece reimportar<br/>mantendo o mapeamento"]
    E2 --> WIZ
    ARQ -->|Sim| TEMP{"Ha pendencias?"}

    TEMP -->|Sim| CONF{"Usuario confirma<br/>gerar assim mesmo? RN-19"}
    CONF -->|Nao| MOSTRA
    CONF -->|Sim| CABE
    TEMP -->|Nao| CABE

    CABE{"Os dias cabem<br/>nas linhas? RN-21"} -->|Nao| E3["Aborta antes de escrever<br/>com os numeros exatos"]
    E3 --> MOSTRA
    CABE -->|Sim| ABRE["Abre o arquivo base<br/>preservando todo o conteudo - RN-22"]

    ABRE --> LOOP["Para cada dia da competencia:<br/>resolve a linha de destino e<br/>escreve as colunas mapeadas"]
    LOOP --> NAOACHOU{"Estrategia POR_DATA<br/>e data nao encontrada?"}
    NAOACHOU -->|Sim| REGISTRA["Registra o dia como nao escrito<br/>e continua os demais - RN-20"]
    NAOACHOU -->|Nao| SEGUE["Segue"]
    REGISTRA --> FIXAS
    SEGUE --> FIXAS

    FIXAS["Escreve as celulas fixas<br/>com perfil e totais do mes"] --> SALVA["Grava o novo arquivo<br/>com o nome do template"]
    SALVA --> OK{"Gravacao<br/>bem sucedida?"}
    OK -->|Nao| E4["Remove qualquer arquivo parcial<br/>e informa a falha - RNF-06"]
    E4 --> MOSTRA
    OK -->|Sim| HIST["Cria registro em envio_mensal<br/>com status GERADO - RN-24"]

    HIST --> GERADO["Exibe o arquivo gerado<br/>com abrir, compartilhar e enviar"]
    GERADO --> PARCIAL{"Houve dias<br/>nao escritos?"}
    PARCIAL -->|Sim| LISTA["Lista os dias que ficaram de fora"]
    PARCIAL -->|Nao| ENVIAR
    LISTA --> ENVIAR

    ENVIAR(["Usuario aciona<br/>'Enviar por e-mail'"]) --> RESOLVE["Resolve as variaveis do assunto,<br/>do corpo e do nome do arquivo"]
    RESOLVE --> DEST{"Destinatario<br/>configurado?"}
    DEST -->|Nao| E5["Bloqueia e leva a TL-22"]
    E5 --> GERADO
    DEST -->|Sim| PREVIEW["Mostra a pre-visualizacao<br/>do e-mail com o anexo"]

    PREVIEW --> INTENT["Monta a intencao de e-mail<br/>e entrega ao sistema operacional"]
    INTENT --> CLI{"Existe cliente<br/>de e-mail?"}
    CLI -->|Nao| ALT["Oferece o compartilhamento<br/>generico do sistema"]
    CLI -->|Sim| EXTERNO(["Cliente de e-mail abre preenchido.<br/>O usuario revisa e envia."])
    ALT --> PERG
    EXTERNO --> PERG

    PERG{"Ao voltar ao app:<br/>'Voce conseguiu enviar?' RN-23"}
    PERG -->|"Enviei"| ENVIADO["Status ENVIADO<br/>com data e hora"]
    PERG -->|"Ainda nao"| MANTEM["Mantem status GERADO.<br/>Competencia segue pendente"]
    PERG -->|"Fecha o app"| MANTEM

    ENVIADO --> CANCELA["Cancela o lembrete<br/>de fechamento do periodo"]
    CANCELA --> FIM(["Competencia concluida"])
    MANTEM --> FIM2(["Pergunta reaparece<br/>na proxima visita"])

    style E1 fill:#ffebee,stroke:#c62828
    style E2 fill:#ffebee,stroke:#c62828
    style E3 fill:#ffebee,stroke:#c62828
    style E4 fill:#ffebee,stroke:#c62828
    style E5 fill:#ffebee,stroke:#c62828
    style EXTERNO fill:#eceff1,stroke:#546e7a,stroke-dasharray: 4 4
    style FIM fill:#e8f5e9,stroke:#2e7d32
```

**Nota de projeto.** O app perde o controle do processo no nó `EXTERNO`, desenhado tracejado porque
está fora da fronteira do sistema. É essa perda de controle que obriga a confirmação manual de
RN-23 — e é por isso que a interface pergunta em vez de afirmar. Um app que dissesse "enviado com
sucesso" sem saber estaria mentindo para o usuário justamente sobre a coisa que ele mais precisa
que seja verdade.

---

## A5 — Cálculo do dia

**Regras:** RN-02, RN-07 a RN-14, RN-16 · **Detalhamento:** [12 — Regras de cálculo](12-regras-de-calculo.md)

Executado após qualquer alteração em marcações, status do dia ou configuração de jornada. É o único
ponto do sistema autorizado a escrever os campos derivados de `dia_trabalho`.

```mermaid
flowchart TD
    INI(["calcularDia(dia, jornada)"]) --> CARGA["cargaPrevista = jornada do dia da semana<br/>0 se nao trabalha - RN-10"]
    CARGA --> ORD["Ordena as marcacoes por hora<br/>e atribui ordem e tipo - RN-01"]
    ORD --> PAR{"Quantidade de<br/>marcacoes e par?"}

    PAR -->|Nao| HOJE{"E o dia corrente e a<br/>ultima e ENTRADA?"}
    HOJE -->|Sim| ANDAMENTO["emAndamento = true<br/>inconsistente = false"]
    HOJE -->|Nao| INCONS["inconsistente = true - RN-02"]
    PAR -->|Sim| CONSIST["inconsistente = false"]

    ANDAMENTO --> SOMA
    INCONS --> SOMA
    CONSIST --> SOMA

    SOMA["Para cada par completo:<br/>duracao = saida - entrada"] --> VIRA{"saida anterior<br/>a entrada?"}
    VIRA -->|Sim| PERMITE{"jornada permite<br/>virada de dia? RN-08"}
    PERMITE -->|Sim| SOMA24["duracao = saida + 24h - entrada"]
    PERMITE -->|Nao| PARINV["Par invalido:<br/>marca o dia inconsistente<br/>e ignora o par"]
    VIRA -->|Nao| NORMAL["duracao = saida - entrada"]

    SOMA24 --> ACUM
    NORMAL --> ACUM
    PARINV --> ACUM
    ACUM["minutosTrabalhados =<br/>soma das duracoes validas - RN-07"] --> STAT{"Qual o status<br/>do dia?"}

    STAT -->|"FOLGA, FERIADO, FERIAS,<br/>ATESTADO, ABONO"| ABONA["saldo = minutosTrabalhados<br/>carga abonada - RN-12"]
    STAT -->|FALTA| FALTA["saldo = -cargaPrevista - RN-13"]
    STAT -->|"NORMAL, COMPENSACAO"| PADRAO["saldo = minutosTrabalhados<br/>- cargaPrevista - RN-11"]

    ABONA --> TOL
    FALTA --> TOL
    PADRAO --> TOL

    TOL{"modulo do saldo dentro<br/>da tolerancia? RN-14"} -->|Sim| ZERA["saldo = 0"]
    TOL -->|Nao| MANTEM["saldo permanece"]
    ZERA --> PREV
    MANTEM --> PREV

    PREV{"Dia em<br/>andamento?"} -->|Sim| CALCPREV["previsaoSaida = hora da ultima entrada<br/>+ minutos que faltam - RN-16"]
    PREV -->|Nao| SEMPREV["previsaoSaida = nulo"]

    CALCPREV --> GRAVA
    SEMPREV --> GRAVA
    GRAVA["Persiste carga_prevista_minutos,<br/>minutos_trabalhados, saldo_minutos<br/>e inconsistente"] --> FIM(["Dia calculado"])

    style INCONS fill:#fff8e1,stroke:#f9a825
    style PARINV fill:#fff8e1,stroke:#f9a825
    style FIM fill:#e8f5e9,stroke:#2e7d32
```

---

## A6 — Notificações: agendamento e disparo

**Caso de uso:** UC-13 · **Tela:** TL-24 · **Requisitos:** RF-44 a RF-47 · **Regra:** RN-30

```mermaid
flowchart TD
    subgraph CONFIG["Agendamento - ator: Funcionario"]
        C1(["Ativa um lembrete em TL-24"]) --> C2{"Permissao de<br/>notificacao concedida?"}
        C2 -->|Nao| C3["Solicita a permissao<br/>ao sistema operacional"]
        C3 --> C4{"Concedida?"}
        C4 -->|Nao| C5["Salva a configuracao,<br/>explica que nao vai funcionar<br/>e oferece atalho para os ajustes"]
        C4 -->|Sim| C6
        C2 -->|Sim| C6
        C6["Calcula as proximas ocorrencias<br/>a partir da jornada configurada"]
        C6 --> C7["Agenda cada ocorrencia<br/>e grava configuracao_notificacao"]
    end

    C7 --> ESPERA(["Aguarda o horario"])

    subgraph DISPARO["Disparo - ator: Agendador do sistema"]
        D1(["Agendador dispara"]) --> D2{"Tipo do<br/>lembrete?"}

        D2 -->|"Lembretes de jornada"| D3{"Status do dia e FOLGA,<br/>FERIADO, FERIAS<br/>ou ATESTADO? RN-30"}
        D3 -->|Sim| SUP["Suprime a notificacao"]
        D3 -->|Nao| D4{"A acao ja<br/>foi cumprida?"}
        D4 -->|Sim| SUP
        D4 -->|Nao| EXIBE

        D2 -->|DIA_INCOMPLETO| D5{"O dia terminou<br/>inconsistente ou vazio?"}
        D5 -->|Nao| SUP
        D5 -->|Sim| EXIBE

        D2 -->|FECHAMENTO_MES| D6{"A competencia ja tem<br/>envio com status ENVIADO?"}
        D6 -->|Sim| SUP
        D6 -->|Nao| EXIBE

        EXIBE["Exibe a notificacao"] --> D7(["Usuario toca"])
        D7 --> D8["Abre o app na tela relevante:<br/>Dia ou Fechamento do mes"]
    end

    ESPERA --> D1
    D8 --> REAG["Reagenda a proxima ocorrencia"]
    SUP --> REAG

    style SUP fill:#eceff1,stroke:#546e7a
    style C5 fill:#fff8e1,stroke:#f9a825
```

**Nota de projeto.** A verificação de supressão acontece **no disparo**, não no agendamento. Um
lembrete agendado na segunda-feira precisa se calar se, na quinta, o usuário marcar aquele dia como
atestado. Reagendar tudo a cada mudança de status seria caro e frágil; verificar no momento do
disparo é barato e sempre correto.

O lembrete de fechamento é o que existe para resolver a dor D1 de
[01](01-visao-e-escopo.md) — a razão original do projeto. Ele se cala sozinho quando a competência
já foi enviada, para não virar ruído que o usuário aprende a ignorar.
