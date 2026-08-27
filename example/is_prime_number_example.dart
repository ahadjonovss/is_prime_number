import 'package:is_prime_number/is_prime_number.dart';

void main() {
  // The question the package is named after.
  print(isPrime(97)); // true
  print(isPrime(1)); // false — 1 is not prime
  print(isPrime(2147483647)); // true — 2^31 − 1, exact, no probability

  // A whole range at once. Sieving beats testing each number in a loop.
  print(primesUpTo(30)); // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
  print(primeCountUpTo(1000)); // 168

  // Lazy and infinite: this costs five primes, not a sieve.
  print(primes().take(5).toList()); // [2, 3, 5, 7, 11]
  print(primes().takeWhile((p) => p < 30).length); // 10

  // Moving around the number line.
  print(nextPrime(10)); // 11
  print(previousPrime(10)); // 7
  print(previousPrime(2)); // null — there is nothing below it
  print(nthPrime(1000)); // 7919

  // Taking a number apart.
  print(primeFactors(360)); // [2, 2, 2, 3, 3, 5]
  print(factorise(360)); // {2: 3, 3: 2, 5: 1}
  print(divisors(28)); // [1, 2, 4, 7, 14, 28]

  // Odds and ends from number theory.
  print(isPerfect(28)); // true — 1 + 2 + 4 + 7 + 14
  print(areTwinPrimes(11, 13)); // true
  print(isCoprime(9, 28)); // true — neither is prime, but they share nothing
  print(gcd(12, 18)); // 6
}
