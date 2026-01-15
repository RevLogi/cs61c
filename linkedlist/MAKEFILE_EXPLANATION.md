# Makefile Explanation

## Variables (Lines 1-4)

- `CC = gcc` - Sets the compiler to GCC
- `CFLAGS = -Wall -Wextra -std=c99` - Compiler flags:
  - `-Wall` enables all common warnings
  - `-Wextra` enables additional warnings
  - `-std=c99` uses C99 standard
- `TARGET = list_demo` - Name of the final executable
- `OBJS = linkedlist.o list_demo.o` - List of object files needed

## Build Rules

### Line 6: Default Target
```makefile
all: $(TARGET)
```
Default target; running `make` without arguments builds the target.

### Lines 8-9: Linking
```makefile
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)
```
Links object files into executable:
```bash
gcc -Wall -Wextra -std=c99 -o list_demo linkedlist.o list_demo.o
```

### Lines 11-12: Compile linkedlist.c
```makefile
linkedlist.o: linkedlist.c linkedlist.h
	$(CC) $(CFLAGS) -c linkedlist.c
```
Compiles `linkedlist.c` to object file.

### Lines 14-15: Compile list_demo.c
```makefile
list_demo.o: list_demo.c linkedlist.h
	$(CC) $(CFLAGS) -c list_demo.c
```
Compiles `list_demo.c` to object file.

### Lines 17-18: Clean Target
```makefile
clean:
	rm -f $(OBJS) $(TARGET)
```
Removes all build artifacts (object files and executable).

## Line 20: Phony Targets
```makefile
.PHONY: all clean
```
Declares `all` and `clean` as phony targets (they don't create files with those names).

## How It Works

When you run `make`, it checks dependencies and only rebuilds what changed. `make clean` removes all build files.

## Usage

```bash
cd linkedlist
make           # Build the project
make clean     # Remove build artifacts
./list_demo    # Run the program
```
