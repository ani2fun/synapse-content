## Intuition

Each row prints just one letter — the row's own index into the alphabet — repeated once per position up to that row number, so the row number doubles as both which letter to pick and how many times to print it.

## Approach

1. Use a for loop to iterate from 0 to N-1, where N is the number of rows. This loop will ensure to print each row of the pattern. Initialize a variable to store the alphabet that needs to be printed in each row, depending upon the row numbers.
2. The inner loop will run for row times and print the alphabets as required.
3. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern16
    def pattern16(self, n):
        # Outer loop for the number of rows.
        for i in range(n):
            
            # Defining character for each row.
            ch = chr(ord('A') + i)
            for j in range(i + 1):
                
                """same char is to be printed
                i times in that row."""
                print(ch, end="")
                
            """ As soon as the letters for each 
            iteration are printed, we move to the
            next row and give a line break otherwise
            all letters would get printed in 1 line. """
            print()

# Reads the test case's n, e.g. 4
N = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern16(N)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern16
        void pattern16(int n) {
            // Outer loop for the number of rows.
            for (int i = 0; i < n; i++) {
                
                // Defining character for each row.
                char ch = (char) ('A' + i);
                for (int j = 0; j <= i; j++) {
                    
                    /* same char is to be printed
                    i times in that row.*/
                    System.out.print(ch);
                }
                /* As soon as the letters for each 
                iteration are printed, we move to the
                next row and give a line break otherwise
                all letters would get printed in 1 line. */
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int N = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern16(N);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). The overall complexity will be O(N²), where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
