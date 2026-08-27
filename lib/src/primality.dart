/// The bases that make Miller–Rabin *deterministic* rather than probabilistic.
///
/// Miller–Rabin is usually described as a probabilistic test, and with random
/// bases it is. But this fixed set is proven to give the right answer for every
/// n below 3.3 × 10²⁴ — which is every integer Dart can hold. So there is no
/// probability here and no "probably prime": for a Dart `int`, this is exact.
const List<int> _witnesses = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

/// Below this, dividing is simply faster than the ceremony of Miller–Rabin.
const int _trialDivisionLimit = 50000;

/// Whether [number] is prime.
///
/// Negative numbers, 0 and 1 are not prime — 1 in particular is a common
/// off-by-one in hand-written prime checks, and the reason it is excluded is
/// that unique factorisation would break if it were included.
///
/// ```dart
/// isPrime(97);   // true
/// isPrime(1);    // false
/// isPrime(-7);   // false
/// ```
///
/// Exact for every value a Dart `int` can hold: small numbers go through trial
/// division by 6k±1, larger ones through Miller–Rabin with a witness set that
/// is proven complete for this range.
///
/// On the web an `int` is a JavaScript double, so integers above 2^53 cannot be
/// represented exactly in the first place. Results are exact up to that point.
bool isPrime(int number) {
  if (number < 2) return false;
  if (number < 4) return true;
  if (number.isEven) return false;
  if (number % 3 == 0) return false;

  return number < _trialDivisionLimit
      ? _byTrialDivision(number)
      : _byMillerRabin(number);
}

/// Trial division, skipping everything that cannot be a factor.
///
/// Every prime above 3 is one either side of a multiple of six, so the loop
/// steps 5, 7, 11, 13, 17, 19… and tries a third of the candidates a naive
/// loop would.
///
/// The bound is `i * i <= number` rather than `i <= sqrt(number)`: `sqrt`
/// returns a double, and a double that lands a hair under a perfect square
/// truncates to one less than it should — which drops the last divisor and
/// reports a composite as prime. Multiplying keeps the whole test in integers.
bool _byTrialDivision(int number) {
  for (var i = 5; i * i <= number; i += 6) {
    if (number % i == 0 || number % (i + 2) == 0) return false;
  }

  return true;
}

/// Miller–Rabin over [BigInt].
///
/// The arithmetic goes through BigInt rather than int because the squaring step
/// multiplies two numbers that are each already near the limit, and on a 64-bit
/// int that silently wraps. A wrapped intermediate does not throw; it just
/// returns the wrong answer for large primes, which is the worst way for a
/// primality test to be wrong.
bool _byMillerRabin(int number) {
  final n = BigInt.from(number);
  final nMinusOne = n - BigInt.one;

  // Write n − 1 as d · 2^r with d odd.
  var d = nMinusOne;
  var r = 0;
  while (d.isEven) {
    d >>= 1;
    r++;
  }

  for (final base in _witnesses) {
    if (base >= number) break;

    var x = BigInt.from(base).modPow(d, n);
    if (x == BigInt.one || x == nMinusOne) continue;

    var isComposite = true;
    for (var i = 1; i < r; i++) {
      x = (x * x) % n;
      if (x == nMinusOne) {
        isComposite = false;
        break;
      }
    }

    if (isComposite) return false;
  }

  return true;
}

/// The smallest prime greater than [number].
///
/// ```dart
/// nextPrime(10);   // 11
/// nextPrime(-5);   // 2
/// ```
int nextPrime(int number) {
  if (number < 2) return 2;

  var candidate = number.isEven ? number + 1 : number + 2;
  while (!isPrime(candidate)) {
    candidate += 2;
  }

  return candidate;
}

/// The largest prime smaller than [number], or `null` when there is none —
/// which is every number up to and including 2.
///
/// Null rather than an exception: "there is no prime below 2" is an ordinary
/// answer about the number line, not a mistake the caller made.
int? previousPrime(int number) {
  if (number <= 2) return null;
  if (number == 3) return 2;

  var candidate = number.isEven ? number - 1 : number - 2;
  while (candidate > 2 && !isPrime(candidate)) {
    candidate -= 2;
  }

  return candidate;
}

/// The [n]-th prime, counting from 1: `nthPrime(1)` is 2.
///
/// Throws [ArgumentError] for n below 1 — unlike "no prime below 2", asking for
/// the zeroth prime is a bug in the calling code.
int nthPrime(int n) {
  if (n < 1) {
    throw ArgumentError.value(n, 'n', 'must be 1 or greater');
  }

  var found = 0;
  for (final prime in primes()) {
    if (++found == n) return prime;
  }

  throw StateError('unreachable: primes() is infinite');
}

/// Every prime, in order, for as long as you keep taking them.
///
/// Lazy, so `primes().take(10)` costs ten primes and not a sieve sized for a
/// guess at how many you might want.
///
/// ```dart
/// primes().take(5).toList();                    // [2, 3, 5, 7, 11]
/// primes().takeWhile((p) => p < 50).toList();
/// ```
Iterable<int> primes() sync* {
  yield 2;
  yield 3;

  for (var candidate = 5;; candidate += 6) {
    if (isPrime(candidate)) yield candidate;
    if (isPrime(candidate + 2)) yield candidate + 2;
  }
}

/// Whether [a] and [b] share no factor but 1.
///
/// ```dart
/// isCoprime(9, 28);   // true — neither is prime, but they share nothing
/// isCoprime(9, 12);   // false — both divide by 3
/// ```
bool isCoprime(int a, int b) => gcd(a, b) == 1;

/// The greatest common divisor of [a] and [b], by Euclid.
///
/// Sign is ignored: the divisor of −12 and 18 is 6, as it is for 12 and 18.
int gcd(int a, int b) {
  var x = a.abs();
  var y = b.abs();

  while (y != 0) {
    final next = x % y;
    x = y;
    y = next;
  }

  return x;
}

