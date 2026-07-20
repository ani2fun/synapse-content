## Intuition

Across the `2n - 1` rows, the star count simply climbs from 1 up to `n` and then mirrors itself back down to 1, so row `i`'s star count is `i` for the first half and `2n - i` for the second half — one loop with that split reproduces the whole grow-then-shrink shape.

## Approach

1. Use nested for loops to print the pattern. First, figure out what is the total number of rows for which the pattern needs to be printed.
2. Then, print the asterisks incrementally till half the total number of rows and after that decrease the asterisks according to the row number.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    #Function to print pattern10
    def pattern10(self, n):
        # Outer loop for number of rows.
        for i in range(1, 2 * n):
            
            """ stars would be equal to the
            row no. uptill first half"""
            stars = i if i <= n else 2 * n - i
            
            # for printing the stars in each row.
            for j in range(1, stars + 1):
                print("*", end="")
            
            """ As soon as the stars for each iteration are 
            printed, we move to the next row and give a line break"""
            print()

if __name__ == "__main__":
    # Reads the test case's n, e.g. 4
    N = int(input())
    
    # Create an instance of Solution class
    sol = Solution()
    
    sol.pattern10(N)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern10
        public static void pattern10(int n) {
            // Outer loop for number of rows.
            for (int i = 1; i <= 2 * n - 1; i++) {

                /* stars would be equal to the
                row no. uptill first half */
                int stars = i;

                // for the second half of rotated triangle.
                if (i > n) stars = 2 * n - i;

                // for printing the stars in each row.
                for (int j = 1; j <= stars; j++) {
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
        int N = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern10(N);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). Where N is the input provided. This quadratic complexity arises due to the nested loops iterating over N rows and printing a number of stars that sums up to approximately N2 stars in total.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
