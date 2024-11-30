part of 'bitflag_base.dart';

@immutable
mixin class BitFlag implements IBitFlag {
  const factory BitFlag(int value, {int bitOffset}) = _BitFlag;

  const factory BitFlag.binary(int value) = _BitFlagBinary;

  const factory BitFlag.at(int position, [int width]) = _BitFlagWithPosition;

  const factory BitFlag.not(IBitFlag otherSide) = _FlipBitFlag;

  const factory BitFlag.notValue(int value) = _FlipValueBitFlag;

  @override
  int get value => 0;

  @override
  BitFlag toFlip() => BitFlags.flip(this);

  @override
  BitFlag extract(IBitFlag mask) => BitFlags.extract(this, mask);

  @override
  IBitFlag toggle(IBitFlag mask) => BitFlags.toggle(this, mask);

  @override
  BitFlag operator |(covariant IBitFlag other) => BitFlags.or(this, other);

  @override
  BitFlag operator &(covariant IBitFlag other) => BitFlags.and(this, other);

  @override
  BitFlag operator ^(covariant IBitFlag other) => BitFlags.xor(this, other);

  @override
  BitFlag operator <<(int other) => BitFlags.shiftLeft(this, other);

  @override
  BitFlag operator >>(int other) => BitFlags.shiftRight(this, other);

  @override
  bool hasFlag(IBitFlag flag) => BitFlags.hasFlag(this, flag);

  @override
  String toRadixString(int radix, [int width = 0]) =>
      BitFlags.toRadixString(this, radix, width);

  @override
  String toBinaryString([int? width]) {
    final bitLength = width ?? value.bitLength;
    return toRadixString(2, bitLength);
  }

  @override
  bool operator ==(Object other) {
    if (other is! IBitFlag) return false;
    return BitFlags.equals(this, other);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => switch (this) {
        FlipBitFlag p1 => 'BitFlag($value┆${p1.otherSide.value})',
        _ => 'BitFlag($value)',
      };
}

// ignore: missing_override_of_must_be_overridden
mixin _BitInternal on BitFlag {}

@immutable
// ignore: missing_override_of_must_be_overridden
class _BitFlag with BitFlag, _BitInternal {
  const _BitFlag(int value, {int bitOffset = 0})
      : assert(bitOffset >= 0),
        value = value << bitOffset;

  @override
  final int value;
}

@immutable
// ignore: missing_override_of_must_be_overridden
class _BitFlagWithPosition with BitFlag, _BitInternal {
  const _BitFlagWithPosition(this.position, [this.width = 1])
      : assert(position >= 0),
        assert(width >= 0);

  final int position;
  final int width;

  int get _binFlag => pow(2, width).toInt() - 1;

  @override
  int get value => _binFlag << position;
}

@immutable
// ignore: missing_override_of_must_be_overridden
class _BitFlagBinary with BitFlag, _BitInternal {
  const _BitFlagBinary(this.bin);

  final int bin;

  @override
  int get value => int.parse('$bin', radix: 2);
}

@immutable
// ignore: missing_override_of_must_be_overridden
class _FlipBitFlag extends FlipBitFlag with BitFlag, _BitInternal {
  const _FlipBitFlag(this.otherSide);

  @override
  final IBitFlag otherSide;
}

@immutable
// ignore: missing_override_of_must_be_overridden
class _FlipValueBitFlag extends FlipBitFlag with BitFlag, _BitInternal {
  const _FlipValueBitFlag(this._otherSideValue);

  final int _otherSideValue;

  @override
  IBitFlag get otherSide => BitFlag(_otherSideValue);
}
