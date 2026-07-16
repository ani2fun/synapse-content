---
title: "Pattern 17"
summary: "Print a left-aligned alphabet pyramid that rises to a row's peak letter and back down to A."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 17

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
    A
   ABA
  ABCBA
 ABCDCBA
ABCDEDCBA
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
   A
  ABA
 ABCBA
ABCDCBA
```

## Example 2

**Input:** n = 2

**Output:**
```
 A
ABA
```

## Constraints

`1 <= n <= 26`

```python run
class Solution:
    # Function to print pattern17
    def pattern17(self, n: int) -> None:
        # Your code goes here — row i has (n-i-1) leading spaces, then letters climbing A..A+i and back down to A.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern17(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern17
        void pattern17(int n) {
            // Your code goes here — row i has (n-i-1) leading spaces, then letters climbing A..A+i and back down to A.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern17(n);
    }
}
```

```testcases
{
  "args": [
    { "id": "n", "label": "n", "type": "int", "placeholder": "4" }
  ],
  "cases": [
    { "args": { "n": "1" }, "expected": "A" },
    { "args": { "n": "2" }, "expected": " A\nABA" },
    { "args": { "n": "3" }, "expected": "  A\n ABA\nABCBA" },
    { "args": { "n": "5" }, "expected": "    A\n   ABA\n  ABCBA\n ABCDCBA\nABCDEDCBA" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This programming problem essentially tests the concept of pattern/problem recognition and string manipulation, which are vital in many areas of software development.

</div>

### Fact 2
For instance, in data analysis or processing platforms, there often are requirements to detect and manipulate data patterns.

### Fact 3
Moreover, in various machine learning models such as natural language processing, the concept of pattern recognition and string manipulation is extensively used to train the models to understand, recognize, and generate human-like text.
