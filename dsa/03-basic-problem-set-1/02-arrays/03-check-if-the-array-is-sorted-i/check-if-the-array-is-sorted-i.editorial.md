## Brute

### Intuition

The simplest method to verify if an array is sorted involves comparing each element with its subsequent neighbor. If any element is found to be greater than the one that follows it, the array is determined to be unsorted.

### Approach

1. Start by focusing on the element at the first index. Compare this element with every subsequent element in the array.
2. If this element is greater than any of the following elements, the array is not sorted.
3. If the element is smaller than or equal to all subsequent elements, proceed to the next element.
4. Continue this process for every element in the array. If all the elements are in proper order, the array can be said sorted.

### Edge Case

If the array has zero or one element (N = 0 or N = 1), it's sorted. Return True.

### Solution

```python solution time=O(N²) space=O(1)
class Solution:
    def arraySortedOrNot(self, arr, n):
        # Iterate through each element
        for i in range(n - 1):
            # Compare with every subsequent element
            for j in range(i + 1, n):
                # If any element is out of order, return False
                if arr[i] > arr[j]:
                    return False
        # All elements are in order
        return True


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []

# Creating an instance of solution class
solution = Solution()
n = len(arr)

# Function call to check if the array is sorted
result = solution.arraySortedOrNot(arr, n)
print("true" if result else "false")
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        public boolean arraySortedOrNot(int[] arr, int n) {
            // Iterate through each element
            for (int i = 0; i < arr.length - 1; i++) {

                // Compare with every subsequent element
                for (int j = i + 1; j < arr.length; j++) {

                    // If any element is out of order, return false
                    if (arr[i] > arr[j]) {
                        return false;
                    }
                }
            }
            return true; // All elements are in order
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());

        // Creating an instance of solution class
        Solution solution = new Solution();
        int n = arr.length;

        // Function call to check if the array is sorted
        boolean result = solution.arraySortedOrNot(arr, n);
        System.out.println(result ? "true" : "false");
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

### Complexity Analysis

**Time Complexity:** O(N²)
Compare each element with all the elements that come after it. This involves a nested loop: the outer loop runs N times (traversing every single element of the array with N elements) and the inner the loop runs up to N-1 times.

**Space Complexity:** O(1)
A constant amount of extra space is used because no additional data structures is needed.

## Optimal

### Intuition

A more efficient approach to verify if an array is sorted leverages a single pass through the array. By comparing each element directly with the next one, it's possible to immediately detect any deviation from the desired order. This method minimizes unnecessary comparisons and quickly identifies whether the array is sorted, as encountering just one instance where an element is greater than the next confirms that the array is not sorted. This approach is both time-efficient and straightforward.

### Approach

1. Start from the first element. Compare each element with the next element in the array.
2. If at any point the current element is greater than the next element, return False (the array is not sorted).
3. If all comparisons are valid (the current element is less than or equal to the next element), continue to the next pair. If the end of the array is reached without finding any out-of-order elements, return True.

### Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to check if an array is sorted
    def arraySortedOrNot(self, arr, n):
        # Iterate through the array
        for i in range(n - 1):

            # Compare each element with the next one
            if arr[i] > arr[i + 1]:

                # If any element is greater than the next one,
                # the array is not sorted
                return False

        # If no such pair is found, array is sorted
        return True


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []

# Creating an instance of solution class
solution = Solution()
n = len(arr)

# Function call to check if the array is sorted
result = solution.arraySortedOrNot(arr, n)
print("true" if result else "false")
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to check if an array is sorted
        public boolean arraySortedOrNot(int[] arr, int n) {
            // Iterate through the array
            for (int i = 0; i < n - 1; i++) {

                // Compare each element with the next one
                if (arr[i] > arr[i + 1]) {

                    /* If any element is greater than the next
                    one, the array is not sorted */
                    return false;
                }
            }
            return true; // If no such pair is found, array is sorted
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());

        // Creating an instance of solution class
        Solution solution = new Solution();
        int n = arr.length;

        // Function call to check if the array is sorted
        boolean result = solution.arraySortedOrNot(arr, n);
        System.out.println(result ? "true" : "false");
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

### Complexity Analysis

**Time Complexity:** O(N)
Perform a single traversal through the array, making a constant-time comparison for each element.

**Space Complexity:** O(1)
A constant amount of extra space for variables is used, independent of the input size.
