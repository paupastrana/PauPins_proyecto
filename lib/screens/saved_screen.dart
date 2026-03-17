import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/pin_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _savedPins = [];
  bool _isLoading = true;
  String? _currentUserId;
  late RealtimeChannel _savesChannel;

  // Método público para refrescar desde MainApp
  Future<void> refresh() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  @override
  void dispose() {
    // Desuscribirse del canal cuando se destruye el widget
    try {
      _savesChannel.unsubscribe();
    } catch (e) {
      print('Error al desuscribirse: $e');
    }
    super.dispose();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        setState(() {
          _currentUserId = user.id;
        });
        await _fetchSavedPins();
        _setupRealtimeListener();
      }
    } catch (e) {
      print('Error al obtener usuario: $e');
      setState(() => _isLoading = false);
    }
  }

  void _setupRealtimeListener() {
    if (_currentUserId == null) return;

    _savesChannel = supabase.channel('saves_channel_$_currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'saves',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _currentUserId,
          ),
          callback: (payload) {
            print('DEBUG: Cambio detectado en saves: ${payload.eventType}');
            _fetchSavedPins();
          },
        )
        .subscribe();
  }

  Future<void> _fetchSavedPins() async {
    try {
      if (_currentUserId == null) return;

      // Pequeño delay para asegurar que Supabase haya actualizado
      await Future.delayed(const Duration(milliseconds: 500));

      // Traemos los guardados con los datos del pin (misma lógica del ProfileScreen)
      final List<dynamic> response = await supabase
          .from('saves')
          .select('*, pins(*)') 
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false);

      print('DEBUG SavedScreen: Se obtuvieron ${response.length} pines guardados');

      setState(() {
        // Filtramos para evitar nulos si un pin fue borrado pero el 'save' existe
        _savedPins = response
            .map((item) => item['pins'])
            .where((pin) => pin != null)
            .cast<Map<String, dynamic>>()
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error al obtener pins guardados: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _unsavePin(String pinId) async {
    try {
      if (_currentUserId == null) return;

      // Eliminamos de la tabla de saves
      await supabase
          .from('saves')
          .delete()
          .eq('user_id', _currentUserId!)
          .eq('pin_id', pinId);

      // Removemos de la lista local
      setState(() {
        _savedPins.removeWhere((pin) => pin['id'] == pinId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pin removido de guardados'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error al desguardar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al remover el pin'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Guardados',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE60023),
              ),
            )
          : _savedPins.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sin pins guardados',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Guarda pins para verlos aquí',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: _savedPins.length,
                  itemBuilder: (context, index) {
                    final pin = _savedPins[index];
                    final userData = pin['users'] as Map<String, dynamic>?;

                    final profileImage = userData?['profile_image_url'];

                    return Stack(
                      children: [
                        PinCard(
                          imageUrl: pin['image_url'] ?? '',
                          title: pin['title'] ?? 'Sin título',
                         
                          userProfileImage: profileImage,
                          isSaved: true,
                          onTap: () {
                            // Aquí irá la navegación al detalle del pin cuando esté implementado
                            print('Abriendo pin: ${pin['id']}');
                          },
                          onSave: () => _unsavePin(pin['id']),
                        ),
                        // Botón de desguardar en la esquina superior derecha
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _unsavePin(pin['id']),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE60023),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.bookmark,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
