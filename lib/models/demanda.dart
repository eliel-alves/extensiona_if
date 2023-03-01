class Demandas {
  Demandas(
    this.titulo,
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
    this.localidade,
  );

  Demandas.fromJson(Map<String, Object> json)
      : this(
            json['id'] as String,
            json['titulo'] as String,
            json['tempo'] as String,
            json['resumo'] as String,
            json['objetivo'] as String,
            json['contrapartida'] as String,
            json['resultados_esperados'] as String,
            json['area_tematica'] as String,
            json['vinculo'] as String,
            json['proposta_conjunto'] as String,
            json['dados_proponente'] as String,
            json['empresa_envolvida'] as String,
            json['equipe_colaboradores'] as String,
            json['localidade'] as String);

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

  Map<String, Object> toJson() {
    return {
      'id': docId,
      'titulo': titulo,
      'tempo': tempo,
      'resumo': resumo,
      'objetivo': objetivo,
      'contrapartida': contrapartida,
      'resultados_esperados': resultadosEsperados,
      'area_tematica': areaTematica,
      'vinculo': vinculo,
      'proposta_conjunto': propostaConjunto,
      'dados_proponente': dadosProponente,
      'empresa_envolvida': empresaEnvolvida,
      'equipe_colaboradores': equipeColaboradores,
      'localidade': localidade
    };
  }
}

class DemandaArguments {
  final String? titulo;
  final String? tempo;
  final String? resumo;
  final String? objetivo;
  final String? contrapartida;
  final String? resultadosEsperados;
  final String? areaTematica;
  final String? vinculo;
  final String? propostaConjunto;
  final String? dadosProponente;
  final String? empresaEnvolvida;
  final String? equipeColaboradores;

  final String? docId;
  final bool editarDemanda;
  final Users usuario;

  DemandaArguments(
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
      required this.editarDemanda,
      required this.usuario});
}

class Users {
  Users(
      {required this.userId,
      required this.email,
      required this.tipo,
      required this.userName,
      required this.userPhone,
      required this.userPhoto,
      required this.userState,
      required this.userCity,
      required this.nomeArquivoFoto});

  Users.fromJson(Map<String, Object?> json)
      : this(
            userId: json['id']! as String,
            email: json['email']! as String,
            tipo: json['tipo']! as String,
            userName: json['name']! as String,
            userPhone: json['telefone']! as String,
            userPhoto: json['url_photo']! as String,
            userState: json['estado']! as String,
            userCity: json['cidade']! as String,
            nomeArquivoFoto: json['nome_arquivo_foto']! as String);

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
