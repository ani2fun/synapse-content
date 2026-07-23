---
title: "Sum Of Highest And Lowest Frequency"
summary: "Find the sum of the highest and lowest occurring element frequencies in an array."
essential: true
kind: problem
difficulty: easy
topics: [hashing, arrays]
---

# Sum Of Highest And Lowest Frequency

Given an array of n integers, find the sum of the frequencies of the highest occurring number and lowest occurring number.

## Example 1

**Input:** arr = [1, 2, 2, 3, 3, 3]

**Output:**

```text
4
```

**Explanation:** The highest frequency is 3 (element 3), and the lowest frequency is 1 (element 1). Their sum is 3 + 1 = 4.

## Example 2

**Input:** arr = [4, 4, 5, 5, 6]

**Output:**

```text
3
```

**Explanation:** The highest frequency is 2 (elements 4 and 5), and the lowest frequency is 1 (element 6). Their sum is 2 + 1 = 3.

## Example 3

**Input:** arr = [10, 9, 7, 7, 8, 8, 8]

**Output:**

```text
4
```

## Constraints

- `1 <= n <= 10⁵`
- `1 <= arr[i] <= 10⁴`

```python run
from typing import List

class Solution:
    # Function to get the sum of highest and lowest frequency in array
    def sumHighestAndLowestFrequency(self, nums: List[int]) -> int:
        # Your code goes here.
        pass


# Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
print(Solution().sumHighestAndLowestFrequency(arr))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to get the sum of highest and lowest frequency in array
        int sumHighestAndLowestFrequency(int[] nums) {
            // Your code goes here.
            return 0;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        System.out.println(new Solution().sumHighestAndLowestFrequency(arr));
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
