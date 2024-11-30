import 'dart:math';

import 'package:meta/meta.dart';

part 'binary.dart';

part 'bitflag_impl.dart';

@protected
abstract interface class IBitFlag {
  int get value;

  IBitFlag operator |(covariant IBitFlag other);

  IBitFlag operator &(covariant IBitFlag other);

  IBitFlag operator ^(covariant IBitFlag other);

  IBitFlag operator <<(int other);

  IBitFlag operator >>(int other);

  bool hasFlag(IBitFlag flag);

  String toRadixString(int radix, [int width]);

  String toBinaryString([int width]);

  IBitFlag toFlip();

  IBitFlag extract(IBitFlag mask);

  IBitFlag toggle(IBitFlag mask);
}


@immutable
// ignore: missing_override_of_must_be_overridden
abstract class FlipBitFlag implements IBitFlag {
  const FlipBitFlag();

  IBitFlag get otherSide;

  @override
  int get value => 0;

  @override
  String toString() {
    return 'BitFlag($value┆${otherSide.value})';
  }
}