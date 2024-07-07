import 'package:flutter/material.dart';

class FallingContainer extends StatefulWidget {
  final double xPosition;
  final VoidCallback onFinished;

  FallingContainer(
      {Key? key, required this.xPosition, required this.onFinished})
      : super(key: key);

  @override
  _FallingContainerState createState() => _FallingContainerState();
}

class _FallingContainerState extends State<FallingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _fallAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFinished();
        }
      });

    _fallAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0.75),
    ).animate(_controller);

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _fallAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: widget.xPosition),
            width: 50,
            height: 50,
            child: Image.asset('assets/rain.png'),
          ),
        ),
      ),
    );
  }
}
