import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/screens/login.dart';
import 'package:dotted_border/dotted_border.dart';

class IconesMedia extends StatelessWidget {
  final String imgMedia;
  final Function press;
  final String text;
  final double paddingRight;
  final double paddingLight;

  const IconesMedia(this.imgMedia, this.press, this.text, this.paddingRight, this.paddingLight);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(2),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Colors.grey
          ),
          borderRadius: BorderRadius.circular(30),
          shape: BoxShape.rectangle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgMedia,
              width: 30,
              height: 30,
            ),

            Padding(
              padding: EdgeInsets.only(right: paddingRight, left: paddingLight),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

}

class Divisor extends StatelessWidget {
  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
   // Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          _buildDivisor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Ou",
              style: GoogleFonts.cabin(textStyle: styleText, color: Colors.black),
            ),
          ),
          _buildDivisor(),
        ],
      ),
    );
  }

  Expanded _buildDivisor() {
    return const Expanded(
        child: Divider(
          color: Colors.grey,
          height: 1.5,
        )
    );
  }
}


class RetornarPageLogin extends StatelessWidget {

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Já possui uma conta?',
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),

            GestureDetector(
              onTap: () {
                debugPrint('Página de cadastro');

                Navigator.pop(context, MaterialPageRoute(builder: (context) => const Login(),
                ));
              },

              child: Text(
                  'Conecte-se',
                  style: GoogleFonts.cabin(textStyle: styleText, color: Colors.black)),
            )

          ]),
    );
  }

}

class AppBarLogo extends StatelessWidget {
  final TextStyle styleTextTitle;

  const AppBarLogo(this.styleTextTitle);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Image.asset(
          'lib/assets/img/logo.png',
          width: 240,
        ),
        const SizedBox(height: 20),
        Text(
          'Escola de Extensão do IFSul',
          style: GoogleFonts.cabin(textStyle: styleTextTitle),
        ),
      ],
    );
  }

}

class AppBarLogoUser extends StatelessWidget {
  final TextStyle styleTextTitle;
  final String userPhoto;
  final String emailUser;

  const AppBarLogoUser(this.styleTextTitle, this.userPhoto, this.emailUser);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [

        DottedBorder(
          color: Colors.white,
        borderType: BorderType.Rect,
        strokeWidth: 1,
        dashPattern: const [5, 4],
        strokeCap: StrokeCap.round,
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(2),
          child: Image.asset(
            userPhoto,
            width: 70,
          ),
        ),
        ),


        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            emailUser,
            style: GoogleFonts.cabin(textStyle: styleTextTitle),
          ),
        ),
      ],
    );
  }

}

class LogoWelcomeScreen extends StatelessWidget {
  final TextStyle styleTextTitle;

  const LogoWelcomeScreen(this.styleTextTitle);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Image.asset(
            'lib/assets/img/logo_verde.png',
            width: size.width * 0.9,
          ),
          const SizedBox(height: 20),
          Text(
            'Escola de Extensão do IFSul',
            style: GoogleFonts.cabin(textStyle: styleTextTitle),
          ),
        ],
      ),
    );
  }

}

class Buttons extends StatelessWidget {

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final Function press;

  final String text;

  final Color color;

  final Color letterColor;

  final Color borderColor;

  Buttons(this.press, this.text, this.color, this.letterColor, this.borderColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: ElevatedButton(
        onPressed: press,
        child: Text(text, style: GoogleFonts.roboto(textStyle: styleText, color: letterColor)),
        style: ElevatedButton.styleFrom(
          primary: color,
            side: BorderSide(
            color: borderColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            )
        ),
      ),
    );
  }

}


