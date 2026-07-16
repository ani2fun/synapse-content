---
title: "Pattern 8"
summary: "Print an inverted right triangle where each row loses two stars and gains a leading space, for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 8

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
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
*******
 *****
  ***
   *
```

## Example 2

**Input:** n = 2

**Output:**
```
***
 *
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern8
    def pattern8(self, n: int) -> None:
        # Your code goes here — print an inverted triangle of stars with a growing leading-space indent.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern8(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern8
        void pattern8(int n) {
            // Your code goes here — print an inverted triangle of stars with a growing leading-space indent.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern8(n);
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
    { "args": { "n": "2" }, "expected": "***\n *" },
    { "args": { "n": "3" }, "expected": "*****\n ***\n  *" },
    { "args": { "n": "5" }, "expected": "*********\n *******\n  *****\n   ***\n    *" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** While this problem may not seem directly applicable to real-world software development, the skills you use to solve it certainly are.

</div>

### Fact 2
This type of problem teaches two key programming concepts: loops and string manipulation.

### Fact 3
Both are widely applied in many fields of software development.

### Fact 4
For example, in web development, loops and string manipulations are often used to dynamically generate HTML or format text content.

### Fact 5
In data analysis, these skills are essential for parsing and cleaning data.

### Fact 6
Drawing a pattern like this is also common in computer graphics, used perhaps in creating design elements or animations dynamically.
