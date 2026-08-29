# 08 — Diagramas de Sequência e de Estado

Os fluxos de [07](07-fluxos-atividade.md) descrevem **o que acontece**. Este documento descreve
**quem faz o quê**, entre os componentes definidos em [09](09-arquitetura-tecnica.md), e quais são
os estados válidos das duas entidades que têm ciclo de vida próprio.

---

## S1 — Importação e mapeamento da planilha

Realiza UC-07. Mostra como o wizard mantém tudo em memória até o salvamento final, garantindo que
um abandono não deixe resíduo.

```mermaid
sequenceDiagram
    autonumber
    actor U as Funcionário
    participant W as WizardPlanilhaTela
    participant C as WizardPlanilhaController
    participant L as LeitorPlanilha
    participant A as ArmazenamentoArquivos
    participant R as ModeloPlanilhaRepositorio
    participant DB as BancoLocal

    U->>W: toca em "escolher arquivo"
    W->>C: selecionarArquivo()
    C->>A: abrirSeletor(extensoes: xlsx)
    A-->>C: caminho do arquivo

    C->>L: lerEstrutura(caminho)
    activate L
    L-->>C: EstruturaPlanilha(abas, dimensões, células)
    deactivate L

    alt arquivo inválido ou protegido
        L-->>C: FalhaLeitura(motivo)
        C-->>W: estado de erro com orientação
        W-->>U: "Não consegui ler esta planilha..."
    end

    C->>A: copiarParaAreaPrivada(caminho)
    A-->>C: caminhoInterno + hashSha256
    C-->>W: estrutura carregada
    W-->>U: exibe grade com o conteúdo real

    Note over C: Todo o mapeamento vive apenas<br/>no estado do controller até o passo 5.

    U->>W: seleciona aba, cabeçalho e 1ª linha de dados
    W->>C: definirLinhas(aba, cabecalho, primeiraLinha)
    U->>W: mapeia as colunas
    W->>C: mapearColuna(campo, indice)
    C->>C: valida obrigatoriedade da coluna DATA (RN-18)
    U->>W: mapeia células fixas e textos de status
    W->>C: definirCelulaFixa(campo, referencia)

    U->>W: avança para a pré-visualização
    W->>C: gerarPrevia()
    C->>DB: buscarDiasDaCompetencia(competenciaExemplo)
    DB-->>C: lista de DiaTrabalho
    C->>C: simula o preenchimento em memória
    C->>C: valida capacidade de linhas (RN-21)
    C-->>W: MatrizPrevia + ResultadoValidacao
    W-->>U: mostra a planilha preenchida

    U->>W: "Salvar modelo"
    W->>C: salvar()
    C->>R: salvarModelo(modelo, colunas, celulas, textos)
    activate R
    R->>DB: transação
    R->>DB: UPDATE modelo_planilha SET ativo = 0 (RN-17)
    R->>DB: INSERT modelo_planilha
    R->>DB: INSERT mapeamento_coluna (N)
    R->>DB: INSERT celula_fixa (N)
    R->>DB: INSERT texto_status (N)
    R->>DB: commit
    DB-->>R: ok
    R-->>C: ModeloPlanilha salvo
    deactivate R
    C-->>W: sucesso
    W-->>U: fecha o wizard e confirma
```

---

## S2 — Geração da planilha da competência

Realiza UC-10. É a sequência de maior risco técnico do projeto — ver
[R-01](15-riscos-e-decisoes.md).

