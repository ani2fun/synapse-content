---
title: "Check If The Array Is Sorted I"
summary: "Check whether an array is sorted in non-decreasing order with a single linear pass."
essential: true
kind: problem
difficulty: easy
topics: [arrays, loops]
---

# Check If The Array Is Sorted I

Given an array arr of size n, the task is to check if the given array is sorted in (ascending / Increasing / Non-decreasing) order. If the array is sorted then return True, else return False.

## Example 1

**Input:** n = 5, arr = [1,2,3,4,5]

**Output:**

```text
true
```

**Explanation:** The given array is sorted i.e Every element in the array is smaller than or equals to its next values, So the answer is True.

## Example 2

**Input:** n = 5, arr = [5,4,6,7,8]

**Output:**

```text
false
```

**Explanation:** The given array is Not sorted i.e Every element in the array is not smaller than or equal to its next values, So the answer is False. Here element 5 is not smaller than or equal to its future elements.

## Example 3

**Input:** n = 5, arr = [5,4,3,2,1]

**Output:**

```text
false
```

## Constraints

- `1 ≤ n ≤ 10⁶`
- `-10⁹ ≤ arr[i] ≤ 10⁹`

```python run
from typing import List

class Solution:
    # Function to check if an array is sorted
    def arraySortedOrNot(self, arr: List[int], n: int) -> bool:
        # Your code goes here.
        pass


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
result = Solution().arraySortedOrNot(arr, len(arr))
print("true" if result else "false")
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to check if an array is sorted
        boolean arraySortedOrNot(int[] arr, int n) {
            // Your code goes here.
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().arraySortedOrNot(arr, arr.length));
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
