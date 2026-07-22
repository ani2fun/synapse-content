---
title: "Flip Characters"
summary: "Given an array of characters arr, reverse it in place by swapping equidistant elements from the start and the end — the canonical two-pointer problem."
difficulty: easy
kind: problem
topics: [two-pointers, arrays]
---

# Flip Characters

## The Problem

Given an array of characters `arr`, reverse the array by **swapping equidistant elements** from the start and the end. The reversal must happen **in-place** — modify the input array directly and use **O(1) extra space**.

```
Input:  arr = [a, e, i, o, u]
Output:       [u, o, i, e, a]
```

This is the canonical direct application of the two-pointer pattern — the template and the algorithm are identical.

---

## Examples

**Example 1**
```
Input:  arr = [a, e, i, o, u]
Output:       [u, o, i, e, a]
```

**Example 2**
```
Input:  arr = [a, b, c, d, e]
Output:       [e, d, c, b, a]
```

**Example 3 — empty array**
```
Input:  arr = []
Output:       []
```

```quiz
{
  "prompt": "Now your turn!",
  "input": "arr = [s, y, n, a, p, s, e]",
  "options": ["[s, y, n, a, p, s, e]", "[e, s, p, a, n, y, s]", "[e, s, y, n, a, p, s]", "[s, e, s, p, a, n, y]"],
  "answer": "[e, s, p, a, n, y, s]"
}
```

## Constraints

- `0 ≤ arr.length ≤ 1000`
- `arr[i]` is a printable ASCII character

```python run viz=array:arr
from typing import List

class Solution:
    def flip_characters(self, arr: List[str]) -> None:
        # Your code goes here — reverse arr in place with two pointers.
        pass

# Reads the test case's arr, e.g. [a, e, i, o, u]
inner = input().strip()[1:-1].strip()
arr = [t.strip() for t in inner.split(",")] if inner else []
Solution().flip_characters(arr)
print("[" + ", ".join(arr) + "]")
```

```java run viz=array:arr
import java.util.*;

public class Main {
    static class Solution {
        void flipCharacters(char[] arr) {
            // Your code goes here — reverse arr in place with two pointers.
        }
    }

    public static void main(String[] args) {
        char[] arr = parseCharArray(new Scanner(System.in).nextLine());
        new Solution().flipCharacters(arr);
        System.out.println(Arrays.toString(arr));
    }

    // "[a, e, i]" → {'a', 'e', 'i'} — reads the test case's arr
    static char[] parseCharArray(String line) {
        String inner = line.trim().replaceAll("^\\[|\\]$", "").trim();
        if (inner.isEmpty()) return new char[0];
        String[] parts = inner.split(",");
        char[] out = new char[parts.length];
        for (int i = 0; i < parts.length; i++) out[i] = parts[i].trim().charAt(0);
        return out;
    }
}
```
