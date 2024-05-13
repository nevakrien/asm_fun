#include <stdio.h>

typedef struct __attribute__((__packed__)) {
	long long num;
	char count;
} factor;

typedef struct __attribute__((__packed__)) {
	factor* factors;
	char length;
} factor_list;

extern long long x86_sqrt(long long x)  __attribute__((ms_abi));  // Adjust the declaration
extern factor_list x86_prime_factors(long long x)  __attribute__((ms_abi));




int main() {
    long long result = x86_sqrt(1);  // Call the assembly function and get the result
    printf("Result: %lld\n", result);  // Print the result
    return 0;
}
