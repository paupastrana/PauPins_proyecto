// import 'package:flutter/material.dart';

// class CreatePinScreen extends StatefulWidget {
//   const CreatePinScreen({Key? key}) : super(key: key);

//   @override
//   State<CreatePinScreen> createState() => _CreatePinScreenState();
// }

// class _CreatePinScreenState extends State<CreatePinScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _urlController = TextEditingController();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _urlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crear Pin'),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.grey[300],
//                   border: Border.all(
//                     color: Colors.grey[400]!,
//                     width: 2,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.image, size: 64, color: Colors.grey[600]),
//                     const SizedBox(height: 12),
//                     const Text('Sube una imagen o pega una URL'),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () {},
//                           icon: const Icon(Icons.upload),
//                           label: const Text('Subir'),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton.icon(
//                           onPressed: () {},
//                           icon: const Icon(Icons.link),
//                           label: const Text('URL'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Título',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   hintText: 'Añade un título descriptivo',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 maxLines: null,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Descripción',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(
//                   hintText: 'Cuéntale a la gente qué es tu pin',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 maxLines: 4,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'URL de destino',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _urlController,
//                 decoration: InputDecoration(
//                   hintText: 'https://ejemplo.com',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Tablero',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text('Selecciona un tablero'),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // TODO: Create pin
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                   child: const Text(
//                     'Publicar',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CreatePinScreen extends StatefulWidget {
//   const CreatePinScreen({Key? key}) : super(key: key);

//   @override
//   State<CreatePinScreen> createState() => _CreatePinScreenState();
// }

// class _CreatePinScreenState extends State<CreatePinScreen> {
//   // 1. Controladores y Variables
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _urlController = TextEditingController();
  
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   final supabase = Supabase.instance.client;

//   // 2. Función para seleccionar imagen
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         imageQuality: 80,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       debugPrint("Error al seleccionar imagen: $e");
//     }
//   }

//   // 3. Función para subir a Storage e insertar en Base de Datos
//   Future<void> _uploadPin() async {
//     if (_imageFile == null || _titleController.text.isEmpty) return;

//     // Mostrar indicador de carga
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );

//     try {
//       // A. Subir imagen al Bucket 'pines'
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
//       final path = 'uploads/$fileName';
//       await supabase.storage.from('pines').upload(path, _imageFile!);

//       // B. Obtener URL Pública
//       final String publicUrl = supabase.storage.from('pines').getPublicUrl(path);

//       // C. Insertar en tabla 'pins'
//       await supabase.from('pins').insert({
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//         'image_url': publicUrl,
//         'source_url': _urlController.text,
//         'user_id': supabase.auth.currentUser?.id, // ID del usuario actual
//       });

//       if (mounted) {
//         Navigator.pop(context); // Cerrar Loading
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('¡Pin publicado!')),
//         );
//         Navigator.pop(context); // Volver al Home
//       }
//     } catch (e) {
//       if (mounted) Navigator.pop(context);
//       debugPrint('Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al subir: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _urlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crear Pin'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ÁREA DE IMAGEN
//             GestureDetector(
//               onTap: () => _pickImage(ImageSource.gallery),
//               child: Container(
//                 width: double.infinity,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.grey[200],
//                   border: Border.all(color: Colors.grey[300]!),
//                   image: _imageFile != null
//                       ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
//                       : null,
//                 ),
//                 child: _imageFile == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.image, size: 50, color: Colors.grey),
//                           const Text('Elige una foto'),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: () => _pickImage(ImageSource.camera),
//                                 icon: const Icon(Icons.camera_alt),
//                                 label: const Text('Cámara'),
//                               ),
//                               const SizedBox(width: 10),
//                               ElevatedButton.icon(
//                                 onPressed: () => _pickImage(ImageSource.gallery),
//                                 icon: const Icon(Icons.photo),
//                                 label: const Text('Galería'),
//                               ),
//                             ],
//                           )
//                         ],
//                       )
//                     : Align(
//                         alignment: Alignment.topRight,
//                         child: IconButton(
//                           onPressed: () => setState(() => _imageFile = null),
//                           icon: const CircleAvatar(
//                             backgroundColor: Colors.white,
//                             child: Icon(Icons.close, color: Colors.red),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // CAMPOS DE TEXTO
//             const Text('Título', style: TextStyle(fontWeight: FontWeight.bold)),
//             TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'Añade un título')),
            
