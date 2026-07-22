---
title: "Count Of Prime Numbers Till N"
summary: "Count how many prime numbers lie in the range [1, n]."
essential: true
kind: problem
difficulty: easy
topics: [maths, primes]
---

# Count Of Prime Numbers Till N

You are given an integer n. You need to find out the number of prime numbers in the range [1, n] (inclusive). Return the number of prime numbers in the range.

A prime number is a number which has no divisors except, 1 and itself.

## Example 1

**Input:** n = 6

**Output:**

```text
3
```

**Explanation:** Prime numbers in the range [1, 6] are 2, 3, 5.

## Example 2

**Input:** n = 10

**Output:**

```text
4
```

**Explanation:** Prime numbers in the range [1, 10] are 2, 3, 5, 7.

## Example 3

**Input:** n = 20

**Output:**

```text
8
```

## Constraints

- `2 <= n <= 1000`

```python run
class Solution:
    # Function to find count of primes till n
    def primeUptoN(self, n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(Solution().primeUptoN(n))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find count of primes till n
        int primeUptoN(int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().primeUptoN(n));
    }
}
```
