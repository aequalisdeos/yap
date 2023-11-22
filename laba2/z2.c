#include <stdio.h>
#include <stdlib.h>
int main() 
{
    int n, m;
    printf("enter n: ");
    scanf("%d", &n);
    printf("enter m: ");
    scanf("%d", &m);
    float array[n][m];
    int i, j;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
            array[i][j] = (float)rand() / RAND_MAX;
        }
    }
    printf("array\n");
    for (i=0; i<n; i++) {
        for(j=0; j<m; j++)
        {
            printf("%.6f ", array[i][j]);
        }
    printf("\n");
    }
    float flatArray[n * m];
    int index = 0;
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            flatArray[index++] = array[i][j];
        }
    }
    // bubble sort
    for (int i = 0; i < n * m - 1; i++) {
        for (int j = 0; j < n * m - i - 1; j++) {
            if (flatArray[j] > flatArray[j + 1]) {
                float temp = flatArray[j];
                flatArray[j] = flatArray[j + 1];
                flatArray[j + 1] = temp;
            }
        }
    }
    printf("sorted array\n");
    index = 0;
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            array[i][j] = flatArray[index++];
            printf("%.6f ", array[i][j]);
        }
        printf("\n");
    }
    FILE *file = fopen("z2.txt", "w");
    if (file == NULL) {
        fprintf(stderr, "error\n");
        return 1;
    }
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            fprintf(file, "%.6f ", array[i][j]);
        }
        fprintf(file, "\n");
    }
    fclose(file);
    return 0;
}