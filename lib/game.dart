import 'package:flutter/material.dart';
// import 'package:telly/game_data.dart';
import 'dart:async';
import 'dart:math';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  // GameData game = GameData();

  int level = 1;
  int score = 0;
  bool isPlaying = true;
  Color? targetColor;
  Color? dummyColor;
  int? targetIndex;
  late Timer timer;
  int timeLeft = 10;

  Random random = Random();

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    targetIndex = random.nextInt((getGridDimension() * getGridDimension()) - 1);
    nextColor();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (timer) {
        if (isPlaying) {
          if (timeLeft == 0) {
            setState(() {
              timer.cancel();
            });
            endGame();
          } else {
            setState(() {
              timeLeft--;
            });
          }
        }
      },
    );
  }

  // void reset() {
  //   setState(() {
  //     level = 1;
  //     score = 0;
  //     isPlaying = true;
  //   });
  // }

  void nextLevel() {
    setState(() {
      level++;
      score += level * timeLeft;
      timeLeft = 10;
      targetIndex =
          random.nextInt((getGridDimension() * getGridDimension()) - 1);
    });
    nextColor();
  }

  void addScore(int value) {
    setState(() {
      score += value;
    });
  }

  void endGame() {
    setState(() {
      isPlaying = false;
    });
    GameOver();
  }

  void continuePlaying() {
    setState(() {
      isPlaying = true;
      // timeLeft = 10;
    });
    startTimer();
    nextLevel();
  }

  int getGridDimension() {
    // Level 1: 2x2
    // Level 15: 3x3
    // Level 30: 4x4
    // Level 50: 5x5

    // Max: 75
    // if (level < 15) return 2;
    if (level >= 15 && level < 30) return 3;
    if (level >= 30 && level < 50) return 4;
    if (level >= 50) return 5;

    // default
    return 2;
  }

  void nextColor() {
    // Random random = Random();
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);

    int offset = 50;

    if (getGridDimension() == 3) {
      offset = 25;
    } else if (getGridDimension() == 4) {
      offset = 12;
    } else if (getGridDimension() == 5) {
      offset = 6;
    }

    int rOffset = random.nextInt(offset);
    int gOffset = random.nextInt(offset);
    int bOffset = random.nextInt(offset);

    if (r + rOffset > 255) {
      rOffset = -rOffset;
    } else if (g + gOffset > 255) {
      gOffset = -gOffset;
    } else if (b + bOffset > 255) {
      bOffset = -bOffset;
    }

    setState(() {
      targetColor = Color.fromRGBO(normalize(r + rOffset),
          normalize(g + gOffset), normalize(b + bOffset), 1.0);
      dummyColor = Color.fromRGBO(r, g, b, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return SafeArea(

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text("Level: $level", style: TextStyle(fontSize: 40)),
                Text("Score: $score", style: TextStyle(fontSize: 30)),
                Text("Time left: $timeLeft", style: TextStyle(fontSize: 30)),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Flexible(
                    child: GridView.count(
                        // primary: true,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: getGridDimension(),
                        // childAspectRatio: 1,
                        children: List.generate(
                            pow(getGridDimension(), 2) as int, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  if (targetIndex == index) {
                                    nextLevel();
                                  } else {
                                    endGame();
                                  }
                                },
                                child: Ink(
                                  height: 50,
                                  width: 50,
                                  color: targetIndex == index
                                      ? targetColor
                                      : dummyColor,
                                )),
                          );
                        })),
                  ),
                ),
              ])),
        ));
  }

  Future<void> GameOver() async {
    await showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushReplacementNamed(context, '/home');
              return false;
            },
            child: SimpleDialog(
              title: const Center(
                child: Text(
                  'Game Over!',
                  style: TextStyle(fontSize: 50),
                ),
              ),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    // Navigator.popUntil(context, ModalRoute.withName('/home'));
                    // return true;
                    // this.deactivate();}
                    // Navigator.
                    Navigator.pop(context, true);
                    continuePlaying();
                    // return true;
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Continue ', style: TextStyle(fontSize: 30)),
                        Icon(
                          Icons.movie,
                          size: 30,
                        )
                      ]),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/home'); // TODO: Black screen on popUntil
                    // Navigator.popUntil(context, ModalRoute.withName('/home'));
                    // Navigator.of(context, rootNavigator: true)
                    //     .popUntil(ModalRoute.withName('/home'));
                    // .pushNamed('/home');
                    // Navigator.pop(context);
                  },
                  child: const Center(
                      child: Text('Main menu', style: TextStyle(fontSize: 30))),
                ),
              ],
            ),
          );
        });
  }
}

// Avoid overflow when generating RGB colors
int normalize(int value, {int min = 0, int max = 255}) {
  if (value < min) {
    return min;
  } else if (value > max) {
    return max;
  } else {
    return (min + (value * (max - min) / max)).floor();
  }
}
