## Intuition

Only the border cells need a star, so the condition is simply "first or last row, or first or last column" — every interior cell fails that check and gets a space instead, which hollows out the square.

## Approach

1. Use a for loop to iterate from 0 to N-1, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Inside the outer loop, use another loop to iterate from 0 to n-1. This loop controls the columns in each row. Within the inner loop, check if it's a top row, left column, bottom row, right column, if so, print a asterisk. Otherwise, print a space.
3. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern21
    def pattern21(self, n):
        # Outer loop for the rows.
        for i in range(n):
            
            """ Inner loop for printing 
            the stars at borders only."""
            for j in range(n):
                
                if i == 0 or j == 0 or i == n-1 or j == n-1:
                    print("*", end="")
                else:
                    print(" ", end="")
                    
            # Move to the next row.
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern21(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern21
        void pattern21(int n) {
            // Outer loop for the rows.
            for(int i = 0; i < n; i++){
                
                /* Inner loop for printing
                the stars at borders only.*/
                for(int j = 0; j < n; j++){
                    
                    if(i == 0 || j == 0 || i == n-1 || j == n-1)
                        System.out.print("*");
                    else
                        System.out.print(" ");
                }
                // Move to the next row.
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern21(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). The overall complexity will be O(N²), where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
