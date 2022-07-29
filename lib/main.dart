
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'viewModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
   const MyStatefulWidget({Key? key}) : super(key: key);

  @override
   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();

}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {



  @override
  void initState() {
    super.initState();
    Future(() async {
      final preference = await SharedPreferences.getInstance();

      if(preference.getBool('isStart') ?? true) {
        ViewModel.setPrefWordList();
        preference.setBool('isStart', false);
      } else {
        print("2回目以降です");
      }
    });

  }
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider<ViewModel>(
        create: (context) => ViewModel(),
      child:
      AllWidget(),
    );
  }

}

class AllWidget extends StatelessWidget {
   AllWidget({
    Key? key,
  }) : super(key: key);

   @override
  Widget build(BuildContext context) {
     final ViewModel viewModel = Provider.of<ViewModel>(context);

    final Size size = MediaQuery.of(context).size;






    String inputNumber = "";
    String mainNumber = "";
    String subNumber = "";

    viewModel.setWordList();
    

    return Container(
        child: Stack(
          children: [
            //背景の白さが足りかったので
            Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
            ),

            //Header
            HeaderBackground(size: size, inputNumberController: viewModel.inputNumberController),

            //アプリタイトル
            Align(
                alignment: Alignment(0.3,-1 + size.height / 8000),
                child: SizedBox(height: size.height / 45,
                    child: Image(image: AssetImage('assets/images/appTitle.png'))
                )
            ),

            //Body
            Positioned(
              top: size.height / 5,
              width: size.width,

              child: Column(
                children: [

                  //ロゴ生成ボタン
                  GenerateRogoBtn(size: size, viewModel: viewModel),

                  SizedBox(height: size.height / 50,),

                  //選択された数字
                  SelectedNumbers(size: size, mainNumber: viewModel.mainNumbers, subNumber: viewModel.limitedSubNumbers,),

                  SizedBox(height: size.height / 80,),

                  //サーチする桁数を決めるボタン
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      rangeArrowBtn(imagePath: 'assets/images/arrowLeft.png',size: size,
                        decideRangeFunc: () {
                        viewModel.decreaseDigit();
                        },),
                      SizedBox(width: size.width / 10,),

                      rangeArrowBtn(imagePath: 'assets/images/arrowRight.png',size: size,
                        decideRangeFunc:
                            () {
                        viewModel.increaseDigit();

                            },)
                    ],
                  ),

                  SizedBox(
                    height: size.height / 30,
                  ),

                  //リスト
                  SizedBox(
                      height: size.height / 4,
                      width:  size.width - 50,
                      child:

                      Stack(
                        children: [

                          //背景
                          const ListBackground(),

                          //ListView
                          WordListView(size: size, items: viewModel.matchWordList, viewModel: viewModel,),

                          //鉛筆ボタン
                          Align(alignment: Alignment(1,0.9),
                              child:
                              IconButton(icon:
                              Icon(Icons.edit, size: size.height/20,

                                  color: Color.fromARGB(450,19, 117, 45)),
                                onPressed: () {print("b");},
                              )
                          ),

                        ],
                      )
                  ),

                ],
              ),

            ),

            //Footer
            Align(alignment: const Alignment(1,1),
              child:
              Stack(
                children: [

                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      //フレーム
                      Container(
                        padding: EdgeInsets.zero,
                        height: size.height / 5,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(217, 217, 217, 217),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )
                        ),
                      ),
                      //中身
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: size.height / 5.8,
                            width: size.width - 20,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(249, 249, 249, 249),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )
                            ),
                            child: Stack(
                              children: [

                                //copyButton
                                Align(alignment: Alignment(1,-1),
                                  child: FooterIconBtn(size: size,imagePath: 'assets/images/copy.png',
                                    onPressd: (){
                                      print("copy");
                                    },
                                  ),),

                                //deleteButtonn
                                Align(alignment: Alignment(1,1),
                                  child: FooterIconBtn(size: size, imagePath: 'assets/images/deleteSelectWord.png',
                                    onPressd: (){
                                      print('delete');
                                    },),
                                ),

                                //expandButton
                                Align(
                                  alignment: Alignment(0,-1),
                                  child: IconButton(icon:
                                  SizedBox(height: 3,
                                    child:
                                    Image.asset('assets/images/expandBtn.png', ),
                                  ),
                                    onPressed: () {print("expand");},

                                  ),
                                ),

                                //選択されたワード
                                Align(
                                    alignment: Alignment(0,1),
                                    child: Container(
                                      height: size.height / 8 ,
                                      width: size.width  - 110,
                                      child:SingleChildScrollView(
                                        controller: viewModel.scrollController,

                                        child:
                                        Wrap(
                                          children: viewModel.rogoList,
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height / 100,),
                        ],
                      ),
                    ],
                  )
                ],

              ),
            ),
          ],
        )
    );

  }
}

