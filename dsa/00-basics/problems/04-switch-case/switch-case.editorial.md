## Intuition

Each valid day number maps to exactly one weekday name, so once out-of-range values are filtered out with a simple bounds check, a direct one-to-one dispatch — a switch (or match) on the day value — reads more naturally than a chain of comparisons.

## Approach

1. **Receive Input:** Capture the integer input day from the user.
2. If the day is less than 1 or greater than 7, print "Invalid".
3. Otherwise, use a switch statement or if-else ladder to print the corresponding day of the week based on the day value.

Note: Earlier Python did not support switch-case statements. However, from Python 3.10 onwards, match-case was introduced similar to switch-case.

## Solution

```python solution time=O(1) space=O(1)
class Solution:
    # Function to determine the day of
    # the week based on day number
    def whichWeekDay(self, day: int) -> None:
        # Check if the day number is valid
        if day < 1 or day > 7:
            print("Invalid")
            return

        # Using match-case to print the corresponding day
        match day:
            case 1:
                print("Monday")
            case 2:
                print("Tuesday")
            case 3:
                print("Wednesday")
            case 4:
                print("Thursday")
            case 5:
                print("Friday")
            case 6:
                print("Saturday")
            case 7:
                print("Sunday")


# Reads the test case's day, e.g. 3
day = int(input())

# Create an instance of the Solution class
sol = Solution()

# Function call to determine the day
# of the week based on day number
sol.whichWeekDay(day)
```

```java solution time=O(1) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to determine the day of
        the week based on day number */
        void whichWeekDay(int day) {
            // Check if the day number is valid
            if (day < 1 || day > 7) {
                System.out.print("Invalid");
                return;
            }

            // Print the corresponding day of the week
            switch (day) {
                case 1: System.out.print("Monday"); break;
                case 2: System.out.print("Tuesday"); break;
                case 3: System.out.print("Wednesday"); break;
                case 4: System.out.print("Thursday"); break;
                case 5: System.out.print("Friday"); break;
                case 6: System.out.print("Saturday"); break;
                case 7: System.out.print("Sunday"); break;
            }
        }
    }

    public static void main(String[] args) {
        // Reads the test case's day, e.g. 3
        int day = new Scanner(System.in).nextInt();

        // Create an instance of the Solution class
        Solution sol = new Solution();

        // Function call to determine the day
        // of the week based on day number
        sol.whichWeekDay(day);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(1), The operations of receiving input and printing output are executed once regardless of the size of the input.

**Space Complexity:** O(1), We only store a single integer in the day variable, and no additional space is used that grows with the input size.
