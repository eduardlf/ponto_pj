import '../../core/extensoes/data_extensoes.dart';
import '../entidades/dia_trabalho.dart';
import '../entidades/resumo_periodo.dart';
import '../enums/enums.dart';

/// Pendências do fechamento (docs/12, seção 12.3, e RF-34). Calculadas na leitura, nunca
/// persistidas.
class GeradorPendencias {
  const GeradorPendencias();

  /// Recebe dias já calculados. Dias futuros são ignorados, e o dia de hoje só vira "dia
  /// útil sem registro" depois que termina.
  List<Pendencia> levantar(List<DiaTrabalho> dias, {DateTime? agora}) {
    final pendencias = <Pendencia>[];
    for (final dia in dias) {
      if (agora != null && dia.data.depoisDe(agora)) continue;
      final ehHoje = agora != null && dia.data.mesmoDia(agora);

      if (dia.inconsistente) {
        pendencias.add(Pendencia(
          data: dia.data,
          tipo: TipoPendencia.marcacoesIncompletas,
          descricao: 'Marcações incompletas',
        ));
      } else if (dia.cargaPrevista > Duration.zero &&
          dia.status == StatusDia.normal &&
          dia.marcacoes.isEmpty &&
          !ehHoje) {
        pendencias.add(Pendencia(
          data: dia.data,
          tipo: TipoPendencia.diaUtilSemRegistro,
          descricao: 'Dia útil sem registro',
        ));
      } else if (dia.status == StatusDia.falta && dia.marcacoes.isNotEmpty) {
        pendencias.add(Pendencia(
          data: dia.data,
          tipo: TipoPendencia.faltaComMarcacoes,
          descricao: 'Falta com horários registrados',
        ));
      }
    }
    return pendencias;
  }
}
