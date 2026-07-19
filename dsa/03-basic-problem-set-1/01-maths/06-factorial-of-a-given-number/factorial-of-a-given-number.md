---
title: "Factorial Of A Given Number"
summary: "Compute n! for a small n with a single accumulating loop."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Factorial Of A Given Number

You are given an integer n. Return the value of n! or n factorial.

Factorial of a number is the product of all positive integers less than or equal to that number.

## Example 1

**Input:** n = 2

**Output:** 2

**Explanation:** 2! = 1 * 2 = 2.

## Example 2

**Input:** n = 0

**Output:** 1

**Explanation:** 0! is defined as 1.

## Example 3

**Input:** 3

**Output:**

```text
6
```

## Constraints

- `0 <= n <= 10`

```python run
class Solution:
    # Function to find the factorial of a number
    def factorial(self, n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(Solution().factorial(n))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find the factorial of a number
        int factorial(int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().factorial(n));
    }
}
```

```testcases
{
  "args": [ { "id": "n", "label": "n", "type": "int", "placeholder": "4" } ],
  "cases": [
    { "args": { "n": "2" }, "expected": "2" },
    { "args": { "n": "0" }, "expected": "1" },
    { "args": { "n": "3" }, "expected": "6" }
  ]
}
```
