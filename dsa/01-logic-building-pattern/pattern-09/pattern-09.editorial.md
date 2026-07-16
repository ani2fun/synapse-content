## Approach

1. This pattern is a combination of the pyramid and an inverted pyramid. First, print the pyramid and then the inverted one.
2. Use nested for loops to print the pyramid. First, print the spaces using a for loop, and then the required asterisks using a second for loop.
3. After this, give a line break to print the next row. Follow the same process to print the inverted pyramid.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    def pattern9(self, n):
        self.erect_pyramid(n)
        self.inverted_pyramid(n)

    def erect_pyramid(self, n):
        # Outer loop which will loop for the rows.
        for i in range(n):
            # For printing the spaces before stars in each row
            for j in range(n - i - 1):
                print(" ", end="")

            # For printing the stars in each row
            for j in range(2 * i + 1):
                print("*", end="")

            # As soon as the stars for each iteration are printed,
            # we move to the next row and give a line break
            print()

    def inverted_pyramid(self, n):
        # Outer loop which will loop for the rows.
        for i in range(n):
            # For printing the spaces before stars in each row
            for j in range(i):
                print(" ", end="")

            # For printing the stars in each row
            for j in range(2 * n - (2 * i + 1)):
                print("*", end="")

            """ As soon as the stars for each iteration are printed,
            we move to the next row and give a line break"""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern9(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern9
        void pattern9(int n) {
            erectPyramid(n);
            invertedPyramid(n);
        }

        private void erectPyramid(int n) {
            // Outer loop which will loop for the rows.
            for (int i = 0; i < n; i++) {
                // For printing the spaces before stars in each row
                for (int j = 0; j < n - i - 1; j++) {
                    System.out.print(" ");
                }

                // For printing the stars in each row
                for (int j = 0; j < 2 * i + 1; j++) {
                    System.out.print("*");
                }

                /* As soon as the stars for each iteration are printed,
                we move to the next row and give a line break */
                System.out.println();
            }
        }

        private void invertedPyramid(int n) {
            // Outer loop which will loop for the rows.
            for (int i = 0; i < n; i++) {
                // For printing the spaces before stars in each row
                for (int j = 0; j < i; j++) {
                    System.out.print(" ");
                }

                // For printing the stars in each row
                for (int j = 0; j < 2 * n - (2 * i + 1); j++) {
                    System.out.print("*");
                }

                /* As soon as the stars for each iteration are printed,
                we move to the next row and give a line break */
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern9(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(2*N2). As both functions take O(N2) each.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
