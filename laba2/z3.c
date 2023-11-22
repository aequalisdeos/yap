#include <stdio.h>
#include <stdlib.h>
struct Product {
    char name[50];
    float price;
};
void sortProducts(struct Product *products, int numProducts) {
    for (int i = 0; i < numProducts - 1; i++) {
        for (int j = 0; j < numProducts - i - 1; j++) {
            if (products[j].price > products[j + 1].price) {
                // Обмен значениями
                struct Product temp = products[j];
                products[j] = products[j + 1];
                products[j + 1] = temp;
            }
        }
    }
}
int main() {
    FILE *inputFile = fopen("z3.txt", "r");
    if (inputFile == NULL) {
        fprintf(stderr, "error\n");
        return 1;
    }
    int numProducts = 0;
    char name[50];
    float price;
    while (fscanf(inputFile, "%s%f", name, &price) == 2) {
        numProducts++;
    }
    struct Product *products = (struct Product *)malloc(numProducts * sizeof(struct Product));
    fseek(inputFile, 0, SEEK_SET);
    for (int i = 0; i < numProducts; i++) {
        fscanf(inputFile, "%s%f", products[i].name, &products[i].price);
    }
    fclose(inputFile);
    sortProducts(products, numProducts);
    FILE *outputFile = fopen("z3_output.txt", "w");
    if (outputFile == NULL) {
        fprintf(stderr, "error\n");
        free(products);
        return 1;
    }
    for (int i = 0; i < numProducts; i++) {
        fprintf(outputFile, "%s %.2f\n", products[i].name, products[i].price);
    }
    fclose(outputFile);
    free(products);
    return 0;
}
