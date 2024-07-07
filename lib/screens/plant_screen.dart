import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_animation/widgets/falling_container.dart';
import 'package:test_animation/widgets/token_widget.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  GlobalKey startKey = GlobalKey();
  GlobalKey endKey = GlobalKey();
  List<Widget> allTokens = [];

  bool _isTapped = false;
  bool _cloudsVisible = false;

  List<String> plantImages = [
    "assets/1.png",
    "assets/2.png",
    "assets/3.png",
    "assets/4.png",
    "assets/5.png",
    "assets/6.png",
    "assets/7.png",
  ];

  int _index = 0;
  double width = 200;
  double height = 200;
  int counter = 0;
  List<Widget> _fallingContainers = [];

  @override
  void initState() {
    super.initState();
    // Başlangıçta bulutları gizle
    _cloudsVisible = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Bulutları 1 saniye sonra göstermek için
      setState(() {
        _cloudsVisible = true;
      });
    });
  }

  void _addFallingContainer() {
    final randomX =
        Random().nextDouble() * (MediaQuery.of(context).size.width - 30);
    final container = FallingContainer(
      key: UniqueKey(),
      xPosition: randomX,
      onFinished: _removeFallingContainer,
    );
    setState(() {
      _fallingContainers.add(container);
    });
    addToken();
  }

  void _removeFallingContainer() {
    setState(() {
      _fallingContainers.removeAt(0);
    });
  }

  void addToken() async {
    RenderBox startBox =
        startKey.currentContext!.findRenderObject() as RenderBox;
    RenderBox endBox = endKey.currentContext!.findRenderObject() as RenderBox;

    Offset startPosition = startBox.localToGlobal(Offset.zero);
    Offset endPosition = endBox.localToGlobal(Offset.zero);
    Size startBoxSize = startBox.size;
    Size endBoxSize = endBox.size;
    Offset destination = Offset(startPosition.dx + startBoxSize.width / 2 - 15,
        startPosition.dy + startBoxSize.height / 2 - 15);

    Offset targetPosition = Offset(endPosition.dx + endBoxSize.width / 2 - 15,
        endPosition.dy + endBoxSize.height / 2 - 15);
    counter++;
    if (counter % 20 == 0 && _index < 6) {
      _isTapped = !_isTapped;
      _index++;
      height += 50;
      width += 50;
      for (var i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 75));
        allTokens.add(TokenWidget(start: destination, end: targetPosition));
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: InkWell(
        onTap: () {
          _addFallingContainer();
        },
        child: Stack(
          children: [
            ..._fallingContainers,
            AnimatedPositioned(
              left: _cloudsVisible ? -10 : -220,
              top: -50,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/cloud.png'),
              ),
            ),
            AnimatedPositioned(
              left: _cloudsVisible ? 150 : 370,
              top: -50,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/cloud.png'),
              ),
            ),
            AnimatedPositioned(
              left: _cloudsVisible ? 250 : 470,
              top: -50,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/cloud.png'),
              ),
            ),
            Positioned(
              top: 100,
              right: 10,
              child: Container(
                height: 100,
                width: 100,
                key: endKey,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: AnimatedContainer(
                key: startKey,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceInOut,
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      plantImages[_index],
                    ),
                  ),
                ),
              ),
            ),
            ...allTokens,
          ],
        ),
      ),
    );
  }
}
