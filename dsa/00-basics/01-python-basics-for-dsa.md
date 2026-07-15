---
title: "Python Basics"
summary: "A friendly, from-scratch introduction to Python: installing it, writing your first program, core syntax, and the built-in libraries you need for data structures and algorithms."
essential: true
---

# Python Basics

Python is like learning to ride a bicycle.

- First time: Scary, wobbly, might fall
- After practice: Smooth, fun, you wonder why you were scared

Let's begin your Python journey.

## What is Python?

### Simple Definition

<div style="border-left:4px solid #15448e;background:rgba(21,68,142,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

📘 **Definition.** Python is a **PROGRAMMING LANGUAGE** - a way to talk to computers.

</div>

- Computer understands only 0s and 1s (binary)
- We need a translator (programming language)
- Python is that translator

## Why Python?

Python is like the **EASIEST** language to learn.

Think of programming languages like languages:

- C++ = Like learning Chinese (hard, complex)
- Java = Like learning French (medium difficulty)
- Python = Like learning Hindi if you know English (easy, similar words)

Python is:

- Easy to read (looks almost like English)
- Simple to write (less rules, less confusion)
- Very popular (used by Google, Netflix, Instagram)
- Powerful (can build websites, apps, AI, games)

### Real Life Analogy - The Friendly Teacher

Imagine two teachers:

- Teacher A: Speaks complex words, strict rules, hard to understand
- Teacher B: Speaks simple words, explains clearly, makes learning fun

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** Python is Teacher B. It's designed to be beginner-friendly.

</div>

## What Can You Build with Python?

- Websites (Instagram, Pinterest use Python)
- Games (like simple mobile games)
- Data analysis (finding patterns in data)
- AI and Machine Learning (ChatGPT uses Python!)
- Automation (making computer do repetitive tasks)
- Mobile apps (with frameworks)

But for now, focus on learning basics. Big projects come later.

## Installing Python - Setting Up Your Tools

### Before You Start

You need Python installed on your computer. Like you need a pen to write, you need Python to write Python programs.

### Step-by-Step Installation

**For Windows:**

1. Go to python.org
2. Click "Downloads"
3. Download Python 3.x (latest version)
4. Run the installer
5. **IMPORTANT:** Check "Add Python to PATH" (very important!)
6. Click "Install Now"
7. Wait for installation
8. Done!

**For Mac:**

1. Python usually comes pre-installed
2. Open Terminal
3. Type: `python3 --version`
4. If you see a version number, Python is installed!
5. If not, go to python.org and download

**For Linux:**

1. Open terminal
2. Type: `sudo apt install python3`
3. Enter password
4. Wait for installation
5. Done!

### How to Check if Python is Installed

1. Open Command Prompt (Windows) or Terminal (Mac/Linux)
2. Type: `python --version` (or `python3 --version`)
3. If you see something like "Python 3.11.5", you're good!
4. If you see "command not found", Python is not installed

### Don't Worry

If installation seems hard, it's okay. Ask for help.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** Everyone struggles with installation the first time. Once it's done, you never have to do it again.

</div>

## What is a Python Interpreter?

### Simple Definition

<div style="border-left:4px solid #15448e;background:rgba(21,68,142,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

📘 **Definition.** An **INTERPRETER** is like a **TRANSLATOR** that converts your Python code into something the computer understands.

</div>

Remember the analogy from Lecture 1?

- You speak Hindi
- Computer speaks only 0s and 1s
- Interpreter is the translator in between

### How It Works

1. You write Python code (in English-like words)
2. Interpreter reads your code
3. Interpreter converts it to 0s and 1s
4. Computer executes it
5. You see the result

### Real Life Analogy - The Restaurant Waiter

You (customer) → Waiter (interpreter) → Chef (computer)

1. You order: "I want biryani" (Python code)
2. Waiter understands and tells chef: "One biryani" (translation)
3. Chef makes biryani (computer executes)
4. Waiter brings it to you (result shown)

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Insight.** The interpreter is like that waiter - it understands both you and the computer.

</div>

### Two Ways to Use Python

**Interactive Mode (Python Shell):**

- Type code, see result immediately
- Like a calculator - type, get answer
- Good for: Testing small code, learning

**Script Mode (Python File):**

- Write code in a file
- Save it
- Run the entire file
- Good for: Writing programs, saving work

We'll use both. Don't worry, you'll understand as we go.

## Code Editors - Where You Write Code

### What is a Code Editor?

<div style="border-left:4px solid #15448e;background:rgba(21,68,142,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

📘 **Definition.** A **CODE EDITOR** is like a special notebook for writing code.

</div>

Think of it like:

- Microsoft Word = For writing documents
- Code Editor = For writing code

### Why Not Use Notepad?

You **CAN** use Notepad, but code editors are better because they:

