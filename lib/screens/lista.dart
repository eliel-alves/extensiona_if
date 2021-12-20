import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/screens/form.dart';

class ItemDemanda extends StatelessWidget {

  final Demanda _demanda;
  const ItemDemanda(this._demanda);
  
  String formatDate(DateTime date) => DateFormat("dd/MM/yyyy").format(date);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200, width: 1),
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.description_outlined, size: 36.0),
              title: Text(
                  this._demanda.titulo,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  )
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14.0, color: Colors.lightBlue),
                  const VerticalDivider(width: 5),
                  Text(formatDate(
                      this._demanda.data),
                      style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600
                      )
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 0.0, right: 16.0, left: 16.0, bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.turned_in_not, size: 16.0, color: Colors.lightGreen),
                  const VerticalDivider(width: 5),
                  Text(
                      this._demanda.status == 'C' ? 'Cadastrada' : this._demanda.status,
                      style: TextStyle(color: Colors.grey.shade500)
                  ),

                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.black
                  ),

                  const Icon(Icons.timer_outlined, size: 16.0, color: Colors.purple),
                  const VerticalDivider(width: 5),
                  Text(
                      this._demanda.tempo,
                      style: TextStyle(color: Colors.grey.shade500)
                  )
                ],
              )
            )
          ],
        ),
    );
  }

}

class ListaDemanda extends StatefulWidget {

  final List<Demanda> _demandas = [];

  @override
  State<StatefulWidget> createState() {
    return ListaDemandaState();
  }

}

class ListaDemandaState extends State<ListaDemanda> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Demandas"),
        ),

        floatingActionButton: buildMessageButton(),

        /*floatingActionButton: FloatingActionButton(
            onPressed: () {
              final Future future = Navigator.push(context, MaterialPageRoute(builder: (context){
                return FormDemanda();
              }));

              future.then((demanda) {
                debugPrint("Retornou do Form");
                debugPrint('$demanda');
                setState(() {
                  widget._demandas.add(demanda);
                });
              });
            },
            child: const Icon(Icons.add)
        ),*/

        body: ListView.builder(
            itemCount: widget._demandas.length,
            itemBuilder: (context, indice) {
              final demanda = widget._demandas[indice];
              return ItemDemanda(demanda);
        })
    );
  }

  Widget buildMessageButton() => FloatingActionButton.extended(
    label: const Text('Nova Demanda'),
    backgroundColor: Colors.green,
    hoverColor: Colors.black87,
    tooltip: 'Cadastrar nova Demanda',
    onPressed: () {
      final Future future = Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FormDemanda();
      }));
      future.then((demanda){
        debugPrint('Retornou do Form');
        debugPrint('$demanda');
        setState(() {
          widget._demandas.add(demanda);
        });
      });
    },
  );

}
