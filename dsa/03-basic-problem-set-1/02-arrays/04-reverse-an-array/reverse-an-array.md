---
title: "Reverse An Array"
summary: "Reverse an array in place using an auxiliary array or the two-pointer swap technique."
essential: true
kind: problem
difficulty: easy
topics: [arrays, two-pointers]
---

# Reverse An Array

Given an array arr of n elements. The task is to reverse the given array. The reversal of array should be inplace.

## Example 1

**Input:** n=5, arr = [1,2,3,4,5]

**Output:**

```text
[5, 4, 3, 2, 1]
```

**Explanation:** The reverse of the array [1,2,3,4,5] is [5,4,3,2,1]

## Example 2

**Input:** n=6, arr = [1,2,1,1,5,1]

**Output:**

```text
[1, 5, 1, 1, 2, 1]
```

**Explanation:** The reverse of the array [1,2,1,1,5,1] is [1,5,1,1,2,1].

## Example 3

**Input:** n=3, arr = [1,2,1]

**Output:**

```text
[1, 2, 1]
```

## Constraints

- `1 <= n <= 10⁴`
- `1 <= arr[i] <= 10⁵`

```python run
from typing import List

class Solution:
    # Function to reverse the given array in place
    def reverse(self, arr: List[int], n: int) -> None:
        # Your code goes here.
        pass


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
Solution().reverse(arr, len(arr))
print("[" + ", ".join(str(x) for x in arr) + "]")
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to reverse the given array in place
        void reverse(int[] arr, int n) {
            // Your code goes here.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        new Solution().reverse(arr, arr.length);
        System.out.println(Arrays.toString(arr));
    }

    // "[1, 2, 3]" -> {1, 2, 3}
    static int[] parseIntArray(String line) {
        String inner = line.trim().replaceAll("^\\[|\\]$", "").trim();
        if (inner.isEmpty()) return new int[0];
        String[] parts = inner.split(",");
        int[] out = new int[parts.length];
        for (int i = 0; i < parts.length; i++) out[i] = Integer.parseInt(parts[i].trim());
        return out;
    }
}
```
