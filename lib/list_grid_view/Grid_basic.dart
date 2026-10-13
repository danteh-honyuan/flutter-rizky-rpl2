import 'package:flutter/material.dart';

class GridBasic extends StatelessWidget {
  const GridBasic ({super.key});

  @override
  Widget build(BuildContext context) {

    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.width;
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: widthScreen / heightScreen,
        children: [
          Container(
            child: Center(child: Text("U")),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber
            ),
          ),
          Container(
            child: Center(child: Text("N")),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red
            ),
          ),
          Container(
            child: Center(child: Text("O")),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue
            ),
          ),
          Container(
            child: Center(child: Text("1")),
            
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green
            ),
          ),
        ],
      )
    );
  }
}