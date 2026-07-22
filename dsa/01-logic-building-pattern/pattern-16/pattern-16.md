---
title: "Pattern 16"
summary: "Print a left-aligned triangle where each row repeats the next alphabet letter."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 16

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
A
BB
CCC
DDDD
EEEEE
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
A
BB
CCC
DDDD
```

## Example 2

**Input:** n = 2

**Output:**
```
A
BB
```

## Constraints

`1 <= n <= 26`

```python run
class Solution:
    # Function to print pattern16
    def pattern16(self, n: int) -> None:
        # Your code goes here — print n rows, row i repeating the i-th alphabet letter i+1 times.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern16(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern16
        void pattern16(int n) {
            // Your code goes here — print n rows, row i repeating the i-th alphabet letter i+1 times.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern16(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This problem may seem simple but it mirrors a fundamental concept in programming: loops and control structures.

</div>

### Fact 2
While in this problem it is used to print patterns, in real world applications, these loops could be used to iterate through data, increment counters, insert into databases or update UI components.

### Fact 3
Moreover, concepts used in this problem are extensively used in animation software, framework development, and even in game development where such pattern logic can be used to create various levels or stages.

### Fact 4
So next time when you see a pattern in a game, remember, it could be something as simple as this problem behind the scene!.
