---
title: "If Else Adult Teen Problem"
summary: "Print Adult or Teen depending on whether an age crosses the 18 threshold."
essential: true
kind: problem
difficulty: easy
topics: [basics, conditionals]
---

# If Else Adult Teen Problem

Given an integer age, print on the screen:

Adult if age >= 18
Teen if age < 18
Do not change the case of any letter in "Adult" and "Teen" while printing the answer.

## Usage

- **C++:** `cout << variable_name<<endl;`
- **Java:** `System.out.println();`
- **Python:** `print()`
- **JavaScript:** `console.log()`

## Example 1

**Input:** age = 19

**Output:** Adult

**Explanation:** age is greater than or equal to 18.

## Example 2

**Input:** age = 7

**Output:** Teen

**Explanation:** age is less than 18.

## Example 3

**Input:** age = 18

**Output:** Adult

## Constraints

`0 <= age <= 100`

```python run
class Solution:
    # Function to check if the person is an adult or a teen
    def isAdult(self, age: int) -> None:
        # Your code goes here — print "Adult" if age >= 18, else "Teen".
        pass


# Reads the test case's age, e.g. 19
age = int(input())
Solution().isAdult(age)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to check if the person is an adult or a teen
        void isAdult(int age) {
            // Your code goes here — print "Adult" if age >= 18, else "Teen".
        }
    }

    public static void main(String[] args) {
        // Reads the test case's age, e.g. 19
        int age = new Scanner(System.in).nextInt();
        new Solution().isAdult(age);
    }
}
```

```testcases
{
  "args": [
    { "id": "age", "label": "age", "type": "int", "placeholder": "19" }
  ],
  "cases": [
    { "args": { "age": "19" }, "expected": "Adult" },
    { "args": { "age": "7" }, "expected": "Teen" },
    { "args": { "age": "18" }, "expected": "Adult" },
    { "args": { "age": "0" }, "expected": "Teen" }
  ]
}
```
