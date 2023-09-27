#include <stdio.h>
#include <stdlib.h>
int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Use: %s <name_file>\n", argv[0]);
        return 1; 
    }
    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        perror("Error");
        return 1;
    }
    int ch;
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
    }
    fclose(file);
    return 0;
}
