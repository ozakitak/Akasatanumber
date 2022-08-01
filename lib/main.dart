
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
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







    viewModel.setIntroduce();
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
                  SelectedNumbers(size: size, viewModel: viewModel,),

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

                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: size.height / 15,
                    width: size.width - 100,
                    child: SingleChildScrollView(
                      controller: viewModel.customScrollController,
                      child:
                          Wrap(
                            children:
                            viewModel.customCharacterList,
                          )
                    ),
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
                          Visibility(
                              visible: viewModel.isIntroduce ,
                              child:
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(size.width / 10, size.height/50, size.width/10, size.height/50),

                                child:
                                AnimatedTextKit(
                                  animatedTexts: [
                                    FadeAnimatedText(
                                        viewModel.introduceStr
                                        ,
                                        textAlign: TextAlign.center
                                        ,
                                        textStyle: TextStyle(fontFamily: 'dotGothic',
                                            fontSize:  17,
                                            color:
                                            Color.fromARGB(1000,94,94,94)),
                                        duration: Duration(seconds: 100),
                                        fadeOutBegin: 0.9,
                                        fadeInEnd: 0.01
                                    )
                                  ],
                                ),
                              ),
                          ),


                  //ListView
                  WordListView(size: size, items: viewModel.matchRogoList, viewModel: viewModel,),

                          // Visibility(
                          //   visible: viewModel.isCustom,
                          //   child:
                          //   CustomMenu(size: size, viewModel: viewModel,),
                          // ),

                          Visibility(
                              visible: !viewModel.isCustom,
                              child:
                              CustomEditBtn(size: size, viewModel: viewModel,),
                          ),
                          //鉛筆ボタン

                          Visibility(
                            visible: viewModel.isCustom,
                              child:
                              Stack(
                                children: [

                                  Align(alignment: Alignment(0.9,0.9),
                                    child:
                                    IgnoreCharacter(ignoreCharacter: "ー", size: size,
                                      onPressed: (){
                                        viewModel.ignoredCharacterBtnListener(false);
                                      },),
                                  ),
                                  Align(alignment: Alignment(0.7,0.5),
                                    child:
                                    IgnoreCharacter(ignoreCharacter: "ッ", size: size,
                                      onPressed: (){
                                        viewModel.ignoredCharacterBtnListener(true);
                                      },),
                                  )
                                ],
                              )
                          ),
                        ],
                      )
                  ),
                  Visibility(
                    visible: viewModel.isCustom,
                      child:
                      CustomMenus(size: size, viewModel: viewModel,),
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
                        height: size.height / 5 + viewModel.expandHeight,
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
                            height: size.height / 5.8 + viewModel.expandHeight,
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
                                    viewModel.copyClickListener();
                                    },
                                  ),),

                                //deleteButtonn
                                Align(alignment: Alignment(1,1),
                                  child: FooterIconBtn(size: size, imagePath: 'assets/images/deleteSelectWord.png',
                                    onPressd: (){
                                    viewModel.buildDeleteDialog(context);
                                    },),
                                ),
                                Align(alignment: Alignment(0,-1),
                                  child: FooterIconBtn(size: size,
                                    imagePath: viewModel.isExpand ? 'assets/images/down.png' : 'assets/images/expandBtn.png',
                                    onPressd: (){
                                      //expand
                                      viewModel.expandBox(size.height / 2);

                                    },),
                                ),

                                //expandButton

                                //選択されたワード
                                Align(
                                    alignment: Alignment(0,1),
                                    child: Container(
                                      height: size.height / 8 + viewModel.expandHeight ,
                                      width: size.width  - 110,
                                      child:SingleChildScrollView(
                                        controller: viewModel.scrollController,

                                        child:
                                        Wrap(
                                          children: viewModel.selectedRogoList,
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

class CustomMenus extends StatelessWidget {
   const CustomMenus({
    Key? key,
    required this.size,
    required this.viewModel,
  }) : super(key: key);


  final Size size;
  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            CustomMenuButtons(size: size,
            imagePath: "assets/images/deleteKatakana.png",
            onPressd: () {
              viewModel.deleteCharacterBtnListener();
            },),

              CustomMenuButtons(size: size,
                imagePath: "assets/images/done.png",
                onPressd: () {
                  viewModel.okBtnClickListener(context);
                },),
              SizedBox(
                width: size.width / 15,
              )
            ]
        ),
      ],
    );
  }
}

class CustomMenuButtons extends StatelessWidget {
  const CustomMenuButtons({
    Key? key,
    required this.size,
    required this.imagePath,
    required this.onPressd,
  }) : super(key: key);


  final VoidCallback onPressd;
  final String imagePath;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return
      Container(
          height: size.height / 22,
          width: size.height / 22,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child:
          ElevatedButton(onPressed: onPressd,
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                elevation: 0,
                primary: Colors.transparent
            )
            ,
            child:
            Image.asset(imagePath),
          ),
      );
  }
}

