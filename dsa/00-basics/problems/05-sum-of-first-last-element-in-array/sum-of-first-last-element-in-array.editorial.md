## Intuition

The first and last elements of an array sit at fixed positions — index 0 and index length − 1 — no matter how many elements lie between them, so the answer is just two index reads and an addition, guarded against the empty-array case.

## Approach

1. **Check Array Length:** Ensure that the array is not empty to avoid accessing elements in an empty array.
2. **Retrieve Elements:**
   - Access the first element of the array.
   - Access the last element of the array.
3. **Compute Sum:** Add the first and last elements.
4. **Return Result:** Return the computed sum.

## Solution

```python solution time=O(1) space=O(1)
class Solution:
    # Function to return the sum of
    # the 1st and last element of the array
    def sumOfFirstAndLast(self, nums):
        # Check if the array is empty
        if not nums:
            return 0 # Return 0

        # Get the first element
        first = nums[0]
        # Get the last element
        last = nums[-1]

        # Return sum of the first and last elements
        return first + last

# Creating an instance of Solution class
sol = Solution()

# Reads the test case's nums, e.g. [2, 3, 4, 5, 6]
inner = input().strip()[1:-1].strip()
nums = [int(t.strip()) for t in inner.split(",")] if inner else []

# Function call to return the sum of
# the 1st and last element of the array
ans = sol.sumOfFirstAndLast(nums)

print(ans)
```

```java solution time=O(1) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to return the sum of
        the 1st and last element of the array */
        public int sumOfFirstAndLast(int[] nums) {
            // Check if the array is empty
            if (nums.length == 0) {
                return 0; // Return 0
            }

            // Get the first element
            int first = nums[0];
            // Get the last element
            int last = nums[nums.length - 1];

            // Return sum of the first and last elements
            return first + last;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's nums, e.g. [2, 3, 4, 5, 6]
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());

        // Creating an instance of Solution class
        Solution sol = new Solution();

        /* Function call to return the sum of
        the 1st and last element of the array */
        int ans = sol.sumOfFirstAndLast(nums);

        System.out.println(ans);
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

## Complexity Analysis

**Time Complexity:** O(1), Accessing elements by index and performing addition are constant-time operations.

**Space Complexity:** O(1), Only a fixed amount of extra space is used (for storing the sum and indices).
