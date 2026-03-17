import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_pin_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/saved_screen.dart';
import 'constants/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';//supabase
// void main() {
//   runApp(const MyApp());
// }


//para la configuración de Supabase, es necesario inicializarlo antes de ejecutar la app, por eso se hace en el main() y se asegura que los bindings estén inicializados con WidgetsFlutterBinding.ensureInitialized()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zlnejgjgtowhzrxvnmqy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsbmVqZ2pndG93aHpyeHZubXF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0Nzc0MDYsImV4cCI6MjA4ODA1MzQwNn0.eHnDkosRbbcnS_XDLICUoBgLDwI7LWik8ZCwJcb9O9g', // La encuentras en Settings > API
  );

  runApp(MyApp());
}

// Ejemplo de función para registrar un nuevo usuario con email y password
Future<void> signUp() async {
  try {
    await supabase.auth.signUp(
      email: 'usuario@email.com',
      password: 'password123',
    );
    // Si sale bien, el Trigger que creamos en la DB ya le hizo su Profile automáticamente
  } catch (e) {
    print("Error al registrar: $e");
  }
}

// Acceso global al cliente
final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(AppConstants.primaryColor),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(AppConstants.backgroundColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(AppConstants.primaryColor),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const MainApp(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final GlobalKey _homeScreenKey = GlobalKey();
  final GlobalKey _savedScreenKey = GlobalKey();
  final GlobalKey _profileScreenKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(key: _homeScreenKey),
      const SearchScreen(),
      const CreatePinScreen(),
      SavedScreen(key: _savedScreenKey),
      ProfileScreen(key: _profileScreenKey),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Refrescar HomeScreen cuando se selecciona la pestaña de inicio (índice 0)
          if (index == 0) {
            final state = _homeScreenKey.currentState;
            if (state != null) {
              (state as dynamic).refresh();
            }
          }
          // Refrescar SavedScreen cuando se selecciona la pestaña de guardados (índice 3)
          if (index == 3) {
            final state = _savedScreenKey.currentState;
            if (state != null) {
              (state as dynamic).refresh();
            }
          }
          // Refrescar ProfileScreen cuando se selecciona la pestaña de perfil (índice 4)
          if (index == 4) {
            final state = _profileScreenKey.currentState;
            if (state != null) {
              (state as dynamic).refresh();
            }
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}
