# Ponto PJ

Registro de ponto para Android que, no fim do mês, preenche a planilha Excel da própria empresa
e abre o e-mail para o RH com o arquivo já anexado. O app aprende o formato da planilha uma vez,
com um assistente, e não acessa a internet.

Trabalho acadêmico multidisciplinar (IHM e Análise de Sistemas, com curricularização da extensão).
A especificação completa — requisitos, casos de uso, diagramas UML, telas e regras de cálculo —
está em [`docs/`](docs/README.md), e o estado de cada fase em
[`docs/13`, seção 13.5](docs/13-plano-de-implementacao.md).

## Rodar

Flutter 3.24.4 / Dart 3.5.4, Android 8.0 (API 26) ou superior.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter run
flutter build apk --release --split-per-abi
```

Instruções para quem for continuar a implementação, humano ou agente: [`CLAUDE.md`](CLAUDE.md).
