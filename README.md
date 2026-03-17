# 📌 Pinterest Clone

> Un clon funcional de Pinterest desarrollado con **Flutter** y **PostgreSQL**

![Flutter][flutter-badge] ![Dart][dart-badge] ![PostgreSQL][postgres-badge] ![License][license-badge]

[flutter-badge]: https://img.shields.io/badge/Flutter-blue?logo=flutter&logoColor=white
[dart-badge]: https://img.shields.io/badge/Dart-teal?logo=dart&logoColor=white
[postgres-badge]: https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql&logoColor=white
[license-badge]: https://img.shields.io/badge/License-MIT-green

## 🎯 Descripción

Este es un proyecto educativo que implementa un clon de Pinterest con toda la estructura necesaria:

- **Frontend**: Aplicación Flutter multiplataforma (iOS, Android, Web, etc.)
- **Backend**: API REST (plantilla lista para implementar)
- **Base de Datos**: Esquema PostgreSQL completo y funcional
- **Estado**: Estructura lista para agregar Provider/Riverpod

## 🚀 Características

### ✨ Implementadas
- ✅ 5 pantallas principales funcionales
- ✅ Modelos de datos completos (User, Pin, Board, Comment, Notification)
- ✅ Componentes reutilizables (PinCard, UserCard)
- ✅ Sistema de navegación con Bottom Navigation
- ✅ Esquema de BD PostgreSQL con triggers e índices
- ✅ Plantilla de API Service

### 🔜 Por Implementar
- ⬜ Backend API REST (Node.js, Django, o similar)
- ⬜ Autenticación JWT
- ⬜ State Management (Provider/Riverpod)
- ⬜ WebSocket para notificaciones en tiempo real
- ⬜ Caché de imágenes
- ⬜ Tests automatizados

## 📚 Documentación Incluida

| Documento | Descripción |
|-----------|-------------|
| **[`QUICK_START.md`](QUICK_START.md)** | 🚀 Inicio rápido para empezar inmediatamente |
| **[`PROJECT_DOCUMENTATION.md`](PROJECT_DOCUMENTATION.md)** | 📖 Documentación completa del proyecto |
| **[`DATABASE_SETUP.md`](DATABASE_SETUP.md)** | 🗄️ Guía paso a paso de configuración de BD |
| **[`DATABASE_ER_DIAGRAM.md`](DATABASE_ER_DIAGRAM.md)** | 📊 Diagrama Entidad-Relación visual |
| **[`FOLDER_STRUCTURE.md`](FOLDER_STRUCTURE.md)** | 📁 Explicación de estructura de carpetas |
| **[`API_USAGE_EXAMPLES.md`](API_USAGE_EXAMPLES.md)** | 💻 Ejemplos de uso de cada endpoint |

## 🔧 Configuración Rápida

### Requisitos
- Flutter SDK (`flutter --version`)
- PostgreSQL 12+ (`psql --version`)
- Git

### Base de Datos

```bash
# Crear BD
createdb pinterest_clone

# Crear esquema
psql -U postgres -d pinterest_clone -f database_schema.sql

# (Opcional) Cargar datos de prueba
psql -U postgres -d pinterest_clone -f sample_data.sql
```

### Aplicación

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en emulador/dispositivo
flutter run

# Ejecutar en web
flutter run -d web
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── constants/                   # Constantes globales
├── models/                      # Modelos de datos
│   ├── user_model.dart
│   ├── pin_model.dart
│   ├── board_model.dart
│   ├── comment_model.dart
│   ├── notification_model.dart
│   └── index.dart
├── screens/                     # Pantallas principales
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── profile_screen.dart
│   ├── pin_detail_screen.dart
│   ├── create_pin_screen.dart
│   └── index.dart
├── widgets/                     # Componentes reutilizables
│   ├── pin_card.dart
│   ├── user_card.dart
│   └── index.dart
├── services/                    # Servicios de API
│   └── api_service.dart
├── routes.dart                  # Rutas de navegación
└── utils/                       # Utilidades (en desarrollo)

