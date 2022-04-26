import 'package:flutter/material.dart';
class NameBox extends StatelessWidget {
 final String name;
   const NameBox({Key? key , required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1,right: 5,left: 10,bottom: 15),
      child:  Text(name,style:  const TextStyle(
          color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold
      )),
    );
  }
}
