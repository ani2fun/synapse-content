## Intuition

Row `i` needs exactly `i` numbers, but the count is never reset between rows — so carrying a single counter across the whole outer loop naturally continues the sequence from wherever the previous row left off, instead of restarting each row from 1.

## Approach

1. Iterate from 1 to N, where N is the number of rows.
2. Inside this loop, take another loop to define the number of columns needed in each row. Now print the numbers strating from 1 and a space. Then increment the number by 1 every time.
3. After completion of a row, make sure to give a line break to print the next rows as well.

## Solution

```python solution time=O(N^2) space=O(1)
class Solution:
    # Function to print pattern13
    def pattern13(self, n):
        # starting the number
        num = 1

        # Outer loop for the number of rows.
        for i in range(1, n + 1):
            
            """ Inner loop will loop for i times and
            print numbers increasing by 1 each time"""
            for j in range(1, i + 1):
                print(num, end=" ")
                num += 1
                
            """ As soon as the numbers for each iteration
            are printed, we move to the next row and give
            a line break otherwise all numbers would get
            printed in 1 line"""
            print()

# Reads the test case's n, e.g. 4
n = int(input())

# Create an instance of Solution class
sol = Solution()

sol.pattern13(n)
```

```java solution time=O(N^2) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print pattern13
        void pattern13(int n) {
            // starting the number
            int num = 1;

            // Outer loop for the number of rows.
            for (int i = 1; i <= n; i++) {
                
                /*Inner loop will loop for i times and
                print numbers increasing by 1 each time*/
                for (int j = 1; j <= i; j++) {
                    System.out.print(num + " ");
                    num = num + 1;
                }
                /* As soon as the numbers for each iteration
                are printed, we move to the next row and give
                a line break otherwise all numbers would get
                printed in 1 line*/
                System.out.println();
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n, e.g. 4
        int n = new Scanner(System.in).nextInt();

        // Create an instance of Solution class
        Solution sol = new Solution();

        sol.pattern13(n);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N2). Where N is the number of rows provided as a input.

**Space Complexity:** O(1). As no extra space is being used to print the patterns.
