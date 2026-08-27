import 'package:is_prime_number/src/primality.dart';

/// The prime factors of [number], in order, with repeats.
///
/// ```dart
/// primeFactors(360);   // [2, 2, 2, 3, 3, 5]
/// primeFactors(97);    // [97]
/// ```
///
/// Empty for anything below 2: 1 has no prime factorisation, and 0 and the
/// negatives have no finite one.
List<int> primeFactors(int number) {
  if (number < 2) return const [];

  final factors = <int>[];
  var remaining = number;

  for (final small in const [2, 3]) {
    while (remaining % small == 0) {
      factors.add(small);
      remaining ~/= small;
    }
  }

  // Everything left is 6k±1, so step through those and nothing else.
  for (var i = 5; i * i <= remaining; i += 6) {
    for (final candidate in [i, i + 2]) {
      while (remaining % candidate == 0) {
        factors.add(candidate);
        remaining ~/= candidate;
      }
    }
  }

  // Whatever survives the loop is prime: if it had a factor at or below its own
  // square root, the loop would have divided it out already.
  if (remaining > 1) factors.add(remaining);

  return factors;
}

/// The prime factorisation of [number] as prime → exponent.
///
/// ```dart
/// factorise(360);   // {2: 3, 3: 2, 5: 1}
/// ```
///
/// The same information as [primeFactors], in the shape you want when the
/// question is "how many twos", not "list the factors".
Map<int, int> factorise(int number) {
  final counts = <int, int>{};
  for (final factor in primeFactors(number)) {
    counts[factor] = (counts[factor] ?? 0) + 1;
  }

  return counts;
}

/// Every divisor of [number], including 1 and itself, in ascending order.
///
/// ```dart
/// divisors(28);   // [1, 2, 4, 7, 14, 28]
/// ```
List<int> divisors(int number) {
  if (number < 1) return const [];

  var result = <int>[1];
  factorise(number).forEach((prime, exponent) {
    final grown = <int>[];
    var power = 1;
    for (var e = 0; e <= exponent; e++) {
      for (final d in result) {
        grown.add(d * power);
      }
      power *= prime;
    }
    result = grown;
  });

  return result..sort();
}

/// Whether [number] equals the sum of its divisors below itself — 6, 28, 496.
///
/// ```dart
/// isPerfect(28);   // true, because 1 + 2 + 4 + 7 + 14 == 28
/// ```
bool isPerfect(int number) {
  if (number < 2) return false;

  final sum = divisors(number)
      .where((d) => d != number)
      .fold(0, (a, b) => a + b);

  return sum == number;
}

/// Whether [a] and [b] are twin primes — both prime, and two apart.
///
/// ```dart
/// areTwinPrimes(11, 13);   // true
/// ```
bool areTwinPrimes(int a, int b) =>
    (a - b).abs() == 2 && isPrime(a) && isPrime(b);
