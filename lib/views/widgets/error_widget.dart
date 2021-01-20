import 'package:flutter/material.dart';

Widget errorPage(BuildContext context, Function refresh) {
  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 200,
              color: Colors.amber,
            ),
            Text(
              '出错了',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ),
            IconButton(icon: Icon(Icons.refresh_rounded), onPressed: refresh),
          ],
        ),
      ),
    ),
  );
}
