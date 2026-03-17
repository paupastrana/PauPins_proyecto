# Ejemplos de Uso de API

## Inicialización

```dart
import 'services/api_service.dart';
import 'constants/app_constants.dart';

final apiService = ApiService(baseUrl: AppConstants.baseUrl);
```

## Autenticación

### Registro de Usuario
```dart
Future<void> registerUser() async {
  try {
    final response = await apiService.registerUser(
      email: 'usuario@example.com',
      username: 'mi_usuario',
      password: 'MiContraseña123',
    );
    print('Usuario registrado: ${response['id']}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Login
```dart
Future<void> loginUser() async {
  try {
    final response = await apiService.loginUser(
      email: 'usuario@example.com',
      password: 'MiContraseña123',
    );
    print('Token: ${response['token']}');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Usuarios

### Obtener Perfil
```dart
Future<void> getUserProfile(String userId) async {
  try {
    final user = await apiService.getUserProfile(userId);
    print('Usuario: ${user.username}');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Pines

### Obtener Pines (Modo Infinito)
```dart
Future<void> getPins() async {
  try {
    List<Pin> pins = [];
    int page = 1;
    
    // Cargar pines página por página
    final newPins = await apiService.getPins(page: page, limit: 20);
    pins.addAll(newPins);
    
    // En un widget real, actualizar el estado
    // setState(() {
    //   this.pins = pins;
    // });
    
    print('Se cargaron ${pins.length} pines');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Detalle de Pin
```dart
Future<void> getPinDetail(String pinId) async {
  try {
    final pin = await apiService.getPinDetail(pinId);
    print('Pin: ${pin.title}');
    print('Likes: ${pin.likeCount}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Crear Pin
```dart
Future<void> createPin() async {
  try {
    final newPin = await apiService.createPin(
      title: 'Mi Primer Pin',
      description: 'Este es mi primer pin en Pinterest Clone',
      imageUrl: 'https://example.com/image.jpg',
      sourceUrl: 'https://example.com',
      boardId: 'board-id-here',
    );
    print('Pin creado: ${newPin.id}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Eliminar Pin
```dart
Future<void> deletePin(String pinId) async {
  try {
    await apiService.deletePin(pinId);
    print('Pin eliminado');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Búsqueda

### Buscar Pines
```dart
Future<void> searchPins(String query) async {
  try {
    final results = await apiService.searchPins(query, page: 1);
    print('Se encontraron ${results.length} pines');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Buscar Usuarios
```dart
Future<void> searchUsers(String query) async {
  try {
    final results = await apiService.searchUsers(query);
    print('Se encontraron ${results.length} usuarios');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Interacciones

### Like Pin
```dart
Future<void> likePin(String pinId) async {
  try {
    await apiService.likesPin(pinId);
    print('Pin con Like');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Quitar Like
```dart
Future<void> unlikePin(String pinId) async {
  try {
    await apiService.unlikePin(pinId);
    print('Like removido');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Guardar Pin
```dart
Future<void> savePin(String pinId) async {
  try {
    await apiService.savePin(pinId);
    print('Pin guardado');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Quitar Guardado
```dart
Future<void> unsavePin(String pinId) async {
  try {
    await apiService.unsavePin(pinId);
    print('Pin no guardado');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Seguidores

### Seguir Usuario
```dart
Future<void> followUser(String userId) async {
  try {
    await apiService.followUser(userId);
    print('Ahora sigues a este usuario');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Dejar de Seguir
```dart
Future<void> unfollowUser(String userId) async {
  try {
    await apiService.unfollowUser(userId);
    print('Dejaste de seguir al usuario');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Comentarios

### Obtener Comentarios
```dart
Future<void> getComments(String pinId) async {
  try {
    final comments = await apiService.getComments(pinId, page: 1);
    print('Se encontraron ${comments.length} comentarios');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Crear Comentario
```dart
Future<void> createComment(String pinId, String content) async {
  try {
    final comment = await apiService.createComment(
      pinId: pinId,
      content: content,
      parentCommentId: null, // null si es comentario principal
    );
    print('Comentario creado: ${comment.id}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Eliminar Comentario
```dart
Future<void> deleteComment(String commentId) async {
  try {
    await apiService.deleteComment(commentId);
    print('Comentario eliminado');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Tableros

### Obtener Tableros de Usuario
```dart
Future<void> getUserBoards(String userId) async {
  try {
    final boards = await apiService.getUserBoards(userId);
    print('Se encontraron ${boards.length} tableros');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Crear Tablero
```dart
Future<void> createBoard() async {
  try {
    final board = await apiService.createBoard(
      title: 'Mi Nuevo Tablero',
      description: 'Tablero para mis inspiraciones',
      isPrivate: false,
    );
    print('Tablero creado: ${board.id}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Obtener Pines de Tablero
```dart
Future<void> getBoardPins(String boardId) async {
  try {
    final pins = await apiService.getBoardPins(boardId);
    print('Se encontraron ${pins.length} pines en el tablero');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Añadir Pin a Tablero
```dart
Future<void> addPinToBoard(String pinId, String boardId) async {
  try {
    await apiService.addPinToBoard(
      pinId: pinId,
      boardId: boardId,
    );
    print('Pin añadido al tablero');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Manejo de Errores

```dart
try {
  final pins = await apiService.getPins();
} catch (e) {
  if (e.toString().contains('401')) {
    // No autorizado - redirigir a login
    print('Sesión expirada, por favor inicia sesión nuevamente');
  } else if (e.toString().contains('404')) {
    // No encontrado
    print('El recurso no fue encontrado');
  } else if (e.toString().contains('500')) {
    // Error del servidor
    print('Error en el servidor, intenta más tarde');
  } else {
    // Otro error
    print('Error desconocido: $e');
  }
}
```

## State Management (Ejemplo con Provider)

```dart
// En un futuro se implementará con Provider o Riverpod

// providers.dart
final pinsProvider = FutureProvider<List<Pin>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPins();
});

// En tu widget
// final pins = await ref.watch(pinsProvider);
```
