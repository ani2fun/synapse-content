---
title: "Second Highest Occurring Element"
summary: "Find the second most frequent element in an array, breaking frequency ties by the smallest value."
essential: true
kind: problem
difficulty: easy
topics: [hashing, arrays]
---

# Second Highest Occurring Element

Given an array of n integers, find the second most frequent element in it.
If there are multiple elements that appear second most frequent times, find the smallest of them.
If second most frequent element does not exist return -1.

## Example 1

**Input:** arr = [1, 2, 2, 3, 3, 3]

**Output:**

```text
2
```

**Explanation:** The number 2 appears the second most (2 times) and number 3 appears the most (3 times).

## Example 2

**Input:** arr = [4, 4, 5, 5, 6, 7]

**Output:**

```text
6
```

**Explanation:** Both 6 and 7 appear second most times, but 6 is smaller.

## Example 3

**Input:** arr = [10, 9, 7, 7]

**Output:**

```text
9
```

## Constraints

- `1 <= n <= 10⁵`
- `1 <= arr[i] <= 10⁴`

```python run
from typing import List

class Solution:
    # Function to get the second highest occurring element in array
    def secondMostFrequentElement(self, nums: List[int]) -> int:
        # Your code goes here.
        pass


# Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
print(Solution().secondMostFrequentElement(arr))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to get the second highest occurring element in array
        int secondMostFrequentElement(int[] nums) {
            // Your code goes here.
            return -1;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().secondMostFrequentElement(arr));
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
