## Brute

### Intuition

In a naive approach to finding the LCM of two given numbers, the multiples of the larger number (considering multiples of the larger number instead of the smaller number will trim unfruitful iterations) can be checked if it is common for both numbers. Any such multiple found will be common to both the given numbers, and that will be the required LCM.

### Approach

1. Initialize a variable lcm to store the LCM of given numbers.
2. Run a loop finding all the multiples of greater number and in every pass, check if the multiple is common for both numbers. If found common, store the multiple as lcm and terminate the loop.
3. The LCM for the two numbers will be stored in variable lcm.

### Solution

```python solution time=O(min(N1,N2)) space=O(1)
class Solution:
    # Function to find LCM of n1 and n2
    def LCM(self, n1, n2):
        # Variable to store lcm
        lcm = 0
        
        # Variable to store max of n1 & n2
        n = max(n1, n2)
        i = 1
        
        while True:
            # Variable to store multiple
            mul = n * i
            
            # Checking if multiple is common
            # common for both n1 and n2
            if mul % n1 == 0 and mul % n2 == 0:
                lcm = mul
                break
            i += 1
        
        # Return the stored LCM
        return lcm

# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to get LCM of n1 and n2
ans = sol.LCM(n1, n2)
print(ans)
```

```java solution time=O(min(N1,N2)) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to find LCM of n1 and n2
        public int LCM(int n1, int n2) {
            // Variable to store lcm
            int lcm;

            // Variable to store max of n1 & n2
            int n = Math.max(n1, n2);
            int i = 1;

            while (true) {
                // Variable to store multiple
                int mul = n * i;

                /* Checking if multiple is common
                common for both n1 and n2 */
                if (mul % n1 == 0 && mul % n2 == 0) {
                    lcm = mul;
                    break;
                }
                i++;
            }

            // Return the stored LCM
            return lcm;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        // Function call to get LCM of n1 and n2
        int ans = sol.LCM(n1, n2);
        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(min(N1, N2)) – In the worst-case scenario, when n1 and n2 are coprime, the loop runs for O(n1 * n2 / max(n1, n2)) iterations which is equivalent to O(min(n1, n2)).

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.

## Optimal

### Intuition

The optimal way to find LCM to two numbers is by finding their GCD and using the formula:
lcm(n1, n2) = (n1 * n2) / gcd(n1, n2).

### Approach

1. Find the GCD of two numbers and store it in some variable.
2. The LCM for the two numbers can be found directly using the formula mentioned above.

### Solution

```python solution time=O(log(min(N1,N2))) space=O(1)
class Solution:
    # Function to find the GCD of two numbers
    def GCD(self, n1, n2):
        
        # Continue loop as long as both 
        # n1 and n2 are greater than zero
        while n1 > 0 and n2 > 0:
            
            # If n1 is greater than n2, perform
            # modulo operation - n1 % n2
            if n1 > n2:
                n1 = n1 % n2
            
            # Else perform modulo
            # operation - n2 % n1
            else:
                n2 = n2 % n1
        
        # If n1 is zero, GCD is stored in n2
        if n1 == 0:
            return n2
        
        # else GCD is stored in n1
        return n1
    
    # Function to find LCM of n1 and n2
    def LCM(self, n1, n2):
        # Function call to find gcd
        gcd = self.GCD(n1, n2)
        
        lcm = (n1 * n2) // gcd
        
        # Return the LCM
        return lcm

# Reads the test case's n1, then n2
n1 = int(input())
n2 = int(input())

# Creating an instance of Solution class
sol = Solution()

# Function call to get LCM of n1 and n2
ans = sol.LCM(n1, n2)
print(ans)
```

```java solution time=O(log(min(N1,N2))) space=O(1)
import java.util.*;

public class Main {
    static class Solution {
        // Function to find the GCD of two numbers
        private int GCD(int n1, int n2) {

            /* Continue loop as long as both
             n1 and n2 are greater than zero */
            while (n1 > 0 && n2 > 0) {

                /* If n1 is greater than n2, perform
                 modulo operation - n1 % n2 */
                if (n1 > n2) {
                    n1 = n1 % n2;
                }

                /* Else perform modulo
                operation - n2 % n1 */
                else {
                    n2 = n2 % n1;
                }
            }

            // If n1 is zero, GCD is stored in n2
            if (n1 == 0) return n2;

            // else GCD is stored in n1
            return n1;
        }

        // Function to find LCM of n1 and n2
        public int LCM(int n1, int n2) {
            // Function call to find gcd
            int gcd = GCD(n1, n2);

            int lcm = (n1 * n2) / gcd;

            // Return the LCM
            return lcm;
        }
    }

    public static void main(String[] args) {
        // Reads the test case's n1, then n2
        Scanner sc = new Scanner(System.in);
        int n1 = sc.nextInt();
        int n2 = sc.nextInt();

        /* Creating an instance of
        Solution class */
        Solution sol = new Solution();

        // Function call to get LCM of n1 and n2
        int ans = sol.LCM(n1, n2);
        System.out.println(ans);
    }
}
```

### Complexity Analysis

**Time Complexity:** O(log(min(N1, N2))) – Finding GCD of two numbers, along with some constant time opeations

**Space Complexity:** O(1) – Using a couple of variables i.e., constant space.
