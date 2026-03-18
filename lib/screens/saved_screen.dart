// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../widgets/pin_card.dart';

// class SavedScreen extends StatefulWidget {
//   const SavedScreen({Key? key}) : super(key: key);

//   @override
//   State<SavedScreen> createState() => _SavedScreenState();
// }

// class _SavedScreenState extends State<SavedScreen> {
//   final supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> _savedPins = [];
//   List<Map<String, dynamic>> _boards = [];
//   bool _isLoading = true;
//   String? _currentUserId;
//   late RealtimeChannel _savesChannel;
//   late RealtimeChannel _boardsChannel;
//   int _selectedTabIndex = 0;

//   // Método público para refrescar desde MainApp
//   Future<void> refresh() async {
//     setState(() {
//       _isLoading = true;
//     });
//     await _fetchCurrentUser();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentUser();
//   }

//   @override
//   void dispose() {
//     try {
//       _savesChannel.unsubscribe();
//       _boardsChannel.unsubscribe();
//     } catch (e) {
//       print('Error al desuscribirse: $e');
//     }
//     super.dispose();
//   }

//   Future<void> _fetchCurrentUser() async {
//     try {
//       final user = supabase.auth.currentUser;
//       if (user != null) {
//         setState(() {
//           _currentUserId = user.id;
//         });
//         await Future.wait([
//           _fetchSavedPins(),
//           _fetchBoards(),
//         ]);
//         _setupRealtimeListeners();
//       }
//     } catch (e) {
//       print('Error al obtener usuario: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   void _setupRealtimeListeners() {
//     if (_currentUserId == null) return;

//     _savesChannel = supabase.channel('saves_channel_$_currentUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'saves',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'user_id',
//             value: _currentUserId,
//           ),
//           callback: (payload) {
//             print('DEBUG: Cambio detectado en saves');
//             _fetchSavedPins();
//           },
//         )
//         .subscribe();

//     _boardsChannel = supabase.channel('boards_channel_$_currentUserId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'boards',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'user_id',
//             value: _currentUserId,
//           ),
//           callback: (payload) {
//             print('DEBUG: Cambio detectado en boards');
//             _fetchBoards();
//           },
//         )
//         .subscribe();
//   }


//   Future<void> _fetchSavedPins() async {
//     try {
//       if (_currentUserId == null) return;
      
//       // Eliminamos el delay artificial para mayor fluidez
//       final List<dynamic> response = await supabase
//           .from('saves')
//           .select('*, pins(*)')
//           .eq('user_id', _currentUserId!)
//           .order('created_at', ascending: false);

