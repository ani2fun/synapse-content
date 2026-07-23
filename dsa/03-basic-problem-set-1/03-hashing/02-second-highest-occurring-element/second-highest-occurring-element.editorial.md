## Brute

### Intuition

Imagine you have a bag full of marbles, each with a different number. Your task is to find the marble that appears the second most number of times in the bag. To solve this, we need to keep track of the number of times each marble appears. We should identify the marble with the highest occurrence first and then look for the marble that comes next in terms of frequency. This way, we ensure that we correctly find the second highest occurring marble in the bag.

### Approach

1. Create variables to store the highest and second highest frequencies. Also, create variables to store the corresponding elements. Use a visited array of boolean type to mark elements that have already been counted to avoid recounting them.
2. Loop through each element in the array. For each element, if it hasn't been counted yet, proceed to count its occurrences. For each element, count how many times it appears in the array. Mark these elements as counted.
3. Compare the frequency of the current element with the highest and second highest frequencies. Update the highest and second highest frequencies and their corresponding elements as needed.
4. If two elements have the same frequency, choose the smaller one. After processing all elements, return the element with the second highest frequency.

### Solution

```python solution time=O(N²) space=O(N)
class Solution:
    """Function to get the second highest
    occurring element in array"""
    def secondMostFrequentElement(self, nums):

        # Variable to store the size of array
        n = len(nums)

        """Variable to store maximum frequency
        and second Max frequency"""
        maxFreq = 0
        secMaxFreq = 0

        """Variable to store elements with most
        and second most frequency"""
        maxEle = -1
        secEle = -1

        # Visited array
        visited = [False] * n

        # First loop
        for i in range(n):
            # Skip second loop if already visited
            if visited[i]:
                continue

            """Variable to store frequency
            of current element"""
            freq = 0

            # Second loop
            for j in range(i, n):
                if nums[i] == nums[j]:
                    freq += 1
                    visited[j] = True

            """Update variables if new element
            having highest frequency or second
            highest frequency is found"""
            if freq > maxFreq:
                secMaxFreq = maxFreq
                maxFreq = freq
                secEle = maxEle
                maxEle = nums[i]
            elif freq == maxFreq:
                maxEle = min(maxEle, nums[i])
            elif freq > secMaxFreq:
                secMaxFreq = freq
                secEle = nums[i]
            elif freq == secMaxFreq:
                secEle = min(secEle, nums[i])

        # Return the result
        return secEle


# Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []

"""Creating an instance of
Solution class"""
sol = Solution()

"""Function call to get the second
highest occurring element in array"""
ans = sol.secondMostFrequentElement(nums)

print(ans)
```

```java solution time=O(N²) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to get the second highest
        occurring element in array */
        int secondMostFrequentElement(int[] nums) {

            // Variable to store the size of array
            int n = nums.length;

            /* Variable to store maximum frequency
            and second Max frequency */
            int maxFreq = 0;
            int secMaxFreq = 0;

            /* Variable to store elements with most
            and second most frequency */
            int maxEle = -1, secEle = -1;

            // Visited array
            boolean[] visited = new boolean[n];

            // First loop
            for(int i = 0; i < n; i++) {
                // Skip second loop if already visited
                if(visited[i]) continue;

                /* Variable to store frequency
                of current element */
                int freq = 0;

                // Second loop
                for(int j = i; j < n; j++) {
                    if(nums[i] == nums[j]) {
                        freq++;
                        visited[j] = true;
                    }
                }

                /* Update variables if new element
                having highest frequency or second
                highest frequency is found */
                if(freq > maxFreq) {
                    secMaxFreq = maxFreq;
                    maxFreq = freq;
                    secEle = maxEle;
                    maxEle = nums[i];
                }
                else if(freq == maxFreq) {
                    maxEle = Math.min(maxEle, nums[i]);
                }
                else if(freq > secMaxFreq) {
                    secMaxFreq = freq;
                    secEle = nums[i];
                }
                else if(freq == secMaxFreq) {
                    secEle = Math.min(secEle, nums[i]);
                }

            }

            // Return the result
            return secEle;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to get the second
        highest occurring element in array */
        int ans = sol.secondMostFrequentElement(nums);

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
   -   Key will denote the element in the array.
   -   Value will store the frequency of the element in the array.

### Approach

To solve this problem, follow these steps:

1. Initialize variables to keep track of the highest and second-highest frequencies, as well as the corresponding elements.
2. Create a hashmap to store the frequency of each element in the array.
3. Iterate through the array and update the frequency of each element in the hashmap.
4. Iterate through the hashmap to determine the element with the highest frequency and the element with the second highest frequency.
5. Return the element with the second highest frequency as the result.

### Solution

```python solution time=O(N) space=O(N)
from collections import defaultdict