class IgnoreCharacter extends StatelessWidget {
   IgnoreCharacter({
    Key? key,
    required this.onPressed,
    required this.ignoreCharacter,
    required this.size,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String ignoreCharacter;
  final Size size;


  @override
  Widget build(BuildContext context) {
    return
    Container(
      height: size.height / 20,
      width: size.height / 15,
      child:
      ElevatedButton(onPressed: onPressed,
          style:
          ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            elevation: 0,
            primary: Colors.transparent,
          )
          ,
          child:
          Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                ignoreCharacter ,
                style: TextStyle(
                  fontFamily: 'dotGothic',
                  shadows: [
                    Shadow(
                        offset: Offset(0, 5.0),
                        blurRadius: 8.0,
                        color: Colors.grey
                    ),

                  ],
                  fontSize: size.height / 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.black,

                ),
              ),
              // Solid text as fill.
              Text(
                ignoreCharacter,
                style: TextStyle(
                  fontFamily: 'dotGothic',
                  fontSize: size.height / 30,
                  color: Colors.black
                ),
              ),
            ],
          )
      ),
    );
  }
}

class CustomEditBtn extends StatelessWidget {
  const CustomEditBtn({
    Key? key,
    required this.size,
    required this.viewModel,
  }) : super(key: key);

  final Size size;
  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment(1,0.9),
        child:
        IconButton(icon:
        Icon(Icons.edit, size: size.height/20,

            color: Color.fromARGB(450,19, 117, 45)),
          onPressed: () {
          viewModel.customRogoBtnListener();
          },
        )
    );
  }
}

class CustomMenu extends StatelessWidget {
  const CustomMenu({
    Key? key,
    required this.size,
    required this.viewModel,
  }) : super(key: key);

  final Size size;
  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment(0.95,0),
      child:
          Stack(
            children: [

              //menu background
              Container(
                width: size.width / 10,
                height: size.height / 4.5,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    // Color.fromARGB(1000, 215, 217, 149),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(1, 4),
                      ),
                    ],

                  ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height /60,
                    ),

                    //ちっちゃいつ
                    SizedBox(
                      height: size.height /30,
                      child:
                      ElevatedButton(
                        child: Text("  ツ" ,
                          style: TextStyle(color: Colors.black,
                              fontSize: size.height /75),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            primary: Colors.transparent

                        ),
                        onPressed: (){
                          viewModel.ignoredCharacterBtnListener(true);
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      thickness: 1,
                    ),

                    //伸ばし棒
                    SizedBox(
                      height: size.height /30,
                      child:
                      ElevatedButton(
                        child: Text("ー" ,
                          style: TextStyle(color: Colors.black,
                              fontSize: size.height /40),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            primary: Colors.transparent

                        ),
                        onPressed: (){
                          viewModel.ignoredCharacterBtnListener(false);
                        },
                      ),
                    ),
                    Divider(color: Colors.black26, thickness: 1,),
                    //Delete katakana
                    SizedBox(
                      height: size.height /30,
                      child:
                          ElevatedButton(
                            child: Image.asset('assets/images/deleteKatakana.png'),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                primary: Colors.transparent

                            ),
                            onPressed: (){
                              viewModel.deleteCharacterBtnListener();
                            },
                          ),
                      // IconButton(icon: ,
                      //   onPressed: (){
                      //
                      //   },)
                    ),
                    Divider(color: Colors.black26, thickness: 1,),

                  //OK
                  SizedBox(
                    height: size.height /25,
                    child:
                    ElevatedButton(
                      child: Icon(
                        Icons.done,
                        color: Colors.blueAccent,
                        size: size.height / 30,
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          primary: Colors.transparent

                      ),
                      onPressed: (){
                        viewModel.okBtnClickListener(context);
                      },
                    ),
                  ),
                  ],
                )
              ),
            ],
          ),
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
    required this.viewModel,
  }) : super(key: key);

  final Size size;
  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [

          Opacity(opacity: 0, child:
          Text(viewModel.limitedSubNumbers),),
          Spacer(),

          Text(viewModel.mainNumbers, style: TextStyle(fontSize: size.height / 20,
              fontFamily: 'sawarabi',
              color: viewModel.editingColor),),
          Container(
            height: size.height / 35,
            child: Text(viewModel.limitedSubNumbers, style: TextStyle(fontSize: size.height / 60,),),
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
                      style: TextStyle(fontSize: size.height / 35,
                        fontFamily: 'dotGothic',
                        color:
                          Color.fromARGB(1000,94,94,94)
                      ),),
                    ),
                      onTap:
                      (){
                      if(viewModel.isCustom){
                        viewModel.customModeListTileClickListener(items[index]);

                      }else {
                        viewModel.listTileClickListener(items[index]);
                      }

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



