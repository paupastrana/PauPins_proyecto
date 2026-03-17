# Diagrama ER - Esquema de Base de Datos

## Relaciones de Tablas

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Modelo Entidad-Relación                     │
└─────────────────────────────────────────────────────────────────────┘

                            ┌──────────────┐
                            │    users     │
                            ├──────────────┤
                            │ id (PK)      │
                            │ email        │◄──┐
                            │ username     │   │
                            │ password_...│   │
                            │ first_name  │   │
                            │ last_name   │   │
                            │ bio         │   │
                            │ profile_...│   │
                            │ created_at  │   │
                            └──────────────┘   │
                                  ▲            │
                                  │            │
                        ┌─────────┴────────────┼────────────┐
                        │                      │            │
                        │                      │            │
              ┌─────────────────┐    ┌────────────────┐    │
              │  followers      │    │     pins       │    │
              ├─────────────────┤    ├────────────────┤    │
              │ id (PK)         │    │ id (PK)        │    │
              │ follower_id ▲───┼────┤ user_id ◄─────┼────┘
              │ following_id│   │    │ title          │
              │             │   │    │ description    │
              │             │   │    │ image_url      │
              │             └───┼────┤ source_url     │
              │                 │    │ view_count     │
              │              ┌──┴────┤ created_at     │
              │              │  │    └────────────────┘
              └──────────────┼──┘           │
                             │              │
                          ┌──┴──────────────┼─────────────┐
                          │                 │             │
                       ┌──────────┐    ┌──────────────┐  ┌──────────────┐
                       │ likes    │    │ comments     │  │ pin_board    │
                       ├──────────┤    ├──────────────┤  ├──────────────┤
                       │ id (PK)  │    │ id (PK)      │  │ id (PK)      │
                       │ user_id ◄┼────┤ user_id ◄────┼──┤ pin_id ◄─────┤
                       │ pin_id ◄─┼────┤ pin_id ◄────┐│  │ board_id ◄──┐
                       └──────────┘    │ content      ││  └──────────────┘
                                       │ parent_...   ││        │
                                       │ is_edited    ││        │
                                       │ created_at   ││        │
                                       └──────────────┘│        │
                                                       │        │
                                              ┌────────────┐   │
                                              │   boards   │   │
                                              ├────────────┤   │
                                              │ id (PK)    │   │
                                              │ user_id ◄──┼───┤
                                              │ title      │   │
                                              │ is_private │◄──┘
                                              │ pin_count  │
                                              │ created_at │
                                              └────────────┘


                              ┌─────────────────────┐
                              │  notifications      │
                              ├─────────────────────┤
                              │ id (PK)             │
                              │ user_id ◄───────────┼──┐
                              │ triggered_by_user_id│  │
                              │ type                │  │
                              │ pin_id              │  │
                              │ comment_id          │  │
                              │ is_read             │  │
                              └─────────────────────┘  │
                                                       └──► users

                              ┌──────────────────┐
                              │ search_history   │
                              ├──────────────────┤
                              │ id (PK)          │
                              │ user_id ◄────────┼──► users
                              │ query            │
                              │ created_at       │
                              └──────────────────┘
```

## Relaciones Principales

### 1:N (One to Many)
- **users → pins**: Un usuario puede crear muchos pines (1:N)
- **users → boards**: Un usuario puede crear muchos tableros (1:N)
- **pins → likes**: Un pin puede tener muchos likes (1:N)
- **pins → comments**: Un pin puede tener muchos comentarios (1:N)
- **pins → notifications**: Un pin puede generar muchas notificaciones (1:N)
- **users → followers**: Un usuario puede tener muchos seguidores (1:N)
- **users → search_history**: Un usuario puede tener muchas búsquedas (1:N)

### M:N (Many to Many)
- **pins ↔ boards**: Muchos pines pueden estar en muchos tableros (M:N)
  - Tabla intermedia: `pin_board`

### Self-Relationship
- **comments → comments**: Comentarios pueden responder a otros comentarios
  - Campo: `parent_comment_id`

### Hierarchical
- **followers**: Relación jerárquica entre usuarios
  - follower_id → usuario que sigue
  - following_id → usuario que es seguido

## Restricciones de Integridad

```
users (id) ◄─────── pins.user_id (FK)
          ◄─────── boards.user_id (FK)
          ◄─────── comments.user_id (FK)
          ◄─────── likes.user_id (FK)
          ◄─────── followers.follower_id (FK)
          ◄─────── followers.following_id (FK)
          ◄─────── notifications.user_id (FK)
          ◄─────── notifications.triggered_by_user_id (FK)
          ◄─────── search_history.user_id (FK)

