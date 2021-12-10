import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/componentes/cardCarrinho.dart';
import 'package:flutteraplicativo/src/pages/checkout.dart';
import 'package:flutteraplicativo/src/pages/loginPage.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class carrinhoPage extends StatefulWidget{
  var _cpf;

  carrinhoPage(cpf) {
    this._cpf = cpf;

  }
  @override
  _carrinhoPageState createState() => _carrinhoPageState();
}

class _carrinhoPageState extends State<carrinhoPage> {

  var conf = Configuracoes.url;
  var conf_site = Configuracoes.url_site;
  var carregando = false;
  var dados;
  var subtotal = "0";
  var frete = "0";
  var total = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _listarDados();

  }

   _listarDados() async{

    var response = await http.get(
        Uri.encodeFull(
            conf + "carrinho/listar.php?cpf=${widget._cpf}"),
        headers: {"Accept": "application/json"});
    final map = json.decode(response.body);
    final itens = map["result"];

    if(map["result"] == 'Dados não encontrados!'){
      Toast.show("Nenhum Item Adicionado", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else{
      setState(() {
        carregando = true;
        this.dados = itens;
        subtotal = map['subtotal'].toString();
        frete = map['frete'];
        total = map['total'].toString();

        if(total == "0" || total == "" || total == null){
          Toast.show("Nenhum Item Adicionado", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }


      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:!carregando
        ? new LinearProgressIndicator()
        : new ListView.builder(
    itemCount: this.dados != null ? this.dados.length : 0,
    itemBuilder: (context, i) {
      final item = this.dados[i];

           return new CardCarrinho(item['nome_produto'], item['valor'], item['imagem'], item['categoria'], item['quantidade'], item['id_carrinho'], widget._cpf) ;

    }),


        bottomNavigationBar: _TotalContainer(),
    );
  }



  Widget _TotalContainer() {
    return Container(

      height: 185.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      margin: EdgeInsets.only(
        top: 30.0,
        ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "SubTotal",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "R\u{0024}" + subtotal,
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Taxa de Entrega",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "R\u{0024}" + frete,
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "R\u{0024}" + total,
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              if(widget._cpf == ""){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
              }else if(total == "0"){
                Toast.show("Nenhum Item Adicionado", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
              }else{
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => checkoutPage(widget._cpf,  total)
                ));
              }

            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  "Finalizar Pagamento",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

}