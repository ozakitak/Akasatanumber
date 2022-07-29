import 'package:akasatanumber/viewModel.dart';
import 'package:flutter/material.dart';

// class SelectRogo{
//   List<SelectedRogoButton> rogoList = [];
//
//   void addSelectedRogo({required selectedRogo}){
//     rogoList.add(SelectedRogoButton(selectedRogo: selectedRogo, viewModel: this,));
//   }
// }
class SelectedRogoButton extends StatefulWidget {
  SelectedRogoButton({Key? key, required this.selectedRogo, required this.rogoNumber, required this.viewModel}) : super(key: key);

  // フィールド
   String selectedRogo;
   String rogoNumber;
   ViewModel viewModel;


  @override
  SelectedRogoButtonState createState() => new SelectedRogoButtonState();



}

class SelectedRogoButtonState extends State<SelectedRogoButton> {
  //  SelectedRogoButtonState(
  //      {
  //   Key? key,
  //   required this.selectedRogo,
  //    required this.viewModel,
  // }
  // ) : super(key: key);
  //  final ViewModel viewModel;



  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;


    return ElevatedButton(child:
    Text(widget.selectedRogo,
      style: TextStyle(fontSize: size.height / 40)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(1),
        primary: Colors.transparent,
        elevation: 0,
        onPrimary: Colors.blue,
      ),
      onPressed: (){
      print(widget.rogoNumber);
      //編集モード
      widget.viewModel.isChangingSelectedWord = true;
      sendSelfToViewModel();

      widget.viewModel.researchMatchWord(widget.rogoNumber);

      },
    );
  }
  void sendSelfToViewModel() {
    widget.viewModel.rogoButton = widget;
  }
  void changeRogo(String rogo) {
    setState(() {
      widget.selectedRogo = rogo;
    });
  }
}