- Show colors (makes code easier to read)
- Find mistakes (like spell-check)
- Auto-complete (suggests words as you type)
- Format code (makes it look neat)

### Popular Code Editors

- **VS Code (Visual Studio Code)** - **RECOMMENDED FOR BEGINNERS**
  - Free
  - Easy to use
  - Works on all computers
  - Very popular
- **PyCharm**
  - Made specifically for Python
  - Free version available
  - A bit complex for beginners
- **Sublime Text**
  - Simple and fast
  - Free to try
- **IDLE (comes with Python)**
  - Simple
  - Good for absolute beginners
  - Limited features

### Recommendation

Start with VS Code. It's the most beginner-friendly and widely used.

### How to Install VS Code

1. Go to code.visualstudio.com
2. Download for your computer (Windows/Mac/Linux)
3. Install it (just click Next, Next, Install)
4. Open VS Code
5. Done!

You don't need to learn everything about VS Code now. Just install it. We'll learn as we use it.

## Your First Python Program - Hello World!

### The Tradition

Every programmer's first program is "Hello World" - printing "Hello, World!" on screen. It's like a tradition. Like saying "Namaste" when you meet someone.

Let's do it!

### Method 1: Using Python Shell (Interactive Mode)

```python
print("Hello, World!")
```

You'll see: `Hello, World!`

That's it! Your first program!

### What Just Happened?

- `print` = A command that shows text on screen
- `("Hello, World!")` = The text you want to show
- The quotes tell Python: "This is text, not code"

Think of print like:

- A megaphone that announces what you say
- You say "Hello, World!" into megaphone
- Everyone hears "Hello, World!"

### Method 2: Using a File (Script Mode)

```python
print("Hello, World!")
```

