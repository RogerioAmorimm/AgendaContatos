import 'package:agenda_contatos/Helpers/contact_helper.dart';
import 'package:agenda_contatos/Ui/personal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contato;

  ContactPage({this.contato});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _numeroTelefoneController = TextEditingController();
  final _focoCampoNome = new FocusNode();

  bool _contatoEditado = false;
  Contact contatoEditavel;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      contatoEditavel = new Contact();
    } else {
      contatoEditavel = widget.contato;
      setControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _chamaPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(contatoEditavel.nome ?? ""),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (contatoEditavel.nome != null &&
                  contatoEditavel.nome.isNotEmpty) {
                Navigator.pop(context, contatoEditavel);
              } else {
                FocusScope.of(context).requestFocus(_focoCampoNome);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    child: construtorImagenContato(contatoEditavel.img,
                        largura: 140.0, altura: 140.0),
                    onTap: () {
                      construtorOpcoes(context, widgets: [
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: FlatButton(
                                child: Text("Galeria",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20.0)),
                                onPressed: () {
                                  ImagePicker.pickImage(
                                          source: ImageSource.gallery)
                                      .then((imagem) {
                                    if (imagem != null) {
                                      setState(() {
                                        contatoEditavel.img = imagem.path;
                                      });
                                    }
                                    Navigator.pop(context);
                                  });
                                })),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: FlatButton(
                                child: Text("Camera",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20.0)),
                                onPressed: () {
                                  ImagePicker.pickImage(
                                          source: ImageSource.camera)
                                      .then((imagem) {
                                    if (imagem != null) {
                                      setState(() {
                                        contatoEditavel.img = imagem.path;
                                      });
                                    }
                                    Navigator.pop(context);
                                  });
                                }))
                      ]);
                    }),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    setState(() {
                      _contatoEditado = true;
                      contatoEditavel.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  onChanged: (text) {
                    _contatoEditado = true;
                    contatoEditavel.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _numeroTelefoneController,
                  decoration: InputDecoration(labelText: "Telefone"),
                  onChanged: (text) {
                    _contatoEditado = true;
                    contatoEditavel.numeroTelefone = text;
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _chamaPop() {
    if (_contatoEditado) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações ?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    } else
      return Future.value(true);
  }

  void setControllers() {
    _nomeController.text = contatoEditavel.nome;
    _emailController.text = contatoEditavel.email;
    _numeroTelefoneController.text = contatoEditavel.numeroTelefone;
  }
}
