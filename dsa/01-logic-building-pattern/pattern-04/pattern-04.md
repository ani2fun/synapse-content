---
title: "Pattern 4"
summary: "Print a right triangle where each row repeats its own row number that many times."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 4

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
1
22
333
4444
55555
```

Print the pattern in the function given to you.

## Example 1

**Input:** n = 4

**Output:**
```
1
22
333
4444
```

## Example 2

**Input:** n = 2

**Output:**
```
1
22
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern4
    def pattern4(self, n: int) -> None:
        # Your code goes here — print row i with the digit i repeated i times.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern4(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern4
        void pattern4(int n) {
            // Your code goes here — print row i with the digit i repeated i times.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern4(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** Many website and application development technologies use the concept underlying this problem, known as "looping".

</div>

### Fact 2
For example, in Javascript, repeating elements are often rendered in a webpage using loops.

### Fact 3
If a React developer needs to display a repeating component, they could use a pattern similar to the given problem.

### Fact 4
This could be a list where each item should display a number of times corresponding to its value, like stars in a rating system or in creating user interface patterns.

### Fact 5
It's a fundamental concept in creating dynamic content based on variable data.
