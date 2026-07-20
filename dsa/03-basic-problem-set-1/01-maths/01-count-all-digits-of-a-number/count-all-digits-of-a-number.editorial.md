## Brute

### Intuition

Given a number, all the digits in the number can be counted by counting one by one every digit which can be done by extracting the last digit successively from the right until there are no more digits left to extract.

### Approach

1. Initialise a counter to keep the count of digits in the number.
2. Keep dividing the number by 10 until no more digits are left to extract.
3. For every digit extracted from the number, increment the counter by 1.
4. Once the iterations are over, the number of digits is stored in the counter.

### Edge Case

What if the given number is zero? Return 1, because the number of digits in zero is 1.

### Solution

```python solution time=O(log₁₀(N)) space=O(1)
class Solution:
    # Function to count all digits in n
    def countDigit(self, n: int) -> int:
        # Edge case
        if n == 0:
            return 1

        # Set counter to 0
        cnt = 0

        # Iterate until n is greater than zero
        while n > 0:
            # Increment count of digits
            cnt = cnt + 1
            n = n // 10

        return cnt


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to get count of digits in n
ans = sol.countDigit(n)
print(ans)
```

```java solution time=O(log₁₀(N)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to count all digits in n
        public int countDigit(int n) {
            // Edge case
            if (n == 0) return 1;

            // Set counter to 0
            int cnt = 0;

            // Iterate until n is greater than zero
            while (n > 0) {
                // Increment count of digits
                cnt = cnt + 1;
                n = n / 10;
            }

            return cnt;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        // Function call to get count of digits in n
        int ans = sol.countDigit(n);
        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(log₁₀(N)) – In every iteration we are dividing N by 10.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.

## Optimal

### Intuition

Given a number, the number of digits can be found directly from the logarithm (base 10) of the number.

### Approach

1. Instead of iterating on the number for every digit, the count of digits in the number can be found using the following mathematical formula: count = log10(N) + 1.

### Edge Case

What if the given number is zero? Return 1, because the number of digits in zero is 1.

### Solution

```python solution time=O(1) space=O(1)
import math

class Solution:
    # Function to count the
    # number of digits in N
    def countDigit(self, n: int) -> int:
        # Edge case
        if n == 0:
            return 1

        count = int(math.log10(n) + 1)
        return count


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to get count of digits in n
ans = sol.countDigit(n)
print(ans)
```

```java solution time=O(1) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to count the
        number of digits in N */
        public int countDigit(int n) {
            // Edge case
            if (n == 0) return 1;

            int count = (int)(Math.log10(n) + 1);
            return count;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        // Function call to get count of digits in n
        int ans = sol.countDigit(n);
        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(1) – Constant time taking statements were used.

**Space Complexity:** O(1) – Because only a couple of variables were used.
