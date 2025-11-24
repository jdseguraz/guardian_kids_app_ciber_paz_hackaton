# 🛡️ GuardianKids - Ciber Paz Demo

**Simulador de Chat Educativo para Prevención de Peligros en Línea**

Una aplicación Flutter desarrollada para la **Hackathon 2025** que ayuda a los niños a identificar y evitar peligros en línea como grooming, sexting y ciberacoso a través de simulaciones interactivas de chat.

---

## 🎯 Propósito

**GuardianKids** es un simulador de chat educativo diseñado para entrenar a los niños en identificar situaciones de riesgo en internet. A través de escenarios interactivos realistas, los niños aprenden a:

- 🚫 Reconocer intentos de **grooming** (manipulación de adultos)
- 📸 Evitar **sexting** (compartir contenido íntimo)
- 💬 Manejar **ciberacoso** de forma segura

La aplicación usa IA (OpenAI GPT) para simular conversaciones realistas donde un "extraño" intenta obtener información personal o contenido inapropiado. Si el niño cae en la trampa, el juego termina con una explicación educativa del error cometido.

---

## 📱 Descargar e Instalar

### Opción 1: Descargar APK (Recomendado)

1. Ve a la sección **[Releases](../../releases)** de este repositorio
2. Descarga el archivo `guardiankids-v1.0.0.apk` (o la versión más reciente)
3. En tu dispositivo Android:
   - Habilita la instalación de fuentes desconocidas (Configuración → Seguridad)
   - Abre el archivo APK descargado
   - Sigue las instrucciones de instalación

### Opción 2: Compilar desde el código

**Requisitos:**
- Flutter SDK (3.6.2 o superior)
- Android Studio / VS Code
- Git

**Pasos:**

```bash
# 1. Clonar el repositorio
git clone https://github.com/jdseguraz/guardian_kids_app_ciber_paz_hackaton.git
cd guardian_kids_app_ciber_paz_hackaton

# 2. Instalar dependencias
flutter pub get

# 3. Configurar API Key de OpenAI
# Copia el archivo de ejemplo y agrega tu API key
cp lib/config/api_config.dart.example lib/config/api_config.dart
# Edita api_config.dart y reemplaza 'TU_API_KEY_AQUI' con tu clave de OpenAI

# 4. Ejecutar en modo debug
flutter run

# 5. Compilar APK para producción
flutter build apk --release
```

---

## ⚙️ Configuración

### API Key de OpenAI

Para que la aplicación funcione, necesitas una API key de OpenAI:

1. Obtén tu API key en [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Crea el archivo `lib/config/api_config.dart` basándote en `api_config.dart.example`
3. Reemplaza `'TU_API_KEY_AQUI'` con tu clave real

```dart
class ApiConfig {
  static const String openAiApiKey = 'sk-proj-TU_CLAVE_AQUI';
  static const String openAiEndpoint = 'https://api.openai.com/v1/chat/completions';
  static const String model = 'gpt-3.5-turbo';
}
```

⚠️ **IMPORTANTE:** Nunca subas tu API key al repositorio. El archivo `api_config.dart` está en `.gitignore`.

---

## 🎮 Cómo Funciona

1. **Inicio del Juego**: Al entrar al módulo hijo, se selecciona aleatoriamente un escenario (grooming, sexting o ciberacoso)
2. **Chat Simulado**: Un "extraño" con nombre y avatar aleatorio inicia una conversación
3. **Trampa Educativa**: La IA intenta sutilmente obtener información sensible o contenido inapropiado
4. **Game Over**: Si el niño comparte información peligrosa, aparece una explicación educativa de por qué fue un error
5. **Reintentar**: El niño puede volver a jugar para aprender de sus errores

---

## Estructura del Proyecto

```
lib/
├── config/
│   └── api_config.dart.example    # Plantilla de configuración de API
├── core/
│   └── localization/               # Sistema de traducción (ES/EN)
│       ├── app_localizations.dart
│       ├── en.dart
│       └── es.dart
├── models/
│   └── chat_message.dart          # Modelo de mensajes
├── providers/
│   └── language_provider.dart      # Manejo de idiomas
├── screens/
│   ├── home_screen.dart           # Pantalla principal
│   └── chat_screen.dart           # Simulador de chat
├── services/
│   └── openai_service.dart        # Integración con OpenAI
└── main.dart
```

---

## 🛠️ Tecnologías Utilizadas

- **Flutter** (3.6.2): Framework multiplataforma
- **Provider**: Manejo de estado
- **OpenAI API (GPT-3.5)**: IA conversacional
- **SharedPreferences**: Almacenamiento local
- **Material Design 3**: UI/UX moderna

---

## 👥 Equipo Xori

Desarrollado para la **Hackathon 2025** por el equipo Xori.

---

## 📄 Licencia

Este proyecto es una demo educativa creada para fines de concurso.

---

## 🤝 Contribuir

Este es un proyecto de demostración. Si deseas contribuir o reportar issues, por favor abre un issue en GitHub.

---

## ⚠️ Advertencias

- **Uso de API de OpenAI**: Esta aplicación requiere conexión a internet y consume créditos de OpenAI
- **Solo educativo**: Este simulador está diseñado únicamente con fines educativos
- **Supervisión recomendada**: Se recomienda que los padres supervisen el uso de la aplicación
const Map<String, String> es = {
  'mi_nueva_clave': 'Mi Nuevo Texto',
  // ...
};
```

### Usar Traducciones en tus Widgets

```dart
final localizations = AppLocalizations.of(context);
Text(localizations.translate('mi_nueva_clave'))
```

### Cambiar Idioma Programáticamente

```dart
final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
languageProvider.setLocale(const Locale('es')); // Para español
languageProvider.setLocale(const Locale('en')); // Para inglés
```

## Ejecutar el Proyecto

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Compilar para producción
flutter build apk  # Android
flutter build ios  # iOS
```

## Idiomas Soportados

- 🇺🇸 Inglés (en)
- 🇪🇸 Español (es)

## Próximos Pasos

- Agregar más pantallas según las necesidades de tu aplicación
- Implementar navegación
- Agregar más idiomas si es necesario
- Personalizar el tema de la aplicación


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
