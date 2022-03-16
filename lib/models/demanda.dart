import 'package:cloud_firestore/cloud_firestore.dart';

class Demandas{

  String TituloProposta;
  String TempoNecessario;
  String Resumo;
  String Objetivo;
  String Contrapartida;
  String ResutadosEsperados;
  String AreaTematica;
  String Vinculo;
  String userID;
  String docId;

  Demandas(
      this.TituloProposta,
      this.TempoNecessario,
      this.Resumo,
      this.Objetivo,
      this.Contrapartida,
      this.ResutadosEsperados,
      this.AreaTematica,
      this.Vinculo,
      this.userID,
      docId,
      );

  @override
  String toString() {
    return "Demanda($TituloProposta, $TituloProposta, $Resumo, $Objetivo, $Contrapartida, $ResutadosEsperados)";
  }


  ///Método responsável por acessar as informações dos campos dos documentos cadastrados no Firebase
  Demandas.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    TituloProposta = data['titulo'];
    TempoNecessario = data['tempo'];
    ResutadosEsperados = data['resultados_esperados'];
    Resumo = data['resumo'];
    Objetivo = data['objetivo'];
    Contrapartida = data['contrapartida'];
    AreaTematica = data['area_tematica'];
    Vinculo = data['vinculo'];
    userID = data['usuario'];
    docId = snapshot.id;
  }

}

class Users {
  String userId;
  String email;
  String tipo;
  String userName;
  String userPhone;
  String userPhoto;
  String docId;


  Users(
      this.userId,
      this.email,
      this.tipo,
      this.userName,
      this.userPhone,
      this.userPhoto,
      this.docId
      );

  ///Método responsável por acessar as informações dos campos dos documentos cadastrados no Firebase
  Users.fromSnapshot() {
    QueryDocumentSnapshot userColection = FirebaseFirestore.instance.collection('USUARIOS').get() as QueryDocumentSnapshot<Object>;

    Map<String, dynamic> data = userColection.data() as Map<String, dynamic>;

    userId = data['id'];
    email = data['email'];
    tipo = data['tipo'];
    userName = data['name'];
    userPhone = data['telefone'];
    userPhoto = data['url_photo'];
    docId = userColection.id;
  }

}
