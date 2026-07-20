## Intuition

Same shrinking-triangle shape as before, but instead of a fixed asterisk each column prints its
own position — so the inner loop's counter (offset by one) doubles as the value to print, while
the row width still shrinks by one column per row.

## Approach

1. Use a for loop to iterate from 0 to N-1, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. Inside this loop, run another loop from 0 to (N - current value of the outer loop variable). It will ensure to decrease the number of columns as the row value increases.
3. Now, print the current value of inner loop + 1, it will print the column number strating from 1 to N.
4. Move to a new line after printing each row to maintain the right-angled triangle shape of the pattern.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:

    # Function to print pattern6
    def pattern6(self, n: int) -> None:

        # Outer loop will run for rows.
        for i in range(0, n):

            # Inner loop will run for columns.
            for j in range(0, n - i):
                print(j + 1, end="")

            """ As soon as n stars are printed, move
            to the next row and give a line break."""
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of the Solution class
sol = Solution()

sol.pattern6(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern6
        void pattern6(int n) {

            // Outer loop which will loop for the rows.
            for (int i = 0; i < n; i++) {

                // Inner loop which loops for the columns.
                for (int j = 0; j < n - i; j++) {
                    System.out.print(j + 1);
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

        sol.pattern6(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). As the outer loop runs for N times and the inner loop runs in decreasing manner in each iteration(N + (N-1) + (N-2) + ... + 1), which is equal to (N*(N+1)/2). So, overall it is O(N²).

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
