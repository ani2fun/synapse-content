## Intuition

To reverse a sequence, the first element must become the last, the second must become the second-to-last, and so on. Every character has a **mirror partner** equidistant from the opposite end. The operation reduces to swapping each pair.

Two pointers map directly onto that mirror structure. Place `left` at index `0` (the first character) and `right` at index `n − 1` (the last character) — they are exactly the first pair that needs to swap. After the swap, both step inward by one position, landing on the next pair. The loop ends when `left >= right`: the pointers have either met at the middle (odd length) or crossed (even length), and every mirror pair has been processed.

A single-pointer traversal breaks here. If you walk forward and overwrite `arr[i]` with `arr[n − 1 − i]`, the original `arr[i]` is gone before you can place it at index `n − 1 − i`. You'd need an `O(n)` temporary buffer to remember evicted values — exactly the brute-force cost the two-pointer template avoids by swapping atomically.

```viz widget=array
{
  "steps": [
    {
      "nodes": [
        { "id": "0", "label": "a", "kind": "cell", "meta": [], "slot": 0, "cardId": "", "layoutKind": "" },
        { "id": "1", "label": "e", "kind": "cell", "meta": [], "slot": 1, "cardId": "", "layoutKind": "" },
        { "id": "2", "label": "i", "kind": "cell", "meta": [], "slot": 2, "cardId": "", "layoutKind": "" },
        { "id": "3", "label": "o", "kind": "cell", "meta": [], "slot": 3, "cardId": "", "layoutKind": "" },
        { "id": "4", "label": "u", "kind": "cell", "meta": [], "slot": 4, "cardId": "", "layoutKind": "" }
      ],
      "edges": [],
      "cursor": [
        { "name": "left", "target": "0", "color": "#3b82f6" },
        { "name": "right", "target": "4", "color": "#f59e0b" }
      ],
      "highlight": [], "changed": [], "removed": [],
      "annotation": "Initial — left = 0, right = 4. Swap arr[left] and arr[right] (a ↔ u).",
      "line": 0, "frames": [], "cardCursor": []
    },
    {
      "nodes": [
        { "id": "0", "label": "u", "kind": "cell", "meta": [], "slot": 0, "cardId": "", "layoutKind": "" },
        { "id": "1", "label": "e", "kind": "cell", "meta": [], "slot": 1, "cardId": "", "layoutKind": "" },
        { "id": "2", "label": "i", "kind": "cell", "meta": [], "slot": 2, "cardId": "", "layoutKind": "" },
        { "id": "3", "label": "o", "kind": "cell", "meta": [], "slot": 3, "cardId": "", "layoutKind": "" },
        { "id": "4", "label": "a", "kind": "cell", "meta": [], "slot": 4, "cardId": "", "layoutKind": "" }
      ],
      "edges": [],
      "cursor": [
        { "name": "left", "target": "1", "color": "#3b82f6" },
        { "name": "right", "target": "3", "color": "#f59e0b" }
      ],
      "highlight": [], "changed": [], "removed": [],
      "annotation": "Move inward — left = 1, right = 3. Swap arr[left] and arr[right] (e ↔ o).",
      "line": 0, "frames": [], "cardCursor": []
    },
    {
      "nodes": [
        { "id": "0", "label": "u", "kind": "cell", "meta": [], "slot": 0, "cardId": "", "layoutKind": "" },
        { "id": "1", "label": "o", "kind": "cell", "meta": [], "slot": 1, "cardId": "", "layoutKind": "" },
        { "id": "2", "label": "i", "kind": "cell", "meta": [], "slot": 2, "cardId": "", "layoutKind": "" },
        { "id": "3", "label": "e", "kind": "cell", "meta": [], "slot": 3, "cardId": "", "layoutKind": "" },
        { "id": "4", "label": "a", "kind": "cell", "meta": [], "slot": 4, "cardId": "", "layoutKind": "" }
      ],
      "edges": [],
      "cursor": [
        { "name": "left", "target": "2", "color": "#3b82f6" },
        { "name": "right", "target": "2", "color": "#f59e0b" }
      ],
      "highlight": [], "changed": [], "removed": [],
      "annotation": "Pointers meet at index 2 — the middle element is its own mirror; no swap needed.",
      "line": 0, "frames": [], "cardCursor": []
    },
    {
      "nodes": [
        { "id": "0", "label": "u", "kind": "cell", "meta": [], "slot": 0, "cardId": "", "layoutKind": "" },
        { "id": "1", "label": "o", "kind": "cell", "meta": [], "slot": 1, "cardId": "", "layoutKind": "" },
        { "id": "2", "label": "i", "kind": "cell", "meta": [], "slot": 2, "cardId": "", "layoutKind": "" },
        { "id": "3", "label": "e", "kind": "cell", "meta": [], "slot": 3, "cardId": "", "layoutKind": "" },
        { "id": "4", "label": "a", "kind": "cell", "meta": [], "slot": 4, "cardId": "", "layoutKind": "" }
      ],
      "edges": [], "cursor": [],
      "highlight": [], "changed": [], "removed": [],
      "annotation": "Done — arr is reversed: [u, o, i, e, a].",
      "line": 0, "frames": [], "cardCursor": []
    }
  ],
  "title": "Reversing [a, e, i, o, u] in place with two pointers"
}
```

