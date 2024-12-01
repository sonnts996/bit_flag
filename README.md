An object uses the Integer Flag and its methods to calculator it.

## Features

- Create the integer flag as an object.
- Merge multi-state as the only one flag.
- Extract and check the flag states.

## Getting started

Add ```bit_flag``` into the dependencies:

```yaml
dependencies:
  bit_flag: ^1.0.0
```

## Usage


```dart
  const enable = BitFlag(b0001); //0b0001 - The first bit is 1.
  const disable = BitFlag.zeroAt(enable); //0┆0b0001 - The first bit is 0;
  const waiting = BitFlag(1, bitOffset: 1); //0b0010 - The second bit is 1
  const done =
      BitFlag.zeroAt(BitFlag(1, bitOffset: 1)); //0┆0b0010 - The second bit is 0
  const success = BitFlag(1, bitOffset: 2); //0b0100 - The third bit is 1
  const failed =
      BitFlag.zeroAt(BitFlag(1, bitOffset: 2)); //0┆0b0100 - The third bit is 0

  final flag = enable | done | success; //0b0101
  print(flag.hasFlag(enable)); // true
  print(flag.hasFlag(disable)); // false => !flag.hasFlag(enable)
  print(flag.hasFlag(success | done)); // true

  switch (flag.extract(BitFlag.binary('0110'))) {
    case const BitFlag.binary('0110'): // success and waiting
      print('success and waiting');
      break;
    case const BitFlag.binary('0100'): // success and done
      print('success and done');
      break;
    case const BitFlag.binary('0000'): // failed and done
      print(' failed and done');
      break;
    case const BitFlag.binary('0010'): // failed and waiting
      print('failed and waiting');
      break;
    default:
      print('unknown');
  }
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/sonnts996/bit_flag/issues).