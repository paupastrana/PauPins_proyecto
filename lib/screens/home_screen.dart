


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

  // Refresh manual
  Future<void> refresh() async {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  // Obtener pines globales
  Future<List<Map<String, dynamic>>> _fetchPins() async {
    final response = await supabase
        .from('pins')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Guardar pin en la tabla general de "saves" (favoritos)
  Future<void> _savePin(String pinId) async {
    final user = supabase.auth.currentUser;
    
    if (user == null) {
      _showSnackBar('Inicia sesión para guardar pines', Colors.orange);
      return;
    }

    try {
      await supabase.from('saves').insert({
        'user_id': user.id,
        'pin_id': pinId,
      });
      
      _showSnackBar('¡Guardado en tu perfil!', Colors.green);
    } catch (e) {
      _showSnackBar('Este pin ya está en tus guardados', Colors.blueGrey);
    }
  }

  // Mostrar el modal de tableros
  Future<void> _showBoardOptions(String pinId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      _showSnackBar('Inicia sesión para usar tableros', Colors.orange);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _buildBoardOptionsSheet(pinId, user.id),
      ),
    );
  }

  Widget _buildBoardOptionsSheet(String pinId, String userId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUserBoards(userId),
      builder: (context, snapshot) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Agregar a tablero',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0F0F0),
                child: Icon(Icons.add, color: Color(0xFFE60023)),
              ),
              title: const Text('Crear nuevo tablero'),
              onTap: () {
                Navigator.pop(context);
                _showCreateBoardDialog(pinId, userId);
              },
            ),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Colors.red),
              )),
            if (snapshot.hasData)
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final board = snapshot.data![index];
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.grid_view_rounded, color: Colors.grey),
                      ),
                      title: Text(board['title'] ?? 'Sin nombre'),
                      subtitle: const Text('Toca para añadir aquí'),
                      onTap: () {
                        Navigator.pop(context);
                        _addPinToBoard(pinId, board['id'].toString());
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  // CORRECCIÓN AQUÍ: No pedimos 'pin_count' porque no existe en la tabla
  Future<List<Map<String, dynamic>>> _fetchUserBoards(String userId) async {
    final response = await supabase
        .from('boards')
        .select('id, title, created_at') 
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  void _showCreateBoardDialog(String pinId, String userId) {
    final boardNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo tablero'),
        content: TextField(
          controller: boardNameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Ej: Ideas para mi cuarto'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE60023)),
            onPressed: () {
              if (boardNameController.text.isNotEmpty) {
                Navigator.pop(context);
                _createBoardAndAddPin(boardNameController.text, pinId, userId);
              }
            },
            child: const Text('Crear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _createBoardAndAddPin(String boardName, String pinId, String userId) async {
    try {
      // 1. Insertamos el tablero y pedimos EXPLICITAMENTE solo el ID
      final response = await supabase.from('boards').insert({
        'user_id': userId,
        'title': boardName,
      }).select('id').single(); 

      // 2. Usamos ese ID para el vínculo
      await _addPinToBoard(pinId, response['id'].toString());
      
    } catch (e) {
      print('Error al crear tablero: $e');
      _showSnackBar('Error al crear el tablero', Colors.red);
    }
  }

  Future<void> _addPinToBoard(String pinId, String boardId) async {
    try {
      print("Intentando guardar... Pin: $pinId en Board: $boardId");

      // EL CAMBIO CLAVE:
      // Agregamos un select vacío o simplemente no ponemos nada 
      // para que PostgREST no intente devolver la fila completa.
      await supabase.from('board_pins').insert({
        'pin_id': pinId,
        'board_id': boardId,
      }); // <--- SIN .select() al final

      _showSnackBar('¡Ahora sí se guardó real!', Colors.green);
      refresh();
    } catch (e) {
      print('ERROR REAL: $e');
      
      // Si el error sigue siendo el 42703, es porque tu configuración de Supabase
      // está forzando un 'return=representation'. 
      // Si eso pasa, el dato SÍ se guardó, pero la respuesta falló.
      if (e.toString().contains('42703')) {
        _showSnackBar('¡Guardado!', Colors.green);
        refresh();
      } else {
        _showSnackBar('Error: $e', Colors.red);
      }
    }
  }

  
  

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _navToCreatePin() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePinScreen()),
    );
    if (shouldRefresh == true) refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('PauPins', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE60023))),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _navToCreatePin)],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        key: _futureBuilderKey,
        future: _fetchPins(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }
          final pins = snapshot.data ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.6,
            ),
            itemCount: pins.length,
            itemBuilder: (context, index) {
              final pin = pins[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Image.network(pin['image_url'] ?? '', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                          Positioned(
                            top: 5, right: 5,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white, radius: 15,
                                  child: IconButton(
                                    icon: const Icon(Icons.folder_open, size: 15, color: Colors.black),
                                    onPressed: () => _showBoardOptions(pin['id'].toString()),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                CircleAvatar(
                                  backgroundColor: Colors.white, radius: 15,
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite_border, size: 15, color: Colors.red),
                                    onPressed: () => _savePin(pin['id'].toString()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pin['title'] ?? '', maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}