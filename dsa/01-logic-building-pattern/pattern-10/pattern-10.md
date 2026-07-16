---
title: "Pattern 10"
summary: "Print a rotated triangle of stars that grows to n and shrinks back down to 1."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 10

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
*
**
***
****
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
*
**
***
****
***
**
*
```

## Example 2

**Input:** n = 2

**Output:**
```
*
**
*
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern10
    def pattern10(self, n: int) -> None:
        # Your code goes here — grow the star count to n, then shrink it back to 1.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern10(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern10
        void pattern10(int n) {
            // Your code goes here — grow the star count to n, then shrink it back to 1.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern10(n);
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
    { "args": { "n": "2" }, "expected": "*\n**\n*" },
    { "args": { "n": "4" }, "expected": "*\n**\n***\n****\n***\n**\n*" },
    { "args": { "n": "5" }, "expected": "*\n**\n***\n****\n*****\n****\n***\n**\n*" }
  ]
}
```

## Fun Facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** In the software development, this pattern problem, or its underlying concept of nested iteration, can often be observed in creating visual effects or graphical interfaces.

</div>

### Fact 2
For example, such pattern logic might be used in creating loading animations, pyramid diagrams, or automated design elements in a web or mobile application.

### Fact 3
On a more abstract level, understanding how to construct and manipulate such patterns is fundamental to working with 2D arrays and matrices - structures widely used in image processing, to represent graphs, in machine learning algorithms, and more.
