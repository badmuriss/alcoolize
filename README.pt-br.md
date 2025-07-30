# 🍻 Alcoolize - App de Jogos de Bebida

<div align="center">

**🌐 Idiomas:** [English](README.md) | [Português](README.pt-br.md) | [Español](README.es.md)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-lightgrey?style=for-the-badge)

**O seu drinking game** - Uma coleção de jogos interativos para animar suas festas!

[📱 Começar](#-começando) • [🎮 Jogos](#-jogos-disponíveis) • [🛠️ Contribuir](#-contribuindo) • [📄 Licença](#-licença)

</div>

---

## 🎯 Sobre

Alcoolize é um **app multiplataforma em Flutter** com uma coleção curada de jogos de bebida projetados para unir pessoas e criar momentos memoráveis em festas e encontros sociais. Com uma interface limpa e intuitiva e jogabilidade personalizável, é o companheiro perfeito para sua próxima celebração!

### ✨ Principais Recursos

- 🎲 **8 Jogos Diferentes** - Do clássico "Eu Nunca" ao único "Medusa" 
- ⚙️ **Controle de Probabilidade** - Ajuste a frequência com que cada jogo aparece
- ✏️ **Editor de Conteúdo** - Edite perguntas e palavras de cada jogo
- 🎨 **UI/UX Moderna** - Design limpo e responsivo que funciona em todos os dispositivos
- 🔧 **Configurações Flexíveis** - Ative/desative jogos baseado no seu grupo
- 💾 **Armazenamento Local** - Todas as personalizações persistem entre sessões
- 🌐 **Multiplataforma** - Android, iOS, Web, Windows, macOS, Linux

---

## 🎮 Jogos Disponíveis

| Jogo | Descrição | Jogadores |
|------|-----------|-----------|
| 🃏 **Cartas** | Cartas de desafio com tarefas individuais ou em grupo | 2+ |
| 🚫 **Palavra Proibida** | Não fale a palavra proibida durante a rodada | 3+ |
| 👁️ **Medusa** | Levantem a cabeça simultaneamente - contato visual = bebam! | 4+ |
| 🙈 **Eu Nunca** | Clássico jogo de bebida com perguntas personalizadas | 3+ |
| 🤔 **Paranoia** | Perguntas sussurradas com respostas misteriosas | 4+ |
| 🎯 **Mais Provável** | Votem em quem é mais provável de... | 3+ |
| 🔄 **Roletinha** | Gire a roleta da sorte (e das bebidas) | 2+ |
| 🔤 **Tibitar** | Adivinhe o verbo escondido através de perguntas criativas | 4+ |

---

## 🚀 Começando

### Pré-requisitos

- Flutter SDK (3.5.3 ou superior)
- Dart SDK (3.5.3 ou superior)
- Para desenvolvimento mobile: Android Studio / Xcode
- Para deploy web: Qualquer navegador moderno

### 📦 Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/badmuriss/alcoolize.git
   cd alcoolize
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Gere os ícones do app**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Execute o app**
   ```bash
   flutter run
   ```

### 🏗️ Build para Produção

#### APK Android
```bash
# Versão debug
flutter build apk --debug

# Versão release (requer assinatura)
flutter build apk --release
```

#### App iOS
```bash
flutter build ios --release
```

#### App Web
```bash
flutter build web --release
```

O app web construído estará em `build/web/` e pode ser implantado em qualquer serviço de hospedagem estática.

---

## 🎨 Personalização

### 🎯 Configurações de Probabilidade
Ajuste a frequência com que cada jogo aparece na rotação:
- Navegue para **Configurações** → **Ajustar Probabilidades**
- Use os sliders para definir os pesos de probabilidade
- O total deve ser igual a 100%

### ✏️ Editor de Conteúdo
Personalize perguntas e palavras para cada jogo:
- Vá para **Configurações** → **Editar Perguntas/Palavras**
- Adicione, modifique ou remova conteúdo
- As alterações são salvas localmente e persistem entre sessões

### 🎪 Adicionando Novos Jogos
O app usa uma arquitetura modular. Para adicionar um novo jogo:

1. Crie uma nova tela estendendo `BaseGameScreen`
2. Implemente os métodos necessários (`gameColor`, `gameTitle`, `gameIcon`, etc.)
3. Adicione seu jogo à lista `GameHandler.games`
4. Crie os assets correspondentes de perguntas/palavras

---

## 🛠️ Desenvolvimento

### 📁 Estrutura do Projeto
```
lib/
├── main.dart                 # Ponto de entrada do app
└── src/
    ├── base_game_screen.dart  # Classe base para todos os jogos
    ├── game_handler.dart      # Lógica dos jogos e navegação
    ├── *_screen.dart         # Telas individuais dos jogos
    ├── settings/             # Configurações e configuração do app
    └── utils/                # Classes utilitárias e helpers
```

### 🧪 Executando Testes
```bash
flutter test
```

### 🎯 Qualidade do Código
O projeto usa Flutter lints para qualidade do código:
```bash
flutter analyze
```

---

## 🤝 Contribuindo

Recebemos contribuições da comunidade! Veja como você pode ajudar:

### 🐛 Relatórios de Bug
- Use o [rastreador de issues](https://github.com/badmuriss/alcoolize/issues)
- Inclua passos para reproduzir
- Mencione seu dispositivo/plataforma

### 💡 Solicitações de Recursos
- Verifique issues existentes primeiro
- Descreva o recurso e seus benefícios
- Considere a complexidade de implementação

### 🔧 Pull Requests
1. Faça um fork do repositório
2. Crie uma branch de feature: `git checkout -b feature/recurso-incrivel`
3. Faça suas alterações seguindo o estilo de código existente
4. Execute testes e garanta que passem
5. Commit com mensagens claras: `git commit -m 'Adiciona recurso incrível'`
6. Push para sua branch: `git push origin feature/recurso-incrivel`
7. Abra um Pull Request

### 📝 Diretrizes de Desenvolvimento
- Siga o [guia de estilo do Flutter](https://dart.dev/guides/language/effective-dart)
- Mantenha texto voltado ao usuário em português (suporte a tradução em breve)
- Escreva testes para novos recursos
- Atualize documentação conforme necessário

---

## 🌐 Deploy

O projeto inclui deploy automatizado via Git hooks:
- Commits automaticamente acionam builds web
- App construído é enviado para branch `gh-pages`
- Pode ser implantado no GitHub Pages, Netlify, Vercel, etc.

### Deploy Web Manual
```bash
flutter pub global activate peanut
flutter pub global run peanut
git push origin gh-pages
```

---

## 📱 Download & Jogar

### Versão Web
🌐 **[Jogar no Navegador](https://alcoolize.outis.com.br/)** - *Disponível Agora!*

### Apps Mobile
📱 Lançamentos de APK Android e App Store iOS em breve!

---

## 🙏 Agradecimentos

- **Equipe Flutter** - Pelo framework multiplataforma incrível
- **Contribuidores da Comunidade** - Por tornar este projeto melhor
- **Galera da Festa** - Por testar e fornecer feedback!

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

```
Licença MIT

Copyright (c) 2024 Alcoolize

É concedida permissão, gratuitamente, a qualquer pessoa que obtenha uma cópia
deste software e arquivos de documentação associados (o "Software"), para lidar
no Software sem restrição, incluindo, sem limitação, os direitos
de usar, copiar, modificar, mesclar, publicar, distribuir, sublicenciar e/ou vender
cópias do Software, e permitir às pessoas a quem o Software é
fornecido a fazê-lo, sujeito às seguintes condições:

O aviso de copyright acima e este aviso de permissão devem ser incluídos em todas
as cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "COMO ESTÁ", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU
IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO,
ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO E NÃO VIOLAÇÃO. EM NENHUM CASO OS
AUTORES OU DETENTORES DE COPYRIGHT SERÃO RESPONSÁVEIS POR QUALQUER REIVINDICAÇÃO, DANOS OU OUTRAS
RESPONSABILIDADES, SEJA EM AÇÃO DE CONTRATO, ATO ILÍCITO OU DE OUTRA FORMA, DECORRENTES DE,
FORA DE OU EM CONEXÃO COM O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES NO
SOFTWARE.
```

---

<div align="center">

**🍻 Feito com ❤️ para noites inesquecíveis 🍻**

⭐ **Favorite este repo se você gostou!** ⭐

</div>