import 'package:flutter/material.dart';
import 'package:extensiona_if/components/item_demanda.dart';
import 'package:extensiona_if/theme/app_theme.dart';

class ListaDemanda extends StatelessWidget {
  const ListaDemanda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas propostas", style: AppTheme.typo.title),
      ),

      body: const ItemDemanda(),
    );
  }
}

