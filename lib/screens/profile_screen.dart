// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProfileScreen extends StatefulWidget {
//   final String? userId;

//   const ProfileScreen({Key? key, this.userId}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();

  
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   Future<void> _signOut() async {
//     await Supabase.instance.client.auth.signOut();
//     if (mounted) {
//       // Usamos pushNamedAndRemoveUntil para que no pueda volver atrás al perfil
//       Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             floating: true,
//             pinned: true,
//             // 2. Añadimos el botón de Logout aquí
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.logout, color: Colors.red),
//                 onPressed: () {
//                   // Mostrar un diálogo de confirmación antes de salir
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text('Cerrar sesión'),
//                       content: const Text('¿Estás seguro de que quieres salir?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Cancelar'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             _signOut();
//                           },
//                           child: const Text('Salir', style: TextStyle(color: Colors.red)),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 color: Colors.grey[300],
//                 // Aquí podrías poner una imagen de portada si quisieras
//               ),
//             ),
//           ),
          
//           // AQUÍ VA EL SliverToBoxAdapter QUE REPARAMOS ANTES (con la info del usuario)
//           SliverToBoxAdapter(
//             child: _isLoading 
//               ? const Padding(
//                   padding: EdgeInsets.all(40),
//                   child: Center(child: CircularProgressIndicator(color: Colors.red)),
//                 )
//               : Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _profileData?['avatar_url'] != null 
//                         ? NetworkImage(_profileData!['avatar_url']) 
//                         : null,
//                       child: _profileData?['avatar_url'] == null 
//                         ? const Icon(Icons.person, size: 50) 
//                         : null,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _profileData?['username'] ?? 'Cargando...',
//                       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//           ),

//           SliverPadding(
//             padding: const EdgeInsets.all(12),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 0.7,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   return Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     color: Colors.grey[200],
//                     child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey)),
//                   );
//                 },
//                 childCount: 8,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Map<String, dynamic>? _profileData;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData();
//   }

//   Future<void> _fetchProfileData() async {
//     try {
//       // Si widget.userId es nulo, usamos el ID del usuario logueado actualmente
//       final id = widget.userId ?? Supabase.instance.client.auth.currentUser?.id;

//       if (id == null) return;

//       final data = await Supabase.instance.client
//           .from('profiles')
//           .select()
//           .eq('id', id)
//           .single();

