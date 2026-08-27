## 0.1.0

A real package rather than a single function.

**Fixed**
- `isPrime` bounded the loop with `sqrt(n).toInt()`. `sqrt` returns a double, and
  one landing a hair under a perfect square truncated low — dropping the final
  divisor and reporting a composite as prime. The bound is now `i * i <= n`,
  entirely in integers.
- Large numbers were tested by trial division alone, which is unusable long
  before `int` runs out. Above 50,000 the test is now Miller–Rabin with a witness
  set proven deterministic across the whole `int` range.
- The test file was the untouched `flutter create` template and did not compile —
  it referenced a `Calculator` class that never existed. There are now 24 tests.
- The README documented `isPrimeNumber(...)`; the function is `isPrime(...)`.

**Changed**
- Now a pure Dart package. It never used Flutter, and dropping the SDK dependency
  lets it run on the server, the web and the command line.

**Added**
- `nextPrime`, `previousPrime`, `nthPrime`
- `primesUpTo`, `primeCountUpTo` — sieve of Eratosthenes over odds only
- `primes()` — a lazy, infinite iterable
- `primeFactors`, `factorise`, `divisors`
- `isPerfect`, `areTwinPrimes`, `isCoprime`, `gcd`
- An example, and documentation comments throughout

## 0.0.1

- `isPrime`.
