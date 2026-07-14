## Approach

The idea is to take an integer input from the user and print it on the screen. This task can be broken down into the following steps:

1. **Receive Input:** Capture the integer input from the user.
2. **Print the Input:** Output the captured integer to the screen.

Use an input function to get the user's input. Return the input integer as per requirement.

## Solution

```python solution time=O(1) space=O(1)
class Solution:
    # Function to take input and display output
    def printNumber(self) -> None:
        # Take input
        number = int(input())

        # Print output
        print(number)


# Driver code
if __name__ == "__main__":
    # Creating an instance of Solution class
    sol = Solution()

    # Function call to take input and display output
    sol.printNumber()
```

```java solution time=O(1) space=O(1)
import java.util.Scanner;

public class Main {
    static class Solution {
        // Function to take input and display output
        void printNumber(Scanner sc) {

            int number;

            // Take input
            number = sc.nextInt();

            // Print output
            System.out.print(number);
        }
    }

    // Driver code
    public static void main(String[] args) {
        // Creating an instance of Solution class
        Solution sol = new Solution();

        // Scanner class
        Scanner sc = new Scanner(System.in);

        // Function call to take input and display output
        sol.printNumber(sc);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(1), Because the operations of receiving input and printing output are executed once regardless of the size of the input.

**Space Complexity:** O(1), Using only a single variable to store the input and not using any additional space that grows with the input size.
