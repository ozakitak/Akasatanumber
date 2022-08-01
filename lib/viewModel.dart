import 'dart:ffi';

import 'package:akasatanumber/introduceStr.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:akasatanumber/readTxtFile.dart';
import 'package:akasatanumber/searchWord.dart';
import 'package:akasatanumber/selectedRogo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customMode.dart';

class ViewModel extends ChangeNotifier{

  TextEditingController inputNumberController = TextEditingController();

  double expandHeight = 0;
  bool isExpand = false;

  String testMainNumber = "";
  //カスタム時
  bool isCustom = false;

  //ロゴ選択時の一時的な箱
  String tempMainNumbers = "";
  String tempSubNumbers = "";

  String inputNumber = "";
  String mainNumbers = "";
  String subNumbers = "";
  String limitedSubNumbers = "";



  String introduceStr = IntroduceStr.introduceList[0];


  //カタカナ

  //辞書
  List<String> wordList = ["aaa"];
  //検索にヒットした語句
  List<String> matchRogoList = [];
  //下の選択した語句
  List<Widget> selectedRogoList = [] ;
  //カスタム作成時に選んだ単文字
  List<Widget> customCharacterList = [];

  bool isChangngRogo = false;
  bool isIntroduce = true;


  Color editingColor = Colors.black;

  SelectedRogoButton? rogoButton;
  CustomMode? customMode;


  final ScrollController scrollController = ScrollController();
  final ScrollController customScrollController = ScrollController();

  int count = 0;
  void setIntroduce() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // エラーの出ていた処理
      if(matchRogoList.isNotEmpty || mainNumbers.isNotEmpty) {

        isIntroduce = false;
        notifyListeners();
        return;
      }

      isIntroduce = true;
      if(count == 0) {
        introduceStr = IntroduceStr.introduceList[0];
        count++;
      }else {
        introduceStr = IntroduceStr.getRandomIntroduce();
      }

