---
title: "Check For Prime Number"
summary: "Check whether an integer is prime, and see why checking divisors only up to √n is enough."
essential: true
kind: problem
difficulty: easy
topics: [maths, primes]
---

# Check For Prime Number

You are given an integer n. You need to check if the number is prime or not. Return true if it is a prime number, otherwise return false.

A prime number is a number which has no divisors except 1 and itself.

## Example 1

**Input:** n = 5

**Output:**

```text
true
```

**Explanation:** The only divisors of 5 are 1 and 5 , So the number 5 is prime.

## Example 2

**Input:** n = 8

**Output:**

```text
false
```

**Explanation:** The divisors of 8 are 1, 2, 4, 8, thus it is not a prime number.

## Example 3

**Input:** n = 9

**Output:**

```text
false
```

## Constraints

- `1 <= n <= 5000`

```python run
class Solution:
    # Function to find whether the number is prime or not
    def isPrime(self, n: int) -> bool:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print("true" if Solution().isPrime(n) else "false")
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find whether the number is prime or not
        boolean isPrime(int n) {
            // Your code goes here.
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().isPrime(n));
    }
}
```

```testcases
{
  "args": [ { "id": "n", "label": "n", "type": "int", "placeholder": "5" } ],
  "cases": [
    { "args": { "n": "5" }, "expected": "true" },
    { "args": { "n": "8" }, "expected": "false" },
    { "args": { "n": "9" }, "expected": "false" },
    { "args": { "n": "2" }, "expected": "true" }
  ]
}
```
