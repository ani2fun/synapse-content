## Brute

### Intuition

Given a number, all its proper divisors (divisors that divide the number without leaving any remainder, excluding the number itself) can be found and summed up. Then, the sum can be compared with the number itself. If the sum is the same as the number, then it is a perfect number, otherwise, it is not.

### Approach

1. Initialize a variable with 0 to store the sum of the proper divisors.
2. Start iterating from 1 to the given number(excluding) using a loop variable, and check whether the number is divisible completely (leaving the remainder zero) by the loop variable.
3. If it is divisible completely, the current value of the loop variable is a proper divisor which is added to the sum storing sum of proper divisors.
4. After the sum is calculated, compare it with the given number. If found equal, the given number is perfect, otherwise, it is not.

### Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to find whether the
    # number is perfect or not
    def isPerfect(self, n):
        
        # Variable to store the sum
        # of all proper divisors
        sum = 0
        
        # Loop from 1 to n
        for i in range(1, n):
            
            # Check if i is a proper divisor
            if n % i == 0:
                # Update sum
                sum = sum + i
        
        # Compare sum and n
        return sum == n


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to find whether the given number is perfect or not
ans = sol.isPerfect(n)

print("true" if ans else "false")
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find whether the
        number is perfect or not */
        public boolean isPerfect(int n) {
            
            /* Variable to store the sum
            of all proper divisors */
            int sum = 0;
            
            // Loop from 1 to n
            for(int i = 1; i < n; ++i) {
                
                // Check if i is a proper divisor
                if(n % i == 0){
                    // Update sum
                    sum = sum + i;
                }
            }
            
            // Compare sum and n
            if(sum == n) return true;
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        
        /* Creating an instance of 
        Solution class */
        Solution sol = new Solution(); 
        
        /* Function call to find whether the
         given number is perfect or not */
        boolean ans = sol.isPerfect(n);
        
        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(N) – Running a loop from 1 to N.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space, regardless of the size of input.

## Optimal

### Intuition

The previous approach can be optimized by using the property that for any non-negative integer n, if d is a divisor of n then n/d is also a divisor (counterpart divisor) of n. This property is symmetric about the square root of n. By traversing just the first half, the redundant iterations and computations can be avoided improving the efficiency of the algorithm.

### Approach

1. Initialize a variable with 0 to store the sum of the proper divisors.
2. Start iterating from 1 to square root of the given number using a loop variable, and check whether the number is divisible completely (leaving the remainder zero) by the loop variable.
3. If it is divisible completely, the current value of the loop variable is a proper divisor which is added to the sum storing sum of proper divisors. Also, using the property discussed above, another proper divisor can be found.
4. Note: Before adding the counterpart divisor, it should be checked if both the proper divisors are different and the counterpart divisor is not the number itself. If they are different and the counterpart divisor is not the number itself, the counterpart divisor should be added to the sum. Otherwise, the counterpart divisor should not be added to the sum ensuring that the divisor is not added twice.
5. After the sum is calculated, compare it with the given number. If found equal, the given number is perfect, otherwise, it is not.

### Edge Case

When the given number is 1, there are no proper divisors of 1, i.e., the sum of proper divisors of the number is 0. Hence, 1 is not a perfect number.

### Solution

```python solution time=O(sqrt(N)) space=O(1)
import math

class Solution:
    # Function to find whether the 
    # number is perfect or not
    def isPerfect(self, n):
        # Edge case
        if n == 1: 
            return False
        # Variable to store the sum of all proper divisors
        sum = 0
        
        # Loop from 1 to square root of n
        for i in range(1, int(math.sqrt(n)) + 1):
            
            # Check if i is a proper divisor
            if n % i == 0:
                # Update sum
                sum = sum + i
                
                # Add the counterpart divisor if it's 
                # different from i and if it is not n itself
                if n // i != n and i != n // i:
                    sum = sum + (n // i)
        
        # Compare sum and n
        if sum == n:
            return True
        return False


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to find whether the given number is perfect or not
ans = sol.isPerfect(n)

print("true" if ans else "false")
```

```java solution time=O(sqrt(N)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find whether the
        number is perfect or not */
        public boolean isPerfect(int n) {
            // Edge case
            if(n == 1) return false;
            
            /* Variable to store the sum
            of all proper divisors */
            int sum = 0;
            
            // Loop from 1 to square root of n
            for (int i = 1; i <= Math.sqrt(n); ++i) {
                
                // Check if i is a proper divisor
                if (n % i == 0) {
                    // Update sum
                    sum = sum + i;
                    
                    /* Add the counterpart divisor
                    if it's different from i and
                    if it is not n itself */
                    if (n / i != n && i != n / i) {
                        sum = sum + (n / i);
                    }
                }
            }
            
            // Compare sum and n
            if (sum == n) return true;
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        
        // Creating an instance of Solution class
        Solution sol = new Solution();
        
        boolean ans = sol.isPerfect(n);
        
        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(sqrt(N)) – Running a loop from 1 to square root of N.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space, regardless of the size of input.
