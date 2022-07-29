import 'dart:ffi';

import 'package:akasatanumber/readTxtFile.dart';
import 'package:akasatanumber/searchWord.dart';
import 'package:akasatanumber/selectedRogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  String inputNumber = "";
  String mainNumber = "";
  String subNumber = "";
  String restNumber = "";

  String selectedWordsGroup = "";


  //カタカナ

  List<String> wordList = ["aaa"];
  List<String> matchWordList = [];
  List<Widget> rogoList = [] ;


  void addSelectedRogo({required selectedRogo}){

    rogoList.add(SelectedRogoButton(selectedRogo: selectedRogo));

    notifyListeners();
  }
  void generateRogo() {
    inputNumber = inputNumberController.text;
    showMatchWord();
  }
  void showMatchWord(){
    SearchMatchWord model = SearchMatchWord();

    _searchMatchWord(model: model);

    mainNumber = inputNumber.substring(0, model.getMaxMatchCount());
    restNumber = inputNumber.substring(model.getMaxMatchCount());
    subNumber = getLimittedSubNumber(restNumber);

    notifyListeners();


  }

  void selectWord(String selectedWord) {
    //FIXME limittedNumberと加工なしのRestNumberを用意する
    inputNumber = restNumber.toString();
    matchWordList = [];
    showMatchWord();
    print(subNumber);

    addSelectedRogo(selectedRogo: selectedWord);

    notifyListeners();
  }

  String getLimittedSubNumber(String subNumber ){
    if(subNumber.length > 8) {
      String limittedSubNumber = subNumber.substring(0, 8);
      return limittedSubNumber += "...";

    } else {
      return subNumber;
    }

  }


  void _searchMatchWord({  SearchMatchWord? model }) {
    SearchMatchWord search = model ?? SearchMatchWord();

   if(inputNumber.isEmpty){ return; }

   matchWordList = search.searchMatchword(wordList, inputNumber, true);
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
