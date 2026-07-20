## Intuition

Row `i` always restarts from 'A' but needs one more letter than the row before it, so counting from 'A' up to `'A' + i` using character arithmetic is enough to produce the growing run of letters for every row.

## Approach

1. Use a for loop to iterate from 0 to N-1, where N is the number of rows. This loop will ensure to print each row of the pattern.
2. The inner loop will run for i times and print alphabets from 'A' to 'A' + (row number).
3. After completing a row give a line break, to make sure next row gets printed as well.

## Solution

```python solution time=O(N²) space=O(1)
class Solution:
    # Function to print pattern14
    def pattern14(self, n):
        # Outer loop for the number of rows.
        for i in range(n):
            
            """Inner loop will loop for i times and
            print alphabets from A to A + i."""
            for ch in range(ord('A'), ord('A') + i + 1):
                print(chr(ch), end="")
                
            """ As soon as the letters for each iteration 
            are printed, we move to the next row and give
            a line break otherwise all letters would get
            printed in 1 line."""
            print()

# Reads the test case's n, e.g. 4
N = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern14(N)
```

```java solution time=O(N²) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern14
        void pattern14(int n) {
            // Outer loop for the number of rows.
            for (int i = 0; i < n; i++) {

                /* Inner loop will loop for i times and
                print alphabets from A to A + i.*/
                for (char ch = 'A'; ch <= 'A' + i; ch++) {
                    System.out.print(ch);
                }

                /*As soon as the letters for each iteration 
                are printed, we move to the next row and give
                a line break otherwise all letters would get
                printed in 1 line*/
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int N = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern14(N);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N²). The overall complexity will be O(N²), where N is the number of rows.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
