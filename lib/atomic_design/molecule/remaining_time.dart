import 'package:flutter/material.dart';
class RemainingTime extends StatelessWidget {
  final String counter;
  const RemainingTime({Key? key , required this.counter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children:  [
        const Text(
          "Remaining Time : ",
          style:  TextStyle(fontSize: 20, color: Colors.white),
        ),
        Text(
          counter,
          style:  const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red),
        ),
      ],
    );
  }
}
