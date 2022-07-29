import 'package:flutter/material.dart';

class SelectRogo{
  List<SelectedRogoButton> rogoList = [];

  void addSelectedRogo({required selectedRogo}){
    rogoList.add(SelectedRogoButton(selectedRogo: selectedRogo));
  }
}
class SelectedRogoButton extends StatelessWidget {
   SelectedRogoButton({
    Key? key,
    required this.selectedRogo,
  }) : super(key: key);

   String selectedRogo;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;


    return ElevatedButton(child: Text(selectedRogo,
      style: TextStyle(fontSize: size.height / 40),
    ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(1),
        primary: Colors.transparent,
        elevation: 0,
        onPrimary: Colors.blue,
      ),
      onPressed: (){
      changeRogo();
      },
    );
  }
  void changeRogo() {
    selectedRogo = "";
  }
}
