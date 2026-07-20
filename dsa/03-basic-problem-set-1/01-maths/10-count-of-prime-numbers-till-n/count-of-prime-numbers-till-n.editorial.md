## Brute

### Intuition

A naive approach to count prime numbers till N, is to check every number starting from 1 till N for prime. Keep a counter to store the count. If the number is prime, increment the counter. Once all the numbers are checked, the counter stores the required count.

### Approach

1. Initialize a counter to store the count of prime numbers.
2. Iterate from 2 to n, and check the current value for prime (using the brute way). If found prime, increment the counter by 1.
3. After the iterations are over, the counter stores the required result.

### Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    # Function to find whether the
    # number is prime or not
    def isPrime(self, n):

        # Variable to store the
        # count of divisors of n
        count = 0

        # Loop from 1 to n
        for i in range(1, n + 1):

            # Check if i is a divisor
            if n % i == 0:
                # Increment count
                count = count + 1

        # If count is 2, n is prime
        if count == 2:
            return True
        # Else not prime
        return False

    # Function to find count
    # of primes till n
    def primeUptoN(self, n):

        # Variable to store count
        count = 0

        # Iterate from 2 to n
        for i in range(2, n + 1):

            # Check if i is prime
            if self.isPrime(i):
                count += 1

        # Return the count
        return count


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to get count of all primes till n
print(sol.primeUptoN(n))
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find whether the
        number is prime or not */
        private boolean isPrime(int n) {

            /* Variable to store the
            count of divisors of n */
            int count = 0;

            // Loop from 1 to n
            for (int i = 1; i <= n; ++i) {

                // Check if i is a divisor
                if (n % i == 0) {
                    // Increment count
                    count = count + 1;
                }
            }

            // If count is 2, n is prime
            if (count == 2) return true;
            // Else not prime
            return false;
        }

        /* Function to find count
        of primes till n */
        public int primeUptoN(int n) {

            // Variable to store count
            int count = 0;

            // Iterate from 2 to n
            for (int i = 2; i <= n; i++) {

                // Check if i is prime
                if (isPrime(i)) count++;
            }

            // Return the count
            return count;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to get
        count of all primes till n */
        int ans = sol.primeUptoN(n);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(N^2) – Checking all numbers from 1 to n for prime and checking if a number is prime or not will take O(n) TC.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.

## Optimal

### Intuition

The previous approach can be optimized by improving the complexity of the function to find whether a number is prime or not.

### Approach

1. Initialize a counter to store the count of prime numbers.
2. Iterate from 2 to n, and check the current value for prime (using the optimal way). If found prime, increment the counter by 1.
3. After the iterations are over, the counter stores the required result.

### Solution

```python solution time=O(N^1.5) space=O(1)
import math

class Solution:
    # Function to find whether
    # the number is prime or not
    def isPrime(self, n):
        # Variable to store the count
        # of divisors of n
        count = 0

        # Loop from 1 to square root of n
        for i in range(1, int(math.sqrt(n)) + 1):
            # Check if i is a divisor
            if n % i == 0:
                # Increment count
                count += 1

                # Check if counterpart divisor is
                # different from original divisor
                if n // i != i:
                    # Increment count
                    count += 1

        # If count is 2, n is prime
        return count == 2

    # Function to find count of primes till n
    def primeUptoN(self, n):
        # Variable to store count
        count = 0

        # Iterate from 2 to n
        for i in range(2, n + 1):
            # Check if i is prime
            if self.isPrime(i):
                count += 1

        # Return the count
        return count


# Reads the test case's n
n = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to get count of all primes till n
print(sol.primeUptoN(n))
```

```java solution time=O(N^1.5) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to find whether the number is prime or not
        private boolean isPrime(int n) {
            // Variable to store the count of divisors of n
            int count = 0;

            // Loop from 1 to square root of n
            for (int i = 1; i <= Math.sqrt(n); ++i) {
                // Check if i is a divisor
                if (n % i == 0) {
                    // Increment count
                    count = count + 1;

                    /* Check if counterpart divisor is
                    different from original divisor */
                    if (n / i != i) {
                        // Increment count
                        count = count + 1;
                    }
                }
            }

            // If count is 2, n is prime
            return count == 2;
        }

        // Function to find count of primes till n
        public int primeUptoN(int n) {
            // Variable to store count
            int count = 0;

            // Iterate from 2 to n
            for (int i = 2; i <= n; i++) {
                // Check if i is prime
                if (isPrime(i)) count++;
            }

            // Return the count
            return count;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        // Creating an instance of Solution class
        Solution sol = new Solution();

        /* Function call to get count
        of all primes till n */
        int ans = sol.primeUptoN(n);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(N^1.5) – Checking all numbers from 1 to N for prime and checking if a number is prime or not will take O(N^0.5) TC.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.
