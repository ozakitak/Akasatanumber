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
  SelectedRogoButton({Key? key, required this.selectedRogo, required this.rogoNumber, required this.viewModel, }) : super(key: key);

  // フィールド
  String selectedRogo;
   String rogoNumber;
   ViewModel viewModel;
  SelectedRogoButtonState? state;

  bool isColorBlue = true;


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
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!mounted){
      return;
    }

    widget.state = this;
  }

  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;


    return ElevatedButton(child:
    Text(widget.selectedRogo,
      style: TextStyle(fontSize: size.height / 40,
        fontFamily: 'sawarabi',
      ),),
      style:
      ElevatedButton.styleFrom(
        padding: EdgeInsets.all(3),
        primary: Colors.transparent,
        elevation: 0,
        onPrimary: color,
      ),
      onPressed: enableFunc
    );
  }

  enableFunc(){
    if(!widget.viewModel.isChangngRogo) {
      //選択数字を置き換える
      widget.viewModel.replaceMainNumbers();
      //編集モード
      changeColor();
      widget.viewModel.isChangngRogo = true;
      sendSelfToViewModel();

      widget.viewModel.researchMatchWord(widget.rogoNumber, false);

    } else {

    }


  }

  void changeColor() {
    setState(() {
      if(!mounted) {
        return;
      }
      if(widget.isColorBlue){
        color = Colors.red;
        widget.viewModel.editingColor = Colors.red;
      } else {
        color = Colors.blue;
        widget.viewModel.editingColor = Colors.black;
      }
      widget.isColorBlue = !widget.isColorBlue;
    });
  }

  void sendSelfToViewModel() {
    if(!mounted){
      return;
    }
    widget.viewModel.rogoButton = widget;
  }

  void changeRogo(String rogo) {
    setState(() {
      //なぜか不定期でエラーになる
      if(!mounted) {
        return;
      }
      widget.selectedRogo = rogo;

    });
  }
}
//
