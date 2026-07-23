---
title: "Count Of Odd Numbers In Array"
summary: "Return the count of odd numbers in an array."
essential: true
kind: problem
difficulty: easy
topics: [arrays, loops]
---

# Count Of Odd Numbers In Array

Given an array of n elements. The task is to return the count of the number of odd numbers in the array.

## Example 1

**Input:** n=5, array = [1,2,3,4,5]

**Output:**

```text
3
```

**Explanation:** The three odd elements are (1,3,5).

## Example 2

**Input:** n=6, array = [1,2,1,1,5,1]

**Output:**

```text
5
```

**Explanation:** The five odd elements are one 5 and four 1's.

## Example 3

**Input:** n=5, array = [1,3,5,7,9]

**Output:**

```text
5
```

## Constraints

- `1 <= n <= 10⁵`
- `1 <= arr[i] <= 10⁴`

```python run
from typing import List

class Solution:
    # Function to count the odd numbers in an array
    def countOdd(self, arr: List[int], n: int) -> int:
        # Your code goes here.
        pass


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
print(Solution().countOdd(arr, len(arr)))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to count the odd numbers in an array
        int countOdd(int[] arr, int n) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().countOdd(arr, arr.length));
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
