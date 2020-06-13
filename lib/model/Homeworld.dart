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