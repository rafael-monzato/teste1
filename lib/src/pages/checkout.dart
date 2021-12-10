import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/componentes/botao.dart';
import 'package:flutteraplicativo/src/config/config.dart';
import 'package:flutteraplicativo/src/pages/loginPage.dart';
import 'package:flutteraplicativo/src/pages/pedidosPage.dart';
import 'package:flutteraplicativo/src/tabs/tabs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class checkoutPage extends StatefulWidget {
  var _cpf, _total;

  checkoutPage(cpf, total) {

    this._cpf = cpf;
    this._total = total;
  }
  @override
  _checkoutPageState createState() => _checkoutPageState();
}

class _checkoutPageState extends State<checkoutPage> {
  bool _toggleVisibility = true;

  String _rua;
  String _numero;
  String _bairro;
  String _troco;
  String _pgto;
  String _obs;

  var conf = Configuracoes.url;
  String dropdownValue = 'Tipo de Pagamento';
  var campo;

  var rua, numero, bairro, troco, pgto, obs;
  var ruatxt, numerotxt, bairrotxt, trocotxt, pgtotxt, obstxt;
  var dados;


  var carregando = false;
  var dadosTotais;
  var subtotal = "0";
  var frete = "0";
  var total = "0";


  GlobalKey<FormState> _formKey = GlobalKey();

  Widget _ruatxt() {
    return TextFormField(
      controller: ruatxt,
      decoration: InputDecoration(
        hintText: "Rua",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      onSaved: (String rua) {
        _rua = rua;
      },

    );
  }

  Widget _numerotxt() {
    return TextFormField(
      controller: numerotxt,
      decoration: InputDecoration(
        hintText: "Número",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,

        ),
      ),
      onSaved: (String numero) {
        _numero = numero.trim();
      },

    );
  }


  Widget _bairrotxt() {
    return TextFormField(
      controller: bairrotxt,
      decoration: InputDecoration(
        hintText: "Bairro",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      onSaved: (String bairro) {
        _bairro = bairro.trim();
      },

    );
  }


  Widget _trocotxt(enab) {
    return TextFormField(
      enabled:enab,
      controller: trocotxt,
      decoration: InputDecoration(
        hintText: "Valor total para o Troco",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      onSaved: (String troco) {
        _troco = troco.trim();
      },

    );
  }




  /*
  Widget _pgtotxt() {
    return TextFormField(
      controller: pgtotxt,
      decoration: InputDecoration(
        hintText: "Tipo Pagamento",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),

      ),

      onSaved: (String pgto) {
        _pgto = pgto;
      },

    );
  } */


  Widget _obstxt() {
    return TextFormField(
      controller: obstxt,
      decoration: InputDecoration(
        hintText: "Observações",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),

      ),

      onSaved: (String obs) {
        _obs = obs.trim();
      },

    );
  }


  mensagem(res){
    var alert = new AlertDialog(
      title: new Text('Finalizar Pedido'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text(res),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            if(res != "Pedido Concluído"){
              Navigator.of(context).pop();
            }else{
              //redirecionar para os pedidos
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => pedidosPage(widget._cpf)
              ));
            }


          },
        ),
      ],
    );
    //showDialog(context: context, child: alert);



  }


  //VERIFICAR SE O USUÁRIO ESTÁ LOGADO, SE TIVER RECUPERAR SEUS DADOS PARA EDITAR
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget._cpf != ""){

      recuperarDados();
      _listarTotais();
    }
    ruatxt = new TextEditingController();
    numerotxt = new TextEditingController();
    bairrotxt = new TextEditingController();
    pgtotxt = new TextEditingController();
    trocotxt = new TextEditingController();
    obstxt = new TextEditingController();
  }

  //método para recuperar os dados do usuário logado
  recuperarDados() async{

    var response = await http.get(
        Uri.encodeFull(
            conf + "clientes/recuperarDados.php?cpf=${widget._cpf}"),
        headers: {"Accept": "application/json"});
    final map = json.decode(response.body);
    final itens = map["result"];

    setState(() {

      this.dados = itens;

      rua = dados[0]["rua"];
      numero = dados[0]["numero"];
      bairro = dados[0]["bairro"];



      ruatxt = new TextEditingController(text: rua);
      numerotxt = new TextEditingController(text: numero);
      bairrotxt = new TextEditingController(text: bairro);

    });



  }

  //método para inserir pedido na api
  void _inserirPedido() async{
    var url = conf + "pedidos/inserir.php";


    var response = await http.post(url, body:{
      "total_pago" : trocotxt.text,
      "tipo_pgto" : dropdownValue,
      "cpf" : widget._cpf,
      "total" : widget._total,
      "obs" : obstxt.text,


    });

    final map = json.decode(response.body);
    final res = map["message"];

    mensagem(res);



  }



  //método para editar dados do cliente
  void _EditarCliente() async{
    var url = conf + "clientes/editar.php";
    var response = await http.post(url, body:{
      "rua" : ruatxt.text,
      "numero" : numerotxt.text,
      "bairro" : bairrotxt.text,
      "cpf" : widget._cpf,


    });

    final map = json.decode(response.body);
    final res = map["message"];

  }





  _listarTotais() async{

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
        this.dadosTotais = itens;
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                       DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              print(dropdownValue);

                            });
                          },
                          items: <String>['Tipo de Pagamento', 'Dinheiro', 'Cartão de Débito', 'Cartão de Crédito']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),

                        SizedBox(
                          height: 12.0,
                        ),
                        dropdownValue != "Dinheiro" ? _trocotxt(false) : _trocotxt(true),
                        SizedBox(
                          height: 12.0,
                        ),
                        _ruatxt(),
                        SizedBox(
                          height: 12.0,
                        ),
                        _numerotxt(),
                        SizedBox(
                          height: 12.0,
                        ),
                        _bairrotxt(),
                        SizedBox(
                          height: 12.0,
                        ),
                        _obstxt(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),


                GestureDetector(
                  onTap: () {
                    if(dropdownValue != "Tipo de Pagamento"){
                      _inserirPedido();
                      _EditarCliente();


                    }else{
                      mensagem("Escolha o tipo de Pagamento");
                    }


                  },
                  child: Button(
                    btnText: 'Finalizar Pedido',
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),

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

              ],
            ),
          ),
        ),



      ),
    );
  }



}