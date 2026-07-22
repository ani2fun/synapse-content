---
title: "Switch Case"
summary: "Print the weekday name for a day number 1-7, or Invalid otherwise."
essential: true
kind: problem
difficulty: easy
topics: [basics, conditionals]
---

# Switch Case

Given the integer day denoting the day number, print on the screen which day of the week it is. Week starts from Monday and for values greater than 7 or less than 1, print Invalid.

Ensure only the 1st letter of the answer is capitalised.

## Usage

- **C++:** `cout << variable_name;`
- **Java:** `System.out.print();`
- **Python:** `print()`
- **JavaScript:** `console.log()`

## Example 1

**Input:** day = 3

**Output:** Wednesday

## Example 2

**Input:** day = 8

**Output:** Invalid

## Example 3

**Input:** day = 2

**Output:**

```
Tuesday
```

## Constraints

`0 <= day <= 50`

```python run
class Solution:
    # Function to determine the day of the week based on day number
    def whichWeekDay(self, day: int) -> None:
        # Your code goes here — print the weekday name for day, or "Invalid".
        pass


# Reads the test case's day, e.g. 3
day = int(input())
Solution().whichWeekDay(day)
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to determine the day of the week based on day number
        void whichWeekDay(int day) {
            // Your code goes here — print the weekday name for day, or "Invalid".
        }
    }

    public static void main(String[] args) {
        // Reads the test case's day, e.g. 3
        int day = new Scanner(System.in).nextInt();
        new Solution().whichWeekDay(day);
    }
}
```
