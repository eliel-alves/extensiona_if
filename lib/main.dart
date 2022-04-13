import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/route/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (context) => UserDAO(),
        child: const ExtensionaApp(),
        ),

        StreamProvider(
          create: (context) => context.read<UserDAO>().authState, initialData: null,
        )
      ],
      child: const ExtensionaApp()
    )
  );
}

class ExtensionaApp extends StatelessWidget {
  const ExtensionaApp({Key key}) : super(key: key);

  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexColorScheme.light(scheme: FlexScheme.green).toTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
