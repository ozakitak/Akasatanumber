import 'dart:ffi';

import 'package:akasatanumber/readTxtFile.dart';
import 'package:akasatanumber/searchWord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModel extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  String inputNumber = "";
  String mainNumber = "";
  String subNumber = "";

  final ReadTxtFile read = ReadTxtFile();

  //カタカナ

  List<String> wordList = ["aaa"];
  List<String> matchWordList = [];

  void generateRogo() {
    inputNumber = inputNumberController.text;
    mainNumber = inputNumber.substring(0, 3);
    subNumber = inputNumber.substring(3);
    notifyListeners();

  }


  void searchMatchWord() {

   if(inputNumber.isEmpty){ return; }

   SearchMatchWord model = SearchMatchWord();
   notifyListeners();
  }



  void loadWordList() {
    read.getWordList().then((value) {
      wordList = value;
      print(wordList);
         });


  }
  void testFunc() {
    mainNumber = "123456";
    notifyListeners();
  }
}
