import 'dart:io';
import 'dart:ui';
import 'package:agenda_contatos/Helpers/contact_helper.dart';
import 'package:agenda_contatos/Ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//variaveis

Widget cardContato(Contact contato, BuildContext contexto, ContactHelper helper,
    {Function setState}) {
  return GestureDetector(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            construtorImagenContato(contato.img),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contato.nome ?? "",
                    style: _textStyleElementosCard(),
                  ),
                  Text(
                    contato.email ?? "",
                    style: _textStyleElementosCard(),
                  ),
                  Text(
                    contato.numeroTelefone ?? "",
                    style: _textStyleElementosCard(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    onTap: () {
      construtorOpcoes(contexto,
          setState: setState,
          widgets: [
            Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    onPressed: () {
                      launch("tel:${contato.numeroTelefone}");
                      Navigator.pop(contexto);
                    },
                    child: Text(
                      "Ligar",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ))),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(contexto);
                      gatilhoContactPage(contexto, helper,
                          contato: contato, setState: setState);
                    },
                    child: Text(
                      "Editar",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ))),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    onPressed: () {
                      helper.deletarContato(contato.id);
                      Navigator.pop(contexto);
                      setState();
                    },
                    child: Text(
                      "Excluir",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ))),
          ]);
    },
  );
}

// Nessa função precisa passar as opções para construção, em widgets
void construtorOpcoes(
    BuildContext contexto,
    {Function setState, List<Widget> widgets}) {
  showModalBottomSheet(
      context: contexto,
      builder: (contexto) {
        return BottomSheet(
          onClosing: () {},
          builder: (contexto) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              ),
            );
          },
        );
      });
}

Widget construtorImagenContato(String imagem, {double largura, double altura}) {
  return Container(
    width: largura == null ? 80.0 : largura,
    height: altura == null ? 80.0 : altura,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: imagem != null
                ? FileImage(File(imagem))
                : AssetImage("images/Google_Contacts_logo.png"))),
  );
}

void gatilhoContactPage(BuildContext contexto, ContactHelper helper,
    {Contact contato, Function setState}) async {
  var retorno = await Navigator.push(
      contexto,
      MaterialPageRoute(
          builder: (context) => ContactPage(
                contato: contato,
              )));

  if (retorno != null) {
    if (contato != null)
      await helper.updateContato(retorno);
    else
      await helper.salvaContato(retorno);
  }
  if (setState != null) setState();
}

TextStyle _textStyleElementosCard() =>
    TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
