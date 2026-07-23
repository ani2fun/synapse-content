## Intuition

Computing the sum of an array's elements involves adding the elements one by one using a loop. A variable is first initialized to zero and is then updated by adding each element of the array as the loop progresses. Once the loop completes, this variable contains the total sum of all elements in the array.

## Approach

1. Initialize a variable to zero to store the sum.
2. Iterate through the array, adding each element to the sum.
3. Return the sum after the loop completes.

## Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to get the sum of array elements
    def sum(self, arr, n):
        ans = 0  # to store the answer

        # Iterate on all the elements
        for i in range(n):
            # Add the current element to the sum
            ans = ans + arr[i]

        # Return the result
        return ans


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []

# Creating an instance of solution class
sol = Solution()

# Function call to get the sum of array elements
result = sol.sum(arr, len(arr))

# output the result
print(result)
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to get the sum of array elements
        int sum(int arr[], int n) {
            int ans = 0; // to store the answer

            // Iterate on all the elements
            for (int i = 0; i < n; i++) {
                // Add the current element to the sum
                ans = ans + arr[i];
            }

            // Return the result
            return ans;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());

        // Creating an instance of solution class
        Solution sol = new Solution();

        // Function call to get the sum of array elements
        int result = sol.sum(arr, arr.length);

        // output the result
        System.out.println(result);
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

## Complexity Analysis

**Time Complexity:** O(N), because each element in the array is processed exactly once.

**Space Complexity:** O(1), because only couple of variable are used.
