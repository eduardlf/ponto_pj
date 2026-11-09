import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/datas_excel.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/formatadores.dart';

/// Tabela de docs/12, seção 12.10.
void main() {
  Duration min(int minutos) => Duration(minutes: minutos);

  group('formatarDuracao', () {
    test('510 min', () => expect(formatarDuracao(min(510)), '08h 30m'));
    test('0 min', () => expect(formatarDuracao(Duration.zero), '00h 00m'));
    test('1500 min nunca vira dias', () => expect(formatarDuracao(min(1500)), '25h 00m'));
    test('negativa nunca aparece sem sinal', () => expect(formatarDuracao(min(-30)), '- 00h 30m'));
  });

  group('formatarDuracaoComSinal', () {
    test('+30 min', () => expect(formatarDuracaoComSinal(min(30)), '+ 00h 30m'));
    test('−75 min', () => expect(formatarDuracaoComSinal(min(-75)), '- 01h 15m'));
    test('zero sem sinal', () => expect(formatarDuracaoComSinal(Duration.zero), '00h 00m'));
  });

  group('formatarHora', () {
    test('510 min', () => expect(formatarHora(min(510)), '08:30'));
    test('1439 min', () => expect(formatarHora(min(1439)), '23:59'));
    test('meia-noite', () => expect(formatarHora(Duration.zero), '00:00'));
    test('passa de 24 h dá a volta', () => expect(formatarHora(min(1800)), '06:00'));
  });

  group('datas', () {
    final data = dataCivil(2026, 5, 7);
    test('formatarDataCurta', () => expect(formatarDataCurta(data), '07/05/2026'));
    test('formatarDataExtensa', () => expect(formatarDataExtensa(data), 'qui., 07 mai. 2026'));
    test('formatarCompetencia', () => expect(formatarCompetencia(2026, 5), 'maio/2026'));
    test('iso', () => expect(data.iso, '2026-05-07'));
    test('lerDataIso', () {
      expect(lerDataIso('2026-05-07'), data);
      expect(lerDataIso('2026-02-30'), isNull);
      expect(lerDataIso('07/05/2026'), isNull);
    });
    test('somar dias atravessa meses sem depender de fuso', () {
      expect(dataCivil(2026, 1, 31).somarDias(1), dataCivil(2026, 2, 1));
      expect(dataCivil(2028, 2, 28).somarDias(1), dataCivil(2028, 2, 29));
    });
    test('hora do dia descarta segundos, nunca arredonda', () {
      expect(DateTime(2026, 5, 7, 8, 30, 59).horaDoDia, min(510));
    });
  });

  group('formatos de planilha', () {
    test('duração como relógio', () {
      expect(formatarDuracaoRelogio(min(510)), '08:30');
      expect(formatarDuracaoRelogio(min(10340)), '172:20');
      expect(formatarDuracaoRelogio(min(-30)), '-00:30');
      expect(formatarDuracaoRelogio(min(510), comSegundos: true), '08:30:00');
    });
    test('horas decimais com vírgula', () {
      expect(formatarHorasDecimais(min(510)), '8,5');
      expect(formatarHorasDecimais(min(500)), '8,33');
      expect(formatarHorasDecimais(min(480)), '8');
      expect(formatarHorasDecimais(min(-30)), '-0,5');
    });
    test('número de série do Excel', () {
      expect(serialDeData(dataCivil(2026, 5, 7)), 46149);
      expect(dataDeSerial(46149), dataCivil(2026, 5, 7));
      expect(dataDeSerial(46149.75), dataCivil(2026, 5, 7));
      expect(serialDeData(dataCivil(2026, 5, 7), sistema1904: true), 46149 - 1462);
    });
    test('fração do dia', () {
      expect(fracaoDoDia(min(720)), 0.5);
      expect(fracaoDoDia(min(510)), closeTo(0.3541666, 1e-6));
      expect(duracaoDeFracao(0.3541666666666667), min(510));
    });
  });
}
