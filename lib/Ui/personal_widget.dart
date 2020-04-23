import 'dart:io';
import 'dart:ui';
import 'package:agenda_contatos/Helpers/contact_helper.dart';
import 'package:agenda_contatos/Ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      gatilhoContactPage(contexto, helper, contato: contato, setState: setState);
    },
  );
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
    if(setState != null) setState();
}

TextStyle _textStyleElementosCard() =>
    TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
