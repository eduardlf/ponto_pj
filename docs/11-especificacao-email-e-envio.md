# 11 — Especificação de E-mail e Envio

Cobre UC-11 e UC-12, o trecho final de [A4](07-fluxos-atividade.md), a sequência
[S3](08-sequencia-e-estados.md) e as entidades `configuracao_email` e `envio_mensal` de
[06](06-modelo-de-dados.md).

Este é o passo que fecha o ciclo do produto: sem ele, o app seria mais um app de ponto que exporta
um arquivo e deixa o resto por conta do usuário — exatamente o que já existe e não resolve o
problema de [01](01-visao-e-escopo.md).

---

## 11.1 Variáveis

Assunto, corpo e nome do arquivo são templates com variáveis entre chaves, resolvidas no momento do
envio pelo `ResolvedorVariaveis` ([09](09-arquitetura-tecnica.md)).

| Variável | Origem | Exemplo |
|----------|--------|---------|
| `{nome}` | `perfil_usuario.nome` | `Eduardo Feltes` |
| `{primeiro_nome}` | Primeira palavra do nome | `Eduardo` |
| `{matricula}` | `perfil_usuario.matricula` | `01234` |
| `{cargo}` | `perfil_usuario.cargo` | `Desenvolvedor` |
| `{empresa}` | `perfil_usuario.empresa` | `Acme Ltda` |
| `{competencia}` | Competência por extenso | `maio/2026` |
| `{mes}` | Mês com dois dígitos | `05` |
| `{mes_extenso}` | Nome do mês | `maio` |
| `{ano}` | Ano com quatro dígitos | `2026` |
| `{total_mes}` | Total trabalhado, formatado | `172h 20m` |
| `{saldo_mes}` | Saldo do mês, com sinal | `+ 04h 20m` |
| `{banco_horas}` | Banco acumulado, com sinal | `+ 06h 30m` |
| `{data_geracao}` | Data em que o arquivo foi gerado | `01/06/2026` |
| `{dias_trabalhados}` | Dias com ao menos um par completo | `21` |

**Regras de resolução**

- Variável desconhecida permanece literal no texto, sem quebrar nada. Escrever `{setor}` produz
  `{setor}` — é preferível a apagar silenciosamente algo que o usuário digitou de propósito.
- Variável conhecida com origem vazia é substituída por string vazia, e os espaços em excesso ao
  redor são colapsados. Um perfil sem matrícula não gera `Ponto -  - maio/2026`.
- No **nome do arquivo**, o resultado passa por saneamento: caracteres inválidos em nome de arquivo
  (`/ \ : * ? " < > |`) são trocados por `-`, acentos são preservados, e espaços viram `_`. Um nome
  vazio após o saneamento cai para `Ponto_{ano}-{mes}.xlsx`.

---

## 11.2 Valores padrão

Semeados na criação do banco ([06, seção 6.7](06-modelo-de-dados.md)) e livremente editáveis em
TL-22.

**Nome do arquivo**
```
Ponto_{nome}_{mes}-{ano}.xlsx
```
→ `Ponto_Eduardo_Feltes_05-2026.xlsx`

**Assunto**
```
Ponto - {nome} - {competencia}
```
→ `Ponto - Eduardo Feltes - maio/2026`

**Corpo**
```
Olá,

Segue em anexo o registro de ponto de {competencia}.

Total trabalhado: {total_mes}
Saldo do período: {saldo_mes}

Atenciosamente,
{nome}
```

O corpo padrão é deliberadamente formal e curto: é uma mensagem que a persona Renata de
[03](03-ux-personas-jornadas.md) vai ler dezenas de vezes por mês, e que o usuário vai enviar sem
reler. Ele precisa estar correto sem edição.

---

## 11.3 Integração com o cliente de e-mail

### A decisão

O app **não envia e-mail**. Ele abre o cliente de e-mail do usuário com tudo preenchido e deixa o
envio a cargo dele. A justificativa completa está em [ADR-02](15-riscos-e-decisoes.md); o resumo:
enviar por SMTP exigiria armazenar a senha de aplicativo do e-mail do usuário no dispositivo, o que
contraria frontalmente [RNF-05](02-requisitos.md) e transformaria um app de ponto em um custodiante
de credenciais. O ganho seria um toque a menos por mês.

### Como funciona

```dart
// data/servicos/servico_email.dart
final class ServicoEmailAndroid implements ServicoEmail {
  @override
  Future<Resultado<void>> abrirComposicao({
    required List<String> destinatarios,
    required List<String> copia,
    required String assunto,
    required String corpo,
    required String caminhoAnexo,
  }) async {
    try {
      await FlutterEmailSender.send(Email(
        recipients: destinatarios,
        cc: copia,
        subject: assunto,
        body: corpo,
        attachmentPaths: [caminhoAnexo],
        isHTML: false,
      ));
      return const Sucesso(null);   // conseguiu ABRIR, não "enviou"
    } on PlatformException catch (e) {
      if (e.code == 'not_available') {
        return const Erro(FalhaSistemaOperacional(
          'Não encontrei um app de e-mail neste aparelho. '
          'Você pode compartilhar o arquivo por outro caminho.',
        ));
      }
      return Erro(FalhaSistemaOperacional('Não consegui abrir o e-mail.', causa: e));
    }
  }
}
```

### Requisitos de plataforma

Três configurações no Android sem as quais o fluxo falha, e falha de formas confusas:

