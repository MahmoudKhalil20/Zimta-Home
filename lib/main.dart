import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Zimta/pages/mahmudhome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  await dotenv.load(); // Initialize flutter_dotenv

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zymta Home',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 255, 255, 255),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 255, 255), // Set your custom button color
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
         return const Mahmudhome();
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
