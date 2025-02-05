import 'package:flutter/material.dart';
import 'package:restapi/product_list.dart';

class RestApi extends StatelessWidget{
  const RestApi({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _lightTheme(),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.light,
        color: Colors.cyanAccent,
        debugShowCheckedModeBanner: false,
        home: const ProductList()
    );
  }

  ThemeData _lightTheme(){
    return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
        errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
        )
      )
    );
  }
}
