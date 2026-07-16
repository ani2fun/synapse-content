---
title: "Print Last Character Of String"
summary: "Return the last character of a string using zero-based indexing."
essential: true
kind: problem
difficulty: easy
topics: [basics, strings]
---

# Print Last Character Of String

Given a string s. Return the last character of the given string s.

## Example 1

**Input:** s = "dog"

**Output:** g

**Explanation:** The last character of given string is "g".

## Example 2

**Input:** s = "goodforyou"

**Output:** u

**Explanation:** The last character of given string is "u".

## Example 3

**Input:** s = "lovecoding"

**Output:** g

## Constraints

- `1 <= s.length <= 100`
- `s consist of only lowercase English letters`

```python run
class Solution:
    # Function to return the last character of the string
    def lastChar(self, s: str) -> str:
        # Your code goes here — return the last character of s.
        pass


# Reads the test case's s, e.g. "dog"
s = input()
print(Solution().lastChar(s))
```

```java run
import java.util.*;

public class Main {
    static class Solution {
        // Function to return the last character of the string
        char lastChar(String s) {
            // Your code goes here — return the last character of s.
            return ' ';
        }
    }

    public static void main(String[] args) {
        // Reads the test case's s, e.g. "dog"
        String s = new Scanner(System.in).nextLine();
        System.out.println(new Solution().lastChar(s));
    }
}
```

```testcases
{
  "args": [
    { "id": "s", "label": "s", "type": "string", "placeholder": "dog" }
  ],
  "cases": [
    { "args": { "s": "dog" }, "expected": "g" },
    { "args": { "s": "goodforyou" }, "expected": "u" },
    { "args": { "s": "lovecoding" }, "expected": "g" },
    { "args": { "s": "a" }, "expected": "a" }
  ]
}
```
