---
title: "Pattern 1"
summary: "Print a solid n x n square of stars for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 1

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
*****
*****
*****
*****
*****
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
****
****
****
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
    # Function to print pattern1
    def pattern1(self, n: int) -> None:
        # Your code goes here — print an n x n square of '*'.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern1(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern1
        void pattern1(int n) {
            // Your code goes here — print an n x n square of '*'.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern1(n);
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
    { "args": { "n": "2" }, "expected": "**\n**" },
    { "args": { "n": "3" }, "expected": "***\n***\n***" },
    { "args": { "n": "5" }, "expected": "*****\n*****\n*****\n*****\n*****" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** Though simple, generating patterns like this one is a foundational skill for graphical programming and game development.

</div>

### Fact 2
Many retro, text-based games like rogue or Dwarf Fortress use text characters to represent the game world, and modern games use more advanced versions of these same principles to create their levels and worlds! Specifically, being able to generate a repetitive pattern like this can be crucial in designing background graphics, creating tile-based games, designing user interfaces and even in certain testing scenarios.