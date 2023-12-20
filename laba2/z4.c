#include <stdio.h>
#include <stdlib.h>
typedef struct Node {
    int data;
    struct Node* next;
} Node;
typedef struct {
    Node* top;  
    int size;
    int capacity;  
} Stack;
void initializeStack(Stack* stack, int capacity) {
    stack->top = NULL;
    stack->size = 0;
    stack->capacity = capacity;
}
int isEmpty(Stack* stack) {
    return stack->size == 0;
}
int isFull(Stack* stack) {
    return stack->size == stack->capacity;
}
void push(Stack* stack, int value) {
    if (isFull(stack)) {
        printf("stack is full\n");
        return;
    }
    Node* newNode = (Node*)malloc(sizeof(Node));
    if (newNode == NULL) {
        printf("error with new node\n");
        return;
    }
    newNode->data = value;
    newNode->next = stack->top;
    stack->top = newNode;
    stack->size++;
}
int pop(Stack* stack) {
    if (isEmpty(stack)) {
        printf("stack is empty\n");
        return -1; 
    }
    Node* temp = stack->top;
    int value = temp->data;
    stack->top = temp->next;
    free(temp);
    stack->size--;
    return value;
}
int peek(Stack* stack) {
    if (isEmpty(stack)) {
        printf("stack is empty\n");
        return -1; 
    }
    return stack->top->data;
}
void freeStack(Stack* stack) {
    while (!isEmpty(stack)) {
        pop(stack);
    }
}
void printStack(Stack* stack) {
    printf("Stack: ");
    Node* current = stack->top;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}
int main() {
    Stack myStack;
    initializeStack(&myStack, 5); 
    push(&myStack, 10);
    push(&myStack, 20);
    push(&myStack, 30);
    printf("upper value: %d\n", peek(&myStack));
    printf("Extracted value: %d\n", pop(&myStack));
    printf("Upper value after extraction: %d\n", peek(&myStack));
    printf("Stack after pop:\n");
    printStack(&myStack);
    freeStack(&myStack); 
    return 0;
}
