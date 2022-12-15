import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ListTileOptions extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onTap;

  const ListTileOptions({Key key, this.icone, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListTile(
          leading: Icon(icone),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  fontSize: 15)),
          onTap: onTap,
          iconColor: AppTheme.colors.blue,
          textColor: AppTheme.colors.dark,
        ),
      );
}

class ListTileFiles extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onPressed;

  const ListTileFiles({Key key, this.icone, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        trailing: IconButton(
          icon: const Icon(Icons.highlight_remove_rounded),
          onPressed: onPressed,
        ),
        title: Text(title),
      );
}

class AppBarLogo extends StatelessWidget {
  final String titulo;

  const AppBarLogo(this.titulo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'lib/assets/svg/extensiona-logo-light.svg',
          width: 220,
        ),
        Utils.addVerticalSpace(10),
        Text(
          titulo,
          style: AppTheme.typo.defaultText,
        ),
      ],
    );
  }
}

Widget toggleButton(
    String firstText, String secondText, Function setFormAction) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Text(firstText, style: AppTheme.typo.defaultText),
    TextButton(
        //style: TextButton.styleFrom(primary: AppTheme.colors.blue),
        onPressed: setFormAction,
        child: Text(secondText, style: AppTheme.typo.defaultBoldText)),
  ]);
}

class Options extends StatelessWidget {
  final String title;
  final String titleContent;
  final Function onTap;
  final bool editImage;
  final bool isDeleteAccountOption;

  const Options(
      this.titleContent, this.editImage, this.onTap, this.isDeleteAccountOption,
      {Key key, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: AppTheme.colors.offWhite,
            width: 2.0,
          ),
        ),
        elevation: 0,
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //textBaseline: TextBaseline.alphabetic,
                  children: [
                    isDeleteAccountOption
                        ? const Icon(Icons.delete_forever_rounded)
                        : Text(title, style: AppTheme.typo.title),
                    Utils.addHorizontalSpace(15),
                    Text(titleContent, style: AppTheme.typo.defaultText),
                  ],
                ),
                editImage
                    ? const Icon(Icons.camera_alt_rounded)
                    : const Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          onTap: onTap,
        ));
  }
}

Future<void> popupBox(context, title, content, onPressed) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          backgroundColor: AppTheme.colors.lightGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('PRÓXIMO'),
            )
          ],
        );
      });
}

class CardInfo extends StatefulWidget {
  final String titulo;
  final String conteudo;
  final Function onTap;

  const CardInfo({Key key, this.titulo, this.conteudo, this.onTap})
      : super(key: key);

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: AppTheme.colors.offWhite,
          width: 2.0,
        ),
      ),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.titulo, style: AppTheme.typo.title),
            ListTile(
                title: Text(widget.conteudo, style: AppTheme.typo.defaultText),
                trailing: const Icon(Icons.edit),
                onTap: widget.onTap)
          ],
        ),
      ),
    );
  }
}

class EmptyStateUi extends StatelessWidget {
  const EmptyStateUi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDAO authService = Provider.of<UserDAO>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/assets/img/empty-folder.png', width: 250),
        Utils.addVerticalSpace(40),
        Text('Sem demandas', style: AppTheme.typo.defaultBoldText),
        Utils.addVerticalSpace(15),
        Text('Você ainda não possui demandas cadastradas',
            style: AppTheme.typo.defaultText),
        Utils.addVerticalSpace(20),
        ElevatedButton(
          onPressed: () async {
            var userRef = await FirebaseFirestore.instance
                .collection('USUARIOS')
                .doc(authService.userId())
                .get();

            var userInfo = Users.fromJson(userRef.data());

            Navigator.pushNamed(context, '/formDemanda',
                arguments:
                    DemandaArguments(editarDemanda: false, usuario: userInfo));
          },
          child: Text('Cadastrar Agora', style: AppTheme.typo.button),
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(16))),
        )
      ],
    );
  }
}

// class IconesMedia extends StatelessWidget {
//   final String imgMedia;
//   final Function press;
//   final String text;
//   final double paddingRight;
//   final double paddingLight;

//   const IconesMedia(this.imgMedia, this.press, this.text, this.paddingRight,
//       this.paddingLight,
//       {Key key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: press,
//       child: Container(
//         padding: const EdgeInsets.all(2),
//         width: size.width * 0.8,
//         decoration: BoxDecoration(
//           border: Border.all(width: 1, color: Colors.grey),
//           borderRadius: BorderRadius.circular(30),
//           shape: BoxShape.rectangle,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               imgMedia,
//               width: 30,
//               height: 30,
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: paddingRight, left: paddingLight),
//               child: Text(text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Divisor extends StatelessWidget {
//   final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

//   const Divisor({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Size size = MediaQuery.of(context).size;

//     return SizedBox(
//       width: double.infinity,
//       child: Row(
//         children: <Widget>[
//           _buildDivisor(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Text(
//               "Ou",
//               style:
//                   GoogleFonts.cabin(textStyle: styleText, color: Colors.black),
//             ),
//           ),
//           _buildDivisor(),
//         ],
//       ),
//     );
//   }

//   Expanded _buildDivisor() {
//     return const Expanded(
//         child: Divider(
//       color: Colors.grey,
//       height: 1.5,
//     ));
//   }
// }
