import 'package:flutter/material.dart';
import 'dart:math' as math;

class IntroduceStr{
  static List<String> introduceList = [
    "1→ア行　　 6→ハ行\n" "2→カ行 　　7→マ行\n" "3→サ行 　　8→ヤ行\n" "4→タ行 　　9→ラ行\n" "5→ナ行 　　0→ワ行\n\n" "無視→「ッ」「ー」" ,

    "選択した語句は、後から編集できます。\n\n" "ただし、桁数を変えるには最後の語句を取り消すしかありません。",

    "語呂がしっくりこない時は、桁数を工夫することをお勧めします。\n\n" "カスタムボタン（鉛筆）を使うと、自由に語呂を作れます。",

    "[ッ」（拗音）と「ー」（促音）は無視します。\n\nどんまい。",

    "助詞の「ハ」は、表記上はハ行ですが、音は「ワ」なので、\n"
        "変換数字は「0」です。",
    "電話番号、年号、暗証番号、円周率100桁などの暗記に有効です。",
  ];
  static String getRandomIntroduce() {
    var rand =  math.Random();
    // 0-4の乱数を発生させます
    return introduceList[rand.nextInt(introduceList.length)];
  }
}