//       setState(() {
//         _profileData = data;
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('Error cargando perfil: $e');
//       setState(() => _isLoading = false);
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? _profileData;
  List<Map<String, dynamic>> _savedPins = []; // Lista para almacenar los pines
  bool _isLoading = true;
  late RealtimeChannel _pinsChannel;

  @override
  void initState() {
    super.initState();
    _fetchProfileAndPins();
  }

  // Método público para refrescar desde MainApp
  Future<void> refresh() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchProfileAndPins();
  }

  @override
  void dispose() {
    // Desuscribirse del canal cuando se destruye el widget
    try {
      _pinsChannel.unsubscribe();
    } catch (e) {
      print('Error al desuscribirse: $e');
    }
    super.dispose();
  }
  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      // Usamos pushNamedAndRemoveUntil para que no pueda volver atrás al perfil
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  // Combinamos la carga de perfil y de pines del usuario
  Future<void> _fetchProfileAndPins() async {
    try {
      final id = widget.userId ?? supabase.auth.currentUser?.id;
      if (id == null) return;

      // Traemos el perfil
      final profileData = await supabase.from('profiles').select().eq('id', id).single();

      // Traemos los PINES PUBLICADOS por el usuario (no guardados)
      final List<dynamic> pinsResponse = await supabase
          .from('pins')
          .select() 
          .eq('user_id', id)
          .order('created_at', ascending: false);

      setState(() {
        _profileData = profileData;
        _savedPins = List<Map<String, dynamic>>.from(pinsResponse);
        _isLoading = false;
      });

      // Iniciar listener de cambios en tiempo real
      _setupRealtimeListener(id);
    } catch (e) {
      print('DEBUG: Error en el perfil: $e');
      setState(() => _isLoading = false);
    }
  }

  void _setupRealtimeListener(String userId) {
    _pinsChannel = supabase.channel('pins_channel_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'pins',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            print('DEBUG: Cambio detectado en pins: ${payload.eventType}');
            _fetchProfileAndPins();
          },
        )
        .subscribe();
  }

  Future<void> _deletePin(String pinId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar pin'),
        content: const Text('¿Estás seguro de que quieres eliminar este pin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeletePin(pinId);
            },
            child: const Text('Eliminar', style: TextStyle(color: Color.fromARGB(255, 59, 41, 66))),
          ),
        ],
      ),
    );
  }

  // Future<void> _confirmDeletePin(String pinId) async {
  //   try {
  //     // Obtener el pin para extraer la URL de la imagen
  //     final pin = _savedPins.firstWhere((p) => p['id'] == pinId);
  //     final imageUrl = pin['image_url'] as String?;

  //     // Eliminar la imagen del bucket si existe
  //     if (imageUrl != null && imageUrl.isNotEmpty) {
  //       try {
  //         // Extraer el path del bucket de la URL
  //         // URL es algo como: https://...supabase.co/storage/v1/object/public/pines/uploads/filename.jpg
  //         // Necesitamos extraer: uploads/filename.jpg
  //         final pathStartIndex = imageUrl.indexOf('/pines/') + 7; // +7 para saltar '/pines/'
  //         if (pathStartIndex > 6) {
  //           final filePath = imageUrl.substring(pathStartIndex);
            
  //           // Eliminar del bucket storage
  //           await supabase.storage.from('pines').remove([filePath]);
  //           print('Imagen eliminada del bucket: $filePath');
  //         }
  //       } catch (e) {
  //         print('Error al eliminar imagen del bucket: $e');
  //         // Continuamos con la eliminación del registro aunque falle el bucket
  //       }
  //     }

  //     // Eliminar el pin de la tabla pins
  //     await supabase
  //         .from('pins')
  //         .delete()
  //         .eq('id', pinId);

  //     // Removemos de la lista local
  //     setState(() {
  //       _savedPins.removeWhere((pin) => pin['id'] == pinId);
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Pin eliminado'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error al eliminar: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Error al eliminar el pin'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }

  Future<void> _confirmDeletePin(String pinId) async {
    // 1. Buscamos el pin y su URL antes de borrar nada
    final pinIndex = _savedPins.indexWhere((p) => p['id'] == pinId);
    if (pinIndex == -1) return; // No se encontró el pin localmente

    final pinToDelete = _savedPins[pinIndex];
    final String? imageUrl = pinToDelete['image_url'];

    // 2. BORRADO OPTIMISTA: Lo quitamos de la pantalla de inmediato
    setState(() {
      _savedPins.removeAt(pinIndex);
    });

    try {
      // 3. Intentar borrar del Bucket Storage primero
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final Uri uri = Uri.parse(imageUrl);
          final List<String> pathSegments = uri.pathSegments;
          final int pinesIndex = pathSegments.indexOf('pines');
          
          if (pinesIndex != -1) {
            final filePath = pathSegments.sublist(pinesIndex + 1).join('/');
            await supabase.storage.from('pines').remove([filePath]);
            print('DEBUG: Imagen eliminada del bucket: $filePath');
          }
        } catch (e) {
          print('DEBUG: Error al eliminar imagen del bucket (quizás ya no existía): $e');
          // Continuamos, el registro en la DB es lo más importante
        }
      }

      // 4. Intentar borrar el registro de la base de datos
      // Gracias al SQL del Paso 1, esto ahora debería funcionar
      await supabase.from('pins').delete().eq('id', pinId);
      
      print('DEBUG: Registro del pin eliminado de la base de datos.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pin eliminado correctamente')),
        );
      }
    } catch (e) {
      print('DEBUG: Error al eliminar: $e');
      
      // 5. REVERSIÓN: Si algo salió mal en la DB, volvemos a poner el pin en su lugar
      if (mounted) {
        setState(() {
          _savedPins.insert(pinIndex, pinToDelete);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el pin de la base de datos'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black54),
                onPressed: _showLogoutDialog,
              ),
            ],
          ),
          
          // Información del Usuario
          SliverToBoxAdapter(
            child: _isLoading 
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileData?['avatar_url'] != null 
                        ? NetworkImage(_profileData!['avatar_url']) 
                        : null,
                      child: _profileData?['avatar_url'] == null 
                        ? const Icon(Icons.person, size: 50, color: Colors.grey) 
                        : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _profileData?['username'] ?? 'Usuario',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mis Publicaciones',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
          ),

          // Grid de Pines Guardados
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.red)),
                )
              : _savedPins.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(child: Text('Aún no has publicado nada')),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final pin = _savedPins[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    color: Colors.grey[100],
                                    child: Image.network(
                                      pin['image_url'] ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                // Botón para eliminar pin
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => _deletePin(pin['id']),
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
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          childCount: _savedPins.length,
                        ),
                      ),
                    ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}