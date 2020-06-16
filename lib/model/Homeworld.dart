import 'dart:convert';

class Homeworld {
  final String region;
  final String name;
  final String uwp;
  final double gravity;
  final List<String> tradeCodes;
  final int str;
  final int end;
  final int dex;
  final int edu;

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
    "Starport": 0,
    "Size": 1,
    "Atmosphere": 2,
    "Hydropgraphic": 3,
    "Population": 4,
    "Government": 5,
    "Law": 6,
    "Tech": 8
  }[code]);


  Homeworld({this.region, this.name, this.uwp, this.gravity, this.tradeCodes,
    this.str, this.end, this.dex, this.edu});

  Map<String, int> get statAdjustments => {
    "str": this.str,
    "dex": this.dex,
    "end": this.end,
    "edu": this.edu
  };

  static List<Homeworld>load(String value) {
    final List<dynamic> rows = jsonDecode(value);
    return rows.sublist(1).map(Homeworld.fromMap).toList();
  }

  static Homeworld fromMap(map) => Homeworld(
    region: map[0],
    name: map[1],
    uwp: map[2],
    gravity: map[3],
    tradeCodes: map[4].split(" "),
    str: map[5],
    end: map[6],
    dex: map[7],
    edu: map[8]
  );
}