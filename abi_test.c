#include <stddef.h>

typedef struct __attribute__((__packed__)) {
    long long num;
    char count;
} factor;

typedef struct __attribute__((__packed__)) {
    factor* factors;
    char length;
} factor_list;


// Definition without attribute
__attribute__((ms_abi)) factor_list x86_prime_factors(long long x) {
    return (factor_list) {NULL, 10};
}
