---
title: "Input Output"
summary: "Read an integer from the user and print it back — the first program in any language."
essential: true
kind: problem
difficulty: easy
topics: [basics, io]
---

# Input Output

<div style="border-left:4px solid #15448e;background:rgba(21,68,142,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

📘 **Definition.** Complete the function printNumber which takes an integer input from the user and prints it on the screen.

</div>

## Usage

- **C++:** `cout << variable_name;`
- **Java:** `System.out.print();`
- **Python:** `print()`
- **JavaScript:** `console.log()`

## Example 1

**Input** (user gives value): 7

**Output:** 7

## Example 2

**Input** (user gives value): -5

**Output:** -5

## Example 3

**Input** (user gives value): 0

**Output:**

```
0
```

## Constraints

`-1000 <= User Input <= 1000`

```python run
class Solution:
    # Function to take input and display output
    def printNumber(self) -> None:
        # Your code goes here — read an integer and print it.
        pass


# Driver code
if __name__ == "__main__":
    Solution().printNumber()
```

```java run
import java.util.Scanner;

public class Main {
    static class Solution {
        // Function to take input and display output
        void printNumber(Scanner sc) {
            // Your code goes here — read an integer and print it.
        }
    }

    // Driver code
    public static void main(String[] args) {
        new Solution().printNumber(new Scanner(System.in));
    }
}
```

```testcases
{
  "args": [
    { "id": "n", "label": "User Input", "type": "int", "placeholder": "7" }
  ],
  "cases": [
    { "args": { "n": "7" }, "expected": "7" },
    { "args": { "n": "-5" }, "expected": "-5" },
    { "args": { "n": "0" }, "expected": "0" }
  ]
}
```