database/
├── database_schema.sql          # Esquema completo de BD
├── sample_data.sql              # Datos de prueba
└── DATABASE_ER_DIAGRAM.md       # Diagrama visual
```

## 🎨 Pantallas

### 1. Home Screen
Página principal con:
- Grid infinito de pines
- Barra de búsqueda integrada
- Notificaciones
- Bottom navigation

### 2. Search Screen
- Búsqueda por pines y usuarios
- Historial de búsquedas
- Categorías populares
- Resultados en tiempo real

### 3. Profile Screen
- Información del usuario
- Estadísticas (pines, seguidores)
- Tableros
- Pines guardados

### 4. Pin Detail Screen
- Imagen grande del pin
- Like, guardar, comentar
- Perfil del creador
- Comentarios y respuestas

### 5. Create Pin Screen
- Subir imagen (galería o URL)
- Título y descripción
- Asignar a tablero
- Publicar

## 💾 Base de Datos

La BD incluye 9 tablas con relaciones:

```
users (1:N) → pins
        (1:N) → boards
        (1:N) → comments
        (1:N) → likes
        (1:N) → followers
        (1:N) → notifications
        (1:N) → search_history

boards (M:N) → pins (via pin_board)

comments (1:N) → comments (self-relationship)
```

**Características:**
- 🔑 UUIDs en todos los IDs
- ⏱️ Timestamps en entidades auditables
- 🔗 Integridad referencial con FK + CASCADE
- ⚡ Índices en columnas de búsqueda
- 🤖 Triggers automáticos para contadores y updates

[**Ver diagrama ER →**](DATABASE_ER_DIAGRAM.md)

## 🔌 API Service

El archivo `lib/services/api_service.dart` contiene plantillas para:

- 👤 Gestión de usuarios (login, registro, perfil)
- 📍 Operaciones con pines (crear, eliminar, buscar)
- 💬 Comentarios y respuestas
- ❤️ Likes y guardados
- 👥 Seguimiento de usuarios
- 📋 Gestión de tableros

[**Ver ejemplos de uso →**](API_USAGE_EXAMPLES.md)

## 🎯 Próximos Pasos

1. **Implementar Backend**
   ```
   Crear API REST conectada a PostgreSQL
   Usar Node.js, Django, Go, o similar
   ```

2. **Conectar Frontend**
   ```
   Reemplazar mocks en ApiService con llamadas reales
   Agregar manejo de errores y loading states
   ```

3. **Agregar State Management**
   ```
   flutter pub add provider
   # o
   flutter pub add riverpod
   ```

4. **Tests**
   ```
   flutter test
   ```

## 🛠️ Tecnologías

| Tecnología | Uso |
|-----------|-----|
| **Flutter** | Framework móvil multiplataforma |
| **Dart** | Lenguaje de programación |
| **PostgreSQL** | Base de datos relacional |
| **Material Design 3** | Diseño de interfaz |

## 📦 Dependencias (Recomendadas)

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0           # Para llamadas HTTP
  provider: ^6.0.0       # State management
  # o riverpod
  cached_network_image: ^3.3.0  # Caché de imágenes
  intl: ^0.19.0          # Internacionalización
  image_picker: ^1.0.0   # Seleccionar imágenes
```

## 🔐 Seguridad

⚠️ **Consideraciones importantes:**

- 🔒 Nunca commitear `.env.local` con credenciales
- 🔐 Hashear contraseñas en backend (bcrypt, argon2)
- 🔑 Usar HTTPS en todas las llamadas API
- ✅ Validar inputs en frontend y backend
- 🚫 Implementar rate limiting

## 📊 Estadísticas

| Métrica | Valor |
|---------|-------|
| Archivos creados | 18+ |
| Líneas de código | 2000+ |
| Tablas de BD | 9 |
| Pantallas | 5 |
| Modelos | 5 |
| Widgets | 2 |
| Documentación | 6 guías |

## 🧪 Testing

```bash
# Análisis de código
flutter analyze

# Formato automático
dart format .

# Tests (cuando estén implementados)
flutter test
```

## 📝 Licencia

MIT License - Libre para usar en proyectos personales y educativos

## 👤 Autor

Creado como proyecto educativo para el curso de Dispositivos Móviles

## 🙋 ¿Necesitas Ayuda?

1. **Inicio rápido**: Ve a [QUICK_START.md](QUICK_START.md)
2. **Documentación**: Revisa [PROJECT_DOCUMENTATION.md](PROJECT_DOCUMENTATION.md)
3. **BD**: Consulta [DATABASE_SETUP.md](DATABASE_SETUP.md)
4. **Ejemplos de API**: Mira [API_USAGE_EXAMPLES.md](API_USAGE_EXAMPLES.md)

---

**Made with ❤️ for learning Flutter and Mobile Development**

[⬆ Volver al inicio](#-pinterest-clone)
