import 'package:agenda_contatos/Helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'personal_widget.dart';

enum OpcoesOrdenacao {
  ordenarAZ,
  ordenarZA,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = new ContactHelper();
  List<Contact> contatos = List();

  @override
  void initState() {
    super.initState();
    obtenhaTodosContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OpcoesOrdenacao>(
            itemBuilder: (context) => <PopupMenuEntry<OpcoesOrdenacao>>[
              const PopupMenuItem<OpcoesOrdenacao>(
                child: Text("Ordenar de A-Z"),
                value: OpcoesOrdenacao.ordenarAZ,
              ),
              const PopupMenuItem<OpcoesOrdenacao>(
                child: Text("Ordenar de Z-A"),
                value: OpcoesOrdenacao.ordenarZA,
              ),
            ],
            onSelected: _ordenaLista,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          gatilhoContactPage(context, helper, setState: obtenhaTodosContatos);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length,
          itemBuilder: (contexto, index) {
            return cardContato(contatos[index], contexto, helper,
                setState: obtenhaTodosContatos);
          }),
    );
  }

  void obtenhaTodosContatos() {
    helper.obtenhaTodosContatos().then((data) {
      setState(() {
        contatos = data;
      });
    });
  }

  void _ordenaLista(OpcoesOrdenacao resultado) {
    switch (resultado) {
      case OpcoesOrdenacao.ordenarAZ:
        contatos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OpcoesOrdenacao.ordenarZA:
        contatos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
