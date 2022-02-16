import 'package:flutter/material.dart';
import 'package:extensiona_if/components/item_demanda.dart';

class ListaDemanda extends StatelessWidget {
  const ListaDemanda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demandas Criadas"),
        centerTitle: true,
      ),

      body: ItemDemanda(),
    );
  }
}

