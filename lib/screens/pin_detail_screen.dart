import 'package:flutter/material.dart';

class PinDetailScreen extends StatefulWidget {
  final String pinId;

  const PinDetailScreen({Key? key, required this.pinId}) : super(key: key);

  @override
  State<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends State<PinDetailScreen> {
  bool _isSaved = false;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Título del Pin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descripción del pin aquí',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLiked = !_isLiked;
                              });
                            },
                          ),
                          const Text('Me gusta'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSaved = !_isSaved;
                              });
                            },
                          ),
                          const Text('Guardar'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.comment_outlined),
                            onPressed: () {},
                          ),
                          const Text('Comentar'),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nombre del Usuario',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '@nombreusuario',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Seguir',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Comentarios',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCommentItem(),
                  _buildCommentItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Usuario',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Este es un comentario en el pin'),
                const SizedBox(height: 4),
                Text(
                  'Hace 2 horas',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