      notifyListeners();
    });
  }

  void setCustomMode() {
    isCustom = true;
    notifyListeners();
  }
  void unSetCustomMode() {
    isCustom = false;
    notifyListeners();
  }
  void test() {
   selectedRogoList.removeAt(selectedRogoList.length - 1);
   print(selectedRogoList);


   notifyListeners();
  }

  void closeBox() {
    isExpand = false;
    expandHeight = 0;
    notifyListeners();
  }

  void expandBox(double sizeHeight) {

    if(!isExpand) {
      expandHeight = sizeHeight;
    } else {
     expandHeight = 0;
    }
    isExpand = !isExpand;
    notifyListeners();
  }
  
  //検索
  ////////////////////////////////////////////////////////////////
  void replaceMainToSub() {
    mainNumbers = subNumbers;

  }
  void showMatchWord(){
    SearchMatchWord model = SearchMatchWord();

    _searchMatchWord(model: model);


    mainNumbers = inputNumber.substring(0, model.getMaxMatchCount());
    testMainNumber = mainNumbers;
    subNumbers = inputNumber.substring(model.getMaxMatchCount());
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);
    print("showMatch${tempMainNumbers}");

    notifyListeners();


  }
  void _searchMatchWord({  SearchMatchWord? model }) {
    SearchMatchWord search = model ?? SearchMatchWord();

    if(inputNumber.isEmpty){ return; }
    print("searchMatchWord${mainNumbers}");

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
    if(selectedRogoList.isEmpty) {return;}
    if(isChangngRogo) { return; }
    //最後の要素が持つ数字を代入
    SelectedRogoButton temp = selectedRogoList[selectedRogoList.length - 1] as SelectedRogoButton;
    subNumbers = mainNumbers + subNumbers;
    mainNumbers = temp.rogoNumber;
    inputNumber = mainNumbers + inputNumber;
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);
    selectedRogoList.removeAt(selectedRogoList.length - 1);
    researchMatchWord(mainNumbers, false);

    print(mainNumbers);
    print(inputNumber);
    notifyListeners();
  }
  void decreaseDigit() {
    if(isChangngRogo || isCustom ) {
      _showToast("編集中は変えられません");
      notifyListeners();

      return;

    }
    if(mainNumbers.length <= 1) {
      _showToast("最小値です");
      notifyListeners();

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
    if(isChangngRogo || isCustom) {
      _showToast("編集中は変えられません");
      return;
    }
    if(mainNumbers.length >= inputNumber.length) {
      _showToast("最大桁です");
      return;
    }

    mainNumbers = mainNumbers + subNumbers.substring(0,1);
    subNumbers = subNumbers.substring(1);
    limitedSubNumbers = _getLimittedSubNumber(subNumbers);

    SearchMatchWord model = SearchMatchWord();
    matchRogoList = model.searchMatchword(wordList, mainNumbers, false);

    notifyListeners();

  }

  Future<bool?> _showToast( String massage) {
    return Fluttertoast.showToast(
      msg: massage,
      fontSize: 20.0,
      textColor: Colors.white,
      backgroundColor: Colors.black54,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
    );
  }

  void generateRogo() {
    resetAll();
    closeBox();
    unSetCustomMode();
    matchRogoList = [];

    inputNumber = inputNumberController.text;
    showMatchWord();
  }

  void copyClickListener() async {

    if(selectedRogoList.isEmpty) { return; }

    String copyContents = "";
    for(Widget item in selectedRogoList){
      SelectedRogoButton goro = item as SelectedRogoButton;
      copyContents += "${goro.selectedRogo} ";
    }
      final data = ClipboardData(text: copyContents);
      await Clipboard.setData(data);
      print("コピーしたよ");
      _showToast("コピーしました");
  }

  //カスタムモード
  ////////////////////////////////////////////////////////////////
  void customRogoBtnListener() {
    if(mainNumbers.isEmpty ) {return;}

    customMode = CustomMode(mainNumber: mainNumbers);
    matchRogoList = customMode?.getCustomList() ?? [];
    setCustomMode();


    notifyListeners();

  }
  void okBtnClickListener(BuildContext context){
    if(customMode!.edittedGoro.length < customMode!.mainNumber.length ){
      customMode?.okClickListener(context, this  );
      notifyListeners();
      return;
    }

    String customWord = customMode?.getCustomWordString() ?? "";
    if(isChangngRogo) {
      // listTileClickListener(customWord);
      isCustom = false;
      return;
    }
    customCharacterList = [];
    // _selectWord(customWord, mainNumbers);
    unSetCustomMode();
    notifyListeners();
  }
  void deleteCharacterBtnListener() {
    customMode?.deleteCharacter();
    _upgradeMatchCharacterList();
    _upgradeCustomCharacterList();
    notifyListeners();

  }

  void ignoredCharacterBtnListener(bool isSmallTsu) {

    if(isSmallTsu) {
      customMode?.addIgnoreCharacterListener(isSmallTsu: true);
    } else {
      customMode?.addIgnoreCharacterListener(isSmallTsu: false);
    }

    _upgradeCustomCharacterList();

  }
  void customModeListTileClickListener(String items) {

    if(customMode?.isMaxCount ?? false ) {
      return;
    }
    //スクロール
    add(customScrollController);

    customMode?.listClickListener(items);


    //リストビューを更新
    _upgradeMatchCharacterList();
    //テキストウィジェットリストを更新
    _upgradeCustomCharacterList();


    if(customMode?.isMaxCount ?? false ) {
      matchRogoList = [];
    }

    notifyListeners();
  }

  void _upgradeMatchCharacterList() {
    matchRogoList =  customMode?.getCustomList() ?? [];
    notifyListeners();
  }
  void _upgradeCustomCharacterList(){
    customCharacterList = customMode?.getCustomTextList() ?? [];
    notifyListeners();
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
      //FIXME
      _selectWord(items, testMainNumber);
      print("tile${mainNumbers}");
      //スクロールを最下部へ
      add(scrollController);
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
  void add(ScrollController scrollController) {
    SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToEnd(scrollController));
  }
  void _scrollToEnd(ScrollController scrollController)  {
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
    setIntroduce();
    notifyListeners();
  }
  void resetAll() {
    selectedRogoList.clear();
    isChangngRogo = false;
    editingColor = Colors.black;
    customCharacterList = [];

  }

//置き換え
  void replaceMainNumbers(String rogoNumber) {
    tempMainNumbers = mainNumbers;
    tempSubNumbers = limitedSubNumbers;

    mainNumbers = rogoNumber;
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

  //Dialog
  ////////////////////////////////////////////////////////////////
  Future<void> buildDeleteDialog(BuildContext context) {
    if(selectedRogoList.isEmpty) {return Future((){ });}
    if(isChangngRogo) { return Future((){
      _showToast("編集中は変えられません。");
    }); }

    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CupertinoAlertDialog(
              title: const Text("最後に追加した語句を取り消しますか？"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("やめる"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                    child: const Text("取り消す"),
                    isDestructiveAction: true,
                    onPressed: (){
                      deleteGoroBtn();
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //ローカルメソッド
  ////////////////////////////////////////////////////////////////

  //リスト要素クリック時
  void _selectWord(String selectedWord, String rogoNumber) {
    print(testMainNumber);
    print("selectWord${mainNumbers}");

    inputNumber = subNumbers.toString();
    matchRogoList = [];
    showMatchWord();
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
