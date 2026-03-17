
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";


CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) NOT NULL UNIQUE,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  bio TEXT,
  profile_image_url VARCHAR(500),
  cover_image_url VARCHAR(500),
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP
);


CREATE TABLE pins (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  image_url VARCHAR(500) NOT NULL,
  source_url VARCHAR(500),
  dominant_color VARCHAR(7),
  image_width INTEGER,
  image_height INTEGER,
  is_saved BOOLEAN DEFAULT FALSE,
  view_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE boards (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  cover_image_url VARCHAR(500),
  is_private BOOLEAN DEFAULT FALSE,
  pin_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE pin_board (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pin_id UUID NOT NULL REFERENCES pins(id) ON DELETE CASCADE,
  board_id UUID NOT NULL REFERENCES boards(id) ON DELETE CASCADE,
  position INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(pin_id, board_id)
);


CREATE TABLE likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pin_id UUID NOT NULL REFERENCES pins(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, pin_id)
);

-- ==================== TABLA COMMENTS ====================
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pin_id UUID NOT NULL REFERENCES pins(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  is_edited BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==================== TABLA FOLLOWERS ====================
CREATE TABLE followers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);

-- ==================== TABLA NOTIFICATIONS ====================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  triggered_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  type VARCHAR(50) NOT NULL, -- 'like', 'comment', 'follow', 'pin_saved'
  pin_id UUID REFERENCES pins(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==================== TABLA SEARCH_HISTORY ====================
CREATE TABLE search_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  query VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==================== ÍNDICES ====================
CREATE INDEX idx_pins_user_id ON pins(user_id);
CREATE INDEX idx_pins_created_at ON pins(created_at DESC);
CREATE INDEX idx_boards_user_id ON boards(user_id);
CREATE INDEX idx_likes_user_id ON likes(user_id);
CREATE INDEX idx_likes_pin_id ON likes(pin_id);
CREATE INDEX idx_comments_pin_id ON comments(pin_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_followers_follower_id ON followers(follower_id);
CREATE INDEX idx_followers_following_id ON followers(following_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_search_history_user_id ON search_history(user_id);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- ==================== TRIGGERS ====================
-- Actualizar updated_at en users
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at_trigger
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_users_updated_at();

-- Actualizar updated_at en pins
CREATE OR REPLACE FUNCTION update_pins_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pins_updated_at_trigger
BEFORE UPDATE ON pins
FOR EACH ROW
EXECUTE FUNCTION update_pins_updated_at();

-- Actualizar updated_at en boards
CREATE OR REPLACE FUNCTION update_boards_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER boards_updated_at_trigger
BEFORE UPDATE ON boards
FOR EACH ROW
EXECUTE FUNCTION update_boards_updated_at();

-- Actualizar updated_at en comments
CREATE OR REPLACE FUNCTION update_comments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER comments_updated_at_trigger
BEFORE UPDATE ON comments
FOR EACH ROW
EXECUTE FUNCTION update_comments_updated_at();

-- Incrementar board pin_count cuando se añade un pin
CREATE OR REPLACE FUNCTION increment_board_pin_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE boards SET pin_count = pin_count + 1 WHERE id = NEW.board_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pin_board_insert_trigger
AFTER INSERT ON pin_board
FOR EACH ROW
EXECUTE FUNCTION increment_board_pin_count();

-- Decrementar board pin_count cuando se elimina un pin
CREATE OR REPLACE FUNCTION decrement_board_pin_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE boards SET pin_count = pin_count - 1 WHERE id = OLD.board_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pin_board_delete_trigger
AFTER DELETE ON pin_board
FOR EACH ROW
EXECUTE FUNCTION decrement_board_pin_count();
