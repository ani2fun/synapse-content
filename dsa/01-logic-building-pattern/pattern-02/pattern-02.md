---
title: "Pattern 2"
summary: "Print a right-angled triangle of stars where row i has i+1 stars."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 2

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
*
**
***
****
*****
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
*
**
***
****
```

## Example 2

**Input:** n = 2

**Output:**
```
*
**
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern2
    def pattern2(self, n: int) -> None:
        # Your code goes here — print a right-angled triangle where row i has i+1 stars.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern2(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern2
        void pattern2(int n) {
            // Your code goes here — print a right-angled triangle where row i has i+1 stars.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern2(n);
    }
}
```

```testcases
{
  "args": [
    { "id": "n", "label": "n", "type": "int", "placeholder": "4" }
  ],
  "cases": [
    { "args": { "n": "1" }, "expected": "*" },
    { "args": { "n": "2" }, "expected": "*\n**" },
    { "args": { "n": "3" }, "expected": "*\n**\n***" },
    { "args": { "n": "5" }, "expected": "*\n**\n***\n****\n*****" }
  ]
}
```
