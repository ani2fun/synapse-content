---
title: "Count Number Of Odd Digits In A Number"
summary: "Count how many digits of a non-negative integer are odd by peeling digits off one at a time."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Count Number Of Odd Digits In A Number

You are given an integer n. You need to return the number of odd digits present in the number.

The number will have no leading zeroes, except when the number is 0 itself.

## Example 1

**Input:** n = 5

**Output:**
```text
1
```

**Explanation:** 5 is an odd digit.

## Example 2

**Input:** n = 25

**Output:**
```text
1
```

**Explanation:** The only odd digit in 25 is 5.

## Example 3

**Input:** n = 15

**Output:**
```text
2
```

## Constraints

- `0 <= n <= 5000`
- `n` will contain no leading zeroes except when it is 0 itself.

```python run
class Solution:
    # Function to count number of odd digits in N
    def countOddDigit(self, n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(Solution().countOddDigit(n))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to count number of odd digits in N
        int countOddDigit(int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().countOddDigit(n));
    }
}
```
