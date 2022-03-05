import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:extensiona_if/screens/homepage_admin.dart';

class AdmApp extends StatefulWidget {
  const AdmApp({Key key}) : super(key: key);

  @override
  State<AdmApp> createState() => _AdmAppState();
}

class _AdmAppState extends State<AdmApp> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _valida = false;

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final styleTextTitle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          title: const AppBarLogo("Escola de Extensão do IFSul"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(45),
                child: Text(
                  'ADMINISTRADOR',
                  style: GoogleFonts.cabin(textStyle: styleTextTitle),
                ),
              ),

              //We are calling the EditorLogin to give our password and email
              EditorAuth(_emailController, 'Email', 'Email', const Icon(Icons.email_outlined), _valida, 25, false),

              const SizedBox(height: 10),

              EditorAuth(_passwordController, 'Senha','Senha', const Icon(Icons.lock_outline), _valida, 10, true),

              const SizedBox(height: 10),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _emailController.text.isEmpty ? _valida = true : _valida = false;
                      _passwordController.text.isEmpty ? _valida = true : _valida = false;
                    });

                    if(!_valida){
                      // userDao.login(_emailController.text, _passwordController.text);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen(),
                      ));
                    }
                  },
                  child: Text("ENTRAR", style: GoogleFonts.roboto(textStyle: styleText)),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29),
                      )
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}