
import 'package:flutter/material.dart';

List<int> range(int size) =>
  new List<int>.generate(size, (i) => i);

Map<X, Y> mapMap<X,Y,Z>(Map<X,Z> m, Y Function(Z) f) =>
  new Map.fromIterable(m.keys, key: (k) => k , value: (v) => f(m[v]));

int sum(List<int> l) =>
  l?.fold(0, (v, e)=> v+e) ?? 0;

T arg<T>(BuildContext c) =>
  ModalRoute.of(c).settings.arguments as T;

List<String> stringList(d) => d.map<String>((e)=> e.toString()).toList();

List<T> parseList<T>(d, String key, T Function(dynamic) mapper) =>
  d[key]?.map<T>(mapper)?.toList();

void eachWithIndex<T>(List<T> l, Function(int, T) f) =>
  l.asMap().forEach((index, value) => f(index, value));