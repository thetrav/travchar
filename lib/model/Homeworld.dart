import 'dart:convert';

import 'package:travchar/model/Character.dart';

class Homeworld {
  String region;
  String name;
  String uwp;
  double gravity;
  List<String> trade;
  int str;
  int end;
  int dex;
  int edu;

  String uwpCode(int index) => uwp.substring(index, index+1);
  int uwpNumber(int index) => int.parse("0x${uwpCode(index)}");

  String get starPort => uwpCode(0);
  int get size => uwpNumber(1);
  int get atmosphere => uwpNumber(2);
  int get hydrographic => uwpNumber(3);
  int get population => uwpNumber(4);
  int get government => uwpNumber(5);
  int get law => uwpNumber(6);
  int get tech => uwpNumber(8);

  int uwpByCode(String code) =>uwpNumber({
    "Size": 1,
    "Atmosphere": 2,
    "Hydropgraphic": 3,
    "Population": 4,
    "Government": 5,
    "Law": 6,
    "Tech": 8
  }[code]);


  Homeworld({this.region, this.name, this.uwp, this.gravity, this.trade,
    this.str, this.end, this.dex, this.edu});

  Map<String, StatAdjustment> get statAdjustments {
    final mods = <String, StatAdjustment>{};
    void apply(String s, int v) {
      if(v != 0) {
        mods[s] = StatAdjustment(v, "Homeworld");
      }
    }
    apply("str", this.str);
    apply("dex", this.dex);
    apply("end", this.end);
    apply("edu", this.edu);
    return mods;
  }

  static List<Homeworld>load(String value) {
    final List<dynamic> rows = jsonDecode(value);
    return rows.sublist(1).map(Homeworld.fromMap).toList();
  }

  static Homeworld fromMap(map) => Homeworld(
    region: map[0],
    name: map[1],
    uwp: map[2],
    gravity: map[3],
    trade: map[4].split(" "),
    str: map[5],
    end: map[6],
    dex: map[7],
    edu: map[8]
  );
}