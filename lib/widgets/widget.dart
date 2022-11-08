import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListTileOptions extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onTap;

  const ListTileOptions({Key key, this.icone, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListTile(
          leading: Icon(icone),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter', fontSize: 15)),
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
        addVerticalSpace(10),
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
                    addHorizontalSpace(15),
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
