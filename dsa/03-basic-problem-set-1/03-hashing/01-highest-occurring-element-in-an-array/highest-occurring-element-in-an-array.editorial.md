## Brute

### Intuition

A brute-force way to solve this problem will be to use two loops:

- First loop to iterate on the array, selecting an element.
- Second loop to traverse the remaining array to find the occurrences of the selected element in the first loop.

Maintain a visited array to mark the elements to keep track of duplicate elements that were already taken into account.

### Approach

1. Initialize a visited array of type boolean having size n, where n is the size of the array with all elements set to false. Also, declare the following variables :
   - maxFreq - to store the frequency of the highest occurring element.
   - maxEle - to store the highest occurring element in the array.
2. In the first loop, start iterating on the elements of the array selecting one element at a time.
3. In the second loop, iterate on the rest portion of the array and count the frequency (number of occurrences) of the selected element. And every time, the same element is found, mark the corresponding index in the visited array as true.
4. If the frequency of the current element is found greater than maxFreq, update maxFreq and maxEle with the new frequency and new element respectively.
5. If the frequency of the current element is the same as maxFreq, store the smaller of maxEle and the current element in maxEle.
6. Before starting the second loop, check if the element is marked as unvisited. Skip the element if it is visited because its frequency has already been taken into consideration.

### Solution

```python solution time=O(N²) space=O(N)
class Solution:
    # Function to get the highest
    # occurring element in array nums
    def mostFrequentElement(self, nums):

        # Variable to store the size of array
        n = len(nums)

        # Variable to store maximum frequency
        maxFreq = 0

        # Variable to store element
        # with maximum frequency
        maxEle = 0

        # Visited array
        visited = [False] * n

        # First loop
        for i in range(n):
            # Skip second loop if already visited
            if visited[i]:
                continue

            # Variable to store frequency
            # of current element
            freq = 0

            # Second loop
            for j in range(i, n):
                if nums[i] == nums[j]:
                    freq += 1
                    visited[j] = True

            # Update variables if new element having
            # highest frequency is found
            if freq > maxFreq:
                maxFreq = freq
                maxEle = nums[i]
            elif freq == maxFreq:
                maxEle = min(maxEle, nums[i])

        # Return the result
        return maxEle


# Reads the test case's nums, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []
print(Solution().mostFrequentElement(nums))
```

```java solution time=O(N²) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to get the highest
        occurring element in array nums */
        public int mostFrequentElement(int[] nums) {

            // Variable to store the size of array
            int n = nums.length;

            // Variable to store maximum frequency
            int maxFreq = 0;

            /* Variable to store element
            with maximum frequency */
            int maxEle = 0;

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

                /* Update variables if new element having
                highest frequency is found */
                if (freq > maxFreq) {
                    maxFreq = freq;
                    maxEle = nums[i];
                } else if (freq == maxFreq) {
                    maxEle = Math.min(maxEle, nums[i]);
                }
            }

            // Return the result
            return maxEle;
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

### Complexity Analysis

**Time Complexity:** O(N²) (where N is the size of the array given) – Using two nested loops.

**Space Complexity:** O(N) – Using a visited array of size N and a couple of variables.

## Optimal

### Intuition

An optimal approach to solve this question will be to use a Hashmap, a data structure that stores key-value pairs.

1. Key will denote the element in the array.
2. Value will store the frequency of the element in the array.

### Approach

1. Take a HashMap to store the int key-value pairs.
2. Start iterating on the array.
   1. If the current element is not present in the HashMap, insert it with a frequency of 1.
   2. Else, increment the frequency of current element in the HashMap.
3. Once the iterations are over, all the elements with their frequencies will be stored in the HashMap. Iterate on the HashMap to find the element with the highest frequency.

### Solution

```python solution time=O(N) space=O(N)
class Solution:
    # Function to get the highest
    # occurring element in array n
    def mostFrequentElement(self, nums):
        # Variable to store maximum frequency
        maxFreq = 0

        # Variable to store element
        # with maximum frequency
        maxEle = 0

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
        for ele, freq in mpp.items():
            if freq > maxFreq:
                maxFreq = freq
                maxEle = ele
            elif freq == maxFreq:
                maxEle = min(maxEle, ele)

        # Return the result
        return maxEle


# Reads the test case's nums, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []
print(Solution().mostFrequentElement(nums))
```

```java solution time=O(N) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to get the highest
        occurring element in array n */
        public int mostFrequentElement(int[] nums) {

            // Variable to store the size of array
            int n = nums.length;

            // Variable to store maximum frequency
            int maxFreq = 0;

            /* Variable to store element
            with maximum frequency */
            int maxEle = 0;

            // HashMap
            Map<Integer, Integer> mpp = new HashMap<>();

            // Iterating on the array
            for (int i = 0; i < n; i++) {
                // Updating hashmap
                mpp.put(nums[i], mpp.getOrDefault(nums[i], 0) + 1);
            }

            // Iterate on the map
            for (Map.Entry<Integer, Integer> it : mpp.entrySet()) {
                int ele = it.getKey(); // Key
                int freq = it.getValue(); // Value

                if (freq > maxFreq) {
                    maxFreq = freq;
                    maxEle = ele;
                } else if (freq == maxFreq) {
                    maxEle = Math.min(maxEle, ele);
                }
            }

            // Return the result
            return maxEle;
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

### Complexity Analysis

**Time Complexity:** O(N) (where N is the size of the array given) –
1. Using a single loop, performing insertion, updation opertion on HashMap takes O(1) TC resulting in O(N) TC.
2. Iterating on HashMap, will take O(N) in the worst-case

**Space Complexity:** O(N) – In the worst-case scenario, the HashMap will store all the elements in the array when array elements are unique.
