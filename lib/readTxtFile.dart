import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //rootBundle
import 'dart:async'; //Future

class ReadTxtFile{
  final String filePath = "assets/documents/wordList.txt";


  Future<String> _loadAssetsTextFile() async {
   return rootBundle.loadString(filePath);
  }

  Future<List<String>> getWordList() async {
    String textContents = "";
    List<String> wordList;

    textContents = await _loadAssetsTextFile();
    wordList = textContents.split(',\n');

    return wordList;
  }


}
