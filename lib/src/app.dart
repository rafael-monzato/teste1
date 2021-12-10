import 'package:flutter/material.dart';
import 'package:flutteraplicativo/src/tabs/tabs.dart';
import 'pages/TelaInicial.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Aplicativo Flutter",
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: Tabs("", "", "", ""),
    );
  }
}