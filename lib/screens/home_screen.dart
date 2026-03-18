import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_pin_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  final supabase = Supabase.instance.client;
  Key _futureBuilderKey = UniqueKey();

  //refresh
  Future<void> refresh() async {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  //obtner pines
  Future<List<Map<String, dynamic>>> _fetchPins() async {
    final response = await supabase
        .from('pins')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // guardar pin
  Future<void> _savePin(String pinId) async {
    final user = supabase.auth.currentUser;
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para guardar pines')),
      );
      return;
    }

    try {
      await supabase.from('saves').insert({
        'user_id': user.id,
        'pin_id': pinId,
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Guardado en tu perfil!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este pin ya está en tus guardados')),
      );
    }
  }

  Future<void> _showBoardOptions(String pinId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para guardar en tableros')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildBoardOptionsSheet(pinId, user.id),
    );
  }

  Widget _buildBoardOptionsSheet(String pinId, String userId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUserBoards(userId),
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Agregar a tablero',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.add, color: Color(0xFFE60023)),
              title: const Text('Crear nuevo tablero'),
              onTap: () {
                Navigator.pop(context);
                _showCreateBoardDialog(pinId, userId);
              },
            ),
            if (snapshot.hasData && snapshot.data!.isNotEmpty)
              Divider(height: 0),
            if (snapshot.hasData && snapshot.data!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final board = snapshot.data![index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.folder,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      title: Text(board['title'] ?? 'Sin nombre'),
                      subtitle: Text('${board['pin_count'] ?? 0} pins'),
                      onTap: () {
                        Navigator.pop(context);
                        _addPinToBoard(pinId, board['id']);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUserBoards(String userId) async {
    final response = await supabase
        .from('boards')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  void _showCreateBoardDialog(String pinId, String userId) {
    final boardNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear nuevo tablero'),
        content: TextField(
          controller: boardNameController,
          decoration: InputDecoration(
            hintText: 'Nombre del tablero',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60023),
            ),
            onPressed: () {
              if (boardNameController.text.isNotEmpty) {
                Navigator.pop(context);
                _createBoardAndAddPin(
                    boardNameController.text, pinId, userId);
              }
            },
            child: const Text(
              'Crear',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _createBoardAndAddPin(String boardName, String pinId, String userId) async {
    try {
      //crear el board
      final boardResponse = await supabase
          .from('boards')
          .insert({
            'user_id': userId,
            'title': boardName,
            'description': '', 
          })
          .select()
          .single();

      //insertar en la tabla
      await supabase.from('board_pins').insert({
        'pin_id': pinId,
        'board_id': boardResponse['id'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tablero "$boardName" creado')),
      );
      
      //refrescar boards
      _fetchUserBoards(userId); 
      
    } catch (e) {
      print('Error detallado: $e'); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear el tablero')),
      );
    }
  }

  Future<void> _addPinToBoard(String pinId, String boardId) async {
    try {
      final existing = await supabase
          .from('board_pins')
          .select()
          .eq('pin_id', pinId)
          .eq('board_id', boardId);

      if (existing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este pin ya está en el tablero'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      await supabase.from('board_pins').insert({
        'pin_id': pinId,
        'board_id': boardId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pin agregado al tablero'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error al agregar pin al board: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar el pin'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navToCreatePin() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePinScreen()),
    );

    if (shouldRefresh == true) {
      setState(() {
        _futureBuilderKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'PauPins',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 32, color: Color(0xFFE60023)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 12, 12, 12),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _navToCreatePin,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          FutureBuilder<List<Map<String, dynamic>>>(
            key: _futureBuilderKey,
            future: _fetchPins(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.red)),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }

              final pins = snapshot.data ?? [];

              if (pins.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No hay pines todavía')),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final pin = pins[index];
                      return Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Stack(
                                children: [
                                  //pin
                                  Image.network(
                                    pin['image_url'] ?? '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          color: Colors.grey[300], 
                                          child: const Icon(Icons.broken_image)
                                        ),
                                  ),
                                  //botones
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Row(
                                      children: [
                                        //boton tablero
                                        GestureDetector(
                                          onTap: () => _showBoardOptions(pin['id'].toString()),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.9),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                )
                                              ]
                                            ),
                                            child: const Icon(
                                              Icons.folder_outlined,
                                              color: Color(0xFFE60023),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        //bton guardar
                                        GestureDetector(
                                          onTap: () => _savePin(pin['id'].toString()),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.9),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                )
                                              ]
                                            ),
                                            child: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Text(
                                pin['title'] ?? 'Sin título',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 13
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: pins.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}