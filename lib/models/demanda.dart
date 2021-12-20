class Demanda {
  final String titulo;
  final DateTime data;
  final String tempo;
  final String resumo;
  final String status;
  final String objetivo;
  final String contrapartida;
  final String vinculo;

  Demanda(this.titulo, this.data, this.tempo, this.resumo, this.status, this.objetivo, this.contrapartida, this.vinculo);

  @override
  String toString() {
    return 'Demanda(titulo: $titulo, data: $data, tempo: $tempo, resumo: $resumo, status: $status, objetivo: $objetivo, contrapartida: $contrapartida, vinculo: $vinculo)';
  }
}