import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //rootBundle
import 'dart:async'; //Future

class SearchMatchWord{


   static List<List<String>> katakanas = [

  ['ワ','ヲ','ン'],
  ['ア','イ','ウ','エ','オ','ァ','イ','ゥ','ェ','ォ',],
  ['カ','キ','ク','ケ','コ','ガ','ギ','グ','ゲ','ゴ',],
  ['サ','シ','ス','セ','ソ','ザ','ジ','ズ','ゼ','ゾ',],
  ['タ','チ','ツ','テ','ト','ダ','ヂ','ヅ','デ','ド',],
  ['ナ','ニ','ヌ','ネ','ノ',],
  ['ハ','ヒ','フ','ヘ','ホ','バ','ビ','ブ','ベ','ボ','パ','ピ','プ','ペ','ポ',],
  ['マ','ミ','ム','メ','モ',],
  ['ヤ','ユ','ヨ','ャ','ュ','ョ',],
  ['ラ','リ','ル','レ','ロ',],
  ];

  List<String> searchMatchword(List<String> wordList, String inputNumbers, bool isRunAgain) {


   int maxMatchCount = 0;
   List<String> matchWordList = [];


    for (var value in wordList) {
      //っとーを無視する
      String word = _ignoreCharacter(value);

      //入力された桁数以上の文字列を弾く
      if(word.length > inputNumbers.length){
        continue;
      }

      //単語を1文字ずつ切り分ける
      List<String> charWordList = word.split("");

      //入力された番号を1文字ずつに切り分ける
      List<String> charNunberList = inputNumbers.split("");

      int tempMaxCount = 0;

      if(charWordList.isEmpty) { continue; }

      for (int index = 0; index < charNunberList.length; index++){


        //一文字ずつマッチするか調べる
        if(_isMatchCharacter(charWordList[index], charNunberList[index])){

          //最大マッチ数をカウントする
          tempMaxCount++;
          if(index == charWordList.length -1){

            if(index == charNunberList.length - 1){
              //マッチしたワードを格納

              matchWordList.add(value);


            } else {
              break;
            }
          }


        } else {


          break;

        }

      }
      //最大マッチ桁を更新
      if (tempMaxCount > maxMatchCount) {

        maxMatchCount = tempMaxCount;

      }
    }

    //ヒット数が0の場合、もう一度回すか検討。
   if(matchWordList.isEmpty) {

     if(isRunAgain) {
       matchWordList = searchMatchword(wordList,inputNumbers.substring(0, maxMatchCount) , isRunAgain);
     }

   }

    return matchWordList;
  }

  String _ignoreCharacter(String word) {
    String ignoredWord = word.replaceAll("ッ", "").replaceAll("ー", "");
    return ignoredWord;
  }

  bool _isMatchCharacter(String letter, String number) {

    for (var value in katakanas[int.parse(number)]) {
      if(value == letter) {
        return true;
      }
    }
    return false;
  }


}
