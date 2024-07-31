package kui.util;

/**
 * Represents a stack of any value
 */
class Stack<T> {

    private var stack: Array<T> = [];
    public function new() {}

    /**
     * Push a value onto the stack
     * @param value The value to push
     */
    public function push(value: T): Void {
        stack.push(value);
    }

    /**
     * Pop a value off the stack
     * @return The value that was popped off the stack
     */
    public inline function pop(): T {
        return stack.pop();
    }

    /**
     * Peek at the top value of the stack
     * @return The value at the top of the stack
     */
    public inline function peek(): T {
        return stack[stack.length - 1];
    }

    /**
     * Get the size of the stack
     * @return The size of the stack
     */
    public function size(): Int {
        return stack.length;
    }

    /**
     * Check if the stack is empty
     * @return True if the stack is empty, false otherwise
     */
    public function isEmpty(): Bool {
        return stack.length == 0;
    }

    /**
     * Clear the stack
     */
    public function clear(): Void {
        stack.resize(0);
    }

    /**
     * Get the stack as an array
     * @return The stack as an array
     */
    @:to(Array)
    public function toArray(): Array<T> {
        return stack;
    }

    /**
     * Get the stack as a string
     * @return The stack as a string
     */
    @:to(String)
    public function toString(): String {
        return stack.toString();
    }

}