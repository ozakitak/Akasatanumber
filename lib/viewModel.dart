import 'dart:ffi';

import 'package:akasatanumber/readTxtFile.dart';
import 'package:akasatanumber/searchWord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  String inputNumber = "";
  String mainNumber = "";
  String subNumber = "";


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
   matchWordList = model.searchMatchword(wordList, inputNumber, true);
   notifyListeners();
  }



  void setWordList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    wordList = prefs.getStringList('my_word_list') ?? [];


  }
  static void setPrefWordList() async {

    final ReadTxtFile read = ReadTxtFile();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    read.getWordList().then((value) {
      prefs.setStringList('my_word_list', value );
    });
  }
  void testFunc() {
    mainNumber = "123456";
    notifyListeners();
  }
}
