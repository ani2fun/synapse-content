## Brute Force

### Intuition

Given a number n, a brute force approach would be to iterate from 1 to n checking each value if it divides n without leaving a remainder. For each divisor found, store it in a list and return the result.

### Approach

1. Initialize an array/list to store the divisors.
2. Iterate from 1 to n, and check if the current value is a divisor of n or not. Add the value to the array/list if it is a divisor.
3. The array/list stores all the divisors of n.

```python solution time=O(N) space=O(K)
class Solution:
    # Function to find all
    # divisors of n
    def divisors(self, n):
        
        # To store the divisors
        ans = []
        
        # Iterate from 1 to n
        for i in range(1, n + 1):
            
            # If a divisor is found
            if n % i == 0:
                # Add it to the answer
                ans.append(i)
        
        # Return the result
        return ans

# Reads the test case's n
n = int(input())

# Creating an instance of 
# Solution class
sol = Solution()

# Function call to find 
# all divisors of n
ans = sol.divisors(n)

print("[" + ", ".join(map(str, ans)) + "]")
```

```java solution time=O(N) space=O(K)
import java.util.*;

public class Main {
    static class Solution {
        /* Function to find all 
        divisors of n */
        public int[] divisors(int n) {
            
            // Initial size of the array is set to n
            int[] temp = new int[n];
            int count = 0;
            
            // Iterate from 1 to n
            for (int i = 1; i <= n; i++) {
                
                // If a divisor is found
                if (n % i == 0) {
                    // Add it to the array
                    temp[count++] = i;
                }
            }
            
            /* Copy the divisors to an 
            array of the exact size */
            int[] ans = Arrays.copyOf(temp, count);
            
            // Return the result
            return ans;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        
        /* Creating an instance of 
        Solution class */
        Solution sol = new Solution();
        
        /* Function call to find 
        all divisors of n */
        int[] ans = sol.divisors(n);
        
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ans.length; i++) {
            sb.append(ans[i]);
            if (i < ans.length - 1) sb.append(", ");
        }
        sb.append("]");
        System.out.println(sb);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(N) – Iterating N times, and performing constant time operations in each pass.

**Space Complexity:** O(K), where K is the number of divisors of N. In the worst case, K is at most O(sqrt(N)), since divisors come in pairs.

## Optimal 1

### Intuition

The previous approach can be optimized by using the property that for any non-negative integer n, if d is a divisor of n then n/d (known as counterpart divisor) is also a divisor of n. This property is symmetric about the square root of n by traversing just the first half we can avoid redundant iteration and computations improving the efficiency of the algorithm.

### Approach

1. Initialize an array/list to store the divisors.
2. Iterate from 1 to sqrt(n), and check if the current value is a divisor of n or not. Add the value to the array/list if it is a divisor. Also, add the counterpart divisor to the array/list if it is different from the current divisor.
3. The array/list stores all the divisors of n. Sort the list and return the result.

```python solution time=O(sqrt(N)+K*log(K)) space=O(sqrt(N))
import math

