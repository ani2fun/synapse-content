---
title: "Pattern 3"
summary: "Print a right triangle where row i lists the numbers 1 through i, for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 3

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
1
12
123
1234
12345
```

Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**

```
1
12
123
1234
```

## Example 2

**Input:** n = 2

**Output:**

```
1
12
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern3
    def pattern3(self, n: int) -> None:
        # Your code goes here — print a right triangle where row i is 1 through i.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern3(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern3
        void pattern3(int n) {
            // Your code goes here — print a right triangle where row i is 1 through i.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern3(n);
    }
}
```
