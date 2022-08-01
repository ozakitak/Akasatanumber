
import 'package:akasatanumber/searchWord.dart';
import 'package:akasatanumber/viewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMode{
  String mainNumber;
  List<String> edittedGoro = [];
  int count = 0;
  bool isMaxCount = false;

  CustomMode({required this.mainNumber});

  List<String> getCustomList() {
    String number = mainNumber.substring(count, count + 1);
    List<String> customList = SearchMatchWord.katakanas[int.parse(number)];
    return customList;
  }


  //クリックリスナー （プログラムの書き方がめちゃくちゃすぎて誰か指導してほしい）
  //////////////////////////////////////////////////////////////////
  void listClickListener(String item) {
    print(count);


    if(count == mainNumber.length - 1) {
      isMaxCount = true;
      edittedGoro.add(item);
      return;
    }
    edittedGoro.add(item);
    countUp();
  }
  void okClickListener(BuildContext context, ViewModel viewModel) {
    //編集途中だったら
    buildDeleteDialog(context, viewModel);
  }
  String getCustomWordString() {
    String customWord = "";
    for(String character in edittedGoro){
      customWord += character;
    }
    return customWord;
  }
  void addIgnoreCharacterListener({required bool isSmallTsu}) {
    int index = edittedGoro.length -1;
    if(edittedGoro[index].length >= 2) { return; }

    if(isSmallTsu) {
      edittedGoro[index] = "${edittedGoro[index]}ッ";
    } else {
      edittedGoro[index] = "${edittedGoro[index]}ー";
    }
    print(edittedGoro);

  }
  void deleteCharacter() {
    if(count <= 0) { return; }
    if(!isMaxCount) {
      count--;
    }
    edittedGoro.removeAt(edittedGoro.length - 1);
    isMaxCount = false;

  }

  void countUp() {
    count++;
  }
  List<Widget> getCustomTextList() {
    List<Widget> customTextList = edittedGoro.map((e) => CustomText(e: e,)).toList();

    return customTextList;
  }


  Future<void> buildDeleteDialog(BuildContext context, ViewModel viewModel) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoAlertDialog(
              title: const Text("まだ編集中です。中止しますか？"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("続ける"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                    child: const Text("中止"),
                    isDestructiveAction: true,
                    onPressed: (){
                      if(viewModel.isChangngRogo) {
                        viewModel.rogoButton?.state?.changeColor();
                        viewModel.isChangngRogo = false;
                        viewModel.isCustom = false;
                        viewModel.showMatchWord();
                        viewModel.customCharacterList = [];
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        viewModel.matchRogoList = [];
                        viewModel.customCharacterList = [];
                        viewModel.isCustom = false;
                        viewModel.showMatchWord();
                      }
                    }
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CustomText extends StatelessWidget {
   CustomText({
    Key? key,
    required this.e,
  }) : super(key: key);

  String e;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Text(e,
    style: TextStyle(fontSize: size.height / 30, fontFamily: 'dotGothic')  
      ,);
  }
}