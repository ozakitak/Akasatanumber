import 'package:flutter/material.dart';

class SelectRogo{
  List<SelectedRogoButton> rogoList = [];

  void addSelectedRogo({required selectedRogo}){
    rogoList.add(SelectedRogoButton(selectedRogo: selectedRogo));
  }
}
class SelectedRogoButton extends StatelessWidget {
  const SelectedRogoButton({
    Key? key,
    required this.selectedRogo,
  }) : super(key: key);

  final String selectedRogo;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;


    // return SizedBox(
    //     height: size.height / 100,
    //     width: size.width / 7,
    //     child:
    // );
    return ElevatedButton(child: Text(selectedRogo,
      style: TextStyle(fontSize: size.height / 40),
    ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: Colors.transparent,
        elevation: 0,
        onPrimary: Colors.blue,
      ),
      onPressed: (){
      },
    );
  }
}
