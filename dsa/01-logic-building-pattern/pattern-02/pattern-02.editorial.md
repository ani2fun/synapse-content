## Intuition

Row i (0-indexed) of a right triangle holds exactly i+1 stars, so the inner loop bound simply
tracks the outer loop index — no separate counter is needed to know how many stars a row gets.

## Approach

1. First, run a loop for N times(0 to N-1). This loop will ensure to print each row of the pattern.
2. Inside the outer loop, run another loop for current value of the outer loop variable. It will basically ensure that the total columns is equal to the current row.
3. Within the inner loop, print an asterisk (*) without moving to a new line. This keeps all asterisks for a single row on the same line.
4. After the inner loop completes, move to a new line to start printing the next row.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:

    # Function to print pattern2
    def pattern2(self, n):

        # Outer loop will run for rows.
        for i in range(n):

            # Inner loop will run for columns.
            for j in range(i+1):
                print("*", end="")

            """ As soon as n stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern2(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern2
        void pattern2(int n) {

            // Outer loop which will loop for the rows.
            for (int i = 0; i < n; i++) {

                // Inner loop which loops for the columns.
                for (int j = 0; j <= i; j++) {
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

        sol.pattern2(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). As the outer loop runs for N time and the inner loop runs incrementally in each iteration(1+2+3+...+N), which is equal to (N*(N+1)/2). So, overall it is O(N²).

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
