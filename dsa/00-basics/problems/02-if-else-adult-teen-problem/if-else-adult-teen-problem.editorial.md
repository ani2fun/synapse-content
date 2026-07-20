## Intuition

Whether a person is an Adult or a Teen collapses to a single comparison against the age-18 threshold, so one `if-else` branch on `age >= 18` is enough to pick between the two outcomes.

## Approach

1. Receive Input: Capture the integer input age from the user.
2. If age is greater than or equal to 18, print "Adult".
3. Otherwise, print "Teen".

## Solution

```python solution time=O(1) space=O(1)
class Solution:
    ''' Function to check if the person
    is an adult or a teen '''
    def isAdult(self, age):

        # If age is greater than or equal to 18
        if age >= 18:
            # The person is an adult
            print("Adult")

        # Otherwise
        else:
            # The person is a teen
            print("Teen")

if __name__ == "__main__":
    # Creating an instance of Solution class
    solution = Solution()

    # Take age as input
    age = int(input())

    ''' Function call to check if the person
    is an adult or a teen '''
    solution.isAdult(age)
```

```java solution time=O(1) space=O(1)
import java.util.Scanner;

public class Main {
    static class Solution {
        /* Function to check if the person
        is an adult or a teen */
        public void isAdult(int age) {

            // If age is greater than or equal to 18
            if (age >= 18) {
                // The person is an adult
                System.out.println("Adult");
            }

            // Otherwise
            else {
                // The person is a teen
                System.out.println("Teen");
            }
        }
    }

    public static void main(String[] args) {
        // Creating an instance of Solution class
        Solution solution = new Solution();

        // Take age as input
        Scanner sc = new Scanner(System.in);
        int age = sc.nextInt();

        /* Function call to check if the person
        is an adult or a teen */
        solution.isAdult(age);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(1), The operations of receiving input and printing output are executed once regardless of the size of the input.

**Space Complexity:** O(1), Using only a single variable to store the age, and no other additional space is used that grows with the input size.
