# Guía de Configuración de la Base de Datos

## Requisitos Previos
- PostgreSQL 12 o superior instalado
- Cliente SQL (pgAdmin, DBeaver, o línea de comandos psql)

## Pasos de Instalación

### 1. Crear la Base de Datos
```sql
CREATE DATABASE pinterest_clone;
```

### 2. Conectar a la Base de Datos
```bash
psql -U postgres -d pinterest_clone
```

### 3. Ejecutar el Esquema
Desde el archivo `database_schema.sql`:

```bash
psql -U postgres -d pinterest_clone -f database_schema.sql
```

O copiar y pegar el contenido del archivo en tu cliente SQL.

## Descripción del Esquema

### Tablas Principales

#### `users`
- Almacena información de usuarios
- Campos: id, email, username, password_hash, first_name, last_name, bio, profile_image_url, cover_image_url, is_verified, is_active, created_at, updated_at, last_login

#### `pins`
- Almacena los pines/publicaciones
- Campos: id, user_id, title, description, image_url, source_url, dominant_color, image_width, image_height, is_saved, view_count, created_at, updated_at

#### `boards`
- Almacena los tableros de usuarios
- Campos: id, user_id, title, description, cover_image_url, is_private, pin_count, created_at, updated_at

#### `pin_board`
- Relación many-to-many entre pines y tableros
- Campos: id, pin_id, board_id, position, created_at

#### `likes`
- Almacena los likes en los pines
- Campos: id, user_id, pin_id, created_at

#### `comments`
- Almacena los comentarios en los pines
- Campos: id, user_id, pin_id, content, parent_comment_id, is_edited, created_at, updated_at

#### `followers`
- Almacena las relaciones de seguimiento entre usuarios
- Campos: id, follower_id, following_id, created_at

#### `notifications`
- Almacena las notificaciones de usuarios
- Campos: id, user_id, triggered_by_user_id, type, pin_id, comment_id, content, is_read, created_at

#### `search_history`
- Almacena el historial de búsquedas de los usuarios
- Campos: id, user_id, query, created_at

## Características del Esquema

### Índices
Se han creado índices en:
- `pins.user_id`
- `pins.created_at`
- `boards.user_id`
- `likes.user_id`
- `likes.pin_id`
- `comments.pin_id`
- `comments.user_id`
- `followers.follower_id`
- `followers.following_id`
- `notifications.user_id`
- `notifications.is_read`
- `search_history.user_id`
- `users.username`
- `users.email`

### Triggers
Se han implementado triggers para:
- Actualizar automáticamente `updated_at` en usuarios, pines, tableros y comentarios
- Incrementar/decrementar el contador de pines en los tableros

## Consultas Útiles

### Obtener todos los pines de un usuario
```sql
SELECT p.* FROM pins p WHERE p.user_id = 'USER_ID' ORDER BY p.created_at DESC;
```

### Obtener los pines más populares
```sql
SELECT p.* FROM pins p ORDER BY p.view_count DESC LIMIT 10;
```

### Obtener los seguidores de un usuario
```sql
SELECT u.* FROM users u
INNER JOIN followers f ON u.id = f.follower_id
WHERE f.following_id = 'USER_ID';
```

### Obtener los tableros de un usuario
```sql
SELECT b.* FROM boards b WHERE b.user_id = 'USER_ID' ORDER BY b.created_at DESC;
```

## Notas de Seguridad

- Las contraseñas se almacenan como `password_hash` - nunca almacenar en texto plano
- Se recomienda usar bcrypt o argon2 para el hash de contraseñas
- Implementar validaciones de datos en la aplicación backend
- Usar prepared statements para prevenir SQL injection

## Mantenimiento

### Limpiar búsquedas antiguas (más de 30 días)
```sql
DELETE FROM search_history WHERE created_at < NOW() - INTERVAL '30 days';
```

### Actualizar tabla de estadísticas
```sql
UPDATE pins SET view_count = view_count + 1 WHERE id = 'PIN_ID';
```
