## Intuition

The star count shrinks by 2 each row (an odd sequence counting down from 2N-1 to 1), and the
leading spaces grow by exactly 1 each row — the two together slant the triangle's left edge
inward while its right edge stays put, producing a triangle that leans instead of standing
upright.

## Approach

1. Iterate from 0 to N-1 using a loop, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Now, run another loop from 0 to the current value of outer loop variable. It will basically print the spaces before asterisks as required in every row.
3. Again, run a loop, print the asterisk, all in one line, to complete the current row.
4. Move to a new line after printing each row to maintain the right-angled triangle shape of the pattern.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:

    # Function to print pattern8
    def pattern8(self, n: int) -> None:

        # Outer loop will run for rows.
        for i in range(0, n):

            # This loop will print the spaces.
            for j in range(0, i):
                print(" ", end="")

            # This loop will print asterisk.
            for j in range(0, 2 * n - (2 * i + 1)):
                print("*", end="")

            """ As soon as n stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern8(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern8
        void pattern8(int n) {

            // Outer loop which will loop for the rows.
            for (int i = 0; i < n; i++) {

                // This loop will print the spaces.
                for (int j = 0; j < i; j++) {
                    System.out.print(" ");
                }

                // This loop will print asterisk.
                for (int j = 0; j < 2 * n - (2 * i + 1); j++) {
                    System.out.print("*");
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

        sol.pattern8(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). As the outer loop runs for N times and the first inner loop runs for(0 + 1 + 2 + .. + N-1), the second inner loop runs in decreasing manner in each iteration((2*N -1) + (2*N - 3) + ... + 1). So, overall it is O(N2).

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
