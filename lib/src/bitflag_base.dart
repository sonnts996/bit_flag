part of '../bit_flag.dart';

@protected
abstract interface class IBitFlag {
  /// Returns the value of the flag, if the class is [FlipBitFlag], the value is always zero.
  int get value;

  /// OR (Bitwise) two values of this and [other].
  /// If both this and [other] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  IBitFlag operator |(covariant IBitFlag other);

  /// AND (Bitwise) two values of this and [other].
  /// If both this and [other] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  IBitFlag operator &(covariant IBitFlag other);

  /// XOR (Bitwise) two values of this and [other].
  /// If both this and [other] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  IBitFlag operator ^(covariant IBitFlag other);

  /// SHIFT LEFT (Bitwise) two values of this and [other].
  /// If both this and [other] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  IBitFlag operator <<(int other);

  /// SHIFT RIGHT (Bitwise) two values of this and [other].
  /// If both this and [other] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  IBitFlag operator >>(int other);

  /// Returns true if the [origin] contains the [flag].
  /// If the [flag] is a [FlipBitFlag], the result will be true when the [origin] does not contain [flag.otherSide].
  bool hasFlag(IBitFlag flag);

  /// Returns the value of [origin] as String with the [radix].
  String toRadixString(int radix, [int width]);

  /// Returns the value of [origin] as String with the binary base.
  /// If the [width] is not set, the bit length will be auto-set.
  String toBinaryString([int width]);

  /// Flip the flag. If the [origin] is a [FlipBitFlag], the result will be a normal [BitFlag].
  /// Otherwise, the result will be changed to [FlipBitFlag].
  IBitFlag toFlip();

  /// Returns flag and keeps the bit that matches the 1-bit in the [mask]. All of the other bits will be set to 0.
  IBitFlag extract(IBitFlag mask);

  /// Toggle the bit that matches the 1-bit in the mask.
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
