## Intuition

Each row is symmetric: the same ascending run `1..i` appears on both sides of a gap of spaces, and as the numbers grow by one each row, the gap in between shrinks by exactly two — so tracking one shrinking `spaces` counter alongside the row index is enough to keep every row aligned into a diamond.

## Approach

1. This pattern can be divided into three parts: first print the numbers, then spaces and at last numbers again.
2. Find out the numbers of spaces needs to printed in the first row and store it in a variable spaces.
3. Then iterate from 1 to N to define the number of rows. Using nested for loop print the numbers as required , then in separate loop print the spaces and finally, the numbers in third loop.
4. After completion of a row, decrease the number of spaces and give a line break to print next row.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern12
    def pattern12(self, n):
        # Initial no. of spaces in row 1.
        spaces = 2 * (n - 1)

        # Outer loop for the number of rows.
        for i in range(1, n + 1):
            # For printing numbers in each row
            for j in range(1, i + 1):
                print(j, end="")

            # For printing spaces in each row
            for j in range(1, spaces + 1):
                print(" ", end="")

            # For printing numbers in each row
            for j in range(i, 0, -1):
                print(j, end="")

            """ As soon as the numbers for each iteration
            are printed, we move to the next row and give
            a line break otherwise all numbers would get 
            printed in 1 line"""
            print()

            """ After each iteration nos. increase by 
            2, thus spaces will decrement by 2"""
            spaces -= 2


# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern12(n)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern12
        void pattern12(int n) {
            // Initial no. of spaces in row 1.
            int spaces = 2 * (n - 1);

            // Outer loop for the number of rows.
            for (int i = 1; i <= n; i++) {
                // For printing numbers in each row
                for (int j = 1; j <= i; j++) {
                    System.out.print(j);
                }

                // For printing spaces in each row
                for (int j = 1; j <= spaces; j++) {
                    System.out.print(" ");
                }

                // For printing numbers in each row
                for (int j = i; j >= 1; j--) {
                    System.out.print(j);
                }

                /* As soon as the numbers for each iteration
                are printed, we move to the next row and give
                a line break otherwise all numbers would get 
                printed in 1 line*/
                System.out.println();

                /* After each iteration nos. increase by 
                2, thus spaces will decrement by 2*/
                spaces -= 2;
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern12(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). Where, N is the number of rows provided as an input.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
