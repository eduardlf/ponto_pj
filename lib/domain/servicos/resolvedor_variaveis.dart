import '../../core/formatadores.dart';
import '../entidades/competencia.dart';
import '../entidades/perfil_usuario.dart';
import '../entidades/resumo_periodo.dart';

/// De onde saem os valores das variáveis de um envio.
class ContextoVariaveis {
  final PerfilUsuario? perfil;
  final Competencia competencia;
  final ResumoPeriodo? resumo;
  final DateTime dataGeracao;

  const ContextoVariaveis({
    required this.perfil,
    required this.competencia,
    required this.resumo,
    required this.dataGeracao,
  });
}

/// Resolve `{nome}`, `{competencia}` e as demais variáveis de assunto, corpo e nome do
/// arquivo (docs/11, seção 11.1).
class ResolvedorVariaveis {
  static const variaveis = [
    'nome', 'primeiro_nome', 'matricula', 'cargo', 'empresa', 'competencia', 'mes', //
    'mes_extenso', 'ano', 'total_mes', 'saldo_mes', 'banco_horas', 'data_geracao',
    'dias_trabalhados',
  ];

  const ResolvedorVariaveis();

  /// Variável desconhecida permanece literal. Variável conhecida com origem vazia vira
  /// texto vazio, sem deixar espaço duplicado para trás.
  String resolver(String modelo, ContextoVariaveis contexto) {
    final valores = _valores(contexto);
    return modelo.replaceAllMapped(RegExp(r'( ?)\{([a-z_]+)\}( ?)'), (m) {
      final nome = m.group(2)!;
      if (!valores.containsKey(nome)) return m.group(0)!;
      final antes = m.group(1)!;
      final depois = m.group(3)!;
      final valor = valores[nome]!;
      if (valor.isNotEmpty) return '$antes$valor$depois';
      return antes.isNotEmpty && depois.isNotEmpty ? ' ' : '';
    });
  }

  /// Nome de arquivo saneado: caracteres inválidos viram `-`, espaços viram `_` e o acento é
  /// preservado. Um nome vazio cai para `Ponto_{ano}-{mes}.xlsx`.
  String resolverNomeArquivo(String modelo, ContextoVariaveis contexto) {
    var base = resolver(modelo, contexto).trim();
    if (base.toLowerCase().endsWith('.xlsx')) base = base.substring(0, base.length - 5);
    base = base
        .replaceAll(RegExp(r'[/\\:*?"<>|]'), '-')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^[_.\-]+|[_.\-]+$'), '');
    if (base.isEmpty) {
      return 'Ponto_${contexto.competencia.ano}-'
          '${contexto.competencia.mes.toString().padLeft(2, '0')}.xlsx';
    }
    return '$base.xlsx';
  }

  Map<String, String> _valores(ContextoVariaveis contexto) {
    final perfil = contexto.perfil;
    final competencia = contexto.competencia;
    final resumo = contexto.resumo;
    final nome = perfil?.nome.trim() ?? '';
    return {
      'nome': nome,
      'primeiro_nome': nome.split(RegExp(r'\s+')).first,
      'matricula': perfil?.matricula?.trim() ?? '',
      'cargo': perfil?.cargo?.trim() ?? '',
      'empresa': perfil?.empresa?.trim() ?? '',
      'competencia': competencia.formatado(),
      'mes': competencia.mes.toString().padLeft(2, '0'),
      'mes_extenso': nomeMes(competencia.mes),
      'ano': '${competencia.ano}',
      'total_mes': resumo == null ? '' : formatarDuracao(resumo.trabalhado),
      'saldo_mes': resumo == null ? '' : formatarDuracaoComSinal(resumo.saldo),
      'banco_horas': resumo == null ? '' : formatarDuracaoComSinal(resumo.bancoHoras),
      'data_geracao': formatarDataCurta(contexto.dataGeracao),
      'dias_trabalhados': resumo == null ? '' : '${resumo.diasTrabalhados}',
    };
  }
}
