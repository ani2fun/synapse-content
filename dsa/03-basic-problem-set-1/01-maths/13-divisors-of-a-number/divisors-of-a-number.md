---
title: "Divisors Of A Number"
summary: "Find every divisor of n, from an O(n) scan to the sqrt(n) pairing trick."
essential: true
kind: problem
difficulty: easy
topics: [maths, number-theory]
---

# Divisors Of A Number

You are given an integer n. You need to find all the divisors of n. Return all the divisors of n as an array or list in a sorted order.

<div style="border-left:4px solid #15448e;background:rgba(21,68,142,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

ℹ️ **Definition.** A number which completely divides another number is called its divisor.

</div>

## Example 1

**Input:** n = 6

**Output:**

```text
[1, 2, 3, 6]
```

**Explanation:** The divisors of 6 are 1, 2, 3, 6.

## Example 2

**Input:** n = 8

**Output:**

```text
[1, 2, 4, 8]
```

**Explanation:** The divisors of 8 are 1, 2, 4, 8.

## Example 3

**Input:** n = 7

**Output:**

```text
[1, 7]
```

## Constraints

- `1 <= n <= 1000`

```python run
class Solution:
    # Function to find all divisors of n
    def divisors(self, n: int) -> list[int]:
        # Your code goes here.
        return []


# Reads the test case's n
n = int(input())
ans = Solution().divisors(n)
print("[" + ", ".join(map(str, ans)) + "]")
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to find all divisors of n
        int[] divisors(int n) {
            // Your code goes here.
            return new int[0];
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        int[] ans = new Solution().divisors(n);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ans.length; i++) {
            sb.append(ans[i]);
            if (i < ans.length - 1) sb.append(", ");
        }
        sb.append("]");
        System.out.println(sb);
    }
}
```

```testcases
{
  "args": [ { "id": "n", "label": "n", "type": "int", "placeholder": "6" } ],
  "cases": [
    { "args": { "n": "6" }, "expected": "[1, 2, 3, 6]" },
    { "args": { "n": "8" }, "expected": "[1, 2, 4, 8]" },
    { "args": { "n": "7" }, "expected": "[1, 7]" }
  ]
}
```
