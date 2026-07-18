---
title: "Print X N Numbers Of Times"
summary: "Print the value X on the screen N times, separated by single spaces — a first loop with an edge case at N = 0."
essential: true
kind: problem
difficulty: easy
topics: [basics, loops]
---

# Print X N Numbers Of Times

Given two integers X and N, print the value X on the screen N times.

- Separate each number by a single space.
- Do not add a space after the last number.
- After printing all N numbers, move to the next line.
- If N = 0, still move to the next line (print an empty line).

## Example 1

**Input:** X = 7, N = 5

**Output:**

```text
7 7 7 7 7
```

## Example 2

**Input:** X = 15, N = 1

**Output:**

```text
15
```

## Example 3

**Input:** X = -5, N = 4

**Output:**

```text
-5 -5 -5 -5
```

## Constraints

- `-100 <= X <= 100`
- `0 <= N <= 100`

```python run
class Solution:
    # Function to print the value X on the screen N times
    def printX(self, X: int, N: int) -> None:
        # Your code goes here — print X exactly N times, separated by single spaces.
        pass


# Reads the test case's X, then N
X = int(input())
N = int(input())
Solution().printX(X, N)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print the value X on the screen N times
        void printX(int X, int N) {
            // Your code goes here — print X exactly N times, separated by single spaces.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's X, then N
        Scanner sc = new Scanner(System.in);
        int X = sc.nextInt();
        int N = sc.nextInt();
        new Solution().printX(X, N);
    }
}
```

```testcases
{
  "args": [
    { "id": "X", "label": "X", "type": "int", "placeholder": "7" },
    { "id": "N", "label": "N", "type": "int", "placeholder": "5" }
  ],
  "cases": [
    { "args": { "X": "7", "N": "5" }, "expected": "7 7 7 7 7" },
    { "args": { "X": "15", "N": "1" }, "expected": "15" },
    { "args": { "X": "-5", "N": "4" }, "expected": "-5 -5 -5 -5" },
    { "args": { "X": "9", "N": "0" }, "expected": "" }
  ]
}
```
