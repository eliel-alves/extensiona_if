class Demandas {
  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String resultadosEsperados;
  final String areaTematica;
  final String vinculo;
  final String propostaConjunto;
  final String dadosProponente;
  final String empresaEnvolvida;
  final String equipeColaboradores;
  final String localidade;
  final String docId;
  final bool editarDemanda;
  final Users usuario;

  Demandas(
      {this.titulo,
      this.tempo,
      this.resumo,
      this.objetivo,
      this.contrapartida,
      this.resultadosEsperados,
      this.areaTematica,
      this.vinculo,
      this.propostaConjunto,
      this.dadosProponente,
      this.empresaEnvolvida,
      this.equipeColaboradores,
      this.docId,
      this.editarDemanda,
      this.localidade,
      this.usuario});

  @override
  String toString() {
    return "Demanda($titulo, $resumo, $objetivo, $contrapartida, $resultadosEsperados)";
  }

  ///Método responsável por acessar as informações dos campos dos documentos cadastrados no Firebase
  // Demandas.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //
  //   titulo = data['titulo'];
  //   tempo = data['tempo'];
  //   resultadosEsperados = data['resultados_esperados'];
  //   resumo = data['resumo'];
  //   objetivo = data['objetivo'];
  //   contrapartida = data['contrapartida'];
  //   areaTematica = data['area_tematica'];
  //   vinculo = data['vinculo'];
  //   userID = data['usuario'];
  //   docId = snapshot.id;
  // }
}

class AreaTematica {
  final int id;
  final String name;

  AreaTematica({
    this.id,
    this.name,
  });
}

class Users {
  Users(this.userId, this.email, this.tipo, this.userName, this.userPhone,
      this.userPhoto, this.userState, this.userCity, this.nomeArquivoFoto);

  Users.fromJson(Map<String, Object> json)
      : this(
            json['id'] as String,
            json['email'] as String,
            json['tipo'] as String,
            json['name'] as String,
            json['telefone'] as String,
            json['url_photo'] as String,
            json['estado'] as String,
            json['cidade'] as String,
            json['nome_arquivo_foto'] as String);

  final String userId;
  final String email;
  final String tipo;
  final String userName;
  final String userPhone;
  final String userPhoto;
  final String userState;
  final String userCity;
  final String nomeArquivoFoto;

  Map<String, Object> toJson() {
    return {
      'id': userId,
      'email': email,
      'tipo': tipo,
      'name': userName,
      'telefone': userPhone,
      'url_photo': userPhoto,
      'estado': userState,
      'cidade': userCity,
      'nome_arquivo_foto': nomeArquivoFoto
    };
  }
}