```mermaid
sequenceDiagram
    autonumber
    actor U as Funcionário
    participant T as FechamentoMesTela
    participant C as FechamentoController
    participant DR as DiaRepositorio
    participant MR as ModeloPlanilhaRepositorio
    participant P as PreenchedorPlanilha
    participant E as EscritorXlsx
    participant A as ArmazenamentoArquivos
    participant ER as EnvioRepositorio

    U->>T: abre o Fechamento do mês
    T->>C: carregar(competencia)
    C->>DR: buscarDias(competencia)
    DR-->>C: lista de DiaTrabalho
    C->>MR: buscarModeloAtivo()
    MR-->>C: ModeloPlanilha ou nulo
    C->>C: calcularResumo() e levantarPendencias()
    C-->>T: EstadoFechamento(resumo, pendências, modelo)
    T-->>U: exibe resumo e pendências

    U->>T: "Gerar planilha"
    T->>C: gerar()

    alt sem modelo ativo (RN-18)
        C-->>T: ErroSemModelo
        T-->>U: bloqueia e oferece configurar
    end

    C->>A: verificarArquivoBase(caminho, hash)
    A-->>C: ok

    opt há pendências (RN-19)
        C-->>T: pedirConfirmacao(pendências)
        U->>T: confirma
        T->>C: prosseguir()
    end

    C->>P: preencher(modelo, competencia, dias, perfil)
    activate P
    P->>P: valida capacidade de linhas (RN-21)
    P->>P: resolve a linha de cada dia pela estratégia
    P->>P: formata datas e horas conforme o modelo
    P->>P: monta as células fixas com perfil e totais
    P-->>C: PlanoDeEscrita(células, dias não resolvidos)
    deactivate P

    Note over P,E: O preenchedor decide O QUE escrever e ONDE.<br/>O escritor sabe COMO escrever sem destruir o arquivo.

    C->>E: aplicar(arquivoBase, planoDeEscrita)
    activate E
    E->>A: lerBytes(arquivoBase)
    A-->>E: bytes do .xlsx
    E->>E: edita apenas as células do plano,<br/>preservando estilos, fórmulas e demais abas (RN-22)
    E-->>C: bytes do novo arquivo
    deactivate E

    alt falha na escrita
        E-->>C: FalhaEscrita
        C->>A: removerParciais()
        C-->>T: erro, nada foi gravado (RNF-06)
    end

    C->>A: gravarArquivoGerado(nome, bytes)
    A-->>C: caminho + tamanho
    C->>ER: registrarGeracao(competencia, caminho, GERADO)
    ER-->>C: EnvioMensal
    C-->>T: EstadoGerado(arquivo, diasNaoEscritos)
    T-->>U: exibe o arquivo e as ações de envio
```

O ponto central desta sequência é a separação entre `PreenchedorPlanilha` e `EscritorXlsx`.
O primeiro é lógica de domínio pura, testável sem arquivo nenhum: dado um modelo e uma lista de
dias, produz um `PlanoDeEscrita` — a lista de coordenadas e valores. O segundo é infraestrutura,
e é o único componente do sistema que conhece o formato `.xlsx`. Se a estratégia técnica de escrita
precisar mudar ([S-01](15-riscos-e-decisoes.md)), só o `EscritorXlsx` é substituído, e todos os
testes do preenchedor continuam válidos.

---

## S3 — Envio por e-mail e confirmação

Realiza UC-11. Note onde o controle do sistema termina.

```mermaid
sequenceDiagram
    autonumber
    actor U as Funcionário
    participant T as FechamentoMesTela
    participant C as FechamentoController
    participant CR as ConfiguracaoEmailRepositorio
    participant RV as ResolvedorVariaveis
    participant S as ServicoEmail
    participant SO as Sistema operacional
    participant CE as Cliente de e-mail
    participant ER as EnvioRepositorio

    U->>T: "Enviar por e-mail"
    T->>C: enviar(envio)
    C->>CR: buscarConfiguracaoAtiva()
    CR-->>C: ConfiguracaoEmail

    alt destinatário não configurado
        C-->>T: ErroSemDestinatario
        T-->>U: leva à configuração de e-mail
    end

    C->>RV: resolver(assunto, corpo, nomeArquivo, contexto)
    Note right of RV: contexto = perfil + competência +<br/>totais do mês + data de geração
    RV-->>C: textos resolvidos

    C-->>T: PreviaEmail(para, cópia, assunto, corpo, anexo)
    T-->>U: exibe a pré-visualização
    U->>T: confirma

    T->>C: dispararIntencao()
    C->>S: enviar(previa, caminhoAnexo)
    activate S
    S->>SO: Intent ACTION_SEND com anexo e destinatários

    alt nenhum cliente de e-mail instalado
        SO-->>S: nenhuma aplicação disponível
        S-->>C: SemClienteEmail
        C-->>T: oferece o compartilhamento genérico
    end

    SO->>CE: abre já preenchido
    deactivate S

    rect rgb(236, 239, 241)
        Note over CE,U: Fora da fronteira do sistema.<br/>O app não recebe retorno algum daqui.
        CE-->>U: exibe o e-mail pronto
        U->>CE: revisa e envia
    end

    U->>T: retorna ao aplicativo
    T-->>U: "Você conseguiu enviar o e-mail?" (RN-23)

    alt usuário confirma o envio
        U->>T: "Enviei"
        T->>C: confirmarEnvio(envio)
        C->>ER: atualizarStatus(envio, ENVIADO, agora)
        ER-->>C: ok
        C->>C: cancelarLembreteFechamento(competencia)
        C-->>T: competência concluída
    else usuário responde "ainda não" ou sai
        T->>C: manterPendente(envio)
        C->>ER: mantém status GERADO
        Note over T: A pergunta reaparece na próxima<br/>visita a esta competência.
    end
```

---

## E1 — Ciclo de vida do dia de trabalho

