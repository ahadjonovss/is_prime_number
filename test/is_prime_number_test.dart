import 'package:is_prime_number/is_prime_number.dart';
import 'package:test/test.dart';

void main() {
  group('isPrime', () {
    test('the small primes, exhaustively', () {
      const known = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];
      for (var n = 0; n <= 50; n++) {
        expect(isPrime(n), known.contains(n), reason: '$n');
      }
    });

    test('1 is not prime, and neither is anything below it', () {
      expect(isPrime(1), isFalse);
      expect(isPrime(0), isFalse);
      expect(isPrime(-7), isFalse);
    });

    test('a square of a prime is not prime', () {
      // The case a sqrt-based bound gets wrong when the double lands short.
      for (final p in [3, 5, 7, 11, 13, 101, 1009, 65537]) {
        expect(isPrime(p * p), isFalse, reason: '${p * p} = $p²');
      }
    });

    test('large primes, past where trial division hands over', () {
      expect(isPrime(1000003), isTrue);
      expect(isPrime(2147483647), isTrue, reason: '2^31 − 1');
      expect(isPrime(1000000007), isTrue);
    });

    test('large composites are not mistaken for primes', () {
      expect(isPrime(1000000007 * 3), isFalse);
      expect(isPrime(2147483647 - 2), isFalse);
      // A Carmichael number: passes the naive Fermat test, fails Miller–Rabin.
      expect(isPrime(561), isFalse);
      expect(isPrime(41041), isFalse);
    });

    test('agrees with the sieve across a whole range', () {
      final sieved = primesUpTo(5000).toSet();
      for (var n = 0; n <= 5000; n++) {
        expect(isPrime(n), sieved.contains(n), reason: '$n');
      }
    });
  });

  group('primesUpTo', () {
    test('gives the primes in order', () {
      expect(primesUpTo(30), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]);
    });

    test('includes the limit when the limit is prime', () {
      expect(primesUpTo(29).last, 29);
      expect(primesUpTo(30).last, 29);
    });

    test('a limit below 2 is an empty list, not an error', () {
      expect(primesUpTo(1), isEmpty);
      expect(primesUpTo(0), isEmpty);
      expect(primesUpTo(-5), isEmpty);
    });

    test('π(100) is 25, π(1000) is 168', () {
      expect(primeCountUpTo(100), 25);
      expect(primeCountUpTo(1000), 168);
      expect(primeCountUpTo(10000), 1229);
    });
  });

  group('primes', () {
    test('is lazy and infinite', () {
      expect(primes().take(5).toList(), [2, 3, 5, 7, 11]);
      expect(primes().takeWhile((p) => p < 20).toList(),
          [2, 3, 5, 7, 11, 13, 17, 19]);
    });

    test('matches the sieve', () {
      expect(primes().take(168).last, primesUpTo(1000).last);
    });
  });

  group('navigation', () {
    test('nextPrime', () {
      expect(nextPrime(10), 11);
      expect(nextPrime(11), 13, reason: 'strictly greater');
      expect(nextPrime(-5), 2);
      expect(nextPrime(0), 2);
    });

    test('previousPrime, and null where there is none', () {
      expect(previousPrime(10), 7);
      expect(previousPrime(3), 2);
      expect(previousPrime(2), isNull);
      expect(previousPrime(-1), isNull);
    });

    test('nthPrime counts from one', () {
      expect(nthPrime(1), 2);
      expect(nthPrime(10), 29);
      expect(nthPrime(168), 997);
      expect(() => nthPrime(0), throwsArgumentError);
    });
  });

  group('factors', () {
    test('primeFactors, with repeats, in order', () {
      expect(primeFactors(360), [2, 2, 2, 3, 3, 5]);
      expect(primeFactors(97), [97]);
      expect(primeFactors(1), isEmpty);
      expect(primeFactors(0), isEmpty);
    });

    test('the factors multiply back to the number', () {
      for (final n in [2, 97, 360, 1024, 999983, 123456789]) {
        expect(primeFactors(n).fold(1, (a, b) => a * b), n, reason: '$n');
      }
    });

    test('every factor is itself prime', () {
      for (final f in primeFactors(123456789)) {
        expect(isPrime(f), isTrue, reason: '$f');
      }
    });

    test('factorise counts the exponents', () {
      expect(factorise(360), {2: 3, 3: 2, 5: 1});
      expect(factorise(97), {97: 1});
    });

    test('divisors, ascending and complete', () {
      expect(divisors(28), [1, 2, 4, 7, 14, 28]);
      expect(divisors(1), [1]);
      expect(divisors(97), [1, 97]);
    });

    test('isPerfect finds the perfect numbers and nothing else', () {
      expect(divisors(496).where((d) => d != 496).fold(0, (a, b) => a + b), 496);
      for (final n in [6, 28, 496, 8128]) {
        expect(isPerfect(n), isTrue, reason: '$n');
      }
      for (final n in [1, 2, 12, 27, 100]) {
        expect(isPerfect(n), isFalse, reason: '$n');
      }
    });
  });

  group('gcd and coprimality', () {
    test('gcd ignores sign', () {
      expect(gcd(12, 18), 6);
      expect(gcd(-12, 18), 6);
      expect(gcd(0, 5), 5);
    });

    test('isCoprime does not require either side to be prime', () {
      expect(isCoprime(9, 28), isTrue);
      expect(isCoprime(9, 12), isFalse);
    });

    test('areTwinPrimes', () {
      expect(areTwinPrimes(11, 13), isTrue);
      expect(areTwinPrimes(13, 11), isTrue, reason: 'order does not matter');
      expect(areTwinPrimes(7, 9), isFalse, reason: '9 is not prime');
      expect(areTwinPrimes(7, 11), isFalse, reason: 'four apart');
    });
  });
}
