## Intuition

Given a number, its factorial can be found by multiplying all positive integers starting from 1 to the given number.

## Approach

1. Initialize a variable with 1 that will store the factorial of the given number.
2. Start iterating from 1 to the given number, and in every pass multiply the variable with the current number.
3. After the iterations are completed, the variable storing the answer can be returned.

## Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to find the
    # factorial of a number
    def factorial(self, n):
        # Edge Case
        if n == 0:
            return 1
            
        # Variable to store the factorial
        fact = 1

        # Iterate from 1 to n
        for i in range(1, n + 1):
            # Multiply fact with current number
            fact = fact * i
        
        # Return the factorial stored
        return fact


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to find the factorial of n
ans = sol.factorial(n)

print(ans)
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {

        /* Function to find the
        factorial of a number */
        public int factorial(int n) {
            // Edge case
            if(n == 0) return 1;

            // Variable to store the factorial
            int fact = 1;

            // Iterate from 1 to n
            for(int i = 1; i <= n; i++) {
                // Multiply fact with current number
                fact = fact * i;
            }

            // Return the factorial stored
            return fact;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        /* Creating an instance of 
        Solution class */
        Solution sol = new Solution();

        // Function call to find the factorial of n
        int ans = sol.factorial(n);

        System.out.println(ans);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N) – Iterating once from 1 to N.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.
