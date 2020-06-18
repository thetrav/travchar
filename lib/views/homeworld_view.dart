

import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/TListView.dart';
import 'package:travchar/components/TLoader.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/Dice.dart';
import 'package:travchar/model/Homeworld.dart';
import 'package:travchar/model/tables.dart';
import 'package:tuple/tuple.dart';

class HomeworldView extends StatelessWidget {

  final Character character;
  final String nextRoute;
  HomeworldView(this.nextRoute, this.character);

  @override
  Widget build(BuildContext context) => TLoader(
    Tables.load(context),
    (c, t) => HomeworldLoadedView(
      nextRoute: nextRoute,
      character: character,
      tables: t
    )
  );
}

class HomeworldLoadedView extends StatefulWidget {
  final Character character;
  final Tables tables;
  List<Homeworld> get homeworlds => tables.homeworlds;
  final String nextRoute;
  HomeworldLoadedView({this.character, this.tables, this.nextRoute});
  @override
  State<StatefulWidget> createState() => HomeworldViewState();

}

class HomeworldViewState extends State<HomeworldLoadedView> {

  List<Homeworld> get homeworlds => widget.homeworlds;

  void select(Homeworld h, BuildContext c) {
    Navigator.pushReplacementNamed(c, widget.nextRoute,
      arguments: Tuple2<Character, Tables>(
        widget.character.copy(
          homeworld: h,
          skills: widget.tables.skills.map((s) => s.copy()).toList()
        ),
        widget.tables
      )
    );
  }

  void randomHomeworld(BuildContext c) =>
    select(homeworlds[dice.roll(1,homeworlds.length).first-1], c);

  Widget listTile(Homeworld h, BuildContext c) =>
    ListTile(
      leading: Text(h.region),
      title: Text(h.name),
      subtitle: Text("UWP: ${h.uwp} Trades: ${h.tradeCodes.join(",")}"),
      onTap: () => select(h, c)
    );

  @override
  Widget build(BuildContext context) =>
    TListView(
      homeworlds,
      listTile,
      header: (c)=> TButton("random", () => randomHomeworld(c))
    );

}