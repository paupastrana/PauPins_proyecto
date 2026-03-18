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
  //varibales de estado
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  //seleccionar imagenes
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, 
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
    //limpiar form
    setState(() {
      _imageFile = null; 
      _titleController.clear();
      _descriptionController.clear(); 
      _urlController.clear(); 
    });
  }

  //publicar foto en supa
  Future<void> _uploadPin() async {
  
    if (_imageFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, añade una imagen y un título')),
      );
      return;
    }

    //loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.red)),
    );

    try {
      //subir imagen al bucket se crea un nombre único usando el tiempo actual
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = 'uploads/$fileName'; 
      
      await supabase.storage.from('pines').upload(path, _imageFile!);

      //url
      final String publicUrl = supabase.storage.from('pines').getPublicUrl(path);

      //isnertar en tabla
      await supabase.from('pins').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'image_url': publicUrl,
        'source_url': _urlController.text,
        'user_id': supabase.auth.currentUser?.id, 
      });

      if (mounted) {
        //borrar loading
        Navigator.of(context, rootNavigator: true).pop();

        //mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pin publicado')),
        );

        //reseta
        _resetForm();
      }
     
    } catch (e) {
      if (mounted) Navigator.pop(context); 
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

            //texto
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

            //
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