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
      this.localidade,
      this.docId,
      this.editarDemanda,
      this.usuario});

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
