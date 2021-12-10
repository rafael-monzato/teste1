import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutteraplicativo/src/config/config.dart';
import 'package:flutteraplicativo/src/pages/carrinhoPage.dart';
import 'package:flutteraplicativo/src/pages/loginPage.dart';
import 'package:flutteraplicativo/src/tabs/tabs.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class pedidosPage extends StatefulWidget{
var _cpf;

pedidosPage(cpf) {
  this._cpf = cpf;

}
@override
_pedidosPageState createState() => _pedidosPageState();
}

class _pedidosPageState extends State<pedidosPage> {

  var conf = Configuracoes.url;

  var carregando = false;
  var dados;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _listarDados();
  }

  _listarDados() async {
    var response = await http.get(
        Uri.encodeFull(
            conf + "pedidos/listar.php?cpf=${widget._cpf}"),
        headers: {"Accept": "application/json"});
    final map = json.decode(response.body);
    final itens = map["result"];
    print(map["result"]);
    if (map["result"] == 'Dados não encontrados!') {
      Toast.show(
          "Você nao Possui Pedidos", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    } else {
      setState(() {
        carregando = true;
        this.dados = itens;
        print(dados);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: appBar(),
        body: new Center(

          child: !carregando
              ? new CircularProgressIndicator()
              : new ListView.builder(
              itemCount: this.dados != null ? this.dados.length : 0,
              itemBuilder: (context, i) {
                final d = this.dados[i];
                var cor;
                if(d['status']=='Iniciado'){
                  cor = Colors.blue;
                }else if(d['status']=='Preparando'){
                  cor = Colors.red;
                }else if(d['status']=='Despachado'){
                  cor = Colors.orangeAccent;
                }else{
                  cor = Colors.green;
                }

                return ListTile(
                  leading: Icon(Icons.check_circle, color: cor),
                  title: Text('Status ' + d['status']),
                  subtitle: Text(d['data'] + ' - Previsão Chegada ' + d['hora']),


                );

              }),
        ),
      ),
    );
  }


  appBar() {

      return AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            icon: Icon(
              Icons.home,
              // size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Tabs(widget._cpf, "", "", "")));
            }),
        title: Text(
          "Lista de Pedidos",
          style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold
          ),

        ),
        centerTitle: true,

        actions: <Widget>[

          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => pedidosPage(widget._cpf)));
            },
          )
        ],

      );
    }

}