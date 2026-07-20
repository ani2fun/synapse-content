## Intuition

Row `i` always starts back at 'A', but the run length shrinks by one letter every row, so counting from 'A' up to `'A' + (n - i - 1)` reproduces the inverted triangle of letters getting shorter as the rows progress.

## Approach

1. Use a for loop to iterate from 0 to N-1, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. The inner loop will run for i times and print alphabets from 'A' to 'A' + (N-row number-1).
3. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern15
    def pattern15(self, n):
        # Outer loop for the number of rows.
        for i in range(n):

            """Inner loop runs (n - i) times and
            prints (n - i) alphabets starting from 'A'."""
            for ch in range(ord('A'), ord('A') + n - i):
                print(chr(ch), end="")

            """As soon as the letters for each iteration
            are printed, we move to the next row and give
            a line break otherwise all letters would get
            printed in 1 line."""
            print()

# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern15(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern15
        void pattern15(int n) {
            // Outer loop for the number of rows.
            for (int i = 0; i < n; i++) {

                /* Inner loop runs (n - i) times and
                prints (n - i) alphabets starting from 'A'.*/
                for (char ch = 'A'; ch<='A'+(n-i-1);ch++) {
                    System.out.print(ch);
                }

                /*As soon as the letters for each iteration
                are printed, we move to the next row and give
                a line break otherwise all letters would get
                printed in 1 line.*/
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern15(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). The overall complexity will be O(N²), where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
