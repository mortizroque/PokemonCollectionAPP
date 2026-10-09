# 🎴 PokéCards: Pokémon Collection App

App móvil multiplataforma desarrollada en **Flutter** para coleccionar cartas Pokémon de la primera generación, con estadísticas por carta y modo de combate.

> Proyecto en equipo desarrollado durante el ciclo formativo de Desarrollo de Aplicaciones Multiplataforma (DAM). Sin ánimo de lucro y con fines educativos. Pokémon es una marca de Nintendo/Game Freak/The Pokémon Company.

## 📸 Capturas

| Colección | Detalle de carta | Juego |
|---|---|---|
| ![Colección](screenshots/screenshot1.png) | ![Detalle](screenshots/screenshot2.png) | ![Juego](screenshots/screenshot3.png) |

## ✨ Funcionalidades

- Colección de cartas de la 1.ª generación, con estadísticas y habilidades propias.
- Modo de combate con cartas contra la IA y otros jugadores.
- Escaneo de cartas con la cámara mediante reconocimiento de texto (Google ML Kit).
- Persistencia local del progreso del jugador.
- Interfaz personalizada con tipografías y recursos gráficos propios.

## 🛠️ Stack técnico

| Área | Tecnología |
|---|---|
| Framework / lenguaje | Flutter · Dart (SDK ≥ 3.3) |
| Gestión de estado | Provider |
| Red | `http` |
| Cámara y OCR | `camera` · `google_mlkit_text_recognition` · `permission_handler` |
| Almacenamiento local | `shared_preferences` |
| UI | `flutter_svg` · `percent_indicator` · fuentes personalizadas |
| Utilidades | `intl` · `crypto` · `logger` |
| Calidad | `flutter_lints` · `flutter_test` |

## 🚀 Cómo ejecutarlo

Requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado y un emulador o dispositivo conectado.

```bash
git clone https://github.com/mortizroque/PokemonCollectionAPP.git
cd PokemonCollectionAPP
flutter pub get
flutter run
```

## 📁 Estructura

```
lib/       # Código de la aplicación
assets/    # Imágenes y recursos del juego
fonts/     # Tipografías personalizadas
test/      # Tests
android/ ios/ web/ ...   # Plataformas soportadas
```

## 🎯 Qué aprendimos

- Desarrollo de una app Flutter completa con gestión de estado mediante Provider.
- Integración de cámara y reconocimiento de texto en dispositivos móviles.
- Gestión de permisos y persistencia local.
- Trabajo en equipo con Git: el proyecto superó los 290 commits entre los tres.

## 👥 Autores

| | LinkedIn |
|---|---|
| **Marc Ortiz** | [Perfil](https://www.linkedin.com/in/marcortizroque/) · [GitHub](https://github.com/mortizroque) |
| **Pau Farré Ruiz** | [Perfil](https://www.linkedin.com/in/paufarreruiz/) |
| **Marc Crespo Cambón** | [Perfil](https://www.linkedin.com/in/marccrespocambon/) |

## 📄 Licencia

MIT, ver [LICENSE](LICENSE).
