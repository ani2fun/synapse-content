---
title: "Pattern 14"
summary: "Print n rows of the alphabet, each row growing by one more letter."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 14

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```text
A
AB
ABC
ABCD
ABCDE
```

Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**
```text
A
AB
ABC
ABCD
```

## Example 2

**Input:** n = 2

**Output:**
```text
A
AB
```

## Constraints

`1 <= n <= 26`

```python run
class Solution:
    # Function to print pattern14
    def pattern14(self, n: int) -> None:
        # Your code goes here — print n rows, row i holding the first i+1 letters of the alphabet.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern14(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern14
        void pattern14(int n) {
            // Your code goes here — print n rows, row i holding the first i+1 letters of the alphabet.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern14(n);
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
    { "args": { "n": "2" }, "expected": "A\nAB" },
    { "args": { "n": "4" }, "expected": "A\nAB\nABC\nABCD" },
    { "args": { "n": "5" }, "expected": "A\nAB\nABC\nABCD\nABCDE" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This programming problem trains you in understanding and manipulating strings, which is a fundamental concept in software development.

</div>

### Fact 2
In real-world applications, this exercise could apply to systems requiring hierarchical data representation or nested data structures.

### Fact 3
For instance, consider a file manager where files/folders are nested within other folders.

### Fact 4
Each level of the hierarchy could be represented by a different letter of the alphabet, giving a visual indicator of the current depth in the hierarchy.

### Fact 5
Likewise, file paths in Unix-like operating systems could be shown using this pattern, with each subsequent directory represented by an additional alphabet letter.

### Fact 6
This problem can also have its applications in generating different patterns which is a key aspect of creating graphs or visualizations in software applications.
