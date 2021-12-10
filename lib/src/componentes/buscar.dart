import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/componentes/cardProduto.dart';
import 'package:flutteraplicativo/src/pages/produtosPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Buscar extends StatelessWidget {
  var _cpf;

  Buscar(cpf) {
    this._cpf = cpf;
    }
    var dados;

   var txtbuscar = new TextEditingController();
  @override
  Widget build(BuildContext context){
    return Material(
      //elevation: 5.0,
      child: TextFormField(
          controller: txtbuscar,
          style:TextStyle(color: Colors.black, fontSize: 16.0),
          cursorColor: Theme.of(context).primaryColor,
          decoration:InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
              suffixIcon: Material(
                  //elevation: 2.0,

                  child: IconButton(
                    icon:Icon(
                    Icons.search,
                    color: Colors.black,
                    ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => produtosPage(txtbuscar.text, "", this._cpf)
                        ));
                      })

              ),
              //border:InputBorder.none,
              hintText: "Buscar Produtos"
          )
      ),
    );
  }

}
