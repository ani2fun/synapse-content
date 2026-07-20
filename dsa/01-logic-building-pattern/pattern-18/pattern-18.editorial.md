## Intuition

Every row ends at the same last letter of the alphabet; only where it starts moves earlier as the row number grows, so counting the inner loop backward from `n - 1 - i` letters before the end keeps the right edge fixed while the left edge grows the triangle.

## Approach

1. Use a for loop to iterate from 0 to N-1, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. The triangle has to be right-angled so, the inner loop will run for exactly current row number and the needed alphabet characters will get printed here.
3. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern18
    def pattern18(self, n):
        # Outer loop for the number of rows.
        for i in range(n):

            """ Inner loop for printing alphabets
            from 'A' + n - 1 - i to 'A' + n - 1."""
            for ch in range(ord('A') + n - 1 - i, ord('A') + n):
                print(chr(ch), end=" ")

            # Move to the next line for the next row.
            print()


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern18(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern18
        public void pattern18(int n) {
            // Outer loop for the number of rows.
            for (int i = 0; i < n; i++) {

                /* Inner loop for printing alphabets
                from A + n -1 -i (i is row no.) to
                A + n -1 ( E in this case).*/
                for (char ch = (char) (('A' + n - 1) - i); ch <= ('A' + n - 1); ch++) {
                    System.out.print(ch + " ");
                }

                // Move to the next line for the next row.
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        //Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern18(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). The overall complexity will be O(N²) due to the nested loops, where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
