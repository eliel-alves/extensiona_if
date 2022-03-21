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

  Users(
      this.userId,
      this.email,
      this.tipo,
      this.userName,
      this.userPhone,
      this.userPhoto,
      );

  Users.fromJson(Map<String, Object> json)
      : this(
    json['id'] as String,
    json['email'] as String,
    json['tipo'] as String,
    json['name'] as String,
    json['telefone'] as String,
    json['url_photo'] as String,
  );

  final String userId;
  final String email;
  final String tipo;
  final String userName;
  final String userPhone;
  final String userPhoto;


  Map<String, Object> toJson() {
    return {
      'id': userId,
      'email': email,
      'tipo': tipo,
      'name': userName,
      'telefone': userPhone,
      'url_photo': userPhoto,
    };
  }
}