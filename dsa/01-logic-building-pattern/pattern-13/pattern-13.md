---
title: "Pattern 13"
summary: "Print a triangular number pattern where each row continues the count from the last."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 13

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:

```
1
2 3
4 5 6
7 8 9 10
11 12 13 14 15
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
1
2 3
4 5 6
7 8 9 10
```

## Example 2

**Input:** n = 2

**Output:**
```
1
2 3
4 5 6
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern13
    def pattern13(self, n: int) -> None:
        # Your code goes here — print a triangular number pattern, continuing the count across rows.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern13(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern13
        void pattern13(int n) {
            // Your code goes here — print a triangular number pattern, continuing the count across rows.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern13(n);
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
    { "args": { "n": "2" }, "expected": "1 \n2 3" },
    { "args": { "n": "4" }, "expected": "1 \n2 3 \n4 5 6 \n7 8 9 10" },
    { "args": { "n": "5" }, "expected": "1 \n2 3 \n4 5 6 \n7 8 9 10 \n11 12 13 14 15" }
  ]
}
```

## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** The underlying concept of this problem is often used in the display logic of many applications.

</div>

### Fact 2
For instance, in social media apps like Instagram, the images are displayed in a similar pattern, where each new row may have more images than previous.

### Fact 3
Similar logic can be seen in calendar based applications and games, where the positions of different data points or objects are calculated dynamically based on a specific pattern.

### Fact 4
Understanding this ensures that developers can create interfaces that are adaptable and user friendly.
