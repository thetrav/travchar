import 'dart:convert';

class Homeworld {
  String region;
  String name;
  String uwp;
  double gravity;
  List<String> trade;
  int str;
  int con;
  int agi;
  int edu;


  Homeworld({this.region, this.name, this.uwp, this.gravity, this.trade,
    this.str, this.con, this.agi, this.edu});

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
    con: map[6],
    agi: map[7],
    edu: map[8]
  );
}