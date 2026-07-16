## Approach

1. Iterate from 0 to N-1, where N is the number of rows. This outer loop ensures that each row of the pyramid pattern is printed.
2. For each row, run a loop from 0 to (N - i - 1) to print the required leading spaces. This helps in aligning the pyramid centrally.
3. Then, run another loop from 0 to (2 * i + 1) to print the asterisks. This ensures that each row has an odd number of stars, forming a symmetric pyramid.
4. After printing spaces and asterisks for the current row, move to the next line to maintain the proper pyramid structure.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:

    # Function to print pattern7
    def pattern7(self, n: int) -> None:

        # Outer loop will run for rows.
        for i in range(n):

            # This loop will print the spaces
            for j in range(n - i - 1):
                print(" ", end="")

            # This loop will print asterisk.
            for j in range(2 * i + 1):
                print("*", end="")

            """ As soon as n stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern7(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern7
        void pattern7(int n) {

            // Outer loop which will loop for the rows.
            for (int i = 0; i < n; i++) {

                // This loop will print the spaces
                for (int j = 0; j < n - i - 1; j++) {
                    System.out.print(" ");
                }

                // Inner loop will print asterisks
                for (int j = 0; j < 2 * i + 1; j++) {
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

        sol.pattern7(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). As the outer loop runs for N times and the first inner loop runs for(N-1 + N-2 + ... + 1), the second inner loop runs incrementally in each iteration(1 + 3 + 5 + ...+2* N-1). So, overall it is O(N2).

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
