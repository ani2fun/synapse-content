---
title: "Pattern 21"
summary: "Print a hollow n x n square outline of stars for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 21

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
*****
*   *
*   *
*   *
*****
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
****
*  *
*  *
****
```

## Example 2

**Input:** n = 2

**Output:**
```
**
**
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern21
    def pattern21(self, n: int) -> None:
        # Your code goes here — print a hollow n x n square outline of '*' (border only, interior spaces).
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern21(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern21
        void pattern21(int n) {
            // Your code goes here — print a hollow n x n square outline of '*' (border only, interior spaces).
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern21(n);
    }
}
```
