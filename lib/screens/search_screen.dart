import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _selectedCategory;

  final List<String> _categories = [
    'Moda',
    'Viajes',
    'Comida',
    'Hogar',
    'Belleza',
    'Fitness',
    'Arte',
    'Tecnología',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Buscar en título y descripción (case-insensitive)
      final response = await supabase
          .from('pins')
          .select()
          .order('created_at', ascending: false);

      print('DEBUG: Total de pins obtenidos: ${(response as List).length}');

      // Filtrar resultados que contengan la consulta en título o descripción
      final results = (response as List)
          .where((pin) {
            final title = (pin['title'] as String?)?.toLowerCase() ?? '';
            final description = (pin['description'] as String?)?.toLowerCase() ?? '';
            final searchQuery = query.toLowerCase();
            
            print('DEBUG: Comparando "$searchQuery" con title: "$title", description: "$description"');
            
            return title.contains(searchQuery) || description.contains(searchQuery);
          })
          .cast<Map<String, dynamic>>()
          .toList();

      print('DEBUG: Resultados encontrados: ${results.length}');

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });

      // Guardar en historial
      if (!_searchHistory.contains(query)) {
        setState(() {
          _searchHistory.insert(0, query);
          if (_searchHistory.length > 10) {
            _searchHistory.removeLast();
          }
        });
      }
    } catch (e) {
      print('Error en búsqueda: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchByCategory(String category) async {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });

    try {
      // Buscar pines que contengan la categoría en título o descripción
      final response = await supabase
          .from('pins')
          .select()
          .order('created_at', ascending: false);

      print('DEBUG: Total de pins obtenidos: ${(response as List).length}');

      // Filtrar por categoría
      final results = (response as List)
          .where((pin) {
            final title = (pin['title'] as String?)?.toLowerCase() ?? '';
            final description = (pin['description'] as String?)?.toLowerCase() ?? '';
            final searchCategory = category.toLowerCase();
            
            print('DEBUG: Comparando categoría "$searchCategory" con title: "$title", description: "$description"');
            
            return title.contains(searchCategory) || description.contains(searchCategory);
          })
          .cast<Map<String, dynamic>>()
          .toList();

      print('DEBUG: Resultados encontrados para categoría: ${results.length}');

      setState(() {
        _searchResults = results;
        _searchController.text = category;
        _isLoading = false;
      });
    } catch (e) {
      print('Error en búsqueda por categoría: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (_searchController.text.isNotEmpty || _selectedCategory != null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResults = [];
                    _selectedCategory = null;
                  });
                },
              )
            : null,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar ...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchResults = [];
                        _selectedCategory = null;
                      });
                    },
                  )
                : const Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {});
            if (value.isNotEmpty) {
              _performSearch(value);
            }
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _performSearch(value);
            }
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _searchController.text.isEmpty && _selectedCategory == null
          ? _buildSearchHistory()
          : _buildSearchResults(),
    );
  }

  Widget _buildSearchHistory() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Búsquedas recientes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(_searchHistory[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _searchHistory.removeAt(index);
                      });
                    },
                  ),
                  onTap: () {
                    _searchController.text = _searchHistory[index];
                    _performSearch(_searchHistory[index]);
                  },
                );
              },
            ),
          ] else
            
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
              'Categorías populares',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: _categories
                  .map((category) => CategoryCard(
                        title: category,
                        onTap: () => _searchByCategory(category),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE60023)),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron resultados',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _selectedCategory = null;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60023),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final pin = _searchResults[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                color: Colors.grey[300],
                child: Image.network(
                  pin['image_url'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
              // Información del pin
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pin['title'] ?? 'Sin título',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFE60023), Color(0xFFD50000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
