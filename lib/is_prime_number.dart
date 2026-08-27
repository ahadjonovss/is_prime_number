/// Prime numbers for Dart.
///
/// A primality test that stays exact across the whole `int` range, a sieve for
/// whole ranges, factorisation, and a lazy stream of primes. Pure Dart, with no
/// dependencies, so it runs anywhere Dart does — Flutter, the server, the web
/// and the command line.
///
/// ```dart
/// isPrime(2147483647);          // true — the eighth Mersenne prime
/// primesUpTo(30);               // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
/// primeFactors(360);            // [2, 2, 2, 3, 3, 5]
/// primes().take(5).toList();    // [2, 3, 5, 7, 11]
/// ```
library;

export 'src/factors.dart'
    show areTwinPrimes, divisors, factorise, isPerfect, primeFactors;
export 'src/primality.dart'
    show gcd, isCoprime, isPrime, nextPrime, nthPrime, previousPrime, primes;
export 'src/sieve.dart' show primeCountUpTo, primesUpTo;
