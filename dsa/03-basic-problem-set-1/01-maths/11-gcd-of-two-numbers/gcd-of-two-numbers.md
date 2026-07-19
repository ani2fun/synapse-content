---
title: "GCD Of Two Numbers"
summary: "Find the Greatest Common Divisor of two integers — from a brute-force scan to Euclid's modulo trick."
essential: true
kind: problem
difficulty: easy
topics: [maths, number-theory]
---

# GCD Of Two Numbers

You are given two integers n1 and n2. You need find the Greatest Common Divisor (GCD) of the two given numbers. Return the GCD of the two numbers.

The Greatest Common Divisor (GCD) of two integers is the largest positive integer that divides both of the integers.

## Example 1

**Input:** n1 = 4, n2 = 6

**Output:**

```text
2
```

**Explanation:** Divisors of n1 = 1, 2, 4, Divisors of n2 = 1, 2, 3, 6. Greatest Common divisor = 2.

## Example 2

**Input:** n1 = 9, n2 = 8

**Output:**

```text
1
```

**Explanation:** Divisors of n1 = 1, 3, 9 Divisors of n2 = 1, 2, 4, 8. Greatest Common divisor = 1.

## Example 3

**Input:** n1 = 6, n2 = 12

**Output:**

```text
6
```

## Constraints

- `1 <= n1, n2 <= 1000`

```python run
class Solution:
    # Function to find the GCD of two numbers
    def GCD(self, n1: int, n2: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())
print(Solution().GCD(n1, n2))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find the GCD of two numbers
        int GCD(int n1, int n2) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();
        System.out.println(new Solution().GCD(n1, n2));
    }
}
```

```testcases
{
  "args": [
    { "id": "n1", "label": "n1", "type": "int", "placeholder": "4" },
    { "id": "n2", "label": "n2", "type": "int", "placeholder": "6" }
  ],
  "cases": [
    { "args": { "n1": "4", "n2": "6" }, "expected": "2" },
    { "args": { "n1": "9", "n2": "8" }, "expected": "1" },
    { "args": { "n1": "6", "n2": "12" }, "expected": "6" },
    { "args": { "n1": "5", "n2": "5" }, "expected": "5" }
  ]
}
```
