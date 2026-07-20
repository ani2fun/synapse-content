## Intuition

A string's last character sits at a fixed offset from the end, so indexing with `-1` (or `length - 1`) reaches it directly without scanning the string.

## Approach

1. Identify the last character of the string. Since strings are zero-indexed, the last character can be accessed using the index len(s) - 1, where len is the length of the string.
2. Return or print the last character.

## Solution

```python solution time=O(1) space=O(1)
class Solution:
    # Function to return the last character of the string
    def lastChar(self, s):

        # Return last character of string
        return s[-1]


# Reads the test case's s, e.g. "dog"
s = input()

# Creating an instance of Solution class
sol = Solution()

# Function call to get the last character of the string
ans = sol.lastChar(s)
print(ans)
```

```java solution time=O(1) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to return the last character of the string
        public char lastChar(String s) {

            // Return last character of string
            return s.charAt(s.length() - 1);
        }
    }

    public static void main(String[] args) {
        // Reads the test case's s, e.g. "dog"
        String s = new Scanner(System.in).nextLine();

        // Creating an instance of Solution class
        Solution sol = new Solution();

        // Function call to get the last character of the string
        char ans = sol.lastChar(s);
        System.out.println(ans);
    }
}
```

## Complexity Analysis

**Time Complexity:** O(1), Accessing the last character of the string takes constant time.

**Space Complexity:** O(1), No extra space is used apart from a few variables.
