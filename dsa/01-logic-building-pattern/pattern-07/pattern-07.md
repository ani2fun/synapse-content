---
title: "Pattern 7"
summary: "Print a right-aligned pyramid of stars for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 7

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
    *
   ***
  *****
 *******
*********
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
```

## Example 2

**Input:** n = 2

**Output:**
```
 *
***
```


## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern7
    def pattern7(self, n: int) -> None:
        # Your code goes here — print an n-row pyramid, right-aligned with leading spaces.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern7(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern7
        void pattern7(int n) {
            // Your code goes here — print an n-row pyramid, right-aligned with leading spaces.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern7(n);
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
    { "args": { "n": "2" }, "expected": " *\n***" },
    { "args": { "n": "3" }, "expected": "  *\n ***\n*****" },
    { "args": { "n": "5" }, "expected": "    *\n   ***\n  *****\n *******\n*********" }
  ]
}
```

## Fun Facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This problem, at its core, is about iteration, conditional logic, and string manipulation - fundamental concepts in many programming languages.

</div>

### Fact 2
In real world applications, a form of this problem can be seen in creating dynamic visualizations or graphical outputs in console-based applications.

### Fact 3
For example, console-based games, progress bar visualization, and console animations all use similar logic to create dynamic, visually-oriented outputs.
