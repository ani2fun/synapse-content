## Intuition

Given a number, it can be reversed if all the digits are extracted from the end of the original number and pushed at the back of a new reversed number.

## Approach

1. Initialize a reversed number with zero, which will store the reversed number.
2. To push any digit at the end of the reversed number, the following mathematical operation can be used: revNum = (revNum * 10) + digit. The last digit of the original number can be found by using the modulus operator (used to find the remainder for any division) with the number 10.
3. Iterate on the original number till there are digits left. In every iteration, extract the last (rightmost) digit and push it at the back of the reversed number. Also, divide the original number by 10 so that the remaining digits can be extracted in the next iterations.
4. Once the iterations are over, the reversed number will be stored in the reverse of the original number.

## Solution

```python solution time=O(log n) space=O(1)
class Solution:
    # Function to reverse given number n
    def reverseNumber(self, n):
        """ After the code, revNum will
        contain the reversed number """
        revNum = 0
        
        """ Keep on iterating while there
        are digits left to extract """
        while n > 0:
            lastDigit = n % 10
            
            """ Pushing last digit at the
            back of reversed number """
            revNum = (revNum * 10) + lastDigit
            n = n // 10
        
        return revNum

if __name__ == "__main__":
    # Reads the test case's n
    n = int(input())
    
    """ Creating an instance of 
    Solution class """
    sol = Solution()
    
    # Function call to reverse the digits in n
    ans = sol.reverseNumber(n)
    print(ans)
```

```java solution time=O(log n) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to reverse given number n
        public int reverseNumber(int n) {
            /* After the code, revNum will
            contain the reversed number */
            int revNum = 0;
            
            /* Keep on iterating while there
            are digits left to extract */
            while (n > 0) {
                int lastDigit = n % 10;

                /* Pushing last digit at the
                back of reversed number */
                revNum = (revNum * 10) + lastDigit;
                n = n / 10;
            }
            
            return revNum;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        
        /* Creating an instance of 
        Solution class */
        Solution sol = new Solution();
        
        // Function call to reverse the digits in n
        int ans = sol.reverseNumber(n);
        System.out.println(ans);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(log₁₀(N)) – In every iteration, N is divided by 10 (equivalent to the number of digits in N.)

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.
