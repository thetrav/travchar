import 'dart:math';

import 'package:travchar/util.dart';

class Dice {
  final r = Random();
  int d(int sides) => r.nextInt(sides)+1;

  List<int> roll(count, sides) =>
    range(count).map((i)=> d(sides)).toList();
}

final dice = Dice();