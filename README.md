<h1 align="center">is_prime_number</h1>

<p align="center">
  <b>Prime numbers for Dart — exact across the whole <code>int</code> range.</b><br>
  A primality test, a sieve, factorisation, and a lazy stream of primes.
</p>

<p align="center">
  <a href="https://pub.dev/packages/is_prime_number"><img src="https://img.shields.io/pub/v/is_prime_number.svg?logo=dart&color=0175C2" alt="pub package"></a>
  <a href="https://pub.dev/packages/is_prime_number/score"><img src="https://img.shields.io/pub/points/is_prime_number?logo=dart&color=0175C2" alt="pub points"></a>
  <a href="https://github.com/ahadjonovss/is_prime_number/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="license"></a>
</p>

---

```dart
import 'package:is_prime_number/is_prime_number.dart';

isPrime(97);                  // true
isPrime(2147483647);          // true — 2³¹ − 1
primesUpTo(30);               // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
primeFactors(360);            // [2, 2, 2, 3, 3, 5]
primes().take(5).toList();    // [2, 3, 5, 7, 11]
```

Pure Dart, **no dependencies**. Runs anywhere Dart does — Flutter, server, web, CLI.

```yaml
dependencies:
  is_prime_number: ^0.1.0
```

## Why not just write the loop

The four-line prime check everyone writes has two bugs in it, and both are quiet.

**`i <= sqrt(n)` drops a divisor.** `sqrt` returns a double. When a double lands a
hair under a perfect square, `toInt()` truncates to one less than it should, the
last divisor is never tried, and a composite is reported as prime. This package
bounds with `i * i <= n` and stays in integers.

**Trial division stops being viable long before `int` does.** Testing a number
near 2⁶³ by division is billions of operations. Above a threshold this switches
to Miller–Rabin with a witness set that is *proven* complete for this range — so
it is exact, not probabilistic. There is no "probably prime" here.

## Testing one number

| | |
| --- | --- |
| `isPrime(n)` | Whether `n` is prime. Negatives, `0` and `1` are not. |
| `nextPrime(n)` | The smallest prime **greater than** `n`. |
| `previousPrime(n)` | The largest prime below `n`, or `null` if there is none. |
| `nthPrime(n)` | The `n`-th prime, counting from 1. `nthPrime(1)` is `2`. |

```dart
nextPrime(11);       // 13 — strictly greater
previousPrime(2);    // null — nothing prime lies below 2
nthPrime(1000);      // 7919
```

`previousPrime` returns `null` rather than throwing: "there is no prime below 2"
is an ordinary fact about the number line, not a mistake the caller made.
`nthPrime(0)` *does* throw — asking for the zeroth prime is a bug.

## Testing a range

```dart
primesUpTo(30);        // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
primeCountUpTo(1000);  // 168
```

`primesUpTo` sieves rather than looping over `isPrime`, which makes the work per
number close to constant instead of proportional to its square root. It holds one
byte per odd number, so ten million costs about 5 MB — past that, walk `primes()`
and keep only what you need.

## Every prime, lazily

```dart
primes().take(5).toList();                   // [2, 3, 5, 7, 11]
primes().takeWhile((p) => p < 100).length;   // 25
primes().firstWhere((p) => p > 10000);       // 10007
```

Infinite and lazy, so taking ten primes costs ten primes — not a sieve sized for
a guess at how many you might end up wanting.

## Taking a number apart

| | |
| --- | --- |
| `primeFactors(n)` | Prime factors in order, with repeats. |
| `factorise(n)` | The same as prime → exponent. |
| `divisors(n)` | Every divisor including 1 and `n`, ascending. |

```dart
primeFactors(360);   // [2, 2, 2, 3, 3, 5]
factorise(360);      // {2: 3, 3: 2, 5: 1}
divisors(28);        // [1, 2, 4, 7, 14, 28]
```

## Odds and ends

```dart
isPerfect(28);        // true — 1 + 2 + 4 + 7 + 14 == 28
areTwinPrimes(11, 13) // true
isCoprime(9, 28);     // true — neither is prime, but they share no factor
gcd(12, 18);          // 6 — sign is ignored
```

## Exactness

Every result is exact for any value a Dart `int` can hold. Small numbers go
through trial division by 6k±1; larger ones through Miller–Rabin with the bases
`2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37`, which are proven deterministic for
everything below 3.3 × 10²⁴ — comfortably past 2⁶³.

The Miller–Rabin arithmetic runs on `BigInt`. The squaring step multiplies two
values that are each already near the limit, and on a 64-bit `int` that silently
wraps — which does not throw, it just returns the wrong answer for large primes.

**On the web** a Dart `int` is a JavaScript double, so integers above 2⁵³ cannot
be represented exactly to begin with. Results are exact up to that point.

## License

MIT © [Samandar Ahadjonov](https://github.com/ahadjonovss)
