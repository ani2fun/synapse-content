---
title: "Pattern 9"
summary: "Print a diamond pattern of stars for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 9

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
    *
   ***
  *****
 *******
*********
*********
 *******
  *****
   ***
    *
```

Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**
```
   *
  ***
 *****
*******
*******
 *****
  ***
   *
```

## Example 2

**Input:** n = 2

**Output:**
```
 *
***
***
 *
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern9
    def pattern9(self, n: int) -> None:
        # Your code goes here — print a pyramid then an inverted pyramid to form a diamond.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern9(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern9
        void pattern9(int n) {
            // Your code goes here — print a pyramid then an inverted pyramid to form a diamond.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern9(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** While developing console-based games, animations, or other graphical representations in terminal, such pattern creation problems come handy.

</div>

### Fact 2
They give an understanding of how to use control structures (like loops) for producing repetitive and patterned output.

### Fact 3
These concepts are fundamental in developing console output display features in many kinds of software.

### Fact 4
The ability to create and manipulate these patterns can be extended to more complex graphics rendering challenges.
