import 'package:flutter/material.dart';

class Kartudashboard extends StatelessWidget {
  const Kartudashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80,
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: Text("Pemasukan"),
            )
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 80,
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: Text("Pemasukan"),
            )
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 80,
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: Text("Pemasukan"),
            )
          ),
        ],
      ),
    );
  }
}