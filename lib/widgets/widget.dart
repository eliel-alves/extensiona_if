import 'dart:async';

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
    Text(firstText,
        style: AppTheme.typo.regular(16, AppTheme.colors.dark, 1, 0)),
    TextButton(
        //style: TextButton.styleFrom(primary: AppTheme.colors.blue),
        onPressed: setFormAction,
        child: Text(secondText,
            style: AppTheme.typo.bold(16, AppTheme.colors.blue, 1, 0))),
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
          onTap: onTap,
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
        Text('Sem demandas',
            style: AppTheme.typo.defaultBoldText, textAlign: TextAlign.center),
        Utils.addVerticalSpace(15),
        Text('Você ainda não possui demandas cadastradas',
            style: AppTheme.typo.defaultText, textAlign: TextAlign.center),
        Utils.addVerticalSpace(20),
        ElevatedButton(
          onPressed: () async {
            var userRef = await FirebaseFirestore.instance
                .collection('USUARIOS')
                .doc(authService.userId())
                .get();

            var userInfo = Users.fromJson(userRef.data());

            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, '/formDemanda',
                arguments:
                    DemandaArguments(editarDemanda: false, usuario: userInfo));
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(16))),
          child: Text('Cadastrar Agora', style: AppTheme.typo.button),
        )
      ],
    );
  }
}

class VerifyEmailContent extends StatefulWidget {
  final String userEmail;
  final Function onPressed;
  final Function onPressedCancel;
  final int start;

  const VerifyEmailContent(
      {Key key,
      this.userEmail,
      this.onPressed,
      this.onPressedCancel,
      this.start})
      : super(key: key);

  @override
  State<VerifyEmailContent> createState() => _VerifyEmailContentState();
}

class _VerifyEmailContentState extends State<VerifyEmailContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Verifique o seu endereço de email',
            style: AppTheme.typo.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Utils.addVerticalSpace(40),
              Image.asset(
                'lib/assets/img/verifyEmail.png',
                width: 300,
                alignment: Alignment.center,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image_rounded),
                      Utils.addHorizontalSpace(5),
                      Text(
                        'Erro ao carregar a imagem.',
                        style: AppTheme.typo.defaultText,
                      )
                    ],
                  );
                },
              ),
              Utils.addVerticalSpace(40),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: AppTheme.typo.defaultText,
                      children: <TextSpan>[
                        const TextSpan(
                            text:
                                'Um link de verificação de email foi enviado para o endereço '),
                        TextSpan(
                            text: widget.userEmail,
                            style: AppTheme.typo.defaultBoldText)
                      ])),
              Utils.addVerticalSpace(20),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: AppTheme.typo.defaultText,
                      children: <TextSpan>[
                        const TextSpan(
                            text:
                                'Caso não esteja na caixa de entrada, verifique sua '),
                        TextSpan(
                            text: 'caixa de spam. ',
                            style: AppTheme.typo.defaultBoldText),
                        const TextSpan(text: 'Certamente estará lá.'),
                      ])),
              Utils.addVerticalSpace(20),
              if (widget.start != 0) ...[
                Text(
                  'O reenvio será habilidado em ${Utils.strDigits(widget.start)} s',
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.defaultText,
                ),
                Utils.addVerticalSpace(5),
              ],
              ElevatedButton.icon(
                  icon: const Icon(Icons.email_rounded),
                  label: Text('Reenviar Email', style: AppTheme.typo.button),
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20))),
                  onPressed: widget.onPressed),
              Utils.addVerticalSpace(15),
              ElevatedButton(
                  onPressed: widget.onPressedCancel,
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20))),
                  child: Text('Cancelar', style: AppTheme.typo.button))
            ],
          ),
        ),
      ),
    );
  }
}
