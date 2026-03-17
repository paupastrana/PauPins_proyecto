# Pinterest Clone - Documentación del Proyecto

## Descripción General
Este es un clon de Pinterest desarrollado en Flutter para dispositivos móviles, con un backend basado en PostgreSQL y una API REST.

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── constants/
│   └── app_constants.dart   # Constantes del aplicación (colores, URLs, etc.)
├── models/
│   ├── user_model.dart      # Modelo de usuario
│   ├── pin_model.dart       # Modelo de pin/publicación
│   ├── board_model.dart     # Modelo de tablero
│   ├── comment_model.dart   # Modelo de comentario
│   └── notification_model.dart # Modelo de notificación
├── screens/
│   ├── home_screen.dart     # Pantalla de inicio
│   ├── search_screen.dart   # Pantalla de búsqueda
│   ├── profile_screen.dart  # Pantalla de perfil
│   ├── pin_detail_screen.dart # Detalle de un pin
│   └── create_pin_screen.dart # Crear un nuevo pin
├── widgets/
│   ├── pin_card.dart        # Widget para tarjeta de pin
│   └── user_card.dart       # Widget para tarjeta de usuario
├── services/
│   └── api_service.dart     # Servicio para comunicación con API
└── utils/                   # Funciones utilitarias (vacío por ahora)
```

## Pantallas Principales

### 1. Home Screen
- Muestra un grid de pines populares
- Barra de búsqueda integrada
- Notificaciones en la esquina superior
- Acceso a todas las funciones del app

### 2. Search Screen
- Búsqueda de pines y usuarios
- Historial de búsquedas
- Categorías populares
- Resultados filtrados

### 3. Profile Screen
- Información del perfil del usuario
- Estadísticas (pines, seguidores, seguiendo)
- Tableros del usuario
- Pines guardados

### 4. Pin Detail Screen
- Vista detallada de un pin
- Like, guardar y comentar
- Información del usuario que compartió el pin
- Comentarios y respuestas

### 5. Create Pin Screen
- Subir imagen desde galería o URL
- Añadir título y descripción
- Asignar a un tablero
- Publicar el pin

## Modelos de Datos

### User
```dart
- id: String (UUID)
- email: String
- username: String
- first_name: String?
- last_name: String?
- bio: String?
- profile_image_url: String?
- cover_image_url: String?
- is_verified: Boolean
- created_at: DateTime
- followers_count: int
- following_count: int
- pins_count: int
```

### Pin
```dart
- id: String (UUID)
- user_id: String
- title: String
- description: String?
- image_url: String
- source_url: String?
- dominant_color: String?
- image_width: int?
- image_height: int?
- is_saved: Boolean
- view_count: int
- like_count: int
- comment_count: int
- created_at: DateTime
- is_liked: Boolean
```

### Board
```dart
- id: String (UUID)
- user_id: String
- title: String
- description: String?
- cover_image_url: String?
- is_private: Boolean
- pin_count: int
- created_at: DateTime
```

## Configuración Inicial

### 1. Instalar dependencias
```bash
cd pinterestclone
flutter pub get
```

### 2. Configurar base de datos PostgreSQL
Ver `DATABASE_SETUP.md` para instrucciones detalladas

### 3. Ejecutar la aplicación
```bash
flutter run
```

## Dependencias Necesarias
Las siguientes dependencias se deben agregar a `pubspec.yaml`:
- `http` - Para llamadas HTTP a la API
- `provider` o `riverpod` - Para gestión de estado
- `image_picker` - Para seleccionar imágenes
- `intl` - Para formateo de fechas
- `cached_network_image` - Para caché de imágenes

## API REST Endpoints (por implementar)

### Usuarios
- `POST /api/auth/register` - Registrar usuario
- `POST /api/auth/login` - Login de usuario
- `GET /api/users/:id` - Obtener perfil de usuario
- `PUT /api/users/:id` - Actualizar perfil
- `POST /api/users/:id/follow` - Seguir usuario
- `DELETE /api/users/:id/follow` - Dejar de seguir

### Pines
- `GET /api/pins` - Obtener todos los pines
- `GET /api/pins/:id` - Detalle de pin
- `POST /api/pins` - Crear pin
- `PUT /api/pins/:id` - Actualizar pin
- `DELETE /api/pins/:id` - Eliminar pin
- `POST /api/pins/:id/like` - Like a pin
- `DELETE /api/pins/:id/like` - Quitar like
- `POST /api/pins/:id/save` - Guardar pin

### Búsqueda
- `GET /api/search?q=query` - Buscar pines
- `GET /api/search/users?q=query` - Buscar usuarios

### Comentarios
- `GET /api/pins/:id/comments` - Obtener comentarios
- `POST /api/pins/:id/comments` - Crear comentario
- `DELETE /api/comments/:id` - Eliminar comentario

### Tableros
- `GET /api/users/:id/boards` - Obtener tableros de usuario
- `POST /api/boards` - Crear tablero
- `POST /api/boards/:id/pins/:pin_id` - Agregar pin a tablero

## Próximas Características por Implementar

- [ ] Sistema de autenticación
- [ ] Gestión de estado con Provider/Riverpod
- [ ] Caché de imágenes
- [ ] Notificaciones en tiempo real (WebSocket)
- [ ] Filtros y categorías avanzadas
- [ ] Modo oscuro
- [ ] Compartir pines en redes sociales
- [ ] Chat entre usuarios
- [ ] Recomendaciones personalizadas

## Notas de Desarrollo

- El colores de la aplicación está basado en Pinterest (rojo #E60023)
- Se utiliza Material Design 3
- La aplicación soporta scroll infinito
- Las imágenes se cargan de forma asincrónica

## Autor
[Tu nombre]

## Licencia
MIT
