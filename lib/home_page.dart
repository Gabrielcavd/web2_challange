import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web2_challange/papel.dart';
import 'package:web2_challange/usuario.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void getPapeis() async {
    var url = 'http://localhost:8080/papeis';
    var response = await http.get(Uri.parse(url));
    String jsonsDataString = response.body.toString();
    List<dynamic> json = jsonDecode(jsonsDataString);
    json.forEach((element) {
      setState(() {
        checkboxList.add(Papel.fromJson(element));
      });
    });
  }

  Future<void> getUsuarios() async {
    var url = 'http://localhost:8080/usuarios';
    var response = await http.get(Uri.parse(url));
    String jsonsDataString = response.body.toString();
    List<dynamic> json = jsonDecode(jsonsDataString);
    listaUsuarios = [];
    json.forEach((element) {
      setState(() {
        listaUsuarios.add(Usuario.fromJson(element));
      });
    });
  }

  void buttonCadastro() async {
    bool validadeCheckboxList =
        checkboxList.any((element) => element.value == true);
    if (nomeUsuario.text != "" && validadeCheckboxList) {
      await postUsuario();
      await getUsuarios();
      nomeUsuario.clear();
      checkboxList.forEach((element) {
        element.value = false;
      });
    }
  }

  Future<void> postUsuario() async {
    final random = Random();
    final url = Uri.parse('http://localhost:8080/usuarios');

    final selectedPapeis =
        checkboxList.where((element) => element.value).toList();
    final papeis = selectedPapeis
        .map((element) => {
              "id": element.id,
              "dataCadastro": element.dataCadastro,
              "descricao": element.descricao,
            })
        .toList();

    final headers = {'Content-Type': 'application/json'};
    final now = DateTime.now();

    // Formatando a data atual no formato "ddMMyyyy"
    final formattedDate = DateFormat('ddMMyyyy').format(now);
    final body = jsonEncode({
      "nome": nomeUsuario.text,
      "papeis": papeis,
      "id": random.nextInt(100),
      "dataCadastro": formattedDate,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("Usuário cadastrado com sucesso");
    } else {
      print(
          "Falha ao cadastrar o usuário. Código de status: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getPapeis();
    getUsuarios();
  }

  List<Papel> checkboxList = [];
  List<Usuario> listaUsuarios = [];

  TextEditingController nomeUsuario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cadastro de Usuários"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Informações do usuário",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: TextField(
                    controller: nomeUsuario,
                    decoration: InputDecoration(
                      label: Text("Nome Completo"),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Selecione os papeis do usuário",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary),
                ),
                ...checkboxList.map(
                  (element) => CheckboxListTile(
                    fillColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      element.descricao,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    value: element.value,
                    onChanged: (value) {
                      setState(() {
                        element.value = value!;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: buttonCadastro,
                  child: Text("Cadastrar"),
                ),
                ...listaUsuarios.map(
                  (usuario) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        usuario.nome,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...usuario.papeis.map(
                            (papel) => Text(
                              papel.descricao,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
