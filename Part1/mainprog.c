#include <stdio.h>

static int A[2048];
static int B[2048];

int main(int argc, char** argv) {
    int n, i;

    scanf("%d", &n);
    int middle = 0;
    for (i = 0; i < n; ++i) {
        int el;
        scanf("%d", &el);
        A[i] = el;
        middle += el;
    }

    middle /= n;
    for (i = 0; i < n; ++i) {
        if (A[i] > middle) {
            B[i] = middle;
        } else {
            B[i] = A[i];
        }
    }

    for (i = 0; i < n; ++i) {
        printf("%d ", B[i]);
    }

    return 0;
}
