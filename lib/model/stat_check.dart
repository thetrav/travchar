
import 'package:travchar/model/Character.dart';

import '../util.dart';
import 'Dice.dart';
import 'requirement.dart';

class StatCheck extends Requirement {
  String stat;
  int target;
  StatCheck(this.stat, this.target);
  static StatCheck parse(d) =>
    StatCheck(d["stat"], d["target"]);

  @override
  bool evaluate(Character c) {
    final roll = dice.roll(2, 6);
    final dm = c.stat(stat).diceMod;
    final result = (sum(roll)+dm) >= target;
    print("Stat Check $result against $stat rolled $roll + $dm needed $target");
    return result;
  }

  @override
  String toString() => "$stat against $target";
}