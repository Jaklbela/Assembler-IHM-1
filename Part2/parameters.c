#include <stdio.h>
#include <malloc.h>

int* create_array(int* A, int middle, int size) {
    int* B = (int*)malloc(sizeof(int) * size);
    for (int i = 0; i < size; ++i) {
        if (A[i] > middle) {
            B[i] = middle;
        } else {
            B[i] = A[i];
        }
    }
    return B;
}

int main(int argc, char** argv) {
    int n;
    int* A;

    scanf("%d", &n);
    A = (int*)malloc(sizeof(int) * n);

    int middle = 0;
    for (int i = 0; i < n; ++i) {
        int el;
        scanf("%d", &el);
        A[i] = el;
        middle += el;
    }

    middle /= n;
    int* B = create_array(A, middle, n);

    for (int i = 0; i < n; ++i) {
        printf("%d ", B[i]);
    }

    return 0;
}
