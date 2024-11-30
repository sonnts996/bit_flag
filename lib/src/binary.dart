part of '../bit_flag.dart';

/// 0b0000 ~ 0 (decimal)
const int b0000 = 0, b00 = 0;

/// 0b0001 ~ 1 (decimal)
const int b0001 = 1, b01 = 1;

/// 0b0010 ~ 2 (decimal)
const int b0010 = 2, b10 = 2;

/// 0b0011 ~ 3 (decimal)
const int b0011 = 3, b11 = 3;

/// 0b0100 ~ 4 (decimal)
const int b0100 = 4;

/// 0b0101 ~ 5 (decimal)
const int b0101 = 5;

/// 0b0110 ~ 6 (decimal)
const int b0110 = 6;

/// 0b0111 ~ 7 (decimal)
const int b0111 = 7;

/// 0b1000 ~ 8 (decimal)
const int b1000 = 8;

/// 0b1001 ~ 9 (decimal)
const int b1001 = 9;

/// 0b1010 ~ 10 (decimal)
const int b1010 = 10;

/// 0b1011 ~ 11 (decimal)
const int b1011 = 11;

/// 0b1100 ~ 12 (decimal)
const int b1100 = 12;

/// 0b1101 ~ 13 (decimal)
const int b1101 = 13;

/// 0b1110 ~ 14 (decimal)
const int b1110 = 14;

/// 0b1111 ~ 15 (decimal)
const int b1111 = 15;

abstract final class BitFlags {
  /// 0b00000000
  static const BitFlag zero = BitFlag(0);

  /// 0b00000001
  static const BitFlag flag0 = BitFlag(1);

  /// 0b00000010
  static const BitFlag flag1 = BitFlag(1 << 1);

  /// 0b00000100
  static const BitFlag flag2 = BitFlag(1 << 2);

  /// 0b00001000
  static const BitFlag flag3 = BitFlag(1 << 3);

  /// 0b00010000
  static const BitFlag flag4 = BitFlag(1 << 4);

  /// 0b00100000
  static const BitFlag flag5 = BitFlag(1 << 5);

  /// 0b01000000
  static const BitFlag flag6 = BitFlag(1 << 6);

  /// 0b10000000
  static const BitFlag flag7 = BitFlag(1 << 7);

  /// OR (Bitwise) two values of [a] and [b].
  /// If both [a] and [b] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  static BitFlag or(IBitFlag a, IBitFlag b) => switch ((a, b)) {
        (FlipBitFlag, FlipBitFlag) record =>
          BitFlag.not(record.$1.otherSide | record.$2.otherSide),
        _ => BitFlag(a.value | b.value)
      };

  /// AND (Bitwise) two values of [a] and [b].
  /// If both [a] and [b] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  static BitFlag and(IBitFlag a, IBitFlag b) => switch ((a, b)) {
        (FlipBitFlag, FlipBitFlag) record =>
          BitFlag.not(record.$1.otherSide & record.$2.otherSide),
        _ => BitFlag(a.value & b.value)
      };

  /// XOR (Bitwise) two values of [a] and [b].
  /// If both [a] and [b] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  static BitFlag xor(IBitFlag a, IBitFlag b) => switch ((a, b)) {
        (FlipBitFlag, FlipBitFlag) record =>
          BitFlag.not(record.$1.otherSide ^ record.$2.otherSide),
        _ => BitFlag(a.value ^ b.value),
      };

  /// SHIFT LEFT (Bitwise) two values of [a] and [b].
  /// If both [a] and [b] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  static BitFlag shiftLeft(IBitFlag a, int b) => switch (a) {
        FlipBitFlag value => BitFlag.not(value.otherSide << b),
        _ => BitFlag(a.value << b),
      };

  /// SHIFT RIGHT (Bitwise) two values of [a] and [b].
  /// If both [a] and [b] are [FlipBitFlag], the result will be a [FlipBitFlag] too.
  static BitFlag shiftRight(IBitFlag a, int b) => switch (a) {
        FlipBitFlag value => BitFlag.not(value.otherSide >> b),
        _ => BitFlag(a.value >> b),
      };

  /// Returns true if the [origin] contains the [flag].
  /// If the [flag] is a [FlipBitFlag], the result will be true when the [origin] does not contain [flag.otherSide].
  static bool hasFlag(IBitFlag origin, IBitFlag flag) => switch (flag) {
        FlipBitFlag p1 => (origin.value & p1.otherSide.value) == 0,
        _ => (origin & flag).value == flag.value,
      };

  /// Flip the flag. If the [origin] is a [FlipBitFlag], the result will be a normal [BitFlag].
  /// Otherwise, the result will be changed to [FlipBitFlag].
  static BitFlag flip(IBitFlag origin) => switch (origin) {
        FlipBitFlag value => BitFlag(value.otherSide.value),
        _ => BitFlag.not(origin),
      };

  ///  Returns true if two flags have the same value:
  /// - If the flag is an extended class of [IBitFlag], the returns are false if they are not the same type, except one of them is [BitFlag].
  /// - If both flags are [FlipBitFlag] type, the return is true if they have the same otherSide's value. Otherwise, it is false.
  static bool equals(IBitFlag a, IBitFlag b) {
    if (identical(a, b)) return true;
    if (a.runtimeType != b.runtimeType) {
      if (b is BitFlag) {
        if (a is! _BitInternal && b is! _BitInternal) {
          return false;
        }
      }
    }

    if (a is FlipBitFlag && b is FlipBitFlag) {
      return a.otherSide == b.otherSide;
    } else if (a is FlipBitFlag || b is FlipBitFlag) {
      return false;
    }

    return a.value == b.value;
  }

  /// Returns flag and keeps the bit that matches the 1-bit in the [mask]. All of the other bits will be set to 0.
  static BitFlag extract(IBitFlag origin, IBitFlag mask) {
    assert(
        mask is! FlipBitFlag,
        """The position parameter stands for the bit's position which will be extracted from the origin, so it can not be a FlipBitFlag.\n"""
        """Example: If the position is BitFlag(b0011), it will get the origin's first and second bits (from the right).""");
    return switch (origin) {
      FlipBitFlag value => BitFlag.notValue(value.otherSide.value & mask.value),
      _ => BitFlag(origin.value & mask.value),
    };
  }

  /// Toggle the bit that matches the 1-bit in the [mask].
  static BitFlag toggle(IBitFlag origin, IBitFlag mask) {
    assert(
        mask is! FlipBitFlag,
        """The position parameter stands for the bit's position which will be extracted from the origin, so it can not be a FlipBitFlag.\n"""
        """Example: If the position is BitFlag(b0011), it will get the origin's first and second bits (from the right).""");

    return switch (origin) {
      FlipBitFlag value => BitFlag.notValue(value.otherSide.value ^ mask.value),
      _ => BitFlag(origin.value ^ mask.value),
    };
  }

  /// Returns the value of [origin] as String with the [radix].
  static String toRadixString(IBitFlag origin, int radix, [int width = 0]) =>
      origin.value.toRadixString(radix).padLeft(width, '0');
}
