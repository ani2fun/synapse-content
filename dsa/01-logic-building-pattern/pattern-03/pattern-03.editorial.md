## Intuition

Row i has exactly i columns, and the value printed in each column is just that column's own
position — so the inner loop's own counter (1, 2, 3, …) is already the number to print, with no
extra bookkeeping.

## Approach

1. Use a for loop to iterate from 1 to N, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Inside this loop, run another loop from 1 to current value of the outer loop variable. It will ensure that the number of rows and columns are equal(1 column in 1st row, 2 columns in 2nd row etc).
3. Now, print the current value of inner loop variable, as the column number needs to be printed in each column of the current row.
4. Move to a new line after printing each row to maintain the right-angled triangle shape of the pattern.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:

    # Function to print pattern3
    def pattern3(self, n):

        # Outer loop will run for rows.
        for i in range(1,n+1):

            # Inner loop will run for columns.
            for j in range(1,i+1):
                print(j, end="")

            """ As soon as n stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern3(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern3
        public void pattern3(int n) {

            // Outer loop which will loop for the rows.
            for (int i = 1; i <= n; i++) {

                // Inner loop which loops for the columns.
                for (int j = 1; j <= i; j++) {
                    System.out.print(j);
                }
                /* As soon as stars for each iteration are printed,
                 move to the next row and give a line break */
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int N = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern3(N);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). As the outer loop runs for N time and the inner loop runs incrementally in each iteration(1+2+3+...+N), which is equal to (N*(N+1)/2). So, overall it is O(N²).

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
