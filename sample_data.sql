-- Datos de prueba para PostgreSQL
-- Ejecutar este script después de crear el esquema

-- Insertar usuarios de prueba
INSERT INTO users (id, email, username, password_hash, first_name, last_name, bio, is_verified, is_active)
VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'juan@example.com', 'juan_dev', '$2a$10$...', 'Juan', 'Pérez', 'Desarrollador apasionado por el diseño', true, true),
  ('550e8400-e29b-41d4-a716-446655440002', 'maria@example.com', 'maria_design', '$2a$10$...', 'María', 'García', 'Diseñadora gráfica y fotógrafa', true, true),
  ('550e8400-e29b-41d4-a716-446655440003', 'carlos@example.com', 'carlos_viajes', '$2a$10$...', 'Carlos', 'López', 'Viajero y bloguero de viajes', false, true),
  ('550e8400-e29b-41d4-a716-446655440004', 'sofia@example.com', 'sofia_cook', '$2a$10$...', 'Sofía', 'Martínez', 'Chef y amante de la cocina', true, true),
  ('550e8400-e29b-41d4-a716-446655440005', 'admin@example.com', 'admin', '$2a$10$...', 'Admin', 'User', 'Contador del sitio', true, true);

-- Insertar pines de prueba
INSERT INTO pins (id, user_id, title, description, image_url, dominant_color, view_count)
VALUES
  ('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Interfaz de usuario moderna', 'Diseño limpio y moderno para aplicación móvil', 'https://picsum.photos/400/500?random=1', '#3498db', 234),
  ('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'Fotografía de montaña', 'Hermosa vista de las montañas al atardecer', 'https://picsum.photos/400/500?random=2', '#e67e22', 512),
  ('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'Viaje a París', 'Mi viaje a la ciudad del amor', 'https://picsum.photos/400/500?random=3', '#2c3e50', 789),
  ('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', 'Receta de Tiramisú', 'Delicioso postre italiano paso a paso', 'https://picsum.photos/400/500?random=4', '#d4af37', 345),
  ('660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'Código limpio', 'Mejores prácticas en programación', 'https://picsum.photos/400/500?random=5', '#2c3e50', 456);

-- Insertar tableros de prueba
INSERT INTO boards (id, user_id, title, description, is_private)
VALUES
  ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Mi Proyecto', 'Diseños para mi proyecto personal', false),
  ('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Inspiración', 'Diseños que me inspiran', false),
  ('770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Fotografía', 'Mis mejores fotografías', false),
  ('770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', 'Recetas favoritas', 'Mis recetas favoritas de alrededor del mundo', false),
  ('770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Destinos para visitar', 'Lugares que quiero visitar', true);

-- Insertar pin_board (relación entre pines y tableros)
INSERT INTO pin_board (id, pin_id, board_id, position)
VALUES
  ('880e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 1),
  ('880e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440002', 1),
  ('880e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440003', 1),
  ('880e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440004', 1),
  ('880e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440005', 1);

-- Insertar likes
INSERT INTO likes (id, user_id, pin_id)
VALUES
  ('990e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001'),
  ('990e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001'),
  ('990e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002'),
  ('990e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002'),
  ('990e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440004');

-- Insertar seguidores
INSERT INTO followers (id, follower_id, following_id)
VALUES
  ('aa0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002'),
  ('aa0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003'),
  ('aa0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001'),
  ('aa0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001'),
  ('aa0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001');

-- Insertar comentarios
INSERT INTO comments (id, user_id, pin_id, content)
VALUES
  ('bb0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '¡Excelente diseño! Me encanta el minimalismo'),
  ('bb0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'Que bonito trabajo, se nota el esfuerzo'),
  ('bb0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002', 'Hermosa fotografía, ¿dónde fue tomada?'),
  ('bb0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', 'Esto sí es arte'),
  ('bb0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440004', 'Me encanta esta receta, voy a intentarla');

-- Insertar notificaciones
INSERT INTO notifications (id, user_id, triggered_by_user_id, type, pin_id, content)
VALUES
  ('cc0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'like', '660e8400-e29b-41d4-a716-446655440001', 'Le gustó tu pin'),
  ('cc0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', 'follow', NULL, 'Te comenzó a seguir'),
  ('cc0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'comment', '660e8400-e29b-41d4-a716-446655440001', 'Comentó en tu pin'),
  ('cc0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'pin_saved', '660e8400-e29b-41d4-a716-446655440004', 'Guardó tu pin'),
  ('cc0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'like', '660e8400-e29b-41d4-a716-446655440002', 'Le gustó tu pin');

-- Actualizar pin_board para reflejar el pin_count
UPDATE boards SET pin_count = 
  (SELECT COUNT(*) FROM pin_board WHERE pin_board.board_id = boards.id);

-- Consultas útiles después de insertar datos:
-- SELECT COUNT(*) FROM users;
-- SELECT COUNT(*) FROM pins;
-- SELECT COUNT(*) FROM likes;
-- SELECT COUNT(*) FROM followers;