pins (id) ◄──────── likes.pin_id (FK)
         ◄──────── comments.pin_id (FK)
         ◄──────── pin_board.pin_id (FK)
         ◄──────── notifications.pin_id (FK)

boards (id) ◄────── pin_board.board_id (FK)

comments (id) ◄──── comments.parent_comment_id (FK)
              ◄──── notifications.comment_id (FK)
```

## Triggers Automáticos

### 1. Actualizar `updated_at`
- Se ejecuta en: `users`, `pins`, `boards`, `comments`
- Acción: Establecer automáticamente `updated_at = CURRENT_TIMESTAMP`

### 2. Incrementar Contador de Pines
- Se ejecuta en: `pin_board` (INSERT)
- Acción: `boards.pin_count += 1`

### 3. Decrementar Contador de Pines
- Se ejecuta en: `pin_board` (DELETE)
- Acción: `boards.pin_count -= 1`

## Índices para Optimización

```
PRIMARY KEYS:
  users.id
  pins.id
  boards.id
  comments.id
  likes.id
  followers.id
  notifications.id
  search_history.id
  pin_board.id

FOREIGN KEYS (Índices automáticos):
  pins.user_id
  boards.user_id
  comments.user_id
  comments.pin_id
  comments.parent_comment_id
  likes.user_id
  likes.pin_id
  followers.follower_id
  followers.following_id
  notifications.user_id
  notifications.triggered_by_user_id
  notifications.pin_id
  notifications.comment_id
  pin_board.pin_id
  pin_board.board_id
  search_history.user_id

BÚSQUEDA:
  users.email
  users.username
```

## Cardinalidad

### Tabla `pins`
- 1 usuario → N pines ✅
- 1 pin → N likes ✅
- 1 pin → N comentarios ✅
- N pines → N tableros ✅

### Tabla `boards`
- 1 usuario → N tableros ✅
- 1 tablero → N pines ✅

### Tabla `followers`
- 1 usuario → N usuarios que lo siguen ✅
- 1 usuario → N usuarios que sigue ✅
- Relación simétrica solo una dirección

### Tabla `comments`
- 1 usuario → N comentarios ✅
- 1 pin → N comentarios ✅
- 1 comentario → N respuestas (comentarios hijos) ✅

## Consideraciones de Diseño

1. **UUIDs**: Todos los IDs son UUIDs para privacidad
2. **Timestamps**: Cada tabla auditable tiene `created_at` y `updated_at`
3. **Blandas**: Los datos nunca se eliminan, se marcan como inactivos
4. **Índices**: Se crearon en columnas de búsqueda frecuente
5. **Triggers**: Automatización de operaciones comunes

## Ejemplo de Querys Comunes

### Obtener todos los pines de un usuario
```sql
SELECT * FROM pins WHERE user_id = 'user-uuid' ORDER BY created_at DESC;
```

### Obtener pines que un usuario ha guardado
```sql
SELECT p.* FROM pins p
INNER JOIN pin_board pb ON p.id = pb.pin_id
INNER JOIN boards b ON pb.board_id = b.id
WHERE b.user_id = 'user-uuid' ORDER BY pb.created_at DESC;
```

### Obtener seguidores de un usuario
```sql
SELECT u.* FROM users u
INNER JOIN followers f ON u.id = f.follower_id
WHERE f.following_id = 'user-uuid';
```

### Obtener pines más populares
```sql
SELECT * FROM pins ORDER BY view_count DESC LIMIT 10;
```

### Obtener comentarios con replies
```sql
SELECT * FROM comments 
WHERE pin_id = 'pin-uuid' AND parent_comment_id IS NULL
ORDER BY created_at DESC;
```
