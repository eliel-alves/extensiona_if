class Demandas{

  final String TituloProposta;
  final String TempoNecessario;
  final String Resumo;
  final String Objetivo;
  final String Contrapartida;
  final String ResutadosEsperados;

  Demandas(this.TituloProposta, this.TempoNecessario, this.Resumo, this.Objetivo, this.Contrapartida, this.ResutadosEsperados);

  @override
  String toString() {
    return "Demanda($TituloProposta, $TituloProposta, $Resumo, $Objetivo, $Contrapartida, $ResutadosEsperados)";
  }

}