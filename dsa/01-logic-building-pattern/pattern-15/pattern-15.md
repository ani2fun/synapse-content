---
title: "Pattern 15"
summary: "Print n rows of the alphabet, each row shrinking by one more letter from the last."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 15

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```text
ABCDE
ABCD
ABC
AB
A
```

Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**
```text
ABCD
ABC
AB
A
```

## Example 2

**Input:** n = 2

**Output:**
```text
AB
A
```

## Constraints

`1 <= n <= 26`

```python run
class Solution:
    # Function to print pattern15
    def pattern15(self, n: int) -> None:
        # Your code goes here — print n rows, row i holding the first (n - i) letters of the alphabet.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern15(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern15
        void pattern15(int n) {
            // Your code goes here — print n rows, row i holding the first (n - i) letters of the alphabet.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern15(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This type of problem is not directly applied in the software industry, but the underlying concept of iteration and pattern generation is frequently used.

</div>
