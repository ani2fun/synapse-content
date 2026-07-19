---
title: "Check If The Number Is Armstrong"
summary: "Check whether a number equals the sum of its digits, each raised to the power of the digit count."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Check If The Number Is Armstrong

You are given an integer n. You need to check whether it is an armstrong number or not. Return true if it is an armstrong number, otherwise return false.

An armstrong number is a number which is equal to the sum of the digits of the number, raised to the power of the number of digits.

## Example 1

**Input:** n = 153

**Output:**

```text
true
```

**Explanation:** Number of digits : 3.

`1^3 + 5^3 + 3^3 = 1 + 125 + 27 = 153.`

Therefore, it is an Armstrong number.

## Example 2

**Input:** n = 12

**Output:**

```text
false
```

**Explanation:** Number of digits : 2.

`1^2 + 2^2 = 1 + 4 = 5.`

Therefore, it is not an Armstrong number.

## Constraints

- `0 <= n <= 10^9`

```python run
class Solution:
    # Function to find whether the number is Armstrong or not
    def isArmstrong(self, n: int) -> bool:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(str(Solution().isArmstrong(n)).lower())
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find whether the number is Armstrong or not
        boolean isArmstrong(int n) {
            // Your code goes here.
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().isArmstrong(n));
    }
}
```

```testcases
{
  "args": [
    { "id": "n", "label": "n", "type": "int", "placeholder": "153" }
  ],
  "cases": [
    { "args": { "n": "153" }, "expected": "true" },
    { "args": { "n": "12" }, "expected": "false" },
    { "args": { "n": "0" }, "expected": "true" },
    { "args": { "n": "9474" }, "expected": "true" }
  ]
}
```
