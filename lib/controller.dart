import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Controller extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  String inputNumber = "";
  String mainNumber = "";
  String subNumber = "";

  void generateRogo() {
    inputNumber = inputNumberController.text;
    mainNumber = inputNumber.substring(0, 3);
    subNumber = inputNumber.substring(3);
    notifyListeners();

  }
  void testFunc() {
    mainNumber = "123456";
    notifyListeners();
  }
}
