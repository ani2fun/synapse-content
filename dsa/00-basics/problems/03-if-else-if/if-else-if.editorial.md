## Intuition

The grade bands never overlap and are naturally ordered by descending cutoff, so checking them from the highest threshold down and stopping at the first match assigns the correct grade with a single chain of comparisons.

## Approach

1. **Receive Input:** Capture the integer input marks from the user.
2. **Conditional Check:** If marks are greater than or equal to 90, print "Grade A".
3. If marks are greater than or equal to 70 but less than 90, print "Grade B".
4. If marks are greater than or equal to 50 but less than 70, print "Grade C".
5. If marks are greater than or equal to 35 but less than 50, print "Grade D".
6. If marks are less than 35, print "Fail".

## Solution

```python solution time=O(1) space=O(1)
class Solution:
    # Function to print the grades based on marks
    def studentGrade(self, marks):

        # If else ladder
        if marks >= 90:
            print("Grade A")
        elif marks >= 70:
            print("Grade B")
        elif marks >= 50:
            print("Grade C")
        elif marks >= 35:
            print("Grade D")
        else:
            print("Fail")

if __name__ == "__main__":
    # Creating an instance of Solution class
    solution = Solution()

    # Taking marks as input from user
    marks = int(input())

    # Function call to print the grades based on marks
    solution.studentGrade(marks)
```

```java solution time=O(1) space=O(1)
import java.util.Scanner;

public class Main {
    static class Solution {
        // Function to print the grades based on marks
        void studentGrade(int marks) {

            // If else ladder
            if (marks >= 90) {
                System.out.print("Grade A");
            } else if (marks >= 70) {
                System.out.print("Grade B");
            } else if (marks >= 50) {
                System.out.print("Grade C");
            } else if (marks >= 35) {
                System.out.print("Grade D");
            } else {
                System.out.print("Fail");
            }
        }
    }

    public static void main(String[] args) {
        // Creating an instance of Solution class
        Solution solution = new Solution();

        // Taking marks as input from user
        Scanner sc = new Scanner(System.in);
        int marks = sc.nextInt();

        // Function call to print the grades based on marks
        solution.studentGrade(marks);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(1), The operations of receiving input and printing output are executed once regardless of the size of the input.

**Space Complexity:** O(1), Using only a single variable to store marks, and no additional space is used that grows with the input size.