class Solution:
    # Function to find all 
    # divisors of n
    def divisors(self, n):
        
        # To store the divisors
        ans = []
        
        sqrtN = int(math.sqrt(n))
        
        # Iterate from 1 to sqrtN
        for i in range(1, sqrtN + 1):
            
            # If a divisor is found
            if n % i == 0:
                # Add it to the answer
                ans.append(i)
                
                # Add the counterpart divisor
                # if it's different from i
                if i != n // i:
                    ans.append(n // i)
        
        # Sorting the result 
        ans.sort()
        
        # Return the result
        return ans

# Reads the test case's n
n = int(input())

# Creating an instance of 
# Solution class 
sol = Solution()

# Function call to find 
# all divisors of n
ans = sol.divisors(n)

print("[" + ", ".join(map(str, ans)) + "]")
```

```java solution time=O(sqrt(N)+K*log(K)) space=O(sqrt(N))
import java.util.*;

public class Main {
    static class Solution {
        public int[] divisors(int n) {
            
            // To store the divisors
            int[] temp = new int[n]; // Temporary array with max possible size
            int count = 0;
            
            int sqrtN = (int) Math.sqrt(n);
            
            // Iterate from 1 to sqrtN
            for (int i = 1; i <= sqrtN; i++) {
                
                // If a divisor is found
                if (n % i == 0) {
                    // Add it to the answer
                    temp[count++] = i;
                    
                    /* Add the counterpart divisor
                     if it's different from i */
                    if (i != n / i) {
                        temp[count++] = n / i;
                    }
                }
            }
            
            // Copy only the filled part of temp to the result array
            int[] ans = Arrays.copyOf(temp, count);
            
            // Sorting the result 
            Arrays.sort(ans);
            
            // Return the result
            return ans;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        
        // Creating an instance of Solution class 
        Solution sol = new Solution(); 
        
        // Function call to find all divisors of n
        int[] ans = sol.divisors(n);
        
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ans.length; i++) {
            sb.append(ans[i]);
            if (i < ans.length - 1) sb.append(", ");
        }
        sb.append("]");
        System.out.println(sb);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(sqrt(N)) + O(K*Log(K)) – Iterating sqrt(N) times, and performing constant time operations in each pass to get all the divisors in the list. Sorting the list of divisors takes O(K*Log(K)) time where K is the number of divisors of the number.

**Space Complexity:** O(sqrt(N)) – A number N can have at max 2*sqrt(N) divisors, which are stored in the array.

## Optimal 2

### Intuition

The sorting step can be avoided by understanding how divisors are formed. Every divisor usually comes with another divisor as its pair.

For example, for 36, when we find 2, we also get 18 because 2×18 = 36. So, while checking numbers only up to the square root, we can collect both divisors at the same time.

The smaller divisors will automatically come in increasing order because we are checking numbers from left to right. The paired larger divisors will come in reverse order because the first small divisor gives the largest paired divisor. So, we keep the larger divisors separately and add them from the end later. This gives the final sorted list without calling sort().

### Approach

1. Create two separate lists: one to store the smaller divisors and another to store their larger paired divisors.
2. Check every number from 1 up to the square root of the given number.
3. Whenever a number divides the given number completely, add it to the smaller divisors list.
4. Also add its paired divisor to the larger divisors list, but only if both divisors are different.
5. Since the larger divisors are collected in reverse order, add them to the answer from the back.
6. Return the final list, which is already sorted in increasing order.

```python solution time=O(sqrt(N)) space=O(K)
class Solution:
    # Function to find all divisors of n
    def divisors(self, n):
        # Stores smaller divisors in increasing order
        small_divisors = []

        # Stores larger divisors in decreasing order
        large_divisors = []

        # Start checking from 1
        i = 1

        # Iterate only till square root of n
        while i * i <= n:
            # Check if i is a divisor of n
            if n % i == 0:
                small_divisors.append(i)

                # Add counterpart divisor if it is different
                if i != n // i:
                    large_divisors.append(n // i)

            i += 1

        # Add larger divisors in reverse order
        for divisor in reversed(large_divisors):
            small_divisors.append(divisor)

        return small_divisors

# Reads the test case's n
n = int(input())

# Creating an instance of Solution class 
sol = Solution()

# Function call to find all divisors of n
ans = sol.divisors(n)

print("[" + ", ".join(map(str, ans)) + "]")
```

```java solution time=O(sqrt(N)) space=O(K)
import java.util.*;

public class Main {
    static class Solution {
        // Function to find all divisors of n
        public int[] divisors(int n) {
            // Stores smaller divisors in increasing order
            ArrayList<Integer> smallDivisors = new ArrayList<>();

            // Stores larger paired divisors in decreasing order
            ArrayList<Integer> largeDivisors = new ArrayList<>();

            // Check numbers only up to the square root of n
            for (int i = 1; i * i <= n; i++) {
                // If i divides n completely, it is a divisor
                if (n % i == 0) {
                    smallDivisors.add(i);

                    // Add the paired divisor only if it is different
                    if (i != n / i) {
                        largeDivisors.add(n / i);
                    }
                }
            }

            // Add larger divisors in reverse order to maintain sorted order
            for (int i = largeDivisors.size() - 1; i >= 0; i--) {
                smallDivisors.add(largeDivisors.get(i));
            }

            // Create the final answer array
            int[] result = new int[smallDivisors.size()];

            // Copy all divisors from list to array
            for (int i = 0; i < smallDivisors.size(); i++) {
                result[i] = smallDivisors.get(i);
            }

            // Return the sorted divisors
            return result;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n
        int n = new Scanner(System.in).nextInt();
        
        // Creating an instance of Solution class 
        Solution sol = new Solution(); 
        
        // Function call to find all divisors of n
        int[] ans = sol.divisors(n);
        
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ans.length; i++) {
            sb.append(ans[i]);
            if (i < ans.length - 1) sb.append(", ");
        }
        sb.append("]");
        System.out.println(sb);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(sqrt(N)), because we check possible divisors only up to the square root of the number and avoid the extra sorting step.

**Space Complexity:** O(K), where K is the number of divisors stored in the answer list. The extra list used for larger divisors is also part of the output-building process.
