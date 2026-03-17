


// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// // Asegúrate de importar tu pantalla de creación
// import 'create_pin_screen.dart'; 

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final supabase = Supabase.instance.client;

//   // 1. Añadimos una llave para forzar el refresco del FutureBuilder
//   Key _futureBuilderKey = UniqueKey();

//   Future<List<Map<String, dynamic>>> _fetchPins() async {
//     final response = await supabase
//         .from('pins')
//         .select()
//         .order('created_at', ascending: false);
//     return List<Map<String, dynamic>>.from(response);
//   }

//   // 2. Función para navegar y esperar la respuesta
//   Future<void> _navToCreatePin() async {
//     final bool? shouldRefresh = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CreatePinScreen()),
//     );

//     // Si CreatePinScreen devolvió 'true', cambiamos la llave para recargar
//     if (shouldRefresh == true) {
//       setState(() {
//         _futureBuilderKey = UniqueKey();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Pinterest',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_box_outlined), // Ícono de agregar
//             onPressed: _navToCreatePin, // Llamamos a nuestra nueva función
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             floating: true,
//             snap: true,
//             backgroundColor: Colors.white,
//             elevation: 0,
//             title: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Buscar en Pinterest',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//               ),
//             ),
//           ),
//           FutureBuilder<List<Map<String, dynamic>>>(
//             key: _futureBuilderKey, // <--- 3. Asignamos la llave aquí
//             future: _fetchPins(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const SliverFillRemaining(
//                   child: Center(child: CircularProgressIndicator(color: Colors.red)),
//                 );
//               }

//               if (snapshot.hasError) {
//                 return SliverFillRemaining(
//                   child: Center(child: Text('Error: ${snapshot.error}')),
//                 );
//               }

//               final pins = snapshot.data ?? [];

//               if (pins.isEmpty) {
//                 return const SliverFillRemaining(
//                   child: Center(child: Text('No hay pines todavía')),
//                 );
//               }

//               return SliverPadding(
//                 padding: const EdgeInsets.all(12),
//                 sliver: SliverGrid(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 0.7,
//                   ),
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       final pin = pins[index];
//                       return Card(
//                         elevation: 0,
//                         clipBehavior: Clip.antiAlias,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 5,
//                               child: Image.network(
//                                 pin['image_url'] ?? '',
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               child: Text(
//                                 pin['title'] ?? 'Sin título',
//                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     childCount: pins.length,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }



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

  // Método público para refrescar desde MainApp
  Future<void> refresh() async {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  // 1. Función para obtener los pines
  Future<List<Map<String, dynamic>>> _fetchPins() async {
    final response = await supabase
        .from('pins')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // 2. Función para guardar un pin en la tabla 'saves'
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _navToCreatePin,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en PauPins',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
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
                                  // Imagen del Pin
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
                                  // Botón de Corazón (Guardar)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
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