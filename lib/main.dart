//
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   static const String _title = 'Sample App';
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: _title,
//       home: Scaffold(
//         body: MyStatefulWidget(),
//       ),
//     );
//   }
// }
//
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController mailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController comPassController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     final Size size = MediaQuery.of(context).size;
//
//     return Padding(padding: EdgeInsets.all(30),
//         child: Column(
//       children: [
//         Stack(
//           children: [
//             Image(image: AssetImage('assets/images/appBar.png')),
//             Align(alignment: Alignment(0,0.9),
//                 child: SizedBox(
//                     height: size.height / 40,
//                     child: Image(image: AssetImage('assets/images/appTitle.png'),)
//                 )
//             )
//           ],
//         )
//       ],
//     )
//     );
//   }
// }
//
//
//




import 'package:flutter/material.dart';

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
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController comPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Container(
        child: Stack(
          children: [
            //背景の白さが足りかったので
            Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
            ),
            Container(

              decoration: BoxDecoration(
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

            ),
            Align(
              alignment: Alignment(0.3,-1 + size.height / 8000),
              child: SizedBox(height: size.height / 45,
                  child: Image(image: AssetImage('assets/images/appTitle.png'))
              )
            ),
            Align(
                alignment: Alignment(0,-1 + size.height / 4200),
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
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "　　数字を入力してください",


                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 30,
                        child:
                        IconButton(icon: Image(image: AssetImage('assets/images/deleteInputNum.png'),),
                          padding: EdgeInsets.zero,
                          highlightColor: Colors.red,
                          onPressed: () {
                            print("a");
                          },
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Positioned(
              top: size.height / 5,
              width: size.width,

              child: Column(
              children: [
                SizedBox(
                  height: size.height / 15,
                  child:
                  ElevatedButton(onPressed: (){}, child: Image(image: AssetImage('assets/images/generateRogo.png'), ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      onPrimary: Colors.blue,
                    ),
                  )
                ),
                SizedBox(height: size.height / 50,),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Opacity(opacity: 0, child:
                      Text("123456789..."),),
                    Spacer(),
                    Text("12345", style: TextStyle(fontSize: size.height / 20,),),
                    Container(
                       height: size.height / 35,
                      child: Text("123456789...", style: TextStyle(fontSize: size.height / 60,),),
                    ),
                    Spacer(),

                  ],
                ),
                SizedBox(height: size.height / 80,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    rangeArrowBtn(imagePath: 'assets/images/arrowLeft.png',size: size,
                      decideRangeFunc: () {},),
                    SizedBox(width: size.width / 10,),

                    rangeArrowBtn(imagePath: 'assets/images/arrowRight.png',size: size,
                    decideRangeFunc: () {},)
                  ],
                ),

                ListView.builder(itemCount: 3,
                    itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      leading: IconButton(icon: Icon(Icons.account_circle),
                        onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog((
                          context: Text("Hello leading Icon"),
                          ))
                        })
                        },
                      )
                    ),
                  );

                })



              ],
              ),
            )
          ],
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



