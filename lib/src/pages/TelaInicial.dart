import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/componentes/buscar.dart';
import 'package:flutteraplicativo/src/componentes/cabecalho.dart';
import 'package:flutteraplicativo/src/componentes/cardProduto.dart';
import 'package:flutteraplicativo/src/componentes/categorias.dart';


class TelaInicial extends StatefulWidget{
  var _cpf;

  TelaInicial(cpf) {
    this._cpf = cpf;

  }
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  AreaCategoria area = new AreaCategoria("");

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: ListView(
        padding:EdgeInsets.only(left:20.0, top:30.0, right:20.0),
        children: <Widget>[
          Cabecalho(),
          AreaCategoria(widget._cpf),
          Buscar(widget._cpf),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Produtos Mais Vendidos",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("Precionou' pressed");
                },
                child: Text(
                  "Ver Todos",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Column(
              children: <Widget>[
                CardProduto(460.0, 340.0, "", "", widget._cpf)
              ],
          )
        ],
      ),
    );
  }



}