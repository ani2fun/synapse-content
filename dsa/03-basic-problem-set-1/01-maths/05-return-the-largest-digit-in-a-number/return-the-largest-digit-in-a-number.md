---
title: "Return The Largest Digit In A Number"
summary: "Peel off digits with %10 and //10, tracking the largest one seen — a first digit-extraction loop."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Return The Largest Digit In A Number

You are given an integer n. Return the largest digit present in the number.

## Example 1

**Input:** n = 25

**Output:** 5

**Explanation:** The largest digit in 25 is 5.

## Example 2

**Input:** n = 99

**Output:** 9

**Explanation:** The largest digit in 99 is 9.

## Constraints

- `0 <= n <= 5000`
- n will contain no leading zeroes except when it is 0 itself.

```python run
class Solution:
    # Function to find the largest digit in a given number
    def largestDigit(self, n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(Solution().largestDigit(n))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find the largest digit in a given number
        int largestDigit(int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().largestDigit(n));
    }
}
```
