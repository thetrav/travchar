import 'dart:math';

import 'package:travchar/util.dart';

class Dice {
  Dice() {
    print("new random seed!");
  }
  final r = Random();
  int d(int sides) => r.nextInt(sides)+1;

  List<int> roll(count, sides) =>
    range(count).map((i)=> d(sides)).toList();

  T tableRoll<T>(Map<int, T> table) =>
    table[r.nextInt(table.length)];
}

final dice = Dice();