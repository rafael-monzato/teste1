  import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/config/config.dart';
import 'package:flutteraplicativo/src/pages/carrinhoPage.dart';
import 'package:flutteraplicativo/src/tabs/tabs.dart';
  import 'package:http/http.dart' as http;

  class CardCarrinho extends StatefulWidget{
    var _nome, _imagem, _valor, _categoria, _quantidade, _id_carrinho, _cpf;


    CardCarrinho(nome, valor, imagem, categoria, quantidade, id_carrinho, cpf) {
      this._nome = nome;
      this._imagem = imagem;
      this._valor = valor;
      this._categoria = categoria;
      this._quantidade = quantidade;
      this._id_carrinho = id_carrinho;
      this._cpf = cpf;

    }
    _CardCarrinhoState createState() =>  _CardCarrinhoState();
  }

  class _CardCarrinhoState extends State<CardCarrinho> {
    var conf = Configuracoes.url;

    var conf_site = Configuracoes.url_site;

    @override
    Widget build(BuildContext context) {

      excluirProduto(id){

        http.get(
            Uri.encodeFull(
                conf + "carrinho/excluir.php?id=${id}"),
            headers: {"Accept": "application/json"});

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Tabs(widget._cpf, "", "", "Carrinho")
        ));

      }


      addQuantidade(id){

        http.get(
            Uri.encodeFull(
                conf + "carrinho/addQuantidade.php?id=${id}"),
            headers: {"Accept": "application/json"});



        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Tabs(widget._cpf, "", "", "Carrinho")
        ));

      }

      removerQuantidade(id){

        http.get(
            Uri.encodeFull(
                conf + "carrinho/removerQuantidade.php?id=${id}"),
            headers: {"Accept": "application/json"});

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Tabs(widget._cpf, "", "", "Carrinho")
        ));

      }


      return Card(
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 45.0,
                      height: 73.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  addQuantidade(widget._id_carrinho);
                                },
                                child: Icon(Icons.keyboard_arrow_up,
                                    color: Color(0xFFD3D3D3))),
                            Text(
                              widget._quantidade,
                              style: TextStyle(fontSize: 18.0, color: Colors.grey),
                            ),
                            InkWell(
                                onTap: () {
                                  removerQuantidade(widget._id_carrinho);
                                },
                                child: Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xFFD3D3D3))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 70.0,
                      width: 70.0,
                      child:Image.network(widget._imagem),

                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget._nome,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "R\u{0024}" + widget._valor,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          height: 25.0,
                          width: 120.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text( widget._categoria,
                                      style: TextStyle(
                                          color: Color(0xFFD3D3D3),
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 5.0,
                                  ),

                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        excluirProduto(widget._id_carrinho);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                    ),
                   ],
              )
         )
      );
    }

  }