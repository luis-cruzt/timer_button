library timer_button;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

enum ButtonType {
  RaisedButton,
  FlatButton,
  OutlineButton,
  ElevatedButton,
  TextButton,
  OutlinedButton
}

const int aSec = 1;

const String _secPostFix = 's';
const String labelSplitter = " |  ";

class TimerButton extends StatefulWidget {
  /// Create a TimerButton button.
  ///
  /// The [label], [onPressed], and [timeOutInSeconds]
  /// arguments must not be null.

  ///label
  final String label;

  ///secPostFix
  final String secPostFix;

  ///[timeOutInSeconds] after which the button is enabled
  final int timeOutInSeconds;

  ///[onPressed] Called when the button is tapped or otherwise activated.
  final VoidCallback onPressed;

  /// Defines the button's base colors
  final Color color;

  /// The color to use for this button's background/border when the button is disabled.
  final Color disabledColor;

  /// activeTextStyle
  final TextStyle? activeTextStyle;

  ///disabledTextStyle
  final TextStyle disabledTextStyle;

  ///buttonType
  final ButtonType buttonType;

  ///If resetTimerOnPressed is true reset the timer when the button is pressed : default to true
  final bool resetTimerOnPressed;

  const TimerButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.timeOutInSeconds,
    this.secPostFix = _secPostFix,
    this.color = Colors.blue,
    this.resetTimerOnPressed = true,
    this.disabledColor = Colors.grey,
    this.buttonType = ButtonType.RaisedButton,
    this.activeTextStyle,
    this.disabledTextStyle = const TextStyle(color: Colors.black45),
  }) : super(key: key);

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  bool timeUpFlag = false;
  int timeCounter = 0;
  late Timer timer;
  
  String get _timerText => '$timeCounter${widget.secPostFix}';

  @override
  void initState() {
    super.initState();
    timeCounter = widget.timeOutInSeconds;
    _timerUpdate();
  }

   _timerUpdate() {
    if (!mounted) return;
     timer = Timer(const Duration(seconds: aSec), () {
      setState(() {
        timeCounter--;
      });

      if (timeCounter > 0)
        _timerUpdate();
      else
        timeUpFlag = true;
    });
  }
  
  dispose() {
    super.dispose();
    timer.cancel();
  }

  Widget _buildChild() {
    TextStyle? activeTextStyle;
    if (widget.activeTextStyle == null) {
      if (widget.buttonType == ButtonType.OutlinedButton ||
          widget.buttonType == ButtonType.OutlineButton) {
        activeTextStyle = TextStyle(color: widget.color);
      } else {
        activeTextStyle = TextStyle(color: Colors.white);
      }
    } else {
      activeTextStyle = widget.activeTextStyle;
    }
    return Container(
      child: timeUpFlag
          ? Text(
              widget.label,
              style: activeTextStyle,
            )
          : Text(
              widget.label + labelSplitter + _timerText,
              style: widget.disabledTextStyle,
            ),
    );
  }

  _onPressed() {
    if (timeUpFlag) {
      setState(() {
        timeUpFlag = false;
      });
      timeCounter = widget.timeOutInSeconds;

      widget.onPressed();

      // reset the timer when the button is pressed
      if (widget.resetTimerOnPressed) {
        _timerUpdate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      //RaisedButton is deprecated, use ElevatedButton instead
      case ButtonType.RaisedButton:
        //TODO: (Ajay) Remove deprecated members
        // ignore: deprecated_member_use
        return RaisedButton(
          disabledColor: widget.disabledColor,
          color: timeUpFlag ? widget.color : widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
      //FlatButton is deprecated, use TextButton instead
      case ButtonType.FlatButton:
        // ignore: deprecated_member_use
        return FlatButton(
          color: timeUpFlag ? widget.color : widget.disabledColor,
          disabledColor: widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
      //OutlineButton is deprecated, use OutlinedButton instead
      case ButtonType.OutlineButton:
        // ignore: deprecated_member_use
        return OutlineButton(
          borderSide: BorderSide(
            color: timeUpFlag ? widget.color : widget.disabledColor,
          ),
          disabledBorderColor: widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
      case ButtonType.ElevatedButton:
        return ElevatedButton(
            onPressed: _onPressed,
            child: _buildChild(),
            style: ElevatedButton.styleFrom(
              primary: timeUpFlag ? widget.color : widget.disabledColor,
            ));
      case ButtonType.TextButton:
        return TextButton(
            onPressed: _onPressed,
            child: _buildChild(),
            style: TextButton.styleFrom(
              backgroundColor: timeUpFlag ? widget.color : widget.disabledColor,
            ));
      case ButtonType.OutlinedButton:
        return OutlinedButton(
            onPressed: _onPressed,
            child: _buildChild(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: timeUpFlag ? widget.color : widget.disabledColor,
              ),
            ));
      default:
        return Container();
    }
  }
}
