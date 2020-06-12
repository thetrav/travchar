

import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/TListView.dart';
import 'package:travchar/components/TLoader.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/Dice.dart';
import 'package:travchar/model/Homeworld.dart';

import '../util.dart';

class HomeworldView extends StatelessWidget {

  final Character character;
  final String nextRoute;
  HomeworldView(this.nextRoute, this.character);

  @override
  Widget build(BuildContext context) => TLoader(
    DefaultAssetBundle.of(context)
      .loadString("assets/homeworlds.json")
      .then(Homeworld.load),
    (c, h) => HomeworldLoadedView(
      nextRoute: nextRoute,
      character: character,
      homeworlds: h
    )
  );
}

class HomeworldLoadedView extends StatefulWidget {
  final Character character;
  final List<Homeworld> homeworlds;
  final String nextRoute;
  HomeworldLoadedView({this.character, this.homeworlds, this.nextRoute});
  @override
  State<StatefulWidget> createState() => HomeworldViewState();

}

class HomeworldViewState extends State<HomeworldLoadedView> {

  List<Homeworld> get homeworlds => widget.homeworlds;

  void select(Homeworld h, BuildContext c) {
    Navigator.pushReplacementNamed(c, widget.nextRoute,
      arguments: widget.character.copy(
        homeworld: h
      )
    );
  }

  void randomHomeworld(BuildContext c) =>
    select(homeworlds[dice.roll(1,homeworlds.length).first], c);

  Widget listTile(Homeworld h, BuildContext c) =>
    ListTile(
      leading: Text(h.region),
      title: Text(h.name),
      subtitle: Text("UWP: ${h.uwp} Trades: ${h.trade.join(",")}"),
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