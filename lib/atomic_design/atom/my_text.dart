import 'package:flutter/material.dart';
class MyText extends StatelessWidget {
  final String id;
  const MyText({Key? key , required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5,bottom: 10),
      child: Text(id,style: const TextStyle(
          color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold
      ),),
    );
  }
}
