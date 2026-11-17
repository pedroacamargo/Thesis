#include <unistd.h>

int main(void) {
    char ola[] = "Hello, World!\n";
    write(STDOUT_FILENO, &ola, sizeof(ola));
    return 0;
}