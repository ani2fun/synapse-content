## Brute

### Intuition

A prime number is defined as a number that is divisible only by 1 and itself. To determine whether a given number is prime, one can check if it is divisible by any integer between 2 and the number minus one. If it is divisible by any such number, then it is not a prime number.

### Approach

1. Check if the given number is less than 2; if yes, return false (not prime).
2. Loop through all numbers from 2 to one less than the given number.
3. For each number in the loop, check if it divides the given number exactly.
4. If a divisor is found, return false (not prime).
5. If no divisor is found after the loop, return true (the number is prime).

### Edge Case

The prime numbers start from 2. Thus, if a number is less than 2, it can be directly said as non-prime.

### Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to find whether the
    # number is prime or not
    def isPrime(self, n):
        # Edge case
        if n < 2:
            return False

        # Loop from 2 to n-1
        for i in range(2, n):

            # Check if i is a divisor
            if n % i == 0:
                return False

        # Return true as the number is prime
        return True


# Reads the test case's n
n = int(input())

# Creating an instance of
# Solution class
sol = Solution()

# Function call to find whether the
# given number is prime or not
ans = sol.isPrime(n)

print("true" if ans else "false")
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {

        /* Function to find whether the
        number is prime or not */
        boolean isPrime(int n) {
            // Edge case
            if (n < 2) return false;

            // Loop from 2 to n-1
            for (int i = 2; i < n; ++i) {

                // Check if i is a divisor
                if (n % i == 0) {
                    return false;
                }
            }

            // Return true as the number is prime
            return true;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to find whether the
        given number is prime or not */
        boolean ans = sol.isPrime(n);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(N) – Looping N times to find the count of all divisors of N.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.

## Optimal

### Intuition

The algorithm can be optimized by only iterating up to the square root of n when checking for divisors. This is because if n has a divisor i, then another divisor (counterpart divisor) for n is (n/i).

### Approach

1. Check if the given number is less than 2; if yes, return false (not prime).
2. Loop from 2 to the square root of the number.
3. For each value in the loop, check if it divides the number exactly.
4. If a divisor is found, return false (not prime).
5. If no divisor is found after the loop, return true (the number is prime).

### Edge Case

The prime numbers start from 2. Thus, if a number is less than 2, it can be directly said as non-prime.

### Solution

```python solution time=O(sqrt(N)) space=O(1)
class Solution:
    # Function to find whether the
    # number is prime or not
    def isPrime(self, n):
        # Edge case
        if n < 2:
            return False

        # Loop from 2 to √n
        i = 2
        while i * i <= n:
            # Check if i is a divisor
            if n % i == 0:
                return False
            i += 1

        # Return true as the number is prime
        return True


# Reads the test case's n
n = int(input())

# Creating an instance of
# Solution class
sol = Solution()

# Function call to find whether the
# given number is prime or not
ans = sol.isPrime(n)

print("true" if ans else "false")
```

```java solution time=O(sqrt(N)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {

        /* Function to find whether the
        number is prime or not */
        boolean isPrime(int n) {
            // Edge case
            if (n < 2) return false;

            // Loop from 2 to √n
            for (int i = 2; i * i <= n; ++i) {

                // Check if i is a divisor
                if (n % i == 0) {
                    return false;
                }
            }

            // Return true as the number is prime
            return true;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to find whether the
        given number is prime or not */
        boolean ans = sol.isPrime(n);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(sqrt(N)) – Looping sqrt(N) times to find the count of all divisors of N.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.
