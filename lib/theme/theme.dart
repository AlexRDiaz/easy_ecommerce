import 'package:flutter/material.dart';

getThemeApp() {
 return ThemeData(

      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.5,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
          centerTitle: true,
          toolbarTextStyle: TextStyle(color: Colors.black)));
}
