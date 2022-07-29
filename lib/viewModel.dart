import 'dart:ffi';

import 'package:akasatanumber/readTxtFile.dart';
import 'package:akasatanumber/searchWord.dart';
import 'package:akasatanumber/selectedRogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  String inputNumber = "";
  String mainNumbers = "";
  String subNumbers = "";
  String limitedSubNumbers = "";

  String selectedWordsGroup = "";


  //カタカナ

  List<String> wordList = ["aaa"];
  List<String> matchWordList = [];
  List<Widget> rogoList = [] ;

  final ScrollController scrollController = ScrollController();


  void addSelectedRogo({required selectedRogo}){

    rogoList.add(SelectedRogoButton(selectedRogo: selectedRogo));

    notifyListeners();
  }
  void decreaseDigit() {
    if(mainNumbers.length <= 1) {
      return;
    }
    //メインを一桁減らしてサブに渡す
    subNumbers =  mainNumbers.substring(mainNumbers.length -1) + subNumbers;
    mainNumbers = mainNumbers.substring(0, mainNumbers.length - 1);
    limitedSubNumbers = getLimittedSubNumber(subNumbers);

    SearchMatchWord model = SearchMatchWord();
    matchWordList = model.searchMatchword(wordList, mainNumbers, false);

    notifyListeners();

  }

  void increaseDigit() {
    if(mainNumbers.length >= inputNumber.length) {
      return;
    }

    mainNumbers = mainNumbers + subNumbers.substring(0,1);
    subNumbers = subNumbers.substring(1);
    limitedSubNumbers = getLimittedSubNumber(subNumbers);

    SearchMatchWord model = SearchMatchWord();
    matchWordList = model.searchMatchword(wordList, mainNumbers, false);

    notifyListeners();

  }
  

  void generateRogo() {
    clearSelectedRogo();

    inputNumber = inputNumberController.text;
    showMatchWord();
  }

  void clearSelectedRogo() {
    rogoList.clear();
  }

  void showMatchWord(){
    SearchMatchWord model = SearchMatchWord();

    _searchMatchWord(model: model);

    mainNumbers = inputNumber.substring(0, model.getMaxMatchCount());
    subNumbers = inputNumber.substring(model.getMaxMatchCount());
    limitedSubNumbers = getLimittedSubNumber(subNumbers);

    notifyListeners();


  }

  void selectWord(String selectedWord) {
    //FIXME limittedNumberと加工なしのRestNumberを用意する
    inputNumber = subNumbers.toString();
    matchWordList = [];
    showMatchWord();
    print(limitedSubNumbers);

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
    mainNumbers = "123456";
    notifyListeners();
  }


  void add() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }
  void _scrollToEnd()  {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut);
    notifyListeners();
  }
}
