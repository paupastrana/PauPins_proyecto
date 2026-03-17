# 🎯 Inicio Rápido - Pinterest Clone

## 📋 Resumen del Proyecto

Este es un **clon funcional de Pinterest** desarrollado en **Flutter** con backend en **PostgreSQL**. El proyecto incluye:

- ✅ Estructura de carpetas organizada
- ✅ 5 pantallasprincipales funcionales
- ✅ Modelos de datos completos
- ✅ Esquema de BD PostgreSQL listo
- ✅ Widgets reutilizables
- ✅ Servicio API (estructura lista para implementar)

## 🚀 Primeros Pasos

### 1️⃣ Configurar Base de Datos PostgreSQL

```bash
# Crear la base de datos
psql -U postgres -c "CREATE DATABASE pinterest_clone;"

# Ejecutar el esquema
psql -U postgres -d pinterest_clone -f database_schema.sql

# (Opcional) Cargar datos de prueba
psql -U postgres -d pinterest_clone -f sample_data.sql
```

**Archivos relacionados:**
- `database_schema.sql` - Esquema completo
- `sample_data.sql` - Datos de prueba
- `DATABASE_SETUP.md` - Guía detallada

### 2️⃣ Configurar el Proyecto Flutter

```bash
# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

### 3️⃣ Configurar Variables de Entorno

```bash
# Copiar el archivo de ejemplo
cp .env.example .env.local

# Editar con tus valores
nano .env.local
```

## 📁 Estructura de Carpetas

```
lib/
├── main.dart                    # Punto de entrada
├── constants/app_constants.dart # Colores, URLs, etc
├── models/                      # User, Pin, Board, Comment, Notification
├── screens/                     # Home, Search, Profile, PinDetail, CreatePin
├── widgets/                     # PinCard, UserCard
├── services/api_service.dart    # Comunicación con API
├── routes.dart                  # Rutas de navegación
└── utils/                       # Funciones helpers
```

**Archivos índice (para importaciones):**
- `models/index.dart`
- `widgets/index.dart`
- `screens/index.dart`

## 🎨 Pantallas Disponibles

| Pantalla | Ruta | Descripción |
|----------|------|-------------|
| **Home** | `/` | Grid de pines, búsqueda rápida |
| **Search** | `/search` | Búsqueda avanzada, historial |
| **Create** | `/create` | Crear nuevo pin |
| **Saved** | `/saved` | Pines guardados |
| **Profile** | `/profile` | Perfil del usuario |
| **Pin Detail** | `/pin/:id` | Detalle, likes, comentarios |

## 🔌 Modelos de Datos

### User
```dart
- id, email, username, password_hash
- first_name, last_name, bio
- profile_image_url, cover_image_url
- is_verified, is_active
- followers_count, following_count, pins_count
```

### Pin
```dart
- id, user_id, title, description
- image_url, source_url, dominant_color
- image_width, image_height
- is_saved, view_count, like_count, comment_count
- user (relación con usuario)
- is_liked (booleano personal)
```

### Board
```dart
- id, user_id, title, description
- cover_image_url
- is_private, pin_count
```

### Comment
```dart
- id, user_id, pin_id
- content, parent_comment_id
- is_edited, user (relación)
```

### Notification
```dart
- id, user_id, triggered_by_user_id
- type (like, comment, follow, pin_saved)
- pin_id, comment_id, content
- is_read, triggered_by_user
```

## 🔗 API Service (Plantilla)

El archivo `lib/services/api_service.dart` contiene las firmas de todas las funciones necesarias:

```dart
// Usuarios
- registerUser()
- loginUser()
- getUserProfile()

// Pines
- getPins()
- getPinDetail()
- createPin()
- deletePin()

// Búsqueda
- searchPins()
- searchUsers()

// Interacciones
- likesPin() / unlikePin()
- savePin() / unsavePin()
- followUser() / unfollowUser()

// Comentarios
- getComments()
- createComment()
- deleteComment()

// Tableros
- getUserBoards()
- getBoardPins()
- createBoard()
- addPinToBoard()
```

## 📖 Documentación

| Archivo | Contenido |
|---------|-----------|
| `PROJECT_DOCUMENTATION.md` | Documentación completa del proyecto |
| `DATABASE_SETUP.md` | Guía de configuración de BD |
| `FOLDER_STRUCTURE.md` | Explicación detallada de carpetas |
| `API_USAGE_EXAMPLES.md` | Ejemplos de uso de cada endpoint |
| `.env.example` | Variables de entorno necesarias |

## 🛠️ Próximos Pasos Recomendados

### Backend (API REST)
1. [ ] Crear servidor con Node.js/Express o Django
2. [ ] Implementar autenticación JWT
3. [ ] Conectar a PostgreSQL
4. [ ] Crear endpoints según especificaciones

### Frontend (Flutter)
1. [ ] Instalar `http` package para llamadas API
2. [ ] Implementar `ApiService` con llamadas reales
3. [ ] Agregar `Provider` o `Riverpod` para state management
4. [ ] Implementar login/register
5. [ ] Conectar pantallas con datos reales

### Optimizaciones
1. [ ] Caché de imágenes con `cached_network_image`
2. [ ] Incrementar el scroll usando pagination
3. [ ] Agregar animaciones suaves
4. [ ] Implementar notificaciones en tiempo real
5. [ ] Agregar tests unitarios e integración

## 🎨 Temas y Colores

```dart
- Primary Color: #E60023 (Rojo Pinterest)
- Accent Color: #1E1E1E (Gris oscuro)
- Background: #FFFBFA (Blanco cálido)
```

## 📱 Plataformas Soportadas

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔐 Seguridad

⚠️ **IMPORTANTE:**
- Nunca commitear `.env.local` con credenciales
- Usar HTTPS para todas las llamadas API
- Validar inputs en frontend y backend
- Hashear contraseñas (bcrypt, argon2)
- Implementar rate limiting en API

## 📞 URLs Útiles

- Documentación Flutter: https://flutter.dev
- PostgreSQL Docs: https://www.postgresql.org/docs/
- Dart Language: https://dart.dev

## 💡 Consejos

1. **Tests frecuentes**: Ejecuta `flutter run` después de cambios
2. **Hot Reload**: Usa `r` para recargar cambios rápidamente
3. **Análisis**: Revisa advertencias con `flutter analyze`
4. **Formato**: Ejecuta `dart format .` regularmente
5. **Git**: Commits frecuentes y descriptivos

## 🎓 Aprendizaje

Este proyecto cubre:
- ✅ Arquitectura de apps móviles
- ✅ Modelos de datos y serialización
- ✅ Diseño responsivo
- ✅ Integración con APIs REST
- ✅ Gestión de base de datos
- ✅ UX/UI principles

## 📄 Licencia

MIT - Libre para usar en proyectos personales o educativos

---

**¿Necesitas ayuda?** Revisa los archivos de documentación o los ejemplos en `API_USAGE_EXAMPLES.md`

¡**Happy Coding! 🚀**
