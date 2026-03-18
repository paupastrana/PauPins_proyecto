// Este archivo puede ser usado en el futuro para centralizar las rutas de la aplicación
// Implementar una vez que se agregue un sistema de routing más robusto como go_router

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/create_pin_screen.dart';

class AppRoutes {
  // Rutas de la aplicación
  static const String home = '/';
  static const String search = '/search';
  static const String profile = '/profile/:userId';
  static const String pinDetail = '/pin/:pinId';
  static const String createPin = '/create';
  static const String editPin = '/edit/:pinId';
  static const String boardDetail = '/board/:boardId';
  static const String login = '/login';
  static const String register = '/register';
  static const String splash = '/splash';

  // Método para generar rutas dinámicas
  static String profileRoute(String userId) => '/profile/$userId';
  static String pinDetailRoute(String pinId) => '/pin/$pinId';
  static String editPinRoute(String pinId) => '/edit/$pinId';
  static String boardDetailRoute(String boardId) => '/board/$boardId';

  // Definición de rutas para MaterialApp
  // Se puede usar con go_router o Navigator en el futuro
  static final routes = <String, WidgetBuilder>{
    home: (context) => const HomeScreen(),
    search: (context) => const SearchScreen(),
    createPin: (context) => const CreatePinScreen(),
  };

  // TODO: Implementar con go_router para mejor manejo de rutas
  // static final GoRouter goRouter = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       builder: (context, state) => const HomeScreen(),
  //     ),
  //     GoRoute(
  //       path: '/search',
  //       builder: (context, state) => const SearchScreen(),
  //     ),
  //     // ... más rutas
  //   ],
  // );
}