<p align="center"><strong>Flipping <code>[a, e, i, o, u]</code> in place — two swaps reverse the array; the middle element at index 2 is its own mirror.</strong></p>

## Applying the Diagnostic Questions

| Check | Answer for Flip Characters |
|---|---|
| ✅ Two positions simultaneously? | Yes — `arr[left]` and `arr[right]` are read and swapped together at every step |
| ✅ One near start, one near end? | Yes — `left = 0`, `right = n-1` |
| ✅ Both move inward? | Yes — `left++`, `right--` after every swap |
| ✅ Simple work at each step? | Yes — one swap per iteration |

Every box is checked with nothing extra needed. This is the purest direct application — the template and the algorithm are identical.

## Brute Force

The most direct idea: **build a reversed copy, then write it back**. Walk a fresh array from the end of the original toward the front, then overwrite the input with it. It is obviously correct and easy to reason about.

The catch is the temporary array: it costs **O(n) extra space**, which the problem's *"O(1) extra space"* constraint explicitly forbids. Two passes over `n` elements also do twice the memory traffic of the in-place swap. Reach for this only to confirm the answer, then optimise the space away.

```python solution
from typing import List

class Solution:
    def flip_characters(self, arr: List[str]) -> None:
        n = len(arr)

        # Build a reversed COPY: reversed_copy[i] is the element that
        # belongs at index i after the reversal.
        reversed_copy = [arr[n - 1 - i] for i in range(n)]

        # Write it back over the input, in place of the originals.
        for i in range(n):
            arr[i] = reversed_copy[i]


# Reads the test case's arr, e.g. [a, e, i, o, u]
inner = input().strip()[1:-1].strip()
arr = [t.strip() for t in inner.split(",")] if inner else []
Solution().flip_characters(arr)
print("[" + ", ".join(arr) + "]")
```

```java solution
import java.util.*;

public class Main {
    static class Solution {
        void flipCharacters(char[] arr) {
            int n = arr.length;

            // Build a reversed COPY, then write it back over the input.
            char[] copy = new char[n];
            for (int i = 0; i < n; i++) copy[i] = arr[n - 1 - i];
            for (int i = 0; i < n; i++) arr[i] = copy[i];
        }
    }

    public static void main(String[] args) {
        char[] arr = parseCharArray(new Scanner(System.in).nextLine());
        new Solution().flipCharacters(arr);
        System.out.println(Arrays.toString(arr));
    }

    // "[a, e, i]" → {'a', 'e', 'i'} — reads the test case's arr
    static char[] parseCharArray(String line) {
        String inner = line.trim().replaceAll("^\\[|\\]$", "").trim();
        if (inner.isEmpty()) return new char[0];
        String[] parts = inner.split(",");
        char[] out = new char[parts.length];
        for (int i = 0; i < parts.length; i++) out[i] = parts[i].trim().charAt(0);
        return out;
    }
}
```

**Time O(n)** — two linear passes. **Space O(n)** — the temporary copy is the whole point of what we fix next.

## Optimal — Two Pointers

