## Intuition

A simple way to solve this problem is by traversing the whole array and checking each element if it is odd. The count of the odd numbers found will be the answer.

## Approach

1. Initialize a counter to zero to keep track of odd numbers. Initialize a for loop to iterate through each element in the array.
2. For each element, check if it is odd by checking it divisibility by 2 and increment counter if odd.
3. After iterating through all elements, the counter will contain the total count of odd numbers.

## Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to count the odd numbers in an array
    def countOdd(self, arr, n):
        count = 0
        # Iterate through the array
        for num in arr:
        # Check for odd values and increment
            if num % 2 != 0:
                count += 1
        return count

# Main method
if __name__ == "__main__":
    # Creating an instance of Solution class
    sol = Solution()

    # Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
    inner = input().strip()[1:-1].strip()
    arr = [int(t) for t in inner.split(",")] if inner else []
    n = len(arr)

    # Function call to count the odd numbers in an array
    count = sol.countOdd(arr, n)
    print(count)
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to count the odd numbers in an array
        public int countOdd(int[] arr, int n) {
            int count = 0;
            // Iterate through the array
            for (int i = 0; i < n; i++) {
            //  Check for odd values and increment
                if (arr[i] % 2 != 0) {
                    count++;
                }
            }
            return count;
        }
    }

    //Main method
    public static void main(String[] args) {

        // Creating an instance of Solution class
        Solution sol = new Solution();

        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        int n = arr.length;

        // Function call to count the odd numbers in an array
        int count = sol.countOdd(arr, n);
        System.out.println(count);
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

**Time Complexity:** O(N) – Each element in the array has to be inspected once to determine if it's odd, resulting in a linear time complexity where N is the number of elements in the array.

**Space Complexity:** O(1) – The space used is constant, as we only use a single counter regardless of the size of the input array.