class Solution:
    # Function to get the second highest
    # occurring element in array
    def secondMostFrequentElement(self, nums):

        # Variable to store the size of array
        n = len(nums)

        # Variable to store maximum frequency
        # and second maximum frequency
        maxFreq = 0
        secMaxFreq = 0

        # Variable to store element
        # with maximum frequency and second
        # highest frequency
        maxEle = -1
        secEle = -1

        # HashMap
        mpp = defaultdict(int)

        # Iterating on the array
        for num in nums:
            # Updating hashmap
            mpp[num] += 1

        # Iterate on the map
        for ele, freq in mpp.items():
            # Update variables if new element
            # having highest frequency or second
            # highest frequency is found
            if freq > maxFreq:
                secMaxFreq = maxFreq
                maxFreq = freq
                secEle = maxEle
                maxEle = ele
            elif freq == maxFreq:
                maxEle = min(maxEle, ele)
            elif freq > secMaxFreq:
                secMaxFreq = freq
                secEle = ele
            elif freq == secMaxFreq:
                secEle = min(secEle, ele)

        # Return the result
        return secEle


# Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
inner = input().strip()[1:-1].strip()
nums = [int(t) for t in inner.split(",")] if inner else []

# Creating an instance of
# Solution class
sol = Solution()

# Function call to get the second
# highest occurring element in array
ans = sol.secondMostFrequentElement(nums)

print(ans)
```

```java solution time=O(N) space=O(N)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to get the second highest
        occurring element in array */
        int secondMostFrequentElement(int[] nums) {

            // Variable to store the size of array
            int n = nums.length;

            /* Variable to store maximum frequency
            and second maximum frequency */
            int maxFreq = 0, secMaxFreq = 0;

            /* Variable to store element
            with maximum frequency and second
            highest frequency */
            int maxEle = -1, secEle = -1;

            // HashMap
            HashMap<Integer, Integer> mpp = new HashMap<>();

            // Iterating on the array
            for (int i = 0; i < n; i++) {
                // Updating hashmap
                mpp.put(nums[i], mpp.getOrDefault(nums[i], 0) + 1);
            }

            // Iterate on the map
            for(Map.Entry<Integer, Integer> it : mpp.entrySet()) {
                int ele = it.getKey(); // Key
                int freq = it.getValue(); // Value

                /* Update variables if new element
                having highest frequency or second
                highest frequency is found */
                if(freq > maxFreq) {
                    secMaxFreq = maxFreq;
                    maxFreq = freq;
                    secEle = maxEle;
                    maxEle = ele;
                }
                else if(freq == maxFreq) {
                    maxEle = Math.min(maxEle, ele);
                }
                else if(freq > secMaxFreq) {
                    secMaxFreq = freq;
                    secEle = ele;
                }
                else if(freq == secMaxFreq) {
                    secEle = Math.min(secEle, ele);
                }
            }

            // Return the result
            return secEle;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's arr, e.g. [1, 2, 2, 3, 3, 3]
        int[] nums = parseIntArray(new Scanner(System.in).nextLine());

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to get the second
        highest occurring element in array */
        int ans = sol.secondMostFrequentElement(nums);

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

   - Using a single loop, performing insertion, and updation operations on HashMap takes O(1) TC resulting in O(N) TC.
   - Iterating on HashMap will take O(N) in the worst-case

**Space Complexity:** O(N) – In the worst-case scenario, the HashMap will store all the elements in the array when array elements are unique.
