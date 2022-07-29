import 'package:akasatanumber/readTxtFile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WordSql {
  static List<String> wordList = [];

  static Future<Database> get database async {
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'word_list.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE wordList(text TEXT PRIMARY KEY)",
        );
      },
      version: 1,
    );
    return _database;
  }


   static Future<void> insertMemo() async {
    final Database db = await database;
    getWordList();
    for(String word in wordList){

      await db.insert(
        'wordList',

        {"word": word},

        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static void getWordList(){
    ReadTxtFile read = ReadTxtFile();
    read.getWordList().then((value) => {
    wordList = value;
    } );
  }
}