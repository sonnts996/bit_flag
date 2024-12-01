## 1.0.0

- Initial version.

## 1.0.1

- Clarify the code:
  - changed `toFlip` method into `flip`.
  - changed `BitFlag.not` and `BitFlag.notValue` constructor into `BitFlag.zeroAt` and `BitFlag.zeroAtValue`.
  - changed `BitFlag extract(IBitFlag mask)` into `BitFlag extract(IBitFlag mask, {bool trimRight = false})`.