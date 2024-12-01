part of '../bit_flag.dart';

@protected
abstract interface class IBitFlag {
  /// Returns the value of the flag, if the class is [ZeroBitFlag], the value is always zero.
  int get value;

  /// OR (Bitwise) two values of this and [other].
  /// If both this and [other] are [ZeroBitFlag], the result will be a [ZeroBitFlag] too.
  IBitFlag operator |(covariant IBitFlag other);

  /// AND (Bitwise) two values of this and [other].
  /// If both this and [other] are [ZeroBitFlag], the result will be a [ZeroBitFlag] too.
  IBitFlag operator &(covariant IBitFlag other);

  /// XOR (Bitwise) two values of this and [other].
  /// If both this and [other] are [ZeroBitFlag], the result will be a [ZeroBitFlag] too.
  IBitFlag operator ^(covariant IBitFlag other);

  /// SHIFT LEFT (Bitwise) two values of this and [other].
  /// If both this and [other] are [ZeroBitFlag], the result will be a [ZeroBitFlag] too.
  IBitFlag operator <<(int other);

  /// SHIFT RIGHT (Bitwise) two values of this and [other].
  /// If both this and [other] are [ZeroBitFlag], the result will be a [ZeroBitFlag] too.
  IBitFlag operator >>(int other);

  /// Returns true if the [origin] contains the [flag].
  /// If the [flag] is a [ZeroBitFlag], the result will be true when the [origin] does not contain [flag.mask].
  bool hasFlag(IBitFlag flag);

  /// Returns the value of [origin] as String with the [radix].
  String toRadixString(int radix, [int width]);

  /// Returns the value of [origin] as String with the binary base.
  /// If the [width] is not set, the bit length will be auto-set.
  String toBinaryString([int width]);

  /// Flip the flag. If the [origin] is a [ZeroBitFlag], the result will be a normal [BitFlag].
  /// Otherwise, the result will be changed to [ZeroBitFlag].
  IBitFlag flip();

  /// Returns flag and keeps the bit that matches the 1-bit in the [mask]. All of the other bits will be set to 0.
  IBitFlag extract(IBitFlag mask, {bool trimRight});

  /// Toggle the bit that matches the 1-bit in the mask.
  IBitFlag toggle(IBitFlag mask);
}

@immutable
// ignore: missing_override_of_must_be_overridden
abstract class ZeroBitFlag implements IBitFlag {
  const ZeroBitFlag();

  IBitFlag get mask;

  @override
  int get value => 0;

  @override
  String toString() {
    return 'BitFlag($value┆${mask.value})';
  }
}