//             const SizedBox(height: 15),
//             const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
//             TextField(controller: _descriptionController, maxLines: 3, decoration: const InputDecoration(hintText: 'De qué trata tu pin')),
            
//             const SizedBox(height: 15),
//             const Text('Enlace (opcional)', style: TextStyle(fontWeight: FontWeight.bold)),
//             TextField(controller: _urlController, decoration: const InputDecoration(hintText: 'https://ejemplo.com')),

//             const SizedBox(height: 30),

//             // BOTÓN DE PUBLICAR
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _uploadPin,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                 ),
//                 child: const Text('Publicar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({Key? key}) : super(key: key);

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  // 1. Controladores y Variables de estado
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  // 2. Función para seleccionar imagen (Cámara o Galería)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Comprime un poco para ahorrar espacio en Storage
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error al seleccionar imagen: $e");
    }
  }
  void _resetForm() {
    setState(() {
      _imageFile = null; // Quita la imagen de la vista
      _titleController.clear(); // Borra el texto del título
      _descriptionController.clear(); // Borra el texto de la descripción
      _urlController.clear(); // Borra el enlace
    });
  }

  //3. Función principal para publicar en Supabase
  Future<void> _uploadPin() async {
    // Validaciones básicas
    if (_imageFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, añade una imagen y un título')),
      );
      return;
    }

    // Mostrar círculo de carga (Loading)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.red)),
    );

    try {
      // A. Subir imagen al Bucket 'pines'
      // Creamos un nombre único usando el tiempo actual
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = 'uploads/$fileName'; 
      
      await supabase.storage.from('pines').upload(path, _imageFile!);

      // B. Obtener la URL pública (la que se guarda en la DB)
      final String publicUrl = supabase.storage.from('pines').getPublicUrl(path);

      // C. Insertar registro en la tabla 'pins'
      await supabase.from('pins').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'image_url': publicUrl,
        'source_url': _urlController.text,
        // Si no tienes auth configurado todavía, comenta la siguiente línea:
        'user_id': supabase.auth.currentUser?.id, 
      });

      if (mounted) {
        // 1. Cerramos el diálogo de carga (el CircularProgressIndicator)
        // Usamos rootNavigator para asegurarnos de cerrar el diálogo
        Navigator.of(context, rootNavigator: true).pop();

        // 2. Mostramos el mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Pin publicado con éxito!')),
        );

        // 3. Regresamos al Home de forma segura
        _resetForm();
      }
     
    } catch (e) {
      if (mounted) Navigator.pop(context); // Quitar loading en caso de error
      debugPrint('Error detallado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar: $e')),
      );
    }

    
  }


//paugpas@gmail.com


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Crear Pin', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ÁREA DE SELECCIÓN DE IMAGEN
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                  image: _imageFile != null
                      ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                      : null,
                ),
                child: _imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload, size: 50, color: Colors.grey[600]),
                          const SizedBox(height: 15),
                          const Text('Selecciona una imagen para tu pin', 
                            style: TextStyle(fontSize: 16, color: Colors.black54)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Cámara'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton.icon(
                                onPressed: () => _pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Galería'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => setState(() => _imageFile = null),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 25),

            // CAMPOS DE TEXTO
            const Text('Título', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Añade un título',
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
              ),
            ),

            const SizedBox(height: 20),
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Cuéntale a todos de qué trata tu pin...',
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 20),
        
            

            const SizedBox(height: 40),

            // BOTÓN DE PUBLICAR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _uploadPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Publicar',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}