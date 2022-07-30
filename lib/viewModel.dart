import 'dart:ffi';

import 'package:akasatanumber/readTxtFile.dart';
import 'package:akasatanumber/searchWord.dart';
import 'package:akasatanumber/selectedRogo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  //ロゴ選択時の一時的な箱
  String tempMainNumbers = "";
  String tempSubNumbers = "";

  String inputNumber = "";
  String mainNumbers = "";
  String subNumbers = "";
  String limitedSubNumbers = "";

  //後で消す
  String selectedWordsGroup = "";


  //カタカナ

  List<String> wordList = ["aaa"];
  List<String> matchRogoList = [];
  List<Widget> selectedRogoList = [] ;
  SelectedRogoButton? rogoButton;

  bool isChangngRogo = false;

  Color editingColor = Colors.black;


  final ScrollController scrollController = ScrollController();

  void test() {
   selectedRogoList.removeAt(selectedRogoList.length - 1);
   print(selectedRogoList);


   notifyListeners();
  }
  
  
  //全体機能
  ////////////////////////////////////////////////////////////////
  void _showMatchWord(){
    SearchMatchWord model = SearchMatchWord();

    _searchMatchWord(model: model);

    mainNumbers = inputNumber.substring(0, model.getMaxMatchCount());
    subNumbers = inputNumber.substring(model.getMaxMatchCount());
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);

    notifyListeners();


  }
  void _searchMatchWord({  SearchMatchWord? model }) {
    SearchMatchWord search = model ?? SearchMatchWord();

    if(inputNumber.isEmpty){ return; }

    matchRogoList = search.searchMatchword(wordList, inputNumber, true);
    notifyListeners();
  }

  //編集モードでもう一度探し直す
  void researchMatchWord(String rogoNumber, bool isRunAgain) {
    SearchMatchWord model = SearchMatchWord();

    if(rogoNumber.isEmpty) { return; }

    matchRogoList = model.searchMatchword(wordList, rogoNumber, isRunAgain);

    notifyListeners();
  }






  //クリックリスナー
  ////////////////////////////////////////////////////////////////
  void deleteGoroBtn() {
    if(isChangngRogo) {
      return;
    }
    //最後の要素が持つ数字を代入
    SelectedRogoButton temp = selectedRogoList[selectedRogoList.length - 1] as SelectedRogoButton;
    subNumbers = mainNumbers + subNumbers;
    mainNumbers = temp.rogoNumber;
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);
    selectedRogoList.removeAt(selectedRogoList.length - 1);
    researchMatchWord(mainNumbers, false);

    print(mainNumbers);
    print(inputNumber);
    notifyListeners();
  }
  void decreaseDigit() {
    if(isChangngRogo) {
      return;
    }
    if(mainNumbers.length <= 1) {
      return;
    }
    //メインを一桁減らしてサブに渡す
    subNumbers =  mainNumbers.substring(mainNumbers.length -1) + subNumbers;
    mainNumbers = mainNumbers.substring(0, mainNumbers.length - 1);
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);

    SearchMatchWord model = SearchMatchWord();
    matchRogoList = model.searchMatchword(wordList, mainNumbers, false);

    notifyListeners();

  }

  void increaseDigit() {
    if(isChangngRogo) {
      return;
    }
    if(mainNumbers.length >= inputNumber.length) {
      return;
    }

    mainNumbers = mainNumbers + subNumbers.substring(0,1);
    subNumbers = subNumbers.substring(1);
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);

    SearchMatchWord model = SearchMatchWord();
    matchRogoList = model.searchMatchword(wordList, mainNumbers, false);

    notifyListeners();

  }
  
  void generateRogo() {
    resetAll();
    matchRogoList = [];

    inputNumber = inputNumberController.text;
    _showMatchWord();
  }

  void listTileClickListener(String items){
    //編集モードの場合
    if(isChangngRogo) {

      changeSelectedRogo(items);
      //編集するロゴの色を変える
      rogoButton?.state?.changeColor();
      isChangngRogo = false;

      clearMatchWordList();
      //値を戻す
      fixMainAndSubNumber();

      researchMatchWord(mainNumbers, false);




    }else{
      _selectWord(items, mainNumbers);
      //スクロールを最下部へ
      add();
    }
    notifyListeners();
  }
  
  //選択された語呂系
  ////////////////////////////////////////////////////////////////
  void changeSelectedRogo(String rogo) {
    rogoButton?.state?.changeRogo(rogo);
    notifyListeners();
  }
  void addSelectedRogo(String selectedRogo, String rogoNumber){

    selectedRogoList.add(SelectedRogoButton(selectedRogo: selectedRogo, rogoNumber: rogoNumber, viewModel: this));

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

  
  //reset
  ////////////////////////////////////////////////////////////////
  void clearMatchWordList () {
    matchRogoList = [];
    notifyListeners();
  }
  void resetAll() {
    selectedRogoList.clear();
    isChangngRogo = false;
    editingColor = Colors.black;
  }

//置き換え
  void replaceMainNumbers() {
    tempMainNumbers = mainNumbers;
    tempSubNumbers = limitedSubNumbers;

    mainNumbers = rogoButton?.rogoNumber ?? "";
    limitedSubNumbers = "";
    notifyListeners();
  }

  void fixMainAndSubNumber() {
    mainNumbers = tempMainNumbers;
    limitedSubNumbers = tempSubNumbers;
  }

  void setWordList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    wordList = prefs.getStringList('my_word_list') ?? [];
  }



  //ローカルメソッド
  ////////////////////////////////////////////////////////////////

  //リスト要素クリック時
  void _selectWord(String selectedWord, String rogoNumber) {
    inputNumber = subNumbers.toString();
    matchRogoList = [];
    _showMatchWord();
    print(limitedSubNumbers);

    addSelectedRogo(selectedWord, rogoNumber);

    notifyListeners();
  }

  String _getLimittedSubNumber(String subNumber ){
    if(subNumber.length > 8) {
      String limittedSubNumber = subNumber.substring(0, 8);
      return limittedSubNumber += "...";

    } else {
      return subNumber;
    }

  }

  static void setPrefWordList() async {

    final ReadTxtFile read = ReadTxtFile();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    read.getWordList().then((value) {
      prefs.setStringList('my_word_list', value );
    });
  }


}
