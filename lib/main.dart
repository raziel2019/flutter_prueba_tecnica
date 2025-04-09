import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Screens/home_screen.dart';
import 'package:prueba_tecnica/Screens/login_screen.dart';
import 'package:prueba_tecnica/Screens/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseUrl = dotenv.env['API_URL']!;
  final supabaseKey = dotenv.env['SUPABASE_KEY']!;
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
         