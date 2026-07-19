## Intuition

Given a number, the number of digits can be found. Once the number of digits is known, all the digits can be extracted one by one from the right which can be used to check whether the number is Armstrong or not.

## Approach

1. Initialize three variables: `count` — to store the count of digits in the given number; `sum` — to store the sum of the digits of the number raised to the power of the number of digits; `copy` — to store the copy of the original number.
2. Start iterating on the given number till there are digits left to extract. In each iteration, extract the last digit (using the modulus operator with 10), and add the digit raised to the power of count to sum. Update n by integer division with 10 effectively removing the last digit.
3. After the iterations are over, check if the copy of the original is the same as the sum stored. If found equal, the original number is an Armstrong number, else it is not.

## Solution

```python solution time=O(log n) space=O(1)
import math

class Solution:

    """ Function to count the 
    number of digits in N """
    def countDigit(self, n):
        
        # Base case
        if n == 0:
            return 1

        count = int(math.log10(n)) + 1
        return count
    
    """ Function to find whether the
    number is Armstrong or not """
    def isArmstrong(self, n):
        # Store the count of digits
        count = self.countDigit(n)
        
        # Variable to store the sum
        sum = 0
        
        # Variable to store the copy
        copy = n
        
        # Iterate through each
        # digit of the number
        while n > 0:
            
            # Extract the last digit
            lastDigit = n % 10
            
            # Update sum
            sum += pow(lastDigit, count)
            
            # Remove the last digit
            # from the number
            n = n // 10
        
        # Check if the sum of digits raised to the
        # power of k equals the original number
        if sum == copy:
            return True
        return False


# Reads the test case's n
n = int(input())

# Creating an instance of
# Solution class
sol = Solution()

# Function call to find whether the
# given number is Armstrong or not
ans = sol.isArmstrong(n)

print(str(ans).lower())
```

```java solution time=O(log n) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to count the 
        number of digits in N */
        private int countDigit(int n) {
            // Base case
            if(n == 0) return 1;
            int count = (int)(Math.log10(n) + 1);
            return count;
        }

        /* Function to find whether the
        number is Armstrong or not */
        public boolean isArmstrong(int n) {
            
            // Store the count of digits
            int count = countDigit(n);
            
            // Variable to store the sum, using long to prevent overflow
            long sum = 0;
            
            // Variable to store the copy
            int copy = n;
            
            /* Iterate through each
            digit of the number */
            while (n > 0) {
                
                // Extract the last digit
                int lastDigit = n % 10;
                
                // Update sum
                sum += Math.pow(lastDigit, count);
                
                /* Remove the last digit
                 from the number */
                n = n / 10;
            }
            
            /* Check if the sum of digits raised to the
            power of k equals the original number */
            if (sum == copy) return true;
            return false;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();

        // Creating an instance of
        // Solution class
        Solution sol = new Solution();

        // Function call to find whether the
        // given number is Armstrong or not
        boolean ans = sol.isArmstrong(n);

        System.out.println(ans);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(log n), since the number of digits in n is proportional to log₁₀(n), and each digit is extracted and processed exactly once.

**Space Complexity:** O(1), as no additional space proportional to the input is used.