class GenerateRogoBtn extends StatelessWidget {
  const GenerateRogoBtn({
    Key? key,
    required this.size,
    required this.viewModel,
  }) : super(key: key);

  final Size size;
  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size.height / 15,
        child:
        ElevatedButton(child: Image(image: AssetImage('assets/images/generateRogo.png'), ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
            onPrimary: Colors.blue,
          ),
          onPressed: (){
          viewModel.generateRogo();
          },
        )
    );
  }
}

class SelectedNumbers extends StatelessWidget {
  const SelectedNumbers({
    Key? key,
    required this.size,
    required this.mainNumber,
    required this.subNumber,
  }) : super(key: key);

  final Size size;
  final String mainNumber;
  final String subNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,

      children: [

        Opacity(opacity: 0, child:
        Text(subNumber),),
        Spacer(),

        Text(mainNumber, style: TextStyle(fontSize: size.height / 20,),),
        Container(
           height: size.height / 35,
          child: Text(subNumber, style: TextStyle(fontSize: size.height / 60,),),
        ),

        Spacer(),

      ],
    );
  }
}

class HeaderBackground extends StatelessWidget {
  const HeaderBackground({
    Key? key,
    required this.size,
    required this.inputNumberController,
  }) : super(key: key);

  final Size size;
  final TextEditingController inputNumberController;

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey, //色
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
        color: Color.fromARGB(1000, 217, 217, 217),
      ),
      width: size.width,
      height: size.height / 6,
      child:
      InputNumberBox(size: size, inputNumberController: inputNumberController),

    );
  }
}

class FooterIconBtn extends StatelessWidget {
  const FooterIconBtn({
    Key? key,
    required this.size,
    required this.onPressd,
    required this.imagePath,
  }) : super(key: key);

  final Size size;
  final String imagePath;
  final VoidCallback onPressd;

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Image.asset(imagePath,
    height: size.height / 30,),
      onPressed: onPressd,

    );
  }
}

class WordListView extends StatelessWidget {
  const WordListView({
    Key? key,
    required this.size,
    required this.items,
    required this.viewModel,
  }) : super(key: key);

  final Size size;
  final List<String> items;
  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.all(size.height / 50),
    itemBuilder: (context,index) {
      return Container(
        height: size.height / 20,
        decoration: const BoxDecoration(
          border: Border(

            bottom: BorderSide(color: Color.fromARGB(217, 217, 217, 217)),
          )
        ),
                  child: ListTile(
                    //下すぎたから空文字で微調整。多分良くない。
                    subtitle: Text(""),

                    title:
                    Center(

                      child:
                      Text('${items[index]}',
                      style: TextStyle(fontSize: size.height / 35),),
                    ),
                    onTap: (){
                      viewModel.selectWord(items[index]);
                      viewModel.add();
                    },
                  ),
      );
    }
    );
  }

}

class ListBackground extends StatelessWidget {
  const ListBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(241, 241, 241, 241)),
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(251, 251, 251, 251),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(222, 222, 222, 222), //色
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 4),
          ),
        ],

      ),
    );
  }
}

class InputNumberBox extends StatelessWidget {
  const InputNumberBox({
    Key? key,
    required this.size,
    required this.inputNumberController,
  }) : super(key: key);

  final Size size;
  final TextEditingController inputNumberController;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment(0 ,0.85),
        child: Container(
          width: size.width - 20,
          height: size.height / 16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white

          ),
          child: Row(
            children: [

              Container(
                width:  size.width - 70,
                child: TextField(
                  controller: inputNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "　　数字を入力してください",


                  ),
                ),
              ),
              //deleteButton
              SizedBox(
                height: size.height / 50,
                child:
                IconButton(icon: Image(image: AssetImage('assets/images/deleteInputNum.png'),),
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.red,
                  onPressed: () {
                    inputNumberController.clear();
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}

class rangeArrowBtn extends StatelessWidget {
  const rangeArrowBtn({
    Key? key,
    required this.imagePath,
    required this.size,
    required this.decideRangeFunc,
  }) : super(key: key);
  final String imagePath;
  final Size size;
  final VoidCallback decideRangeFunc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height / 25,
      child:
      IconButton(icon: Image(image: AssetImage(imagePath),),
        padding: EdgeInsets.zero,
        highlightColor: Colors.red,
        onPressed: decideRangeFunc,
      )
    );
  }
}



