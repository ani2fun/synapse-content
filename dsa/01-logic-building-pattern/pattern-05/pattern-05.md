---
title: "Pattern 5"
summary: "Print an inverted right triangle of stars where row i has n-i stars."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 5

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
*****
****
***
**
*
```



Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**
```
****
***
**
*
```

## Example 2

**Input:** n = 2

**Output:**
```
**
*
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern5
    def pattern5(self, n: int) -> None:
        # Your code goes here — print an inverted right triangle where row i has n-i stars.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern5(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern5
        void pattern5(int n) {
            // Your code goes here — print an inverted right triangle where row i has n-i stars.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern5(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This basic problem is designed to test your understanding of loops and string manipulation, which are basic in almost any programming language.

</div>

### Fact 2
In the real world, similar patterns and principles might be used for creating complex data visualization tools, ASCII art, or templating engines that generate HTML for web pages.

### Fact 3
Drawing patterns, grids, or other specific shapes is often a core part of game development as well, so praticing such problems can be a kick-start towards learning how to develop basic graphical elements in game designing.
