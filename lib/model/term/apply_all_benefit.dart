import "term.dart";
import '../../util.dart';
import '../Character.dart';

class ApplyAllBenefit extends TermEffect {
  static String type = "applyAll";
  final List<TermEffect> effects;
  final String label;
  bool applied;
  ApplyAllBenefit({this.effects, this.label, this.applied: false});

  static ApplyAllBenefit parse(d, tables) =>
    ApplyAllBenefit(
      effects: parseList(d, "effects", (d) => TermEffect.parse(d, tables)),
      label: d["label"]
    );

  @override
  Character apply(Character c) {
    applied = true;
    return effects.fold(c, (c, e) => e.apply(c));
  }

  @override
  bool get hasChoice => effects.any((e) => e.hasChoice);
  @override
  String toString() => applied == true ?
    effects.join(", ") :
    (label == null) ?
      "Apply multiple benefits" :
      label;
  @override
  String get route => type;

  @override
  TermEffect copy({List<TermEffect> effects}) => ApplyAllBenefit(
    effects: (effects ?? this.effects)?.map((e) => e.copy())?.toList(),
    label: label,
    applied: applied
  );
}