#include <stdio.h>
int main()
{
    double a, b, c, x;
    printf("enter a: ");
    scanf("%lf", &a);
    printf("enter b: ");
    scanf("%lf", &b);
    printf("enter c: ");
    scanf("%lf", &c);
    x = (c-b)/a;
    printf("%.2lf*%.2lf + %.2lf = %.2lf\n", a, x, b, c);
    printf("x = %.2lf\n", x);
    return 0;
}