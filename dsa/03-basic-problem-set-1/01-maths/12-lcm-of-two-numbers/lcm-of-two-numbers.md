---
title: "LCM Of Two Numbers"
summary: "Find the Lowest Common Multiple of two integers — brute-force multiples versus the GCD-based formula."
essential: true
kind: problem
difficulty: easy
topics: [maths, number-theory]
---

# LCM Of Two Numbers

You are given two integers n1 and n2. You need find the Lowest Common Multiple (LCM) of the two given numbers. Return the LCM of the two numbers.

The Lowest Common Multiple (LCM) of two integers is the lowest positive integer that is divisible by both the integers.

## Example 1

**Input:** n1 = 4, n2 = 6

**Output:**
```text
12
```

**Explanation:** 4 * 3 = 12, 6 * 2 = 12. 12 is the lowest integer that is divisible both 4 and 6.

## Example 2

**Input:** n1 = 3, n2 = 5

**Output:**
```text
15
```

**Explanation:** 3 * 5 = 15, 5 * 3 = 15. 15 is the lowest integer that is divisible both 3 and 5.

## Example 3

**Input:** n1 = 4, n2 = 12

**Output:**
```text
12
```

## Constraints

- `1 <= n1, n2 <= 1000`

```python run
class Solution:
    # Function to find LCM of n1 and n2
    def LCM(self, n1: int, n2: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())
print(Solution().LCM(n1, n2))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find LCM of n1 and n2
        int LCM(int n1, int n2) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();
        System.out.println(new Solution().LCM(n1, n2));
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
    { "args": { "n1": "4", "n2": "6" }, "expected": "12" },
    { "args": { "n1": "3", "n2": "5" }, "expected": "15" },
    { "args": { "n1": "4", "n2": "12" }, "expected": "12" },
    { "args": { "n1": "7", "n2": "7" }, "expected": "7" }
  ]
}
```
