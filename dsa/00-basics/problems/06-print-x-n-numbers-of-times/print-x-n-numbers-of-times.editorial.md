## Intuition

Printing X exactly N times is just a counted loop; the only trick is placing the separating space before every value except the last, which a check against the final iteration index handles cleanly.

## Approach

1. **Receive Inputs:** Capture the integers X and N from the user.
2. Use a loop to print the value X exactly N times, ensuring a space separates each value.

## Solution

```python solution time=O(N) space=O(1)
class Solution:
    # Function to print the value X on the screen N times
    def printX(self, X: int, N: int) -> None:
        # Loop to print the value X, N times
        for i in range(N):
            # Print the value X
            print(X, end='')

            # Print a space between numbers,
            # but not after the last one
            if i < N - 1:
                print(" ", end='')

        # Move to the next line after printing
        print()


# Reads the test case's X, then N
X = int(input())
N = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to print the value X, N times
sol.printX(X, N)
```

```java solution time=O(N) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to print the value X on the screen N times
        public void printX(int X, int N) {

            // Loop to print the value X, N times
            for (int i = 0; i < N; ++i) {
                // Print the value X
                System.out.print(X);

                // Print a space between numbers
                if (i < N - 1) {
                    System.out.print(" ");
                }
            }

            // Move to the next line after printing
            System.out.println();
        }
    }

    public static void main(String[] args) {
        // Reads the test case's X, then N
        Scanner sc = new Scanner(System.in);
        int X = sc.nextInt();
        int N = sc.nextInt();

        // Creating an instance of Solution class
        Solution sol = new Solution();

        // Function call to print the value X, N times
        sol.printX(X, N);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(N), The loop runs N times, printing the value X.

**Space Complexity:** O(1), Only a couple of variables were used taking constant space.
