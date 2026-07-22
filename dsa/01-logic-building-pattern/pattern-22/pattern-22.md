---
title: "Pattern 22"
summary: "Print concentric square layers of numbers that count down from n at the edges to 1 in the center."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 22

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
5 5 5 5 5 5 5 5 5
5 4 4 4 4 4 4 4 5
5 4 3 3 3 3 3 4 5
5 4 3 2 2 2 3 4 5
5 4 3 2 1 2 3 4 5
5 4 3 2 2 2 3 4 5
5 4 3 3 3 3 3 4 5
5 4 4 4 4 4 4 4 5
5 5 5 5 5 5 5 5 5
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
4 4 4 4 4 4 4
4 3 3 3 3 3 4
4 3 2 2 2 3 4
4 3 2 1 2 3 4
4 3 2 2 2 3 4
4 3 3 3 3 3 4
4 4 4 4 4 4 4
```

## Example 2

**Input:** n = 2

**Output:**
```
2 2 2 
2 1 2 
2 2 2 
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern22
    def pattern22(self, n: int) -> None:
        # Your code goes here — print concentric square layers counting down from n at the edges to 1 in the center.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern22(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern22
        void pattern22(int n) {
            // Your code goes here — print concentric square layers counting down from n at the edges to 1 in the center.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern22(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** One real-world application of this problem is in graphic design software and games, where such patterns might be used to create programmatically generated visuals or puzzles.

</div>

### Fact 2
Understanding how to construct complex patterns from simple mathematical rules is a fundamental aspect of procedural generation, a technique commonly used in game design to create vast, explorable worlds on the fly.
