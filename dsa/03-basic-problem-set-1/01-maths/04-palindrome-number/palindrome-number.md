---
title: "Palindrome Number"
summary: "Check whether an integer reads the same forwards and backwards by reversing its digits."
essential: true
kind: problem
difficulty: easy
topics: [maths, loops]
---

# Palindrome Number

You are given an integer n. You need to check whether the number is a palindrome number or not. Return true if it's a palindrome number, otherwise return false.

A palindrome number is a number which reads the same both left to right and right to left.

## Example 1

**Input:** n = 121

**Output:** true

**Explanation:** When read from left to right : 121. When read from right to left : 121.

## Example 2

**Input:** n = 123

**Output:** false

**Explanation:** When read from left to right : 123. When read from right to left : 321.

## Constraints

- `0 <= n <= 5000`
- n will contain no leading zeroes except when it is 0 itself.

```python run
class Solution:
    # Function to check if a number is palindrome or not
    def isPalindrome(self, n: int) -> bool:
        # Your code goes here.
        pass


# Reads the test case's n
n = int(input())
result = Solution().isPalindrome(n)
print("true" if result else "false")
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to check if a number is palindrome or not
        boolean isPalindrome(int n) {
            // Your code goes here.
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        System.out.println(new Solution().isPalindrome(n));
    }
}
```
