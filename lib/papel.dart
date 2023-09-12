class Papel {
  int id;
  String dataCadastro;
  String descricao;
  bool value;

  Papel(
      {required this.id,
      required this.dataCadastro,
      required this.descricao,
      this.value = false});

  factory Papel.fromJson(Map<String, dynamic> mapa) {
    return Papel(
        id: mapa['id'],
        dataCadastro: mapa['dataCadastro'],
        descricao: mapa['descricao']);
  }

  String getDescricao() => descricao;
}