**1. `FileProvider`** — sem ele, o cliente de e-mail recebe uma URI de um arquivo privado do app e
não consegue lê-la. O anexo aparece com 0 byte ou simplesmente não aparece.

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths" />
</provider>
```

```xml
<!-- android/app/src/main/res/xml/file_paths.xml -->
<paths>
    <files-path name="planilhas_geradas" path="geradas/" />
</paths>
```

**2. `queries`** — no Android 11 (API 30) e superior, o app não enxerga outros aplicativos sem
declarar o que pretende fazer. Sem isso, `FlutterEmailSender` reporta que não há cliente de e-mail
mesmo com o Gmail instalado.

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.SENDTO" />
        <data android:scheme="mailto" />
    </intent>
</queries>
```

**3. Ausência de `INTERNET`** — a permissão continua não declarada
([09, seção 9.3](09-arquitetura-tecnica.md)). O e-mail sai pelo cliente do usuário, com a conta e a
conexão dele. O app nunca toca na rede.

### Alternativa quando não há cliente de e-mail

O fluxo cai para `share_plus`, que oferece qualquer aplicativo capaz de receber o arquivo —
WhatsApp, Drive, Telegram. A pergunta de confirmação de RN-23 acontece do mesmo jeito, porque o
problema é o mesmo: o app não sabe o que aconteceu depois.

---

## 11.4 Por que o app pergunta em vez de afirmar

O Android não devolve à aplicação o resultado de uma intenção de compartilhamento. O
`resultCode` é `RESULT_CANCELED` tanto quando o usuário desiste quanto quando ele envia a mensagem,
porque o cliente de e-mail encerra a atividade sem informar o desfecho. **Não existe forma correta
de o app saber se o e-mail saiu.**

Isso deixa duas opções:

| Opção | Consequência |
|-------|--------------|
| Assumir que enviou | Falso positivo. O app marcaria como entregue uma competência que nunca chegou, e — pior — silenciaria o lembrete. O usuário só descobriria quando o RH cobrasse, exatamente a dor D1 que o produto existe para eliminar. |
| **Perguntar ao usuário** | Um toque a mais por mês, e o estado do histórico é sempre verdadeiro. |

A segunda é a escolhida ([RN-23](02-requisitos.md)). A pergunta aparece ao retornar ao app, aceita
"ainda não" sem julgamento, e reaparece na próxima visita àquela competência se ficar sem resposta.
Uma competência em `GERADO` continua contando como pendente e continua recebendo lembrete.

O microcopy foi escrito para não soar como burocracia, e sim como honestidade — "O app não consegue
confirmar isso sozinho" ([04, seção 4.6](04-ux-navegacao-telas.md)).

---

## 11.5 Histórico de envios

`envio_mensal` guarda um registro por geração ([RN-24](02-requisitos.md)). Regerar uma competência
cria um novo registro e preserva o anterior, o que dá ao usuário um rastro do que foi entregue e
quando — útil justamente no caso em que o RH questiona uma planilha.

**TL-23 exibe, por competência:**

```
maio/2026                                    ✓ Enviado
Ponto_Eduardo_Feltes_05-2026.xlsx · 24 KB
Gerado em 01/06 às 19:04 · Enviado em 01/06 às 19:06
                                  [ Abrir ]  [ ⋮ ]

abril/2026                                   ⏳ Gerado
Ponto_Eduardo_Feltes_04-2026.xlsx · 23 KB
Gerado em 02/05 às 20:11 · não confirmado
                        [ Abrir ]  [ Enviar ]  [ ⋮ ]
```

O menu `⋮` oferece compartilhar, regerar e excluir o arquivo. Excluir remove o arquivo do disco mas
mantém o registro histórico, que passa a exibir "arquivo não disponível" — o fato de ter sido
enviado continua sendo verdade mesmo depois de o arquivo ser apagado.

**Retenção.** Arquivos gerados ficam indefinidamente. Um `.xlsx` de ponto tem dezenas de kilobytes;
doze meses ocupam menos que uma foto. A limpeza é manual, pelo menu de cada item.

---

## 11.6 Lembrete de fechamento

É a funcionalidade que ataca a dor **D1** de [01](01-visao-e-escopo.md) — a razão original do
projeto. Especificação do agendamento em [A6](07-fluxos-atividade.md).

| Parâmetro | Padrão | Observação |
|-----------|--------|------------|
| `dia_referencia` | `-1` | Último dia do mês. Valores negativos contam a partir do fim; positivos são o dia do mês |
| `hora` | `1140` (19:00) | Fim do expediente, quando ainda dá tempo de resolver |
| `ativa` | `false` | Ligado pelo usuário; sugerido em um cartão na tela de fechamento |

**Condições de supressão**, verificadas no disparo:

- A competência já tem um `envio_mensal` com status `ENVIADO`.
- Não existe modelo de planilha ativo — nesse caso a notificação é substituída por outra, que
  convida a configurar a planilha, porque lembrar de fechar sem ter como fechar é frustração pura.

**Ao tocar**, o app abre TL-21 já na competência correta, com as pendências levantadas. O caminho da
notificação até o e-mail enviado tem três toques, cumprindo OE-4 de [01](01-visao-e-escopo.md).

**Escalonamento.** Se a competência continuar sem envio confirmado, o lembrete se repete nos dias
`+1`, `+3` e `+5` do mês seguinte, e então para. Insistir além disso transformaria o lembrete em
ruído que o usuário aprende a descartar — e um lembrete descartado por hábito é pior que nenhum.

> ⚠️ EM ABERTO — o escalonamento em três repetições é uma hipótese de design, não um resultado de
> pesquisa. Vale revisitá-lo depois de dois ou três meses de uso real.
