import 'package:bit_flag/bit_flag.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group(
    'Equatable: If a is equals to b, then b is also equals to a.',
    () {
      test(
        'BitFLag Equatable',
        () {
          expect(BitFlag(1), BitFlag(1));
          expect(BitFlag.at(1, 1), BitFlag(2));
          expect(BitFlag.binary(10), BitFlag(2));
          expect(BitFlag.not(BitFlag(1)), isNot(BitFlag(0)));
          expect(BitFlag.not(BitFlag(1)), isNot(BitFlag(1)));
          expect(BitFlag.not(BitFlag(1)), BitFlag(1).toFlip());
          expect(BitFlag.notValue(1), BitFlag(1).toFlip());

          String switchTest(BitFlag flag) => switch (flag) {
                const BitFlag(1) => 'A',
                const BitFlag(2) => 'B',
                _ => 'C',
              };
          expect(switchTest(BitFlag(1)), 'A');
          expect(switchTest(BitFlag(2)), 'B');
          expect(switchTest(BitFlag(3)), 'C');
          expect(switchTest(BitFlag.binary(b0001)), 'A');
          expect(switchTest(BitFlag.notValue(b0001)), 'C');

          expect(switchTest(BitFlag(b0011) & BitFlag(b0001)), 'A');
          expect(switchTest(BitFlag(b0011) & BitFlag(b0010)), 'B');
        },
      );
    },
  );

  group(
    'OR',
    () {
      test('a | b == b | a', () {
        expect(BitFlag(b0011) | BitFlag(b0001), BitFlag(b0011));
        expect(
            BitFlag(b0011) | BitFlag(b0001), BitFlag(b0001) | BitFlag(b0011));
        expect(BitFlag(b0011) | BitFlag.notValue(b0001), BitFlag(b0011));
        expect(BitFlag.notValue(b0011) | BitFlag.notValue(b0001),
            BitFlag.notValue(b0011));
      });

      test('If a | b is c, then c contains a and c contains b', () {
        const a = BitFlag(b0100);
        const b = BitFlag(b0010);
        const c = BitFlag.notValue(b0001);
        const d = BitFlag.notValue(b0010);
        final flag = a | b | c; // 0b0110
        expect(flag, BitFlag(b0110));
        expect(flag.hasFlag(a), true);
        expect(flag.hasFlag(b), true);
        expect(flag.hasFlag(c), true);

        expect(c | d, isA<FlipBitFlag>());
        expect(c | d, BitFlag.notValue(b0011));
        expect(c | d, d | c);

        expect(flag.hasFlag(c | d), false);

        expect((() {
          final flag2 = flag | BitFlag(b0001); // 0b0111
          return flag2.hasFlag(c);
        })(), false);

        expect((() {
          final flag2 = BitFlag(b0000);
          return flag2.hasFlag(c | d);
        })(), true);

        String switchTest(BitFlag flag) => switch (flag) {
              const BitFlag(b0110) => 'A|B',
              const BitFlag(b0010) => 'B|C',
              const BitFlag(b0100) => 'A|C',
              const BitFlag(b0101) => 'A|0┆C', // 0 flip C
              _ => 'Others',
            };
        expect(switchTest(flag), 'A|B');
        expect(switchTest(flag.extract(BitFlag(b11, bitOffset: 0))), 'B|C');
        expect(switchTest(flag.extract(BitFlag(b11, bitOffset: 1))), 'A|B');
        expect(switchTest(flag.extract(BitFlag(b0101))), 'A|C');
        expect(switchTest(flag.extract(BitFlag(b1100))), 'A|C');

        final fa = BitFlag.not(a);
        final fb = BitFlag.not(b);
        final fFlag = fa | fb; // 0┆0b0110
        expect(fFlag.hasFlag(a), false);
        expect(fFlag.hasFlag(fa), true);
      });
    },
  );

  group(
    'AND',
    () {
      test('a & b == b & a', () {
        const a = BitFlag(b0100);
        const b = BitFlag(b0010);
        const c = BitFlag.notValue(b0001);
        const d = BitFlag.notValue(b0010);

        expect(a & b, BitFlag(b0000));
        expect(a & b, b & a);

        expect(a & c, BitFlag(b0000));
        expect(a & c, c & a);

        expect(c & d, isA<FlipBitFlag>());
        expect(c & d, BitFlag.notValue(b0000));
        expect(c & d, d & c);
      });
    },
  );

  group(
    'XOR',
    () {
      test('a ^ b == b ^ a', () {
        const a = BitFlag(b0100);
        const b = BitFlag(b0010);
        const c = BitFlag.notValue(b0001);
        const d = BitFlag.notValue(b0010);

        expect(a ^ b, BitFlag(b0110));
        expect(a ^ b, b ^ a);

        expect(a ^ c, BitFlag(b0100));
        expect(a ^ c, c ^ a);

        expect(c ^ d, isA<FlipBitFlag>());
        expect(c ^ d, BitFlag.notValue(b0011));
        expect(c ^ d, d ^ c);
      });
    },
  );

  group(
    'SHIFT',
    () {
      test('SHIFT', () {
        const a = BitFlag(b0100); // BitFlags.flag2
        const b = BitFlag.notValue(b0001); // BitFlags.flag0

        expect(a << 1, BitFlags.flag3); //0b1000
        expect(a >> 1, BitFlags.flag1); //0b0010
        expect(a << 2, BitFlags.flag4); //0b00010000
        expect(a >> 5, BitFlags.zero); //0b0000

        expect(b << 1, BitFlag.notValue(b0010));
        expect(b << 3, BitFlag.notValue(b1000));
      });
    },
  );

  group(
      'FLIP: If c is a | b  and a1 is the flip of a, then !(c.hasFlag(a)) is equals to c.hasFlag(a1).',
      () {
    test(
      'a is not a FlipBitFlag',
      () {
        const a = BitFlag(b0100);
        const b = BitFlag(b0010);
        const flipA = BitFlag.not(a);
        final c = a | b;
        expect(c.hasFlag(a), true);
        expect(c.hasFlag(a.toFlip()), false);
        expect(c.hasFlag(flipA), false);
      },
    );

    test(
      'flipA is a FlipBitFlag',
      () {
        const a = BitFlag(b0100);
        const b = BitFlag(b0010);
        const flipA = BitFlag.not(a);
        final d = flipA | b;
        expect(d.hasFlag(flipA), true);
        expect(d.hasFlag(b), true);
        expect(d.hasFlag(a), false);
        expect(d.hasFlag(a.toFlip()), true);
      },
    );

    test(
      'Flip A Flip',
      () {
        const a = BitFlag(b0100);
        const b = BitFlag(b0010);
        const flipA = BitFlag.not(a);
        const flipFlipA = BitFlag.not(flipA);
        final c = a | b;
        expect(c.hasFlag(a), true);
        expect(c.hasFlag(flipA), false);
        expect(c.hasFlag(flipFlipA), true);
        expect(c.hasFlag(flipFlipA.toFlip()), true);
      },
    );
  });

  group('Function', () {
    test(
      'Extract',
      () {
        const flag = BitFlag(0x1AD6); // 0001 1010 1101 0110
        expect(flag.extract(BitFlag.binary(001100)),
            BitFlag.binary(00000100)); // 0000 0000 0001 0000
        expect(flag.extract(BitFlag.binary(11001100)),
            BitFlag.binary(11000100)); // 0000 0000 1100 0100
        expect(flag.extract(BitFlag.binary(11001010)),
            BitFlag.binary(11000010)); // 0000 0000 1100 0010

        final flipFlag = BitFlag.not(flag);
        expect(flipFlag.extract(BitFlag.binary(001100)),
            BitFlag.not(BitFlag.binary(00000100)));
        expect(flipFlag.extract(BitFlag.binary(11001100)),
            BitFlag.not(BitFlag.binary(11000100)));
        expect(flipFlag.extract(BitFlag.binary(11001010)),
            BitFlag.not(BitFlag.binary(11000010)));
      },
    );

    test(
      'Toggle',
      () {
        const flag = BitFlag(0x1AD6); // 0001 1010 1101 0110
        expect(flag.toggle(BitFlag.binary(001100)),
            BitFlag.binary(0001101011011010)); // 0001 1010 1101 1010
        expect(flag.toggle(BitFlag.binary(11)),
            BitFlag.binary(0001101011010101)); // 0001 1010 1101 1010

        final flipFlag = BitFlag.not(flag);
        expect(flipFlag.toggle(BitFlag.binary(001100)),
            BitFlag.not(BitFlag.binary(0001101011011010)));
        expect(flipFlag.toggle(BitFlag.binary(11)),
            BitFlag.not(BitFlag.binary(0001101011010101)));
      },
    );
  });
}
