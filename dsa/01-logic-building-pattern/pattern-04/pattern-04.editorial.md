## Intuition

Unlike a pattern where the printed value changes across a row, here the value is constant for
the whole row — it's just the row number itself, repeated as many times as the row is wide.

## Approach

1. Use a for loop to iterate from 1 to N, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Inside this loop, run another loop from 1 to current value of the outer loop variable. It will make the number of rows and columns equal(1 column in 1st row, 2 columns in 2nd row etc).
3. Now, print the current value of outer loop variable, as the row number needs to be printed in each column of the current row.
4. Move to a new line after printing each row to maintain the right-angled triangle shape of the pattern.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    
    # Function to print pattern4
    def pattern4(self, n):
        
        # Outer loop will run for rows.
        for i in range(1,n+1):
            
            # Inner loop will run for columns.
            for j in range(1,i+1):
                print(i, end="")
                
            """ As soon as n stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern4(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern4
        void pattern4(int n) {

            // Outer loop which will loop for the rows.
            for (int i = 1; i <= n; i++) {

                // Inner loop which loops for the columns.
                for (int j = 1; j <= i; j++) {
                    System.out.print(i);
                }
                /* As soon as stars for each iteration are printed,
                 move to the next row and give a line break */
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern4(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). As the outer loop runs for N time and the inner loop runs incrementally in each iteration(1+2+3+...+N), which is equal to (N*(N+1)/2). So, overall it is O(N2).

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
