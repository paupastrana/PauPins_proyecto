# Pinterest Clone - Resumen de Carpetas

## Estructura del Proyecto

```
pinterestclone/
│
├── android/                    # Configuración específica para Android
├── ios/                        # Configuración específica para iOS
├── linux/                      # Configuración para Linux
├── macos/                      # Configuración para macOS
├── web/                        # Configuración para Web
├── windows/                    # Configuración para Windows
│
├── lib/                        # CÓDIGO PRINCIPAL DE LA APP
│   ├── main.dart              # Punto de entrada - Configuración general del app
│   │
│   ├── constants/             # Constantes de la aplicación
│   │   └── app_constants.dart # Colores, URLs base, claves API, etc.
│   │
│   ├── models/                # Modelos de datos (clases de entidades)
│   │   ├── user_model.dart       # Usuario
│   │   ├── pin_model.dart        # Pin/Publicación
│   │   ├── board_model.dart      # Tablero
│   │   ├── comment_model.dart    # Comentario
│   │   └── notification_model.dart # Notificación
│   │
│   ├── screens/               # Pantallas principales
│   │   ├── home_screen.dart        # Pantalla de inicio con grid de pines
│   │   ├── search_screen.dart      # Pantalla de búsqueda
│   │   ├── profile_screen.dart     # Perfil del usuario
│   │   ├── pin_detail_screen.dart  # Detalle de un pin
│   │   └── create_pin_screen.dart  # Crear/compartir un pin
│   │
│   ├── widgets/               # Componentes reutilizables
│   │   ├── pin_card.dart      # Tarjeta de pin (con imagen, título, usuario)
│   │   └── user_card.dart     # Tarjeta de usuario
│   │
│   ├── services/              # Servicios de lógica de negocio
│   │   └── api_service.dart   # Comunicación con servidor/API REST
│   │
│   └── utils/                 # Funciones utilitarias
│       # (formatos, validadores, helpers, etc.)
│
├── test/                       # Tests unitarios
│   └── widget_test.dart
│
├── pubspec.yaml               # Dependencias del proyecto
├── pubspec.lock               # Lock file de dependencias
│
├── analysis_options.yaml      # Configuración de análisis Dart/Flutter
├── .gitignore                 # Archivos a ignorar en Git
├── .env.example               # Ejemplo de variables de entorno
│
├── database_schema.sql        # 📊 ESQUEMA DE BASE DE DATOS POSTGRESQL
├── sample_data.sql            # Datos de prueba para la BD
│
├── DATABASE_SETUP.md          # 📖 Guía de configuración de BD
└── PROJECT_DOCUMENTATION.md   # 📖 Documentación completa del proyecto
```

## Descripción por Carpeta

### `/lib/constants`
Almacena valores constantes reutilizados en toda la app:
- Colores (rojo Pinterest #E60023)
- URLs del backend
- Claves de API
- Tamaños, márgenes, etc.

### `/lib/models`
Define las estructuras de datos que se usan en toda la app:
- Cada modelo tiene métodos `fromJson()` y `toJson()` para serialización
- Modelos inmutables con `copyWith()` para state management

### `/lib/screens`
Pantallas principales (páginas) de la aplicación:
- Contienen Widgets complejos y lógica de UI
- Se acceden a través del BottomNavigationBar

### `/lib/widgets`
Componentes reutilizables en múltiples pantallas:
- `PinCard` - Componente visual para mostrar un pin
- `UserCard` - Componente visual para mostrar usuario
- Otros componentes comunes del UI

### `/lib/services`
Lógica de negocio y comunicación:
- `ApiService` - Línea de comunicación con el backend
- Gestión de datos remotos
- Cachés y transformaciones de datos

## Flujo de Datos

```
main.dart (App)
    ↓
MainApp (StatefulWidget con navigation)
    ↓
Screens (home, search, profile, etc.)
    ↓
Widgets (pin_card, user_card, etc.)
    ↓
Models (estructuras de datos)
    ↓
Services (API calls)
    ↓
Backend API (PostgreSQL)
```

## Próximos Pasos

1. ✅ Crear estructura de carpetas
2. ✅ Definir modelos de datos
3. ✅ Crear pantallas básicas
4. ✅ Definir esquema de BD
5. ⬜ Implementar API REST en backend
6. ⬜ Conectar app con API
7. ⬜ Implementar autenticación
8. ⬜ Agregar state management (Provider/Riverpod)
9. ⬜ Optimizar con caché de imágenes
10. ⬜ Tests unitarios e integración

## Notas Importantes

- Todas las rutas deben estar documentadas en el futuro en `routes.dart`
- Implementar state management antes de conectar con API
- Validar inputs del usuario en el frontend
- Nunca commitear `.env.local` con credenciales
- Usar tipos UUID para todos los IDs en BD
