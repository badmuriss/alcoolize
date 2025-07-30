# Alcoolize - Jogo de Bebidas

## Sobre o Projeto

Alcoolize é um aplicativo de jogos sociais para festas e encontros com amigos. O app contém uma coleção de jogos interativos projetados para animar reuniões e promover a socialização. Inclui jogos populares como "Eu Nunca", "Quem é Mais Provável", "Paranoia", "Medusa", "Palavra Proibida", entre outros.

## Características

- **Múltiplos Jogos**: 8 jogos diferentes para diversas situações
- **Personalização**: Ajuste de probabilidades para cada jogo aparecer
- **Editor de Conteúdo**: Edite perguntas e palavras de cada jogo
- **Interface Intuitiva**: Design moderno e fácil de usar
- **Configurações Flexíveis**: Ative/desative jogos conforme sua preferência

## Tecnologias Utilizadas

- Flutter
- Dart
- SharedPreferences para persistência de dados

## Requisitos

- Flutter 3.0.0 ou superior
- Dart 2.17.0 ou superior
- Android Studio / VS Code
- Xcode (para build iOS)

## Como Instalar e Executar

### Configuração do Ambiente

1. Instale o Flutter seguindo as [instruções oficiais](https://flutter.dev/docs/get-started/install)
2. Configure seu editor (Android Studio ou VS Code) com os plugins do Flutter e Dart
3. Clone este repositório:

```bash
git clone https://github.com/badmuriss/alcoolize.git
cd alcoolize
```

### Instalação de Dependências

Execute o seguinte comando para instalar todas as dependências necessárias:

```bash
flutter pub get
```

### Configuração do Ícone do Aplicativo

O projeto utiliza o pacote `flutter_launcher_icons` para gerar ícones para diferentes plataformas. O ícone base está localizado em `assets/icons/icon.png`.

Para gerar os ícones para todas as plataformas configuradas, execute:

```bash
flutter pub run flutter_launcher_icons
```

### Executando o Projeto

Para executar o projeto em modo de desenvolvimento:

```bash
flutter run
```

## Build para Android

### Gerar APK de Debug

```bash
flutter build apk --debug
```

O APK será gerado em `build/app/outputs/flutter-apk/app-debug.apk`

### Gerar APK de Release

```bash
flutter build apk --release
```

O APK será gerado em `build/app/outputs/flutter-apk/app-release.apk`

## Build para iOS

### Requisitos para iOS

- Mac com macOS
- Xcode instalado

### Gerar arquivo IPA

1. Abra o projeto no Xcode:

```bash
open ios/Runner.xcworkspace
```

2. Configure o Bundle Identifier e Team no Xcode
3. Execute o build a partir do Flutter:

```bash
flutter build ios --release
```

## Personalização

### Edição de Perguntas e Palavras

O aplicativo permite editar as perguntas e palavras de cada jogo através da interface. As alterações são salvas localmente no dispositivo e persistem entre sessões.

### Ajuste de Probabilidades

É possível ajustar a probabilidade de cada jogo aparecer, permitindo que seus jogos favoritos apareçam com mais frequência.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

```
MIT License

Copyright (c) 2023 Alcoolize

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```