---
title: "Sum Of Array Elements"
summary: "Return the sum of all elements in an array."
essential: true
kind: problem
difficulty: easy
topics: [arrays, loops]
---

# Sum Of Array Elements

Given an array arr of size n, the task is to find the sum of all the elements in the array.

## Example 1

**Input:** n=5, arr = [1,2,3,4,5]

**Output:**

```text
15
```

**Explanation:** Sum of all the elements is 1+2+3+4+5 = 15

## Example 2

**Input:** n=6, arr = [1,2,1,1,5,1]

**Output:**

```text
11
```

**Explanation:** Sum of all the elements is 1+2+1+1+5+1 = 11

## Constraints

- `1 <= n <= 10⁵`
- `1 <= arr[i] <= 10⁴`

```python run
from typing import List

class Solution:
    # Function to get the sum of array elements
    def sum(self, arr: List[int], n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
print(Solution().sum(arr, len(arr)))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to get the sum of array elements
        int sum(int[] arr, int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().sum(arr, arr.length));
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
