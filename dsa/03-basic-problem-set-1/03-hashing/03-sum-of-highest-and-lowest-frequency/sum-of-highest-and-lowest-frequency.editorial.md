## Brute

### Intuition

The brute force way to solve this problem will be to count the frequency of each element in the array, and once found, this frequency can be compared with the highest and the lowest frequency. Accordingly, the highest and the lowest frequency can be set.

### Approach

Determine the size of the array. Initialize two variables: one to keep track of the highest frequency and another for the lowest frequency.

- Initially, set the highest frequency to zero (to ensure any actual frequency found will be higher and update this value.) and the lowest to the size of the array (to ensure any actual frequency found will be lower and update this value).
- Create a visited array to avoid counting the same number multiple times.

- Loop through each element in the array. For each element:
    - If the element has already been counted (visited), skip it.
    - Otherwise, count how many times this element appears in the array by comparing it with every other element.
    - Update the highest and lowest frequency variables based on the count of the current element.
    - Mark all occurrences of this element as visited.

- Finally, add the highest and lowest frequencies together and return the result.

### Solution

```python solution time=O(N²) space=O(N)
class Solution:
    """ Function to get the sum of highest
    and lowest frequency in array """
    def sumHighestAndLowestFrequency(self, nums):

        # Variable to store the size of array
        n = len(nums)

        """ Variable to store maximum
        and minimum frequency """
        max_freq = 0
        min_freq = n

        # Visited array
        visited = [False] * n

        # First loop
        for i in range(n):
            # Skip second loop if already visited
            if visited[i]:
                continue

            """ Variable to store frequency
            of current element """
            freq = 0

            # Second loop
            for j in range(i, n):
                if nums[i] == nums[j]:
                    freq += 1
                    visited[j] = True

            """ Update maximum and
            minimum frequencies """
            max_freq = max(max_freq, freq)
            min_freq = min(min_freq, freq)

        # Return the required sum
        return max_freq + min_freq


# Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []

""" Creating an instance of
Solution class """
sol = Solution()

""" Function call to get the sum of highest
and lowest frequency in array """
ans = sol.sumHighestAndLowestFrequency(nums)

print(ans)
```

```java solution time=O(N²) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to get the sum of highest
        and lowest frequency in array */
        public int sumHighestAndLowestFrequency(int[] nums) {

            // Variable to store the size of array
            int n = nums.length;

            /* Variable to store maximum
            and minimum frequency */
            int maxFreq = 0;
            int minFreq = n;

            // Visited array
            boolean[] visited = new boolean[n];

            // First loop
            for (int i = 0; i < n; i++) {
                // Skip second loop if already visited
                if (visited[i]) continue;

                /* Variable to store frequency
                of current element */
                int freq = 0;

                // Second loop
                for (int j = i; j < n; j++) {
                    if (nums[i] == nums[j]) {
                        freq++;
                        visited[j] = true;
                    }
                }

                /* Update maximum and
                minimum frequencies */
                maxFreq = Math.max(maxFreq, freq);
                minFreq = Math.min(minFreq, freq);

            }

            // Return the required sum
            return maxFreq + minFreq;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to get the sum of highest
        and lowest frequency in array */
        int ans = sol.sumHighestAndLowestFrequency(nums);

        System.out.println(ans);
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

**Time Complexity:** O(N²) (where N is the size of the array given) – Using two nested loops.

**Space Complexity:** O(N) – Using a visited array of size N and a couple of variables.

## Optimal

### Intuition

An optimal approach to solve this question will be to use a Hashmap, a data structure that stores key-value pairs.

- Key will denote the element in the array.
- Value will store the frequency of the element in the array.

### Approach

- Take a HashMap to store the int key-value pairs.
- Start iterating on the array.
  - If the current element is not present in the HashMap, insert it with a frequency of 1.
  - Else, increment the frequency of current element in the HashMap.

- Once the iterations are over, all the elements with their frequencies will be stored in the HashMap. Iterate on the HashMap to find the highest frequency and the lowest frequency whose sum can be returned as answer.

### Solution

```python solution time=O(N) space=O(N)
class Solution:
    # Function to get the sum of highest
    # and lowest frequency in array
    def sumHighestAndLowestFrequency(self, nums):

        # Variable to store the size of array
        n = len(nums)

        # Variable to store maximum
        # and minimum frequency
        maxFreq = 0
        minFreq = n

        # HashMap
        mpp = {}

        # Iterating on the array
        for num in nums:
            # Updating hashmap
            if num in mpp:
                mpp[num] += 1
            else:
                mpp[num] = 1

        # Iterate on the map
        for freq in mpp.values():
            # Update maximum and
            # minimum frequencies
            maxFreq = max(maxFreq, freq)
            minFreq = min(minFreq, freq)

        # Return the required sum
        return maxFreq + minFreq


# Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []

# Creating an instance of
# Solution class
sol = Solution()

# Function call to get the sum of highest
# and lowest frequency in array
ans = sol.sumHighestAndLowestFrequency(nums)

print(ans)
```

```java solution time=O(N) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to get the sum of highest
        and lowest frequency in array */
        public int sumHighestAndLowestFrequency(int[] nums) {

            // Variable to store the size of array
            int n = nums.length;

            /* Variable to store maximum
            and minimum frequency */
            int maxFreq = 0, minFreq = n;

            // HashMap
            HashMap<Integer, Integer> mpp = new HashMap<>();

            // Iterating on the array
            for (int i = 0; i < n; i++) {
                // Updating hashmap
                mpp.put(nums[i], mpp.getOrDefault(nums[i], 0) + 1);
            }

            // Iterate on the map
            for (int freq : mpp.values()) {
                /* Update maximum and
                minimum frequencies */
                maxFreq = Math.max(maxFreq, freq);
                minFreq = Math.min(minFreq, freq);
            }

            // Return the required sum
            return maxFreq + minFreq;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to get the sum of highest
        and lowest frequency in array */
        int ans = sol.sumHighestAndLowestFrequency(nums);

        System.out.println(ans);
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

**Time Complexity:** O(N) (where N is the size of the array given) –

  - Iterating the array results in O(N) TC. In every iteration, the hashmap is updated, which is a constant time operation. This results in overall O(N) TC.
  - Iterating on HashMap, will take O(N) in the worst-case.

**Space Complexity:** O(N) – In the worst-case scenario, the HashMap will store all the elements in the array when array elements are unique.