Skip the copy entirely. `left` and `right` are the two ends of the current mirror pair; swapping them places **both** characters in their final positions in a single step, so no evicted value ever needs remembering. Walk the pointers inward until they meet or cross.

```python solution time=O(n) space=O(1)
from typing import List

class Solution:
    def flip_characters(self, arr: List[str]) -> None:

        # Initialize two pointers, one pointing to the beginning of the
        # array and the other pointing to the end of the array
        left: int = 0
        right = len(arr) - 1

        # Use a while loop to traverse the array using the two pointers
        while left < right:

            # Swap the characters pointed by the left and right pointers
            arr[left], arr[right] = arr[right], arr[left]

            # Move the pointers towards the center of the array
            left  += 1
            right -= 1


# Reads the test case's arr, e.g. [a, e, i, o, u]
inner = input().strip()[1:-1].strip()
arr = [t.strip() for t in inner.split(",")] if inner else []
Solution().flip_characters(arr)
print("[" + ", ".join(arr) + "]")
```

```java solution time=O(n) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        void flipCharacters(char[] arr) {

            // Initialize two pointers, one pointing to the beginning of the
            // array and the other pointing to the end of the array
            int left  = 0;
            int right = arr.length - 1;

            // Use a while loop to traverse the array using the two pointers
            while (left < right) {

                // Swap the characters pointed by the left and right pointers
                char tmp     = arr[left];
                arr[left]    = arr[right];
                arr[right]   = tmp;

                // Move the pointers towards the center of the array
                left++;
                right--;
            }
        }
    }

    public static void main(String[] args) {
        char[] arr = parseCharArray(new Scanner(System.in).nextLine());
        new Solution().flipCharacters(arr);
        System.out.println(Arrays.toString(arr));
    }

    // "[a, e, i]" → {'a', 'e', 'i'} — reads the test case's arr
    static char[] parseCharArray(String line) {
        String inner = line.trim().replaceAll("^\\[|\\]$", "").trim();
        if (inner.isEmpty()) return new char[0];
        String[] parts = inner.split(",");
        char[] out = new char[parts.length];
        for (int i = 0; i < parts.length; i++) out[i] = parts[i].trim().charAt(0);
        return out;
    }
}
```

**Time O(n)** — `n/2` swaps. **Space O(1)** — just the two index variables. This is the answer the constraint asks for.

## Dry Run — Example 1

`arr = [a, e, i, o, u]`, `n = 5`

| Iteration | `left` | `right` | Swap | Array after swap |
|---|---|---|---|---|
| 1 | 0 | 4 | `a ↔ u` | `[u, e, i, o, a]` |
| 2 | 1 | 3 | `e ↔ o` | `[u, o, i, e, a]` |
| — | 2 | 2 | `left ≥ right` — stop | `[u, o, i, e, a]` ✓ |

The middle element at index 2 (`i`) is its own mirror — no swap needed.

## Complexity Comparison

| Approach | Time | Space | In-place? | Passes |
|---|---|---|---|---|
| **Brute Force** (reversed copy) | O(n) | **O(n)** | No — temp array | 2 |
| **Optimal** (two pointers) | O(n) | **O(1)** | Yes | ½ |

Both are linear in time — the win is entirely in space. The two-pointer version does half the passes and allocates nothing, which is why it satisfies the O(1)-space constraint the brute force violates.

## Edge Cases

| Scenario | Input | Output | Note |
|---|---|---|---|
| Empty array | `[]` | `[]` | `left = 0 > right = -1` — loop never runs |
| Single character | `[A]` | `[A]` | `left = right = 0` — loop never runs |
| Two characters | `[A, B]` | `[B, A]` | One swap, then `left = right = 1` — stops |
| Even length | `[A, B, C, D]` | `[D, C, B, A]` | All pairs swapped, no middle element |
| Odd length | `[A, B, C]` | `[C, B, A]` | Two pairs swapped, middle `B` unchanged |

## Key Takeaway

Flip Characters is the two-pointer reversal applied to a character array — mechanics identical to reversing integers, only the element type differs. The brute-force reversed-copy always works and is a fine sanity check, but two pointers turn its O(n) space into O(1) by swapping mirror pairs atomically. Every future two-pointer problem is a variation on this same swap-and-converge core.
