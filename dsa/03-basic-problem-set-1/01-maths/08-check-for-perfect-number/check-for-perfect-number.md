---
title: "Check For Perfect Number"
summary: "Determine whether an integer's proper divisors sum to itself."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Check For Perfect Number

You are given an integer n. You need to check if the number is a perfect number or not. Return true if it is a perfect number, otherwise, return false.

A perfect number is a number whose proper divisors (excluding the number itself) add up to the number itself.

## Example 1

**Input:** n = 6

**Output:**
```text
true
```

**Explanation:** Proper divisors of 6 are 1, 2, 3.

1 + 2 + 3 = 6.

## Example 2

**Input:** n = 4

**Output:**
```text
false
```

**Explanation:** Proper divisors of 4 are 1, 2.

1 + 2 = 3.

## Example 3

**Input:** n = 28

**Output:**
```text
true
```

## Constraints

- `1 <= n <= 5000`

```python run
class Solution:
    # Function to find whether the number is perfect or not
    def isPerfect(self, n: int) -> bool:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print("true" if Solution().isPerfect(n) else "false")
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find whether the number is perfect or not
        boolean isPerfect(int n) {
            // Your code goes here.
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().isPerfect(n));
    }
}
```