1. Open VS Code (or any text editor)
2. Create a new file
3. Save it as: `hello.py` (the .py means it's a Python file)
4. Type the code above
5. Save the file
6. Open terminal in VS Code
7. Type: `python hello.py` (or `python3 hello.py`)
8. You'll see: `Hello, World!`

### Congratulations!

You just wrote and ran your first Python program! You're officially a programmer now. Welcome to the club!

### Let's Try More

```python
print("My name is Python")
print("I am learning programming")
print(2 + 3)
print("2 + 3 =", 2 + 3)
```

See? Python can do math too! We'll learn more soon.

## Python Extension for VS Code

**What is an Extension?** An **EXTENSION** is like an add-on that makes VS Code better for Python.

**Why Install Python Extension?** Without it, VS Code doesn't know you're writing Python (no colors, no help). With it, you get colors, suggestions, and specific Python support.

**How to Install:**

1. Open VS Code
2. Click the Extensions icon (left side, looks like 4 squares)
3. Search: "Python"
4. Click "Install" on the one by Microsoft (official one)

## Linting - Finding Mistakes Automatically

**LINTING** is like a spell-checker for code. It finds mistakes before you run your program.

```python
# Wrong code:
prnt("Hello")  # Linter will show check error here!

# Correct code:
print("Hello") # No error
```

## Formatting - Making Code Look Nice

**FORMATTING** is making your code look neat and organized.

```python
# Unformatted Code (Hard to read)
x=5
y=10
if x
```

VS Code can format automatically: Right-click > "Format Document".

## Running Python Code - Different Ways

- **Python Shell:** Type `python` in terminal. Good for testing small code.
- **Running a File:** Type `python filename.py`. Good for actual programs.
- **Using VS Code:** Click the "Run" button (play icon). Most convenient.

## Implementations & Execution

Just use CPython (standard Python). When execution happens, your code goes through: Code -> Interpreter -> Bytecode -> Virtual Machine -> Result.

## Variables - Storing Information

<div style="border-left:4px solid #15448e;background:rgba(21,68,142,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

📘 **Definition.** A **VARIABLE** is like a **BOX** that stores information.

</div>

```python
name = "Alex"           # string
age = 25               # int
city = "Mumbai"        # string

print("My name is", name)
print(name, "is", age, "years old")
print(name, "lives in", city)
```

**Rules:** Must start with letter/underscore. No spaces. Case sensitive.

## Strings - Working with Text

A **STRING** is text data in Python. Anything inside quotes.

```python
name = "Alex"
# Concatenation
print("Hello " + name)

# Repetition
print("Hello " * 3)

# Length
print(len(name)) # 3
```

## Escape Sequences - Special Characters

**ESCAPE SEQUENCES** are special characters that do special things.

- `\n` = New line
- `\t` = Tab
- `\\` = Backslash
- `\"` = Double quote
- `\'` = Single quote

```python
print("Line 1\nLine 2")
print("Name:\tAlex")
print("He said \"Hello\"")
```

## Formatted Strings (f-strings)

Use f-strings to insert variables into text. This is the recommended way.

```python
name = "Alex"
age = 25
print(f"My name is {name} and I am {age} years old")
```

## String Methods

```python
text = "  Hello World  "
print(text.upper())      # HELLO WORLD
print(text.lower())      # hello world
print(text.strip())      # Hello World (removes spaces)
print(text.replace("World", "Python")) # Hello Python
print(text.find("World")) # 8
```

## Numbers and Operations

```python
print(10 + 5)   # 15 (Add)
print(10 - 5)   # 5 (Subtract)
print(10 * 5)   # 50 (Multiply)
print(10 / 3)   # 3.333 (Division)
print(10 // 3)  # 3 (Floor Division)
print(10 % 3)   # 1 (Modulus/Remainder)
print(2 ** 3)   # 8 (Power)
```

## Type Conversion

Changing data from one type to another.

```python
age = "25"
age_num = int(age) # Converts string to int

price = 99.99
price_str = str(price) # Converts float to string
```

## Comparison Operators

Compare two values and return True or False.

- `==` Equal to
- `!=` Not equal to
- `>` Greater than
- `<` Less than
- `>=` Greater than or equal to
- `<=` Less than or equal to

```python
print(5 == 5)   # True
print(5 != 3)   # True
print(5 > 3)    # True
```

## Conditional Statements

Making decisions.

```python
marks = 85

if marks >= 90:
    print("Grade A")
elif marks >= 80:
    print("Grade B")
else:
    print("Grade C")
```

## Ternary Operator

Short way to write if-else.

```python
age = 20
status = "Adult" if age >= 18 else "Minor"
print(status) # Adult
```

## Logical Operators

Combine conditions: `and`, `or`, `not`.

```python
age = 20
has_id = True
if age >= 18 and has_id:
    print("Can enter")
```

## Advanced Conditionals

**Short-circuit:** Python stops checking if the result is known early.

**Chaining:** You can chain comparisons.

```python
age = 25
if 18 <= age <= 65:
    print("Working age")
```

## For Loops

Repeating actions.

```python
# Print numbers 0 to 4
for i in range(5):
    print(i)

# Print items in list
for fruit in ["apple", "banana"]:
    print(fruit)
```

## For Loop with Else

The `else` block runs after the loop finishes successfully (without hitting a `break`).

```python
for i in range(3):
    print(i)
else:
    print("Loop done!")
```

## Nested Loops

A loop inside another loop.

```python
for i in range(2):
    for j in range(2):
        print(i, j)
```

## Iterables

An **ITERABLE** is anything you can loop over (like a list, string, or range).

## While Loops

Repeat until condition becomes False.

```python
i = 1
while i <= 5:
    print(i)
    i = i + 1  # Important: Update i!
```

## Infinite Loops

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **Watch out.** A loop that never ends. Be careful! Press Ctrl + C to stop it.

</div>

```python
while True:
    print("This will run forever")
    # Press Ctrl+C to stop
```

## Functions

Reusable code blocks.

```python
def greet(name):
    print(f"Hello, {name}!")

greet("Alex")   # Output: Hello, Alex!
greet("Priya") # Output: Hello, Priya!
```

## Function Arguments

Arguments are values sent to the function.

### Types of Functions

- **Built-in:** Provided by Python (`print()`, `len()`, `range()`)
- **User-defined:** Created by you (`def my_func():`)

## Keyword Arguments

You can send arguments with the `key = value` syntax.

```python
def my_func(c1, c2, c3):
    print(c3 + " is smartest")

my_func(c1="Emil", c2="Tobias", c3="Linus")
```

## Default Arguments

If we call the function without argument, it uses the default value.

```python
def my_func(country="India"):
    print("I am from " + country)

my_func("Sweden")
my_func() # Uses default "India"
```

## `*args` (Arbitrary Arguments)

If you don't know how many arguments will be passed, use `*args`.

```python
def my_func(*kids):
    print("The youngest child is " + kids[2])

my_func("Emil", "Tobias", "Linus")
```

## Exercises

1. Print your name and age.
2. Create a calculator (+, -, *, /).
3. Check if a number is even or odd.
4. Print numbers from 1 to 10 using a loop.
5. Write a function to greet someone.

## Key Takeaways

- Python is easy and powerful.
- Indentation is important.
- Variables store data.
- Loops repeat actions.
- Functions reuse code.

## Common Mistakes to Avoid

- Forgetting colons (:)
- Wrong indentation
- misspelled variable names
- Confusing = (assign) and == (compare)

## Final Message

You have taken the first step.

"The journey of a thousand miles begins with a single step." - Lao Tzu

Keep coding, keep learning!

## Summary

- Variables store data
- Strings are text, numbers are numbers
- `if/else` makes decisions
- Loops repeat code
- Functions organize and reuse code

Programming is practice. Keep writing code!

## Python Libraries for DSA & Problem-Solving

(Your Toolkit for Problem Solving)

### Welcome to Python Libraries!

Python provides powerful built-in libraries for data structures and algorithms. Comparable to C++ STL or Java Collections - essential tools for DSA!

### Reasons to Learn

- Save time (pre-written, optimized code)
- Essential to know (expected knowledge)
- Makes DSA problems easier
- Industry standard

## Built-in Functions - Common Operations

### Sorting

`sorted(iterable, key=None, reverse=False)`

- Returns new sorted list
- `key`: function to determine sort order
- `reverse`: True for descending

**Examples:**

```python
arr = [3, 1, 4, 1, 5]
sorted(arr)                    # [1, 1, 3, 4, 5]
sorted(arr, reverse=True)      # [5, 4, 3, 1, 1]

arr = [-3, 1, -4, 2, -1]
sorted(arr, key=lambda x: abs(x))   # [1, -1, 2, -3, -4]

# Sort list in-place
arr.sort()                     # Modifies original list

# Sort by custom key
words = ["apple", "pie", "banana"]
sorted(words, key=len)         # ['pie', 'apple', 'banana']
```

### Min/Max

- `min(iterable, key=None)`: Minimum value
- `max(iterable, key=None)`: Maximum value

**Examples:**

```python
min([3, 1, 4, 1, 5])           # 1
max([3, 1, 4, 1, 5])           # 5
```

### Sum/Product

- `sum(iterable, start=0)`: Sum of elements
- For product, use: `functools.reduce` or `math.prod`

**Examples:**

```python
sum([1, 2, 3, 4])              # 10
sum([1, 2, 3], 10)             # 16 (starts from 10)

import math
math.prod([2, 3, 4])          # Product: 24 (Python 3.8+)
```

### Length/Count

- `len(iterable)`: Length/count
- `count = iterable.count(value)`: Count occurrences

**Examples:**

```python
len([1, 2, 3])                 # 3
"hello".count('l')             # 2
```

### Any/All

- `any(iterable)`: True if any element is True
- `all(iterable)`: True if all elements are True

**Examples:**

```python
any([False, True, False])       # True
all([True, True, True])        # True
any([])                        # False (empty is False)
```

### Enumerate

`enumerate(iterable, start=0)`: Returns (index, value) pairs

**Examples:**

```python
for i, val in enumerate([10, 20, 30]):
    print(i, val)              # 0 10, 1 20, 2 30
list(enumerate(['a', 'b', 'c']))  # [(0, 'a'), (1, 'b'), (2, 'c')]
list(enumerate(['a', 'b'], 1))     # [(1, 'a'), (2, 'b')] (start=1)
```

### Zip

`zip(*iterables)`: Combine multiple iterables

**Examples:**

```python
list(zip([1, 2], [3, 4]))      # [(1, 3), (2, 4)]
list(zip([1, 2, 3], [4, 5]))   # [(1, 4), (2, 5)] (stops at shortest)
list(zip([1, 2], [3, 4], [5, 6]))  # [(1, 3, 5), (2, 4, 6)]
```

### Reversed

`reversed(iterable)`: Reverse iterator

**Examples:**

```python
list(reversed([1, 2, 3]))     # [3, 2, 1]
"hello"[::-1]                  # "olleh" (string slicing)
```

### Range

- `range(stop)`: 0 to stop-1
- `range(start, stop)`: start to stop-1
- `range(start, stop, step)`: with step

**Examples:**

```python
list(range(5))                 # [0, 1, 2, 3, 4]
list(range(1, 5))              # [1, 2, 3, 4]
list(range(0, 10, 2))          # [0, 2, 4, 6, 8]
```

## Collections Module - Specialized Data Structures

**Import:**

```python
from collections import deque, Counter, defaultdict, OrderedDict, namedtuple
```

### DEQUE - Double-Ended Queue

Fast add/remove from both ends (O(1))

**Methods:**

```python
d = deque([1, 2, 3])
d.append(4)                    # Add to right: deque([1, 2, 3, 4])
d.appendleft(0)                # Add to left: deque([0, 1, 2, 3, 4])
d.pop()                        # Remove from right: returns 4
d.popleft()                    # Remove from left: returns 0
d.extend([5, 6])               # Extend from right: deque([1, 2, 3, 5, 6])
d.extendleft([-1, 0])         # Extend from left: deque([0, -1, 1, 2, 3])
d.rotate(2)                    # Rotate 2 steps right: deque([2, 3, 0, -1, 1])
d.rotate(-1)                   # Rotate 1 step left: deque([3, 0, -1, 1, 2])
len(d)                         # Length: 5
d[0]                           # Access by index: 3
```

**When to Use:**

- Queue/Stack implementation
- Sliding window problems
- BFS traversal
- Fast add/remove from both ends

### COUNTER - Frequency Counter

Counts occurrences automatically

**Methods:**

```python
c = Counter([1, 2, 2, 3, 3, 3])
c[2]                           # Get count: 2
c[5]                           # Get count (not found): 0
c.most_common(2)               # Top 2: [(3, 3), (2, 2)]
list(c.elements())             # All elements: [1, 2, 2, 3, 3, 3]
c.update([3, 4])               # Add counts: Counter({3: 4, 2: 2, 1: 1, 4: 1})
c.subtract([2, 2])             # Subtract: Counter({3: 4, 1: 1, 4: 1, 2: 0})
c2 = Counter([3, 4, 4])
c + c2                         # Add: Counter({3: 5, 4: 3, 1: 1})
c - c2                         # Subtract: Counter({3: 3, 1: 1})
c & c2                         # Intersection (min): Counter({3: 1, 4: 1})
c | c2                         # Union (max): Counter({3: 4, 4: 2, 1: 1})
```

**When to Use:**

- Frequency counting
- Most common elements
- Anagram problems
- Frequency-based problems

### DEFAULTDICT - Dictionary with Defaults

Never raises KeyError, creates default value

**Methods:**

```python
dd = defaultdict(int)           # Default: 0
dd['a']                        # Returns 0 (auto-created)
dd['a'] += 1                   # Now dd['a'] = 1

dd_list = defaultdict(list)    # Default: []
dd_list['fruits'].append('apple')  # Auto-creates list
dd_list['fruits']              # ['apple']

dd_set = defaultdict(set)       # Default: set()
dd_set['nums'].add(1)          # Auto-creates set
dd_set['nums']                 # {1}

dd_custom = defaultdict(lambda: "N/A")  # Custom default
dd_custom['missing']           # Returns "N/A"
```

**When to Use:**

- Grouping elements
- Building graphs
- Avoiding KeyError checks
- Counting with auto-initialization

### ORDEREDDICT - Ordered Dictionary

Maintains insertion order (Python 3.7+ dicts also do this)

**Methods:**

```python
od = OrderedDict([('a', 1), ('b', 2), ('c', 3)])
od['d'] = 4                    # Set value: OrderedDict([('a',1), ('b',2), ('c',3), ('d',4)])
od.move_to_end('a')            # Move to end: OrderedDict([('b',2), ('c',3), ('d',4), ('a',1)])
od.move_to_end('c', last=False) # Move to beginning: OrderedDict([('c',3), ('b',2), ('d',4), ('a',1)])
od.popitem()                   # Remove last: returns ('a', 1)
od.popitem(last=False)         # Remove first: returns ('c', 3)
```

**When to Use:**

- LRU Cache implementation
- Need ordered dictionary
- Special pop operations

### NAMEDTUPLE - Named Tuples

Tuples with named fields (immutable, lightweight)

**Methods:**

```python
Point = namedtuple('Point', ['x', 'y'])
p = Point(1, 2)                # Create: Point(x=1, y=2)
p.x                            # Access by name: 1
p.y                            # Access by name: 2
p[0]                           # Access by index: 1
p[1]                           # Access by index: 2
# Immutable: p.x = 3  # ERROR! Cannot modify
```

**When to Use:**

- Lightweight data structures
- Return multiple values
- Immutable records
- Dictionary keys

## Heapq - Priority Queue

**Import:**

```python
import heapq
```

**Note:** Creates MIN-HEAP (smallest at top)

**Functions:**

```python
heap = []
heapq.heappush(heap, 3)         # Push: heap = [3]
heapq.heappush(heap, 1)         # Push: heap = [1, 3]
heapq.heappush(heap, 2)         # Push: heap = [1, 3, 2]
heapq.heappop(heap)             # Pop smallest: returns 1, heap = [2, 3]
arr = [3, 1, 4, 1, 5]
heapq.heapify(arr)              # Convert to heap: arr = [1, 1, 4, 3, 5]
heapq.heappushpop(heap, 0)      # Push 0 then pop: returns 0
heapq.heapreplace(heap, 5)       # Pop then push 5: returns 2
heap[0]                         # Get smallest: 3 (without removing)
heapq.nlargest(3, [1,2,3,4,5])   # 3 largest: [5, 4, 3]
heapq.nsmallest(2, [3,1,4,1,5])  # 2 smallest: [1, 1]
```

**Max-Heap Trick:**

```python
max_heap = []
heapq.heappush(max_heap, -10)   # Push negated: [-10]
heapq.heappush(max_heap, -5)    # Push negated: [-10, -5]
max_val = -heapq.heappop(max_heap)  # Pop and negate: returns 10
```

**When to Use:**

- Priority queue
- K largest/smallest elements
- Merge K sorted lists
- Dijkstra's algorithm

## Bisect - Binary Search

**Import:**

```python
import bisect
```

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **Watch out.** Note: arr must be sorted!

</div>

**Functions:**

```python
arr = [1, 3, 3, 3, 5, 7]
bisect.bisect_left(arr, 3)      # Leftmost position: 1
bisect.bisect_left(arr, 4)      # Position to insert 4: 4
bisect.bisect_right(arr, 3)     # Rightmost position: 4
bisect.bisect(arr, 3)           # Same as bisect_right: 4
arr = [1, 3, 5]
bisect.insort_left(arr, 2)      # Insert at leftmost: [1, 2, 3, 5]
bisect.insort_right(arr, 3)     # Insert at rightmost: [1, 2, 3, 3, 5]
bisect.insort(arr, 4)           # Same as insort_right: [1, 2, 3, 3, 4, 5]
```

**When to Use:**

- Binary search
- Maintain sorted list
- Find insertion position
- Range queries

## Itertools - Iteration Tools

**Import:**

```python
import itertools
```

**Functions:**

```python
list(itertools.combinations([1,2,3], 2))      # [(1,2), (1,3), (2,3)]
list(itertools.combinations_with_replacement([1,2], 2))  # [(1,1), (1,2), (2,2)]
list(itertools.permutations([1,2], 2))        # [(1,2), (2,1)]
list(itertools.product([1,2], [3,4]))         # [(1,3), (1,4), (2,3), (2,4)]
list(itertools.cycle([1,2,3]))[:7]            # [1,2,3,1,2,3,1] (first 7)
list(itertools.repeat(5, 3))                  # [5, 5, 5]
list(itertools.chain([1,2], [3,4], [5]))      # [1, 2, 3, 4, 5]
list(itertools.accumulate([1,2,3,4]))        # [1, 3, 6, 10] (cumulative sum)
list(itertools.accumulate([1,2,3,4], lambda x,y: x*y))  # [1, 2, 6, 24]
groups = itertools.groupby([1,1,2,2,2,3])
[(k, list(g)) for k, g in groups]            # [(1, [1,1]), (2, [2,2,2]), (3, [3])]
```

**When to Use:**

- Generate combinations/permutations
- Cartesian products
- Grouping elements
- Complex iteration patterns

## Functools - Function Tools

**Import:**

```python
import functools
```

**Functions:**

```python
# LRU Cache
@functools.lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2: return n
    return fibonacci(n-1) + fibonacci(n-2)
fibonacci(10)                                  # First call: computes
fibonacci(10)                                  # Second call: uses cache (instant!)

# Reduce
from functools import reduce
reduce(lambda x, y: x + y, [1, 2, 3, 4])      # Sum: 10
reduce(lambda x, y: x * y, [1, 2, 3, 4])      # Product: 24
reduce(lambda x, y: x + y, [1, 2, 3], 10)     # With initial: 16

# Partial
def multiply(x, y): return x * y
double = functools.partial(multiply, 2)
double(5)                                      # 10 (2 * 5)
triple = functools.partial(multiply, 3)
triple(4)                                      # 12 (3 * 4)

# Wraps (preserves function metadata)
def my_decorator(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper
```

**When to Use:**

- Memoization (caching)
- Function composition
- Reducing sequences
- Function manipulation

## Math Module - Mathematical Operations

**Import:**

```python
import math
```

**Constants:**

- `math.pi` (3.14...)
- `math.e` (2.71...)

**Functions:**

```python
math.sqrt(16)                  # Square root: 4.0
math.pow(2, 3)                 # 2^3: 8.0
math.factorial(5)              # 5!: 120
math.gcd(48, 18)               # GCD: 6
math.lcm(12, 8)                # LCM: 24 (Python 3.9+)
math.log(math.e)               # Natural log: 1.0
math.log10(100)                # Base 10 log: 2.0
math.log2(8)                   # Base 2 log: 3.0
math.sin(math.pi/2)            # sin(90°): 1.0
math.cos(0)                    # cos(0°): 1.0
math.degrees(math.pi)          # Radians to degrees: 180.0
math.radians(180)              # Degrees to radians: 3.14159...
math.ceil(4.3)                # Ceiling: 5
math.floor(4.7)                # Floor: 4
math.isfinite(10)              # Check if finite: True
math.isinf(float('inf'))       # Check if infinite: True
```

**When to Use:**

- Mathematical calculations
- GCD/LCM
- Prime checking
- Distance calculations

## Random Module - Randomness

**Import:**

```python
import random
```

**Functions:**

```python
random.random()                # Float in [0.0, 1.0): 0.123456...
random.randint(1, 10)           # Integer in [1, 10]: 7 (example)
random.randrange(0, 10, 2)     # Even numbers 0-8: 4 (example)
random.choice([1, 2, 3, 4])    # Random element: 3 (example)
random.sample([1,2,3,4,5], 3)  # 3 random elements: [2, 5, 1] (example)
arr = [1, 2, 3, 4, 5]
random.shuffle(arr)            # Shuffle in-place: arr = [3, 1, 5, 2, 4] (example)
random.uniform(1.0, 10.0)      # Float in [1.0, 10.0]: 5.678... (example)
```

**When to Use:**

- Generate test cases
- Shuffle arrays
- Random sampling
- Testing algorithms

## String Module - String Constants

**Import:**

```python
import string
```

**Constants:**

```python
string.ascii_lowercase         # 'abcdefghijklmnopqrstuvwxyz'
string.ascii_uppercase         # 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
string.ascii_letters           # Lowercase + uppercase
string.digits                  # '0123456789'
string.hexdigits               # '0123456789abcdefABCDEF'
string.punctuation             # All punctuation
string.whitespace              # Space, tab, newline, etc.
```

**When to Use:**

- Character validation
- String filtering
- Character set operations

## List Methods - Common Operations

**Methods:**

```python
lst = [1, 2, 3]
lst.append(4)                  # Add to end: [1, 2, 3, 4]
lst.extend([5, 6])             # Extend: [1, 2, 3, 4, 5, 6]
lst.insert(0, 0)              # Insert at index 0: [0, 1, 2, 3, 4, 5, 6]
lst.remove(3)                  # Remove first 3: [0, 1, 2, 4, 5, 6]
lst.pop()                      # Remove last: returns 6, lst = [0, 1, 2, 4, 5]
lst.pop(0)                     # Remove at index 0: returns 0, lst = [1, 2, 4, 5]
lst.index(2)                   # Index of 2: 1
lst.count(2)                   # Count of 2: 1
lst.sort()                     # Sort: [1, 2, 4, 5]
lst.sort(reverse=True)         # Sort descending: [5, 4, 2, 1]
lst.reverse()                  # Reverse: [1, 2, 4, 5]
lst.clear()                    # Clear: []
lst = [1, 2, 3]
lst2 = lst.copy()              # Shallow copy: [1, 2, 3]
```

## Dict Methods - Dictionary Operations

**Methods:**

```python
d = {'a': 1, 'b': 2}
d['a']                         # Get value: 1
d['c']                         # KeyError (missing key)
d.get('a')                     # Get value: 1
d.get('c', 0)                  # Get with default: 0
d['c'] = 3                     # Set value: {'a': 1, 'b': 2, 'c': 3}
d.update({'d': 4})             # Update: {'a': 1, 'b': 2, 'c': 3, 'd': 4}
d.pop('c')                     # Remove and return: 3
d.pop('x', -1)                 # Remove with default: -1 (key not found)
d.popitem()                    # Remove last: ('d', 4)
list(d.keys())                 # View of keys: ['a', 'b']
list(d.values())               # View of values: [1, 2]
list(d.items())                # View of pairs: [('a', 1), ('b', 2)]
d.clear()                      # Clear: {}
d = {'a': 1, 'b': 2}
'a' in d                       # Check if key exists: True
d2 = d.copy()                  # Shallow copy: {'a': 1, 'b': 2}
```

## Set Methods - Set Operations

**Methods:**

```python
s = {1, 2, 3}
s.add(4)                        # Add element: {1, 2, 3, 4}
s.remove(2)                    # Remove: {1, 3, 4}
s.remove(5)                     # KeyError (not found)
s.discard(3)                    # Remove: {1, 4}
s.discard(5)                    # No error (not found): {1, 4}
s.pop()                         # Remove arbitrary: returns 1, s = {4}
s.clear()                       # Clear: set()
s = {1, 2, 3}
s2 = s.copy()                   # Shallow copy: {1, 2, 3}
```

**Operations:**

```python
s1 = {1, 2, 3}
s2 = {3, 4, 5}
s1 | s2                         # Union: {1, 2, 3, 4, 5}
s1 & s2                         # Intersection: {3}
s1 - s2                         # Difference: {1, 2}
s1 ^ s2                         # Symmetric difference: {1, 2, 4, 5}
{1, 2} <= s1                    # Subset: True
s1 >= {1, 2}                    # Superset: True
```

## String Methods - String Operations

**Methods:**

```python
s = "Hello World"
s.upper()                       # Uppercase: "HELLO WORLD"
s.lower()                       # Lowercase: "hello world"
s.capitalize()                  # First letter capital: "Hello world"
s.title()                       # Title case: "Hello World"
"  hello  ".strip()             # Remove whitespace: "hello"
s.split()                       # Split by space: ['Hello', 'World']
s.split('l')                    # Split by 'l': ['He', '', 'o Wor', 'd']
"-".join(['a', 'b', 'c'])       # Join: "a-b-c"
s.replace('World', 'Python')    # Replace: "Hello Python"
s.find('World')                 # Find index: 6
s.find('xyz')                  # Not found: -1
s.index('World')                # Find index: 6
s.index('xyz')                 # ValueError (not found)
s.startswith('Hello')          # Check prefix: True
s.endswith('World')            # Check suffix: True
s.count('l')                   # Count occurrences: 3
"abc".isalpha()                 # All alphabetic: True
"123".isdigit()                 # All digits: True
"abc123".isalnum()              # Alphanumeric: True
```

**Slicing:**

```python
s = "Hello"
s[1:4]                          # Slice: "ell"
s[:3]                           # From start: "Hel"
s[2:]                           # To end: "llo"
s[::-1]                         # Reverse: "olleH"
s[::2]                          # Every 2nd char: "Hlo"
```

## Common Algorithms - Quick Reference

### Sorting

```python
# List sorting
arr.sort()                      # In-place
sorted_arr = sorted(arr)        # New list

# Custom sorting
arr.sort(key=lambda x: x[1])    # Sort by second element
arr.sort(key=len)               # Sort by length

# Multiple criteria
arr.sort(key=lambda x: (x[1], x[0]))  # Sort by second, then first
```

### Searching

```python
# Linear search
target in arr                   # O(n) - check existence
arr.index(target)               # O(n) - get index

# Binary search (sorted array)
import bisect
pos = bisect.bisect_left(arr, target)  # O(log n)
```

### Finding Min/Max

```python
min(arr)                        # Minimum
max(arr)                        # Maximum
min(arr, key=len)               # Minimum by key
max(arr, key=len)               # Maximum by key
```

### Counting

```python
# Using Counter
from collections import Counter
counter = Counter(arr)
counter.most_common(k)         # K most common

# Manual counting
freq = {}
for item in arr:
    freq[item] = freq.get(item, 0) + 1
```

### Grouping

```python
# Using defaultdict
from collections import defaultdict
groups = defaultdict(list)
for item in arr:
    groups[key].append(item)
```

### Filtering

```python
filtered = [x for x in arr if condition]  # List comprehension
filtered = filter(lambda x: condition, arr)  # Filter function
```

### Mapping

```python
mapped = [func(x) for x in arr]  # List comprehension
mapped = map(func, arr)          # Map function
```

### Reducing

```python
from functools import reduce
result = reduce(lambda x, y: x + y, arr)  # Sum
result = reduce(lambda x, y: x * y, arr)  # Product
```

## When to Use Which - Quick Guide

- Use **DEQUE** for: Queue/Stack operations, Sliding window, BFS traversal, fast add/remove from both ends.
- Use **COUNTER** for: Frequency counting, most common elements, anagram problems.
- Use **DEFAULTDICT** for: Grouping elements, building graphs, avoiding KeyError.
- Use **HEAPQ** for: Priority queue, K largest/smallest, merge K sorted lists.
- Use **BISECT** for: Binary search, maintaining sorted list, range queries.
- Use **ITERTOOLS** for: Combinations/permutations, Cartesian products, grouping consecutive.
- Use **FUNCTOOLS** for: Memoization needed, function composition, reducing sequences.

## Common Coding Patterns

### Pattern 1: Two Sum

```python
seen = {}
for i, num in enumerate(nums):
    if target - num in seen:
        return [seen[target - num], i]
    seen[num] = i
```

### Pattern 2: Group Anagrams

```python
from collections import defaultdict
groups = defaultdict(list)
for s in strs:
    groups[''.join(sorted(s))].append(s)
return list(groups.values())
```

### Pattern 3: Top K Frequent

```python
from collections import Counter
counter = Counter(nums)
return [num for num, _ in counter.most_common(k)]
```

### Pattern 4: LRU Cache

```python
from collections import OrderedDict
cache = OrderedDict()
cache.move_to_end(key)          # Mark as recently used
cache.popitem(last=False)       # Remove least recent
```

### Pattern 5: Sliding Window

```python
from collections import deque
dq = deque()
dq.popleft()                    # Remove out of window
dq.pop()                        # Remove smaller elements
dq.append(i)                    # Add current
```

## Key Takeaways

### Essential Libraries

- **Collections:** deque, Counter, defaultdict, OrderedDict, namedtuple
- **Heapq:** priority queue
- **Bisect:** binary search
- **Itertools:** combinations, permutations
- **Functools:** lru_cache, reduce
- **Math:** GCD, LCM, sqrt, etc.
- **Built-in functions:** sorted, min, max, sum, etc.

### Remember

- Know when to use which library
- Understand time complexities
- Practice common patterns
- Read documentation when needed
