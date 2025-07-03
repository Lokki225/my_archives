
import 'package:flutter/material.dart';

ThemeData theme () {
  return ThemeData(
    scaffoldBackgroundColor: Colors.deepPurple,
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.deepPurple,
    centerTitle: true,
    // elevation: 15,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)
  );

}
