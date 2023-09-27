#include <stdio.h>

void main(int argc, char *argv[])
{
    FILE *file = fopen(argv[1], "r");
    if (file == NULL)
    {
        perror("error");
    }
    int cntStr = 0;
    int lenStr = 0;
    while (!feof(file))
    {
        if (fgetc(file) == '\n')
        {
            cntStr++;
        }
        else
        {
            lenStr++;
        }
    }
    int j = 0;
    char Origintext[cntStr][lenStr]; 
    fseek(file, 0, SEEK_SET);        
    while (!feof(file))
    {
        fgets(Origintext[j], lenStr - 1, file);
        j++;
    }
    fclose(file);              
    file = fopen(argv[1], "w"); 
    printf("enter text\n");
    char txtNew[256];
    fgets(txtNew, 256, stdin);
    fputs(txtNew, file);
    for (int i = 0; i < cntStr; i++)
    {
        fputs(Origintext[i], file);
    }
    fclose(file);
}