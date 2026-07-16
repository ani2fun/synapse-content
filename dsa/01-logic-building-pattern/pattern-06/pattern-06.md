---
title: "Pattern 6"
summary: "Print a right triangle of decreasing counting numbers for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 6

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
12345
1234
123
12
1
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
1234
123
12
1
```


## Example 2

**Input:** n = 2

**Output:**
```
12
1
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern6
    def pattern6(self, n: int) -> None:
        # Your code goes here — print a right triangle of decreasing counting numbers.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern6(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern6
        void pattern6(int n) {
            // Your code goes here — print a right triangle of decreasing counting numbers.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern6(n);
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
    { "args": { "n": "2" }, "expected": "12\n1" },
    { "args": { "n": "3" }, "expected": "123\n12\n1" },
    { "args": { "n": "5" }, "expected": "12345\n1234\n123\n12\n1" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This problem, while simple, forms the basic building block for algorithms related to pattern recognition and generation.

</div>

### Fact 2
In real-world software development, these kind of pattern algorithms underlie many different aspects, from simple user interface design (creating repetitive patterns or layouts) to more complex concepts like creating game stages procedurally in video game development.

### Fact 3

This exercise of generating patterns based on a given number can also serve as the elementary introduction to recursive functions and loops, vital concepts in any kind of programming.
