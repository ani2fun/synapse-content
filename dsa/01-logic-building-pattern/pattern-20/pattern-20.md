---
title: "Pattern 20"
summary: "Print a mirrored hourglass of stars for any given n."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 20

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
*        *
**      **
***    ***
****  ****
**********
****  ****
***    ***
**      **
*        *
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
*      *
**    **
***  ***
********
***  ***
**    **
*      *
```

## Example 2

**Input:** n = 2

**Output:**
```
*  *
****
*  *
```

## Constraints

`1 <= n <= 100`

```python run
class Solution:
    # Function to print pattern20
    def pattern20(self, n: int) -> None:
        # Your code goes here — print a mirrored hourglass of stars.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern20(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern20
        void pattern20(int n) {
            // Your code goes here — print a mirrored hourglass of stars.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern20(n);
    }
}
```



## Fun facts

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** This problem demonstrates the concept of loops and pattern recognition/matching which is a fundamental aspect in many software applications.

</div>

### Fact 2
In the real-world, pattern generation problems like this are commonly used in computer graphics and game development to generate textures, shapes, or terrain.
### Fact 3
It is also used in tools like regular expression engines which are widely used in text parsing, syntax highlighting, data validation, and search functionalities which are core to numerous software applications.
### Fact 4
Interesting fact: Algorithms to generate complex patterns are also pivotal in certain aspects of cryptography and data security.
