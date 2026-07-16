---
title: "Sum Of First Last Element In Array"
summary: "Return the sum of the first and last element of an array — index arithmetic and the empty-array edge case."
essential: true
kind: problem
difficulty: easy
topics: [basics, arrays]
---

# Sum Of First Last Element In Array

Given an integer array nums, return the sum of the 1st and last element of the array.

## Example 1

**Input:** nums = [2, 3, 4, 5, 6]

**Output:** 8

**Explanation:** 1st element = 2, last element = 6, sum = 2 + 6 = 8.

## Example 2

**Input:** nums = [2]

**Output:** 4

**Explanation:** 1st element = last element = 2, sum = 2 + 2 = 4.

## Example 3

**Input:** nums = [-1, 2, 4, 1]

**Output:** 0

## Constraints

- `1 <= Number of elements in nums <= 100`
- `-100 <= nums[i] <= 100`

```python run
from typing import List

class Solution:
    # Function to return the sum of
    # the 1st and last element of the array
    def sumOfFirstAndLast(self, nums: List[int]) -> int:
        # Your code goes here — return nums[0] + nums[-1] (0 if nums is empty).
        pass


# Reads the test case's nums, e.g. [2, 3, 4, 5, 6]
inner = input().strip()[1:-1].strip()
nums = [int(t.strip()) for t in inner.split(",")] if inner else []
print(Solution().sumOfFirstAndLast(nums))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to return the sum of
        // the 1st and last element of the array
        int sumOfFirstAndLast(int[] nums) {
            // Your code goes here — return nums[0] + nums[nums.length - 1] (0 if nums is empty).
            return 0;
        }
    }

    public static void main(String[] args) {
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().sumOfFirstAndLast(nums));
    }

    // "[2, 3, 4]" → {2, 3, 4} — reads the test case's nums
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

```testcases
{
  "args": [
    { "id": "nums", "label": "nums", "type": "int[]", "placeholder": "[2, 3, 4, 5, 6]" }
  ],
  "cases": [
    { "args": { "nums": "[2, 3, 4, 5, 6]" }, "expected": "8" },
    { "args": { "nums": "[2]" }, "expected": "4" },
    { "args": { "nums": "[-1, 2, 4, 1]" }, "expected": "0" },
    { "args": { "nums": "[-100, -100]" }, "expected": "-200" }
  ]
}
```
