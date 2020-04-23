import 'package:agenda_contatos/Helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'personal_widget.dart';

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
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          gatilhoContactPage(context, helper, setState: obtenhaTodosContatos );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length, 
          itemBuilder: (contexto, index) {
            return cardContato(contatos[index], contexto, helper, setState: obtenhaTodosContatos);
          }),
    );
  }

  void obtenhaTodosContatos(){
    helper.obtenhaTodosContatos().then((data){
      setState(() {
        contatos = data;
      });
    });
  }
}
