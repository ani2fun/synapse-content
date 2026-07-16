## Approach

1. Use a for loop to iterate from 0 to 2*N-2, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Inside the outer loop, use another loop to iterate from 0 to 2*N-2. This loop controls the columns of each row.
3. Assume the pattern as matrix, for each cell in the matrix, calculate how far the cell is from the matrix boundaries: top = distance to the top edge, bottom = distance to the bottom edge, right = distance to the right edge (from reverse index), left = distance to the left edge (from reverse index).
4. Determine the value for each cell based on the minimum distance from the edges. This calculation ensures that cells closer to the edges have higher values, which decrease towards the center.
5. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    # Function to print pattern22
    def pattern22(self, n):
        # Outer loop for the rows
        for i in range(2 * n - 1):
            # Inner loop for the columns
            for j in range(2 * n - 1):

                # Initialising distances from all four boundaries
                top = i
                left = j
                right = (2 * n - 2) - j
                bottom = (2 * n - 2) - i

                # Compute value based on minimum distance
                value = n - min(min(top, bottom), min(left, right))

                print(value, end="")
                if j < 2 * n - 2:
                    print(" ", end="")

            # Move to the next row
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern22(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern22
        public void pattern22(int n) {
            // Loop through all rows of the pattern
            for (int i = 0; i < 2 * n - 1; i++) {

                // Loop through all columns of the pattern
                for (int j = 0; j < 2 * n - 1; j++) {

                    // Distance of current cell from all four boundaries
                    int top = i;
                    int left = j;
                    int right = (2 * n - 2) - j;
                    int bottom = (2 * n - 2) - i;

                    // The minimum distance from any boundary gives the layer number
                    int value = n - Math.min(Math.min(top, bottom), Math.min(left, right));

                    // Print the current value
                    System.out.print(value);
                    if (j < 2 * n - 2) System.out.print(" ");
                }

                // Move to the next row
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern22(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2) The time complexity is dominated by the nested loops, which both iterate 2×N-1 times. Therefore, the overall time complexity is O((2×N-1)2), which simplifies to O(N2), where N is the number of rows.

**Space Complexity:** O(1), as no extra space is being used to print the patterns.
