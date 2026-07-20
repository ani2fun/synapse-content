## Intuition

The gap between the two star columns closes by two every row until it vanishes at the middle row, then reopens by two every row after — so counting the star width up to N and back down, mirrored by counting the gap down to zero and back up, is enough to draw a diamond that is widest in the middle and pinched at both ends.

## Approach

1. Start by initializing spaces to 2*N - 2. This variable tracks the number of spaces between the two sets of stars in each row, where N is the number of rows.
2. Use an outer loop (for loop) to iterate from 1 to 2*N- 1. This loop controls the number of rows printed for both the upper and lower halves of the pattern.
3. Inside the loop, calculate stars: For the first half (when row number <= N), stars starts from 1 and increments with each row. For the second half (when row > N), stars decreases with each row.
4. Use nested loops to print stars, spaces, the second set of stars, mirroring the first set. After printing stars and spaces for each row, adjust spaces.
5. If row < N, decrease spaces by 2 to gradually reduce the space between stars as rows progress towards the middle, else, increase spaces by 2 to gradually increase the space as rows move away from the middle.
6. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern20
    def pattern20(self, n):
        # Initialising the spaces.
        spaces = 2 * n - 2
        
        # Outer loop to print the row.
        for i in range(1, 2 * n):
            # Stars for first half
            stars = i
            
            # Stars for the second half.
            if i > n:
                stars = 2 * n - i
            
            # For printing the stars
            print("*" * stars, end="")
            
            # For printing the spaces
            print(" " * spaces, end="")
            
            # For printing the stars
            print("*" * stars, end="")
            
            # Give a line break for new row.
            print()
            
            # Adjust spaces for the next row
            if i < n:
                spaces -= 2
            else:
                spaces += 2

# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern20(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern20
        public void pattern20(int n) {
            // Initialising the spaces.
            int spaces = 2*n-2;
            
            // Outer loop to print the row.
            for(int i = 1; i <= 2*n-1; i++){
                // Stars for first half
                int stars = i;
                
                // Stars for the second half.
                if(i > n) stars = 2*n - i;
                
                // For printing the stars
                for(int j = 1; j <= stars; j++){
                    System.out.print("*");
                }
                
                // For printing the spaces
                for(int j = 1; j <= spaces; j++){
                    System.out.print(" ");
                }
                
                // For printing the stars
                for(int j = 1; j <= stars; j++){
                    System.out.print("*");
                }
                
                // Give a line break for new row.
                System.out.println();
                
                if(i < n) spaces -= 2;
                else spaces += 2;
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();
        
        // Create an instance of Solution class
        Solution sol = new Solution();
        
        sol.pattern20(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). The overall complexity will be O(N²), where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
