# 🍻 Alcoolize - App de Juegos de Bebida

<div align="center">

**🌐 Idiomas:** [English](README.md) | [Português](README.pt-br.md) | [Español](README.es.md)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-lightgrey?style=for-the-badge)

**Tu juego de bebida** - ¡Una colección de juegos interactivos para animar tus fiestas!

[📱 Comenzar](#-empezando) • [🎮 Juegos](#-juegos-disponibles) • [🛠️ Contribuir](#-contribuyendo) • [📄 Licencia](#-licencia)

</div>

---

## 🎯 Sobre el Proyecto

Alcoolize es una **app multiplataforma en Flutter** con una colección curada de juegos de bebida diseñados para unir a las personas y crear momentos memorables en fiestas y reuniones sociales. ¡Con una interfaz limpia e intuitiva y jugabilidad personalizable, es el compañero perfecto para tu próxima celebración!

### ✨ Características Principales

- 🎲 **8 Juegos Diferentes** - Desde el clásico "Yo Nunca" hasta el único "Medusa" 
- 🌍 **Soporte Multiidioma** - Inglés, Español, Portugués con reinicio automático de la app
- ⚙️ **Control de Probabilidad** - Ajusta la frecuencia con que aparece cada juego
- ✏️ **Editor de Contenido** - Edita preguntas y palabras de cada juego
- 🎨 **UI/UX Moderna** - Diseño limpio y responsivo que funciona en todos los dispositivos
- 🔧 **Configuraciones Flexibles** - Activa/desactiva juegos según tu grupo
- 💾 **Almacenamiento Local** - Todas las personalizaciones persisten entre sesiones
- 🌐 **Multiplataforma** - Android, iOS, Web, Windows, macOS, Linux

---

## 🎮 Juegos Disponibles

| Juego | Descripción | Jugadores |
|-------|-------------|-----------|
| 🃏 **Cartas** | Cartas de desafío con tareas individuales o grupales | 2+ |
| 🚫 **Palabra Prohibida** | No digas la palabra prohibida durante la ronda | 3+ |
| 👁️ **Medusa** | ¡Levanten la cabeza simultáneamente - contacto visual = beban! | 4+ |
| 🙈 **Yo Nunca** | Clásico juego de bebida con preguntas personalizadas | 3+ |
| 🤔 **Paranoia** | Preguntas susurradas con respuestas misteriosas | 4+ |
| 🎯 **Más Probable** | Voten por quién es más probable que... | 3+ |
| 🔄 **Ruleta** | Gira la rueda de la fortuna (y las bebidas) | 2+ |
| 🔤 **Verbo Misterioso** | Adivina el verbo oculto a través de preguntas creativas | 4+ |

---

## 🚀 Empezando

### Requisitos Previos

- Flutter SDK (3.5.3 o superior)
- Dart SDK (3.5.3 o superior)
- Para desarrollo móvil: Android Studio / Xcode
- Para despliegue web: Cualquier navegador moderno

### 📦 Instalación

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/badmuriss/alcoolize.git
   cd alcoolize
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Genera los iconos de la app**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Ejecuta la app**
   ```bash
   flutter run
   ```

### 🏗️ Compilación para Producción

#### APK Android
```bash
# Versión debug
flutter build apk --debug

# Versión release (requiere firma)
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

La app web compilada estará en `build/web/` y puede desplegarse en cualquier servicio de hosting estático.

---

## 🎨 Personalización

### 🎯 Configuraciones de Probabilidad
Ajusta la frecuencia con que cada juego aparece en la rotación:
- Navega a **Configuraciones** → **Ajustar Probabilidades**
- Usa los deslizadores para establecer los pesos de probabilidad
- El total debe sumar 100%

### ✏️ Editor de Contenido
Personaliza preguntas y palabras para cada juego:
- Ve a **Configuraciones** → **Editar Preguntas/Palabras**
- Añade, modifica o elimina contenido
- Los cambios se guardan localmente y persisten entre sesiones

### 🎪 Añadiendo Nuevos Juegos
La app usa una arquitectura modular. Para añadir un nuevo juego:

1. Crea una nueva pantalla extendiendo `BaseGameScreen`
2. Implementa los métodos requeridos (`gameColor`, `gameTitle`, `gameIcon`, etc.)
3. Añade tu juego a la lista `GameHandler.games`
4. Crea los assets correspondientes de preguntas/palabras

---

## 🛠️ Desarrollo

### 📁 Estructura del Proyecto
```
lib/
├── main.dart                 # Punto de entrada de la app
└── src/
    ├── base_game_screen.dart  # Clase base para todos los juegos
    ├── game_handler.dart      # Lógica de juegos y navegación
    ├── *_screen.dart         # Pantallas individuales de juegos
    ├── settings/             # Configuraciones de la app
    └── utils/                # Clases utilitarias y helpers
```

### 🧪 Ejecutando Pruebas
```bash
flutter test
```

### 🎯 Calidad del Código
El proyecto usa Flutter lints para calidad del código:
```bash
flutter analyze
```

---

## 🤝 Contribuyendo

¡Damos la bienvenida a contribuciones de la comunidad! Aquí te mostramos cómo puedes ayudar:

### 🐛 Reportes de Errores
- Usa el [rastreador de issues](https://github.com/badmuriss/alcoolize/issues)
- Incluye pasos para reproducir
- Menciona tu dispositivo/plataforma

### 💡 Solicitudes de Características
- Revisa issues existentes primero
- Describe la característica y sus beneficios
- Considera la complejidad de implementación

### 🔧 Pull Requests
1. Haz fork del repositorio
2. Crea una rama de característica: `git checkout -b feature/caracteristica-increible`
3. Haz tus cambios siguiendo el estilo de código existente
4. Ejecuta pruebas y asegúrate de que pasen
5. Commit con mensajes claros: `git commit -m 'Añade característica increíble'`
6. Push a tu rama: `git push origin feature/caracteristica-increible`
7. Abre un Pull Request

### 📝 Pautas de Desarrollo
- Sigue la [guía de estilo de Flutter](https://dart.dev/guides/language/effective-dart)
- Mantén el texto orientado al usuario en español (soporte de traducción próximamente)
- Escribe pruebas para nuevas características
- Actualiza documentación según sea necesario

---

## 🌐 Despliegue

El proyecto incluye despliegue automatizado vía Git hooks:
- Los commits automáticamente activan compilaciones web
- La app compilada se sube a la rama `gh-pages`
- Puede desplegarse en GitHub Pages, Netlify, Vercel, etc.

### Despliegue Web Manual
```bash
flutter pub global activate peanut
flutter pub global run peanut
git push origin gh-pages
```

---

## 📱 Descargar y Jugar

### Versión Web
🌐 **[Jugar en el Navegador](https://alcoolize.outis.com.br/)** - *¡Disponible Ahora!*

### Apps Móviles
📱 ¡Próximamente lanzamientos de APK Android y App Store iOS!

---

## 🙏 Agradecimientos

- **Equipo Flutter** - Por el increíble framework multiplataforma
- **Contribuidores de la Comunidad** - Por hacer este proyecto mejor
- **Gente de Fiesta** - ¡Por probar y proporcionar feedback!

---

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.

```
Licencia MIT

Copyright (c) 2024 Alcoolize

Se concede permiso, de forma gratuita, a cualquier persona que obtenga una copia
de este software y archivos de documentación asociados (el "Software"), para tratar
en el Software sin restricción, incluyendo sin limitación los derechos
a usar, copiar, modificar, fusionar, publicar, distribuir, sublicenciar y/o vender
copias del Software, y permitir a las personas a las que se proporciona el Software
hacerlo, sujeto a las siguientes condiciones:

El aviso de copyright anterior y este aviso de permiso se incluirán en todas
las copias o partes sustanciales del Software.

EL SOFTWARE SE PROPORCIONA "TAL COMO ESTÁ", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O
IMPLÍCITA, INCLUYENDO PERO NO LIMITADO A LAS GARANTÍAS DE COMERCIABILIDAD,
IDONEIDAD PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN. EN NINGÚN CASO LOS
AUTORES O PROPIETARIOS DE COPYRIGHT SERÁN RESPONSABLES DE CUALQUIER RECLAMACIÓN, DAÑOS U OTRA
RESPONSABILIDAD, YA SEA EN UNA ACCIÓN DE CONTRATO, AGRAVIO O DE OTRA MANERA, SURGIENDO DE,
FUERA DE O EN CONEXIÓN CON EL SOFTWARE O EL USO U OTROS TRATOS EN EL
SOFTWARE.
```

---

<div align="center">

**🍻 Hecho con ❤️ para noches inolvidables 🍻**

⭐ **¡Dale estrella a este repo si te gusta!** ⭐

</div>