---
title: "Count All Digits Of A Number"
summary: "Count the number of digits in an integer n, including the n = 0 edge case."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Count All Digits Of A Number

You are given an integer n. You need to return the number of digits in the number.

The number will have no leading zeroes, except when the number is 0 itself.

## Example 1

**Input:** n = 4

**Output:**
```text
1
```

**Explanation:** There is only 1 digit in 4.

## Example 2

**Input:** n = 14

**Output:**
```text
2
```

**Explanation:** There are 2 digits in 14.

## Example 3

**Input:** n = 234

**Output:**
```text
3
```

## Constraints

- `0 <= n <= 5000`
- n will contain no leading zeroes, except when it is 0 itself.

```python run
class Solution:
    # Function to count all digits in n
    def countDigit(self, n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(Solution().countDigit(n))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to count all digits in n
        int countDigit(int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().countDigit(n));
    }
}
```

```testcases
{
  "args": [ { "id": "n", "label": "n", "type": "int", "placeholder": "4" } ],
  "cases": [
    { "args": { "n": "4" }, "expected": "1" },
    { "args": { "n": "14" }, "expected": "2" },
    { "args": { "n": "234" }, "expected": "3" }
  ]
}
```