Estados de `dia_trabalho`. As transições de cálculo são todas executadas pelo fluxo
[A5](07-fluxos-atividade.md).

```mermaid
stateDiagram-v2
    direction TB

    [*] --> SemRegistro : data existe no calendário

    state "Sem registro" as SemRegistro
    state "Em andamento" as EmAndamento
    state "Completo" as Completo
    state "Inconsistente" as Inconsistente
    state "Não trabalhado" as NaoTrabalhado
    state "Fechado" as Fechado

    SemRegistro --> EmAndamento : primeira ENTRADA registrada<br/>no dia corrente
    SemRegistro --> Inconsistente : marcações ímpares<br/>em dia passado (RN-02)
    SemRegistro --> Completo : par de marcações completo
    SemRegistro --> NaoTrabalhado : status definido como FOLGA, FERIADO,<br/>FERIAS, ATESTADO, FALTA ou ABONO

    EmAndamento --> Completo : SAÍDA registrada
    EmAndamento --> Inconsistente : o dia vira sem<br/>a saída correspondente
    EmAndamento --> SemRegistro : única marcação excluída

    Completo --> EmAndamento : nova ENTRADA registrada<br/>no dia corrente
    Completo --> Inconsistente : marcação excluída ou<br/>par tornado inválido (RN-08)
    Completo --> SemRegistro : todas as marcações excluídas
    Completo --> Fechado : usuário fecha o dia (RF-15)

    Inconsistente --> Completo : marcação faltante adicionada<br/>ou excedente removida
    Inconsistente --> SemRegistro : todas as marcações excluídas

    NaoTrabalhado --> Completo : status volta a NORMAL<br/>com marcações completas
    NaoTrabalhado --> SemRegistro : status volta a NORMAL<br/>sem marcações
    NaoTrabalhado --> Fechado : usuário fecha o dia

    Fechado --> Completo : reabertura confirmada (RN-28)
    Fechado --> Inconsistente : reabertura de dia<br/>com pendência preexistente

    note right of Inconsistente
        Aparece com ⚠ na tela do Mês
        e vira pendência no Fechamento.
        Não impede a geração (RN-19).
    end note

    note right of EmAndamento
        Único estado com previsão
        de saída calculada (RN-16).
        Só existe no dia corrente.
    end note
```

**Invariantes**

- `Em andamento` só é atingível quando a data do dia é hoje. Na virada da meia-noite, um dia nesse
  estado passa a `Inconsistente` sem intervenção do usuário — o recálculo ocorre na próxima leitura
  do dia, e é o que dispara o lembrete `DIA_INCOMPLETO` de [A6](07-fluxos-atividade.md).
- `Fechado` é o único estado somente leitura. Toda tentativa de escrita é recusada pela camada de
  aplicação antes de chegar ao repositório.
- `Não trabalhado` não impede marcações: um dia de folga com marcações registra hora extra integral,
  conforme RN-12.

---

## E2 — Ciclo de vida do envio mensal

Estados de `envio_mensal`. Uma competência pode ter vários registros ao longo do tempo (RN-24), cada
um percorrendo esta máquina de forma independente.

```mermaid
stateDiagram-v2
    direction LR

    [*] --> Pendente : competência com dias registrados<br/>e ainda não gerada

    state "Pendente" as Pendente
    state "Gerado" as Gerado
    state "Enviado" as Enviado
    state "Cancelado" as Cancelado

    Pendente --> Gerado : planilha gerada com sucesso (UC-10)
    Pendente --> Cancelado : usuário descarta a competência

    Gerado --> Enviado : usuário confirma o envio (RN-23)
    Gerado --> Gerado : regeração cria um novo registro,<br/>este permanece no histórico
    Gerado --> Cancelado : arquivo descartado pelo usuário

    Enviado --> [*] : competência concluída
    Cancelado --> [*]

    note right of Gerado
        O arquivo existe no dispositivo, mas
        o app não sabe se o e-mail saiu.
        Este é o estado de espera de RN-23.
    end note

    note right of Enviado
        Único estado que cancela o lembrete
        de fechamento e some da lista de
        competências pendentes.
    end note
```

**Por que não existe transição automática de `Gerado` para `Enviado`.** O Android não devolve ao
aplicativo o resultado de uma intenção de e-mail: o `resultCode` é `RESULT_CANCELED` mesmo quando a
mensagem foi enviada, porque o cliente de e-mail encerra a atividade sem informar o desfecho.
Qualquer tentativa de inferir o envio produziria falso positivo — o pior erro possível para este
produto, já que faria o app silenciar o lembrete de uma competência que nunca chegou ao RH.
A confirmação humana de RN-23 é, portanto, uma decisão de projeto consciente, não uma limitação
não resolvida.
