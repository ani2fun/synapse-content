## Intuition

Given a number, all the digits in the number can be extracted one by one from right to left which can be checked for even and odd.

## Approach

1. The last digit of the given number can be found by using the modulus operator (used to find the remainder for any division) with the number 10.
2. Iterate on the original number till there are digits left, extract the last (rightmost) digit, and check whether the digit is odd or not. In every iteration, divide the original number by 10 so that the remaining digits can be extracted in the next iterations.
3. Keep a counter to count the number of odd digits found in the number and every time an odd digit is encountered, increment the counter.

## Solution

```python solution time=O(log10(N)) space=O(1)
class Solution:
    # Function to count number
    # of odd digits in N
    def countOddDigit(self, n):
        # Counter to store the 
        # number of odd digits
        oddDigits = 0

        # Iterate till there are digits left
        while n > 0:
            # Extract last digit
            lastDigit = n % 10
            
            # Check if digit is odd
            if lastDigit % 2 != 0:
                # Increment counter
                oddDigits = oddDigits + 1
            n = n // 10

        return oddDigits


# Reads the test case's n
n = int(input())

# Creating an instance of 
# Solution class
sol = Solution()

# Function call to get count of odd digits in n
ans = sol.countOddDigit(n)
print(ans)
```

```java solution time=O(log10(N)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to count number
        of odd digits in N */
        public int countOddDigit(int n) {
            /* Counter to store the 
            number of odd digits */
            int oddDigits = 0;

            // Iterate till there are digits left
            while (n > 0) {
                // Extract last digit
                int lastDigit = n % 10;
                
                // Check if digit is odd
                if (lastDigit % 2 != 0) {
                    // Increment counter
                    oddDigits = oddDigits + 1;
                }
                n = n / 10;
            }

            return oddDigits;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();

        /* Creating an instance of 
        Solution class */
        Solution sol = new Solution(); 

        // Function call to get count of odd digits in n
        int ans = sol.countOddDigit(n);
        System.out.println(ans);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(log10(N)) – In every iteration we are dividing N by 10 (equivalent to the number of digits in N).

**Space Complexity:** O(1) – Using only couple of variables i.e., constant space.
