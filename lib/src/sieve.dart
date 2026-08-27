/// Every prime up to and including [limit], in order.
///
/// A sieve of Eratosthenes: instead of testing each number, it crosses out the
/// multiples of each prime it finds. For a whole range this is far cheaper than
/// calling `isPrime` in a loop — the work per number is close to constant
/// rather than proportional to its square root.
///
/// ```dart
/// primesUpTo(30);   // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
/// ```
///
/// Memory is one byte per odd number, so a limit of ten million costs about
/// 5 MB. For anything larger, walk [primes] instead and keep only what you
/// need — a sieve you cannot hold is worse than a slower loop.
///
/// Returns an empty list for a limit below 2 rather than throwing: "no primes
/// up to 1" is a correct answer, not a mistake.
List<int> primesUpTo(int limit) {
  if (limit < 2) return const [];
  if (limit == 2) return const [2];

  // Odd numbers only. Index i stands for the number 2i + 3, which halves both
  // the memory and the crossing-out.
  final size = (limit - 1) ~/ 2;
  final composite = List<bool>.filled(size, false);

  for (var i = 0; (2 * i + 3) * (2 * i + 3) <= limit; i++) {
    if (composite[i]) continue;

    final prime = 2 * i + 3;
    // Start at prime², because every smaller multiple carries a smaller factor
    // and was crossed out when that factor came round.
    for (var j = (prime * prime - 3) ~/ 2; j < size; j += prime) {
      composite[j] = true;
    }
  }

  final result = <int>[2];
  for (var i = 0; i < size; i++) {
    if (!composite[i]) result.add(2 * i + 3);
  }

  return result;
}

/// How many primes there are up to and including [limit].
///
/// ```dart
/// primeCountUpTo(100);   // 25
/// ```
int primeCountUpTo(int limit) => primesUpTo(limit).length;
