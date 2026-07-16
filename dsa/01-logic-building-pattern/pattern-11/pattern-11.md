---
title: "Pattern 11"
summary: "Print a right triangle of alternating 1s and 0s, flipping the starting digit on each row."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 11

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
1
0 1
1 0 1
0 1 0 1
1 0 1 0 1
```

Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**
```
1
0 1
1 0 1
0 1 0 1
```

## Example 2

**Input:** n = 2

**Output:**
```
1
0 1
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern11
    def pattern11(self, n: int) -> None:
        # Your code goes here — print row i with i+1 digits alternating 1 and 0, starting with 1 on even rows and 0 on odd rows.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern11(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern11
        void pattern11(int n) {
            // Your code goes here — print row i with i+1 digits alternating 1 and 0, starting with 1 on even rows and 0 on odd rows.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern11(n);
    }
}
```

```testcases
{
  "args": [
    { "id": "n", "label": "n", "type": "int", "placeholder": "4" }
  ],
  "cases": [
    { "args": { "n": "1" }, "expected": "1" },
    { "args": { "n": "2" }, "expected": "1\n0 1" },
    { "args": { "n": "3" }, "expected": "1\n0 1\n1 0 1" },
    { "args": { "n": "5" }, "expected": "1\n0 1\n1 0 1\n0 1 0 1\n1 0 1 0 1" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** While this problem may seem trivial, the concept underlying it - pattern recognition and generation, is frequently used in software development.

</div>

### Fact 2
For example, in web development, design patterns such as MVC (Model View Controller) and MVVM (Model View ViewModel) are used.

### Fact 3
In artificial intelligence, machine learning algorithms often use pattern recognition to make predictions or decisions without being specifically programmed to perform the task.

### Fact 4
Consequently, having a solid understanding of simple pattern generation problems like this one can build a foundation for understanding more complex pattern-related concepts in various fields of software development and data science.
