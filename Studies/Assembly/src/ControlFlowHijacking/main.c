void hello() {
    puts("Hello!");
}


/**
 * an attacker can corrupt the function pointer.
 * function pointer
      |
      v
  unexpected_address
      |
      v
  unintended code
 * 
 *
 * Now, instead of calling hello, the CPU attempts to execute code at the attacker-selected address.
 * This is a form of control-flow hijacking.
 * The attacker doesn't necessarily need to inject new code;
 * They might try to redirect execution into instructions already present in the program.
 */
int main() {
    void (*function)() = hello;

    function();
}