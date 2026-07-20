## Intuition

The two star blocks in a row shrink by one star and their middle gap grows by two, row after row, which pulls the shape inward toward the center; running that same "stars, gap, stars" rule forward for the top half and in reverse for the bottom half pinches the two halves together into an hourglass.

## Approach

1. This pattern can be broken down into lower half and upper half. Both the halves follow the same logic, first print the asterisks then the spaces and at last the asterisks again.
2. Upper half pattern: Start by initializing iniS to 0. This variable will keep track of the number of spaces between the two sets of stars in each row of the upper half pattern.
3. Use an outer loop to iterate from 0 to N-1 (where N is the input parameter), representing each row of the upper half pattern.
4. Print stars (*) starting from N - (the current row index) and decrementing until 1. Print spaces using another loop (for loop) that runs iniS times. iniS starts at 0 and increases by 2 with each new row. Print stars again, mirroring the first set but in reverse order.
5. After completing a row give a line break, to make sure next row gets printed as well.
6. Lower half pattern: Follow the same above steps to print the lower half pattern.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    # Function to print pattern19
    def pattern19(self, n):
        # Print the upper half pattern

        # Store the initial spaces.
        iniS = 0

        for i in range(n):
            # Printing the stars in the row.
            print("*" * (n - i), end="")

            # Printing the spaces in the row.
            print(" " * iniS, end="")

            # Printing the stars in the row.
            print("*" * (n - i))

            """ The spaces increase by 2 
            every time we hit a new row."""
            iniS += 2

        # Print the lower half pattern

        # Store the initial spaces.
        iniS = 2 * n - 2

        for i in range(1, n + 1):
            # Printing the stars in the row.
            print("*" * i, end="")

            # Printing the spaces in the row.
            print(" " * iniS, end="")

            # Printing the stars in the row.
            print("*" * i)

            """ The spaces decrease by 2 
            every time we hit a new row."""
            iniS -= 2


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern19(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern19
        void pattern19(int n) {
            // Print the upper half pattern

            // Store the initial spaces.
            int iniS = 0;

            for (int i = 0; i < n; i++) {
                // Printing the stars in the row.
                for (int j = 1; j <= n - i; j++) {
                    System.out.print("*");
                }

                // Printing the spaces in the row.
                for (int j = 0; j < iniS; j++) {
                    System.out.print(" ");
                }

                // Printing the stars in the row.
                for (int j = 1; j <= n - i; j++) {
                    System.out.print("*");
                }

                /* The spaces increase by 2 
                every time we hit a new row. */
                iniS += 2;

                // Give a line break for a new row.
                System.out.println();
            }

            // Print the lower half pattern

            // Store the initial spaces.
            iniS = 2 * n - 2;

            for (int i = 1; i <= n; i++) {
                // Printing the stars in the row.
                for (int j = 1; j <= i; j++) {
                    System.out.print("*");
                }

                // Printing the spaces in the row.
                for (int j = 0; j < iniS; j++) {
                    System.out.print(" ");
                }

                // Printing the stars in the row.
                for (int j = 1; j <= i; j++) {
                    System.out.print("*");
                }

                /* The spaces decrease by 2 
                every time we hit a new row. */
                iniS -= 2;

                // Give a line break for a new row.
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern19(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). The overall complexity will be O(N2), where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
