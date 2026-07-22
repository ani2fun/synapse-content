---
title: "Pattern 12"
summary: "Print n rows of ascending-then-descending numbers separated by a shrinking gap of spaces."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 12

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
1        1
12      21
123    321
1234  4321
1234554321
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
1      1
12    21
123  321
12344321
```

## Example 2

**Input:** n = 2

**Output:**
```
1  1
1221
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern12
    def pattern12(self, n: int) -> None:
        # Your code goes here — print ascending-then-descending number rows separated by a shrinking gap of spaces.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern12(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern12
        void pattern12(int n) {
            // Your code goes here — print ascending-then-descending number rows separated by a shrinking gap of spaces.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern12(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** Though this problem seems purely academic, the underlying concepts - the manipulation of strings and control structures like loops, are fundamental in many areas of software development.

</div>

### Fact 2
For instance, generating dynamic SQL queries for specific situations often requires sophisticated string manipulation.

### Fact 3
Also, the understanding and usage of nested loops are crucial in rendering hierarchical data or multi-dimensional arrays, like creating expandable menu systems in app development.

### Fact 4
So while this exact problem may not be seen in the wild, its elemental concepts are heavily utilized in coding.