//       if (mounted) { // Verificamos si el widget sigue activo
//         setState(() {
//           _savedPins = response
//               .map((item) => item['pins'])
//               .where((pin) => pin != null)
//               .cast<Map<String, dynamic>>()
//               .toList();
//           // Solo quitamos carga si estamos en la pestaña 0 o si ambas terminaron
//           if (_selectedTabIndex == 0) _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error al obtener pins guardados: $e');
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _fetchBoards() async {
//     try {
//       if (_currentUserId == null) return;

//       final List<dynamic> response = await supabase
//           .from('boards')
//           .select()
//           .eq('user_id', _currentUserId!)
//           .order('created_at', ascending: false);

//       if (mounted) {
//         setState(() {
//           _boards = List<Map<String, dynamic>>.from(response);
//           // IMPORTANTE: Quitar el estado de carga aquí también
//           if (_selectedTabIndex == 1) _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error al obtener boards: $e');
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _unsavePin(String pinId) async {
//     try {
//       if (_currentUserId == null) return;

//       await supabase
//           .from('saves')
//           .delete()
//           .eq('user_id', _currentUserId!)
//           .eq('pin_id', pinId);

//       setState(() {
//         _savedPins.removeWhere((pin) => pin['id'] == pinId);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Pin removido de guardados'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       print('Error al desguardar: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Error al remover el pin'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _showBoardOptions(String pinId) async {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => _buildBoardOptionsSheet(pinId),
//     );
//   }

//   Widget _buildBoardOptionsSheet(String pinId) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Add to board',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//         ),
//         Divider(height: 0),
//         ListTile(
//           leading: const Icon(Icons.add, color: Color(0xFFE60023)),
//           title: const Text('New Board'),
//           onTap: () {
//             Navigator.pop(context);
//             _showCreateBoardDialog(pinId);
//           },
//         ),
//         if (_boards.isNotEmpty)
//           Divider(height: 0),
//         if (_boards.isNotEmpty)
//           Expanded(
//             child: ListView.builder(
//               itemCount: _boards.length,
//               itemBuilder: (context, index) {
//                 final board = _boards[index];
//                 return ListTile(
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       color: Colors.grey[300],
//                       child: Icon(
//                         Icons.folder,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//                   title: Text(board['title'] ?? 'Sin nombre'),
//                   subtitle: Text('${board['pin_count'] ?? 0} pins'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _addPinToBoard(pinId, board['id']);
//                   },
//                 );
//               },
//             ),
//           ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   void _showCreateBoardDialog(String pinId) {
//     final boardNameController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('New Board'),
//         content: TextField(
//           controller: boardNameController,
//           decoration: InputDecoration(
//             hintText: 'Board name',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFE60023),
//             ),
//             onPressed: () {
//               if (boardNameController.text.isNotEmpty) {
//                 Navigator.pop(context);
//                 _createBoardAndAddPin(boardNameController.text, pinId);
//               }
//             },
//             child: const Text(
//               'Crear',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _createBoardAndAddPin(String boardName, String pinId) async {
//     try {
//       if (_currentUserId == null) return;

//       final boardResponse = await supabase
//           .from('boards')
//           .insert({
//             'user_id': _currentUserId,
//             'title': boardName,
//             'description': '',
//             'created_at': DateTime.now().toIso8601String(),
//           })
//           .select()
//           .single();

//       await supabase.from('board_pins').insert({
//         'pin_id': pinId,
//         'board_id': boardResponse['id'],
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Board "$boardName" created and pin added'),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       print('Error al crear board: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Error al crear el board'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _addPinToBoard(String pinId, String boardId) async {
//     try {
//       final existing = await supabase
//           .from('board_pins')
//           .select()
//           .eq('pin_id', pinId)
//           .eq('board_id', boardId);

//       if (existing.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Este pin ya está en el board'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//         return;
//       }

//       await supabase.from('board_pins').insert({
//         'pin_id': pinId,
//         'board_id': boardId,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Pin agregado al board'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       print('Error al agregar pin al board: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Error al agregar el pin'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<String?> _getBoardCoverImage(String boardId) async {
//     try {
//       final pinBoard = await supabase
//           .from('board_pins')
//           .select('pins(image_url)')
//           .eq('board_id', boardId)
//           .limit(1);

//       if (pinBoard.isNotEmpty && pinBoard[0]['pins'] != null) {
//         return pinBoard[0]['pins']['image_url'];
//       }
//       return null;
//     } catch (e) {
//       print('Error al obtener imagen de portada: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Guardados',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Container(
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedTabIndex = 0;
//                         _isLoading = true;
//                       });
//                       _fetchSavedPins();
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Pines',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: _selectedTabIndex == 0
//                                 ? Colors.black
//                                 : Colors.grey,
//                           ),
//                         ),
//                         if (_selectedTabIndex == 0)
//                           Container(
//                             height: 2,
//                             color: const Color(0xFFE60023),
//                             margin: const EdgeInsets.only(top: 8),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedTabIndex = 1;
//                         _isLoading = true;
//                       });
//                       _fetchBoards();
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Boards',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: _selectedTabIndex == 1
//                                 ? Colors.black
//                                 : Colors.grey,
//                           ),
//                         ),
//                         if (_selectedTabIndex == 1)
//                           Container(
//                             height: 2,
//                             color: const Color(0xFFE60023),
//                             margin: const EdgeInsets.only(top: 8),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFFE60023),
//               ),
//             )
//           : _selectedTabIndex == 0
//               ? _buildPinesTab()
//               : _buildTablerosTab(),
//     );
//   }

//   Widget _buildPinesTab() {
//     if (_savedPins.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.bookmark_outline,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Sin pins guardados',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Guarda pins para verlos aquí',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//         childAspectRatio: 0.65,
//       ),
//       itemCount: _savedPins.length,
//       itemBuilder: (context, index) {
//         final pin = _savedPins[index];
//         final userData = pin['users'] as Map<String, dynamic>?;
//         final profileImage = userData?['profile_image_url'];

//         return Stack(
//           children: [
//             PinCard(
//               imageUrl: pin['image_url'] ?? '',
//               title: pin['title'] ?? 'Sin título',
//               userProfileImage: profileImage,
//               isSaved: true,
//               onTap: () {
//                 print('Abriendo pin: ${pin['id']}');
//               },
//               onSave: () => _unsavePin(pin['id']),
//             ),
//             // Botón desguardar
//             Positioned(
//               top: 8,
//               right: 8,
//               child: GestureDetector(
//                 onTap: () => _unsavePin(pin['id']),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE60023),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.bookmark,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//             // Botón agregar a tablero
//             Positioned(
//               bottom: 8,
//               right: 8,
//               child: GestureDetector(
//                 onTap: () => _showBoardOptions(pin['id']),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.folder_outlined,
//                     color: Color(0xFFE60023),
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTablerosTab() {
//     // Si está cargando, mostrar el indicador
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator(color: Color(0xFFE60023)));
//     }

//     // Si terminó de cargar y la lista está vacía
//     if (_boards.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             const Text(
//               'Aún no tienes boards',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
//             ),
//             const Text('Crea uno para organizar tus pines'),
//           ],
//         ),
//       );
//     }
//     // if (_boards.isEmpty) {
//     //   return Center(
//     //     child: Column(
//     //       mainAxisAlignment: MainAxisAlignment.center,
//     //       children: [
//     //         Icon(
//     //           Icons.folder_outlined,
//     //           size: 80,
//     //           color: Colors.grey[400],
//     //         ),
//     //         const SizedBox(height: 24),
//     //         Text(
//     //           'Sin tableros',
//     //           style: TextStyle(
//     //             fontSize: 24,
//     //             fontWeight: FontWeight.bold,
//     //             color: Colors.grey[600],
//     //           ),
//     //         ),
//     //         const SizedBox(height: 8),
//     //         Text(
//     //           'Crea tableros para organizar tus pins',
//     //           style: TextStyle(
//     //             fontSize: 16,
//     //             color: Colors.grey[500],
//     //           ),
//     //         ),
//     //       ],
//     //     ),
//     //   );
//     // }

//     return GridView.builder(
//       padding: const EdgeInsets.all(8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: _boards.length,
//       itemBuilder: (context, index) {
//         final board = _boards[index];

//         return FutureBuilder<String?>(
//           future: _getBoardCoverImage(board['id']),
//           builder: (context, snapshot) {
//             return GestureDetector(
//               onTap: () {
//                 print('Abriendo board: ${board['id']}');
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey[300],
//                       ),
//                       child: snapshot.hasData && snapshot.data != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 snapshot.data!,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : Icon(
//                               Icons.folder,
//                               size: 60,
//                               color: Colors.grey[600],
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     board['title'] ?? 'Sin nombre',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     '${board['pin_count'] ?? 0} pins',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/pin_card.dart';
import '../screens/board_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _savedPins = [];
  List<Map<String, dynamic>> _boards = [];
  bool _isLoading = true;
  String? _currentUserId;
  late RealtimeChannel _savesChannel;
  late RealtimeChannel _boardsChannel;
  int _selectedTabIndex = 0;

  Future<void> refresh() async {
    setState(() => _isLoading = true);
    await _fetchCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  @override
  void dispose() {
    try {
      _savesChannel.unsubscribe();
      _boardsChannel.unsubscribe();
    } catch (e) {
      print('Error al desuscribirse: $e');
    }
    super.dispose();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        setState(() => _currentUserId = user.id);
        await Future.wait([_fetchSavedPins(), _fetchBoards()]);
        _setupRealtimeListeners();
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _setupRealtimeListeners() {
    if (_currentUserId == null) return;
    _savesChannel = supabase.channel('saves_channel_$_currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'saves',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: _currentUserId),
          callback: (payload) => _fetchSavedPins(),
        ).subscribe();

    _boardsChannel = supabase.channel('boards_channel_$_currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'boards',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: _currentUserId),
          callback: (payload) => _fetchBoards(),
        ).subscribe();
  }

  Future<void> _fetchSavedPins() async {
    try {
      final response = await supabase
          .from('saves')
          .select('*, pins(*)')
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _savedPins = response.map((item) => item['pins']).where((pin) => pin != null).cast<Map<String, dynamic>>().toList();
          if (_selectedTabIndex == 0) _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _fetchBoards() async {
    try {
      // Traemos los boards y, de paso, contamos los registros en la tabla intermedia
      final response = await supabase
          .from('boards')
          .select('*, board_pins(count)') // Esto pide el conteo de la relación
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _boards = List<Map<String, dynamic>>.from(response);
          if (_selectedTabIndex == 1) _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetch boards: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _unsavePin(String pinId) async {
    await supabase.from('saves').delete().eq('user_id', _currentUserId!).eq('pin_id', pinId);
    setState(() => _savedPins.removeWhere((pin) => pin['id'] == pinId));
  }

  // --- MÉTODOS DE UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              _tabItem('Likes', 0),
              _tabItem('Boards', 1),
            ],
          ),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE60023))) 
          : (_selectedTabIndex == 0 ? _buildPinesTab() : _buildTablerosTab()),
    );
  }

  Widget _tabItem(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _selectedTabIndex = index; _isLoading = true; index == 0 ? _fetchSavedPins() : _fetchBoards(); }),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? Colors.black : Colors.grey)),
            if (isSelected) Container(height: 2, color: const Color(0xFFE60023), margin: const EdgeInsets.only(top: 8)),
          ],
        ),
      ),
    );
  }

  Widget _buildPinesTab() {
    if (_savedPins.isEmpty) return const Center(child: Text('Sin pins guardados'));
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7, // Ajuste de tamaño para que no se vea chiquito
      ),
      itemCount: _savedPins.length,
      itemBuilder: (context, index) {
        final pin = _savedPins[index];
        return Stack(
          children: [
            PinCard(
              imageUrl: pin['image_url'] ?? '',
              title: pin['title'] ?? 'Sin título',
              isSaved: true,
              onTap: () {
                // AQUÍ ES DONDE "ABREN":
                print('Navegando al pin: ${pin['id']}');
                /* Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PinDetailScreen(pin: pin)
                )); */
              },
              onSave: () => _unsavePin(pin['id']),
            ),
            // Botón rápido de desguardar
            Positioned(
              top: 5, right: 5,
              child: IconButton(
                icon: const Icon(Icons.bookmark, color: Color(0xFFE60023)),
                onPressed: () => _unsavePin(pin['id']),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTablerosTab() {
    if (_boards.isEmpty) return const Center(child: Text('Aún no tienes boards'));
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.85, // Ratio para tableros más grandes
      ),
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        final board = _boards[index];
        return GestureDetector(
          onTap: () {
            // ESTO ES LO QUE HACE QUE SE ABRA
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoardDetailsScreen(
                  boardId: board['id'],
                  boardTitle: board['title'] ?? 'Tablero',
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey[200]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FutureBuilder<String?>(
                      future: _getBoardCoverImage(board['id']),
                      builder: (context, snap) {
                        if (snap.hasData && snap.data != null) {
                          return Image.network(snap.data!, fit: BoxFit.cover, width: double.infinity);
                        }
                        return const Icon(Icons.folder, size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(board['title'] ?? 'Sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
              //Text('${board['pin_count'] ?? 0} pines', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text('${board['board_pins']?[0]?['count'] ?? 0} pines', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _getBoardCoverImage(String boardId) async {
    final res = await supabase.from('board_pins').select('pins(image_url)').eq('board_id', boardId).limit(1);
    if (res.isNotEmpty && res[0]['pins'] != null) return res[0]['pins']['image_url'];
    return null;
  }
}
