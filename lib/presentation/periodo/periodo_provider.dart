import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/servicos/consulta_periodo.dart';

/// Dias e totais de um intervalo de datas (UC-08), recarregados a cada escrita.
final periodoProvider = FutureProvider.autoDispose
    .family<PeriodoConsultado, ({DateTime inicio, DateTime fim})>((ref, intervalo) {
  ref.watch(versaoDadosProvider);
  return ref.watch(consultaPeriodoProvider).consultar(intervalo.inicio, intervalo.fim);
});
