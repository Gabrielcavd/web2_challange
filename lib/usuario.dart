import 'package:web2_challange/papel.dart';

class Usuario {
  String nome;
  List<Papel> papeis;
  int id;
  String dataCadastro;

  Usuario(
      {required this.nome,
      required this.papeis,
      required this.id,
      required this.dataCadastro});

  factory Usuario.fromJson(Map<String, dynamic> mapa) {
    List<dynamic> generico = mapa['papeis'];
    List<Papel> papeis = [];

    papeis = generico
        .map(
          (element) => Papel(
              id: element['id'],
              dataCadastro: element['dataCadastro'],
              descricao: element['descricao']),
        )
        .toList();

    return Usuario(
        nome: mapa['nome'],
        papeis: papeis,
        id: mapa['id'],
        dataCadastro: mapa['dataCadastro'].toString());
  }
}
