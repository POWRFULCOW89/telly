import 'package:flutter/material.dart';
import 'dart:math';

class GameData {
  int level = 1;
  int score = 0;
  bool isPlaying = true;
  Color? targetColor;
  Color? dummyColor;
  int? targetIndex;

  void init() {
    nextColor();
  }

  void reset() {
    level = 1;
    score = 0;
    isPlaying = true;
  }

  void nextLevel() {
    level++;
    // score = 0;
    print('level: $level');
  }

  void addScore(int value) {
    score += value;
  }

  void endGame() {
    isPlaying = false;
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
    Random random = Random();
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);

    int colorOffset = random.nextInt(50);

    targetColor = Color.fromRGBO(normalize(r - colorOffset),
        normalize(g - colorOffset), normalize(b - colorOffset), 1.0);
    dummyColor = Color.fromRGBO(r, g, b, 1);

    targetIndex = random.nextInt((getGridDimension() * getGridDimension()) - 1);
    print('New target: $targetIndex');
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
