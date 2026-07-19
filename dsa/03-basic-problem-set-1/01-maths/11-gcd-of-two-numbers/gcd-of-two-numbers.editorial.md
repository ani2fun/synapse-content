## Brute

### Intuition

The GCD (Greatest Common Divisor), also known as HCF (Highest Common Factor), of two numbers is the largest number that divides both without leaving a remainder. To find the GCD, check all numbers from 1 up to the smaller of the two input numbers for common factors. The largest of these common factors is the GCD.

### Approach

1. Initialize a variable gcd with 1 that will store the greatest common divisor of the two given numbers.
2. Iterate from 1 to the minimum of the two numbers using a loop variable. Update the gcd if both the given numbers are divisible by the current value of the loop variable.
3. After the iterations are over, the greatest common divisor will be stored in the gcd variable.

### Solution

```python solution time=O(min(N1, N2)) space=O(1)
class Solution:
    # Function to find the
    # GCD of two numbers
    def GCD(self, n1, n2):

        # Variable to store the gcd
        gcd = 1

        # Iterate from 1 to min(n1, n2)
        for i in range(1, min(n1, n2) + 1):

            # Check if i is a common
            # divisor of both n1 and n2
            if n1 % i == 0 and n2 % i == 0:

                # Update gcd
                gcd = i

        # Return stored GCD.
        return gcd


# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())

# Creating an instance of
# Solution class
sol = Solution()

# Function call to find the
# gcd of two numbers
ans = sol.GCD(n1, n2)

print(ans)
```

```java solution time=O(min(N1, N2)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find the
        GCD of two numbers */
        public int GCD(int n1, int n2) {

            // Variable to store the gcd
            int gcd = 1;

            // Iterate from 1 to min(n1, n2)
            for (int i = 1; i <= Math.min(n1, n2); i++) {

                /* Check if i is a common
                divisor of both n1 and n2 */
                if (n1 % i == 0 && n2 % i == 0) {

                    // Update gcd
                    gcd = i;
                }
            }

            // Return stored GCD.
            return gcd;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to find the
        gcd of two numbers */
        int ans = sol.GCD(n1, n2);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(min(N1, N2)) – where N1 and N2 are given numbers. Iterating from 1 to min(N1, N2) and performing constant time operations in each iteration.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.

## Better

### Intuition

The time complexity of the previous approach can be optimized if we iterate backward from min(n1, n2) to 1. This way the first divisor that is found for both numbers can be returned as the greatest common divisor of the numbers saving unnecessary iterations.

### Approach

1. Declare a variable gcd that will store the greatest common divisor of the two given numbers.
2. Iterate from the minimum of the two numbers down to 1 using a loop variable. Update the gcd if both the given numbers are divisible by the current value of the loop variable and break out from the loop to save unnecessary iterations.
3. The greatest common divisor for the two numbers is stored in the gcd variable which can be returned as the answer.

### Solution

```python solution time=O(min(N1, N2)) space=O(1)
class Solution:
    # Function to find the GCD of two numbers
    def GCD(self, n1, n2):

        # Variable to store the gcd
        gcd = 1

        # Iterate from 1 to min(n1, n2)
        for i in range(min(n1, n2), 0, -1):

            # Check if i is a common divisor
            # of both n1 and n2
            if n1 % i == 0 and n2 % i == 0:

                # Update gcd
                gcd = i
                # Break to skip unnecessary iterations
                break

        # Return stored GCD
        return gcd


# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to find the gcd of two numbers
ans = sol.GCD(n1, n2)

print(ans)
```

```java solution time=O(min(N1, N2)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find the
        GCD of two numbers */
        public int GCD(int n1, int n2) {

            // Variable to store the gcd
            int gcd = 1;

            // Iterate from 1 to min(n1, n2)
            for (int i = Math.min(n1, n2); i >= 1; --i) {

                /* Check if i is a common
                divisor of both n1 and n2 */
                if (n1 % i == 0 && n2 % i == 0) {

                    // Update gcd
                    gcd = i;
                    // Break to skip unnecessary iterations
                    break;
                }
            }

            // Return stored GCD.
            return gcd;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to find the
        gcd of two numbers */
        int ans = sol.GCD(n1, n2);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(min(N1, N2)) – where N1 and N2 are given numbers. In the worst case, finding GCD will require iterating from min(N1, N2) till 1 and performing constant time operations in each iteration.

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.

## Optimal

### Intuition

The most optimal way to solve this problem is to use the Euclidean Algorithm which works on the principle that the GCD of two numbers remains the same even if the smaller number is subtracted from the larger number.

Euclidean Algorithm: to find the GCD of n1 and n2 where n1 > n2, repeatedly subtract the smaller number from the larger number until one of them becomes 0. Once one of them becomes 0, the other number is the GCD of the original numbers.

Example: GCD of n1 = 7, n2 = 2 can be found in this way:

```text
gcd(7, 2) = gcd(7-2, 2) = gcd(5, 2)
gcd(5, 2) = gcd(5-2, 2) = gcd(3, 2)
gcd(3, 2) = gcd(3-2, 2) = gcd(1, 2)
gcd(2, 1) = gcd(2-1, 1) = gcd(1, 1)
gcd(1, 1) = gcd(1-1, 1) = gcd(0, 1)
```

Hence GCD of n1 = 7, n2 = 2 is 1.

Note: observe that instead of subtracting the smaller number from the greater number repeatedly, the modulus operator can be used.

```text
gcd(7, 2) = gcd(7%2, 2) = gcd(1, 2)
```

### Approach

1. Initialize a while loop till both numbers are greater than zero.
2. In each iteration perform the modulus operation of the greater number with the smaller number.
3. Once the loop terminates, one of the two variables stores a non-zero value which is the GCD for the given pair of numbers.

### Solution

```python solution time=O(log(min(N1, N2))) space=O(1)
class Solution:
    # Function to find the GCD of two numbers
    def GCD(self, n1, n2):

        # Continue loop as long as both n1 and
        # n2 are greater than zero
        while n1 > 0 and n2 > 0:

            # If n1 is greater than n2, perform
            # modulo operation - n1 % n2
            if n1 > n2:
                n1 = n1 % n2

            # Else perform modulo operation - n2 % n1
            else:
                n2 = n2 % n1

        # If n1 is zero, GCD is stored in n2
        if n1 == 0:
            return n2

        # else GCD is stored in n1
        return n1


# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to find the gcd of two numbers
ans = sol.GCD(n1, n2)

print(ans)
```

```java solution time=O(log(min(N1, N2))) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find the
        GCD of two numbers */
        public int GCD(int n1, int n2) {

            /* Continue loop as long as both
             n1 and n2 are greater than zero */
            while (n1 > 0 && n2 > 0) {

                /* If n1 is greater than n2, perform
                 modulo operation - n1 % n2 */
                if (n1 > n2) {
                    n1 = n1 % n2;
                }

                /* Else perform modulo
                operation - n2 % n1 */
                else {
                    n2 = n2 % n1;
                }
            }

            // If n1 is zero, GCD is stored in n2
            if (n1 == 0) return n2;

            //else GCD is stored in n1
            return n1;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        /* Function call to find the
        gcd of two numbes */
        int ans = sol.GCD(n1, n2);

        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(log(min(N1, N2))) – where N1 and N2 are given numbers. Because in every iteration, the algorithm is dividing larger number with the smaller number resulting in time complexity.(approx.)

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.
