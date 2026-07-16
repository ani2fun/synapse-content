---
title: "Pattern 18"
summary: "Print a triangle of letters where every row ends at the n-th letter of the alphabet."
essential: true
kind: problem
difficulty: easy
topics: [patterns, loops]
---

# Pattern 18

Given an integer n. You need to recreate the pattern given below for any value of N. Let's say for N = 5, the pattern should look like as below:
```
E 
D E 
C D E 
B C D E 
A B C D E 
```


Print the pattern in the function given to you.


## Example 1

**Input:** n = 4

**Output:**
```
D  
C D  
B C D  
A B C D  
```

## Example 2

**Input:** n = 2

**Output:**
```
B 
A B 
```

## Constraints

`1 <= n <= 26`

```python run
class Solution:
    # Function to print pattern18
    def pattern18(self, n: int) -> None:
        # Your code goes here — print n rows of letters, each row ending at the n-th letter.
        pass


# Reads the test case's n, e.g. 4
n = int(input())
Solution().pattern18(n)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern18
        void pattern18(int n) {
            // Your code goes here — print n rows of letters, each row ending at the n-th letter.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        new Solution().pattern18(n);
    }
}
```

```testcases
{
  "args": [
    { "id": "n", "label": "n", "type": "int", "placeholder": "4" }
  ],
  "cases": [
    { "args": { "n": "1" }, "expected": "A " },
    { "args": { "n": "2" }, "expected": "B \nA B " },
    { "args": { "n": "3" }, "expected": "C \nB C \nA B C " },
    { "args": { "n": "5" }, "expected": "E \nD E \nC D E \nB C D E \nA B C D E " }
  ]
}
```
