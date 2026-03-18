import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/pin_card.dart';

class BoardDetailsScreen extends StatefulWidget {
  final String boardId;
  final String boardTitle;

  const BoardDetailsScreen({
    Key? key, 
    required this.boardId, 
    required this.boardTitle
  }) : super(key: key);

  @override
  State<BoardDetailsScreen> createState() => _BoardDetailsScreenState();
}

class _BoardDetailsScreenState extends State<BoardDetailsScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _pinsInBoard = [];

  @override
  void initState() {
    super.initState();
    _fetchBoardPins();
  }

  Future<void> _fetchBoardPins() async {
    try {
      //traer pins
      final response = await supabase
          .from('board_pins')
          .select('pins(*)')
          .eq('board_id', widget.boardId);

      setState(() {
        _pinsInBoard = (response as List)
            .map((item) => item['pins'] as Map<String, dynamic>)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando pines del board: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE60023)))
          : _pinsInBoard.isEmpty
              ? const Center(child: Text('Este tablero no tiene pines aún'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _pinsInBoard.length,
                  itemBuilder: (context, index) {
                    final pin = _pinsInBoard[index];
                    return PinCard(
                      imageUrl: pin['image_url'] ?? '',
                      title: pin['title'] ?? '',
                      onTap: () {
                       
                      },
                    );
                  },
                ),
    );
  }
}