#include <stdio.h>
#include <stdlib.h>
int main() 
{
    int n, m;
    printf("enter n: ");
    scanf("%d", &n);
    printf("enter m: ");
    scanf("%d", &m);
    int array[n][m];
    int i, j;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
            array[i][j] = rand()%100;
        }
    }
    printf("array\n");
    for (i=0; i<n; i++) {
        for(j=0; j<m; j++)
        {
            printf("%d ", array[i][j]);
        }
    printf("\n");
    }

    FILE *file = fopen("z1.txt", "w");
    if (file == NULL) {
        perror("Error");
        return 1;
    }
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            fprintf(file, "%d ", array[i][j]);
        }
        fprintf(file, "\n"); 
    }
    fclose(file);
}