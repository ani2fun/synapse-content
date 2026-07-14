## Approach

1. Use a for loop to iterate from 0 to (N-1), where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Inner loops makes sure that N stars are printed in every line, eventually since the inner loop will run for N times, it will make sure that N stars are printed in N lines, resulting in a square of size N x N, which is the desired pattern
3. Now, print the asterisks for each column of a row, inside the inner loop.
4. Move to a new line after printing each row to maintain the square structure of the pattern.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:

    # Function to print pattern1
    def pattern1(self, n: int) -> None:

        # Outer loop will run for rows.
        for i in range(n):

            # Inner loop will run for columns.
            for j in range(n):
                print("*", end="")

            """ As soon as N stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern1(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern1
        void pattern1(int n) {

            // Outer loop will run for rows.
            for (int i = 0; i < n; i++) {

                // Inner loop will run for columns.
                for (int j = 0; j < n; j++) {
                    System.out.print("*");
                }
                /* As soon as n stars are printed, move
                to the next row and give a line break. */
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of the Solution class
        Solution sol = new Solution();

        sol.pattern1(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2) As two for loops are being used to print the patterns and both of them runs for N time.

**Space Complexity:** As no additional space is used, so the Space Complexity is O(1)
