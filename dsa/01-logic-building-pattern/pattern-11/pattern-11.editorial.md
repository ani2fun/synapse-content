## Intuition

Each row's starting digit is fixed by the parity of the row index (1 on even rows, 0 on odd rows), and every value after that is just the previous one flipped — so a single toggling variable that starts at the right bit and inverts itself after each print reproduces the whole alternating row.

## Approach

1. Iterate from 1 to N using a for loop, it will basically define the number of rows needed.
2. Now, if the row index is even then start from 1, else from 0. Alternatively print 0's and 1's throughout the the current row.
3. Finally, print a next line at the end of a row, it ensures to print the next row as well.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    # Function to print pattern11
    def pattern11(self, n):
        # First row starts by printing a single 1.
        start = 1

        # Outer loop for the no. of rows
        for i in range(n):

            # if the row index is even then 1
            # is printed first in that row.
            if i % 2 == 0:
                start = 1

            # if odd, then the first 0 
            # will be printed in that row
            else:
                start = 0

            # We alternatively print 1's and 0's 
            # in each row by using inner for loop
            for j in range(i + 1):
                print(start, end="")
                if j != i:
                    print(" ", end="")

                start = 1 - start

            # As soon as the numbers for each 
            # iteration are printed, we move to the
            # next row and give a line break
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern11(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern11
        public void pattern11(int n) {
            // First row starts by printing a single 1.
            int start = 1;

            // Outer loop for the no. of rows
            for (int i = 0; i < n; i++) {

                /* if the row index is even then 1
                is printed first in that row.*/
                if (i % 2 == 0) start = 1;

                /* if odd, then the first 0 
                will be printed in that row*/
                else start = 0;

                /* We alternatively print 1's and 0's 
                in each row by using inner for loop*/
                for (int j = 0; j <= i; j++) {
                    System.out.print(start);
                    if (j != i) System.out.print(" ");

                    start = 1 - start;
                }

                /* As soon as the numbers for each 
                iteration are printed, we move to the
                next row and give a line break */
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern11(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). Where, N is the number of rows provided as an input.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
