## Brute

### Intuition

To reverse an array, the objective is to reorder the elements such that the last element becomes the first and the second last becomes the second, and so forth. The straightforward approach involves creating a new array of the same size and populating it by iterating through the input array from end to start, thereby storing elements in reverse order.

### Approach

1. Declare a new array having the same size as the input array.
2. Iterate through the input array from the end to the beginning and for each element in the input array, store it in the corresponding position in the new array.
3. After the loop ends, the new array will contain the reversed elements.
4. Copy the elements back to the original array to get the reversed array.

### Solution

```python solution time=O(N) space=O(N)
class Solution:
    # Function to reverse array using an auxiliary array
    def reverse(self, arr, n):
        ans = [0] * n

        # Fill new array with elements of
        # original array in reverse order
        for i in range(n - 1, -1, -1):
            ans[n - i - 1] = arr[i]

        # Copy the elements back to the original array
        for i in range(n):
            arr[i] = ans[i]

        # Return
        return


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
Solution().reverse(arr, len(arr))
print("[" + ", ".join(str(x) for x in arr) + "]")
```

```java solution time=O(N) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        // Function to reverse array using an auxiliary array
        void reverse(int[] arr, int n) {
            int[] ans = new int[n];

            /* Fill new array with elements of
            original array in reverse order */
            for (int i = n - 1; i >= 0; i--) {
                ans[n - i - 1] = arr[i];
            }

            // Copy the elements back to the original array
            for (int i = 0; i < n; i++) {
                arr[i] = ans[i];
            }

            // Return
            return;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        new Solution().reverse(arr, arr.length);
        System.out.println(Arrays.toString(arr));
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

**Time Complexity:** O(N), A single-pass of the array with N elements is being done to reverse the array.

**Space Complexity:** O(N), for the extra array of the same size used.

## Optimal

### Intuition

To reverse an array in place without additional space, employ a swapping technique utilizing two pointers: one starting from the beginning of the array and the other from the end. By exchanging the elements at these pointers and progressively moving them toward the center, the array can be reversed efficiently within the same memory allocation. This method is both space-efficient and effective.

### Approach

1. Initialize a pointer p1 at the first index and another pointer p2 at the last index of the array.
2. Swap the elements pointed by p1 and p2 and increment p1 by 1 while decrementing p2 by 1 simultaneously.
3. Repeat the process for the first n/2 elements, where n is the length of the array.

### Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to reverse array using two pointers
    def reverse(self, arr, n):
        p1 = 0
        p2 = n - 1
        # Swap elements pointed by p1 and
        # p2 until they meet in the middle
        while p1 < p2:
            tmp = arr[p1]
            arr[p1] = arr[p2]
            arr[p2] = tmp
            p1 += 1
            p2 -= 1
        # Return
        return


# Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
inner = input().strip()[1:-1].strip()
arr = [int(t) for t in inner.split(",")] if inner else []
Solution().reverse(arr, len(arr))
print("[" + ", ".join(str(x) for x in arr) + "]")
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to reverse array using two pointers
        void reverse(int[] arr, int n) {
            int p1 = 0, p2 = n - 1;
            /* Swap elements pointed by p1 and
            p2 until they meet in the middle */
            while (p1 < p2) {
                int tmp = arr[p1];
                arr[p1] = arr[p2];
                arr[p2] = tmp;
                p1++;
                p2--;
            }
            // Return
            return;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 3, 4, 5]
        int[] arr = parseIntArray(new Scanner(System.in).nextLine());
        new Solution().reverse(arr, arr.length);
        System.out.println(Arrays.toString(arr));
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

**Time Complexity:** O(N), A single-pass of the array with N elements is being done to reverse the array

**Space Complexity:** O(1), no extra data structure is being used so no extra space.
