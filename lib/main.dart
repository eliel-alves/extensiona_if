import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/meu_aplicativo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          projectId: 'sis-extensao',
          appId: '1:280548324802:web:34b9a1b6dc7d5070f9125b',
          messagingSenderId: '280548324802',
          apiKey: 'AIzaSyAGsXFLecU1vGnyxiLN5efdVNqmf1Nf-DI'
      ),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDAO()),
        // ChangeNotifierProvider(
        // create: (context) => UserDAO(),
        // child: const ExtensionaApp(),
        // ),
        //
        // StreamProvider(
        //   create: (context) => context.read<UserDAO>().authState, initialData: null,
        // )
      ],
      child: const ExtensionaApp()
    )
  );
}

