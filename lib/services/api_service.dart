// API service para interactuar con el backend
// TODO: Reemplazar con implementación real

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Usuarios
  Future<dynamic> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    // TODO: Implementar
  }

  Future<dynamic> loginUser({
    required String email,
    required String password,
  }) async {
    // TODO: Implementar
  }

  Future<dynamic> getUserProfile(String userId) async {
    // TODO: Implementar
  }

  // Pines
  Future<dynamic> getPins({int page = 1, int limit = 20}) async {
    // TODO: Implementar
  }

  Future<dynamic> getPinDetail(String pinId) async {
    // TODO: Implementar
  }

  Future<dynamic> createPin({
    required String title,
    String? description,
    required String imageUrl,
    String? sourceUrl,
    String? boardId,
  }) async {
    // TODO: Implementar
  }

  Future<dynamic> deletePin(String pinId) async {
    // TODO: Implementar
  }

  // Búsqueda
  Future<dynamic> searchPins(String query, {int page = 1}) async {
    // TODO: Implementar
  }

  Future<dynamic> searchUsers(String query) async {
    // TODO: Implementar
  }

  // Likes
  Future<dynamic> likesPin(String pinId) async {
    // TODO: Implementar
  }

  Future<dynamic> unlikePin(String pinId) async {
    // TODO: Implementar
  }

  // Guardados
  Future<dynamic> savePin(String pinId) async {
    // TODO: Implementar
  }

  Future<dynamic> unsavePin(String pinId) async {
    // TODO: Implementar
  }

  // Seguidores
  Future<dynamic> followUser(String userId) async {
    // TODO: Implementar
  }

  Future<dynamic> unfollowUser(String userId) async {
    // TODO: Implementar
  }

  // Comentarios
  Future<dynamic> getComments(String pinId, {int page = 1}) async {
    // TODO: Implementar
  }

  Future<dynamic> createComment({
    required String pinId,
    required String content,
    String? parentCommentId,
  }) async {
    // TODO: Implementar
  }

  Future<dynamic> deleteComment(String commentId) async {
    // TODO: Implementar
  }

  // Tableros
  Future<dynamic> getUserBoards(String userId) async {
    // TODO: Implementar
  }

  Future<dynamic> getBoardPins(String boardId) async {
    // TODO: Implementar
  }

  Future<dynamic> createBoard({
    required String title,
    String? description,
    bool isPrivate = false,
  }) async {
    // TODO: Implementar
  }

  Future<dynamic> addPinToBoard({
    required String pinId,
    required String boardId,
  }) async {
    // TODO: Implementar
  }
}
