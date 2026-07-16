---
title: "If Else If"
summary: "Grade a student's marks using a chain of if-else-if conditions."
essential: true
kind: problem
difficulty: easy
topics: [basics, conditionals]
---

# If Else If

Given marks of a student, print on the screen:

- Grade A if marks >= 90
- Grade B if marks >= 70
- Grade C if marks >= 50
- Grade D if marks >= 35
- Fail, otherwise.

## Usage

- **C++:** `cout << variable_name;`
- **Java:** `System.out.print();`
- **Python:** `print()`
- **JavaScript:** `console.log()`
- **C#:** `Console.WriteLine();`
- **Go:** `fmt.Println()`

## Example 1

**Input:** marks = 95

**Output:** Grade A

**Explanation:** marks are greater than or equal to 90.

## Example 2

**Input:** marks = 14

**Output:** Fail

**Explanation:** marks are less than 35.

## Example 3

**Input:** marks = 70

**Output:** Grade B

## Constraints

`0 <= marks <= 100`

```python run
class Solution:
    # Function to print the grades based on marks
    def studentGrade(self, marks: int) -> None:
        # Your code goes here — print the grade for the given marks.
        pass


# Reads the test case's marks, e.g. 95
marks = int(input())
Solution().studentGrade(marks)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to print the grades based on marks
        void studentGrade(int marks) {
            // Your code goes here — print the grade for the given marks.
        }
    }

    public static void main(String[] args) {
        // Reads the test case's marks, e.g. 95
        int marks = new Scanner(System.in).nextInt();
        new Solution().studentGrade(marks);
    }
}
```

```testcases
{
  "args": [
    { "id": "marks", "label": "marks", "type": "int", "placeholder": "95" }
  ],
  "cases": [
    { "args": { "marks": "95" }, "expected": "Grade A" },
    { "args": { "marks": "14" }, "expected": "Fail" },
    { "args": { "marks": "70" }, "expected": "Grade B" },
    { "args": { "marks": "50" }, "expected": "Grade C" }
  ]
}
```
