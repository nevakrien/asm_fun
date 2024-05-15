#include <stdio.h>

typedef struct __attribute__((__packed__)) {
	char count;
	long long num;
} factor;

typedef struct __attribute__((__packed__)) {
//typedef struct {
	factor* factors;
	char length;
} factor_list;

extern long long x86_sqrt(long long x)  __attribute__((ms_abi));  // Adjust the declaration
extern factor_list x86_prime_factors(long long x)  __attribute__((ms_abi));




int main() {
    long long result = x86_sqrt(4);  // Call the assembly function and get the result
    printf("sqrt is: %lld\n", result);  // Print the result

    factor_list ans=x86_prime_factors(5);
    if(ans.factors==NULL){
    	perror("something went wrong got null\n");
    	return 1;
    }

    printf("we have %d factors\n",ans.length );
    for(int i=0;i<ans.length;i++){
    	factor f=ans.factors[i];
    	printf("%lld is a factor of multiplicity %d\n",f.num,f.count );
    }


    return 0;
}
