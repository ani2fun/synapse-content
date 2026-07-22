---
title: "Reverse A Number"
summary: "Return the integer formed by reversing the digits of n."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Reverse A Number

You are given an integer n. Return the integer formed by placing the digits of n in reverse order.

## Example 1

**Input:** n = 25

**Output:**

```text
52
```

**Explanation:** Reverse of 25 is 52.

## Example 2

**Input:** n = 123

**Output:**

```text
321
```

**Explanation:** Reverse of 123 is 321.

## Example 3

**Input:** n = 54

**Output:**

```text
45
```

## Constraints

- `0 <= n <= 5000`
- `n will contain no leading zeroes except when it is 0 itself.`

```python run
class Solution:
    # Function to reverse given number n
    def reverseNumber(self, n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
print(Solution().reverseNumber(n))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to reverse given number n
        int reverseNumber(int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().reverseNumber(n));
    }
}
```
