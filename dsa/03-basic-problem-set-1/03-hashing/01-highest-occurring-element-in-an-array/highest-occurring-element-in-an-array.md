---
title: "Highest Occurring Element In An Array"
summary: "Find the most frequent element in an array, breaking ties by the smallest value."
essential: true
kind: problem
difficulty: easy
topics: [hashing, arrays]
---

# Highest Occurring Element In An Array

Given an array nums of n integers, find the most frequent element in it i.e., the element that occurs the maximum number of times. If there are multiple elements that appear a maximum number of times, find the smallest of them.

## Example 1

**Input:** nums = [1, 2, 2, 3, 3, 3]

**Output:**

```text
3
```

**Explanation:** The number 3 appears the most (3 times). It is the most frequent element.

## Example 2

**Input:** nums = [4, 4, 5, 5, 6]

**Output:**

```text
4
```

**Explanation:** Both 4 and 5 appear twice, but 4 is smaller. So, 4 is the most frequent element.

## Example 3

**Input:** nums = [2, 4, 3, 2, 5, 4]

**Output:**

```text
2
```

## Constraints

- `1 <= n <= 10⁵`
- `1 <= nums[i] <= 10⁴`

```python run
from typing import List

class Solution:
    # Function to get the highest occurring element in array nums
    def mostFrequentElement(self, nums: List[int]) -> int:
        # Your code goes here.
        pass


# Reads the test case's nums, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []
print(Solution().mostFrequentElement(nums))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to get the highest occurring element in array nums
        int mostFrequentElement(int[] nums) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's nums, e.g. [1, 2, 2, 3, 3, 3]
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().mostFrequentElement(nums));
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
