import 'package:dosomething/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool loading;

  RoundedButton({Key? key, required this.buttonLabel, required this.onPressed, required this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 12.0)),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
        }),
        side: MaterialStateProperty.resolveWith((states) {
          Color _borderColor;

          if (states.contains(MaterialState.disabled)) {
            _borderColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _borderColor = Colors.transparent;
          } else {
            _borderColor = Colors.black;
          }

          return BorderSide(color: _borderColor, width: 1);
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return Colors.black;
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black;
          }
          return Colors.transparent;
        }),
      ),
      onPressed: loading ? null : onPressed,
      child: loading ? Row(
        children: [
          SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.black,
              )),
          SizedBox(
            width: 8,
          ),
          Text(buttonLabel, style: Styles.button18,),
        ],
      ) :
      Text(buttonLabel, style: Styles.button18,),
    );
  }
}
