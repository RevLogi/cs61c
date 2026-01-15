CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = list_demo
OBJS = linkedlist.o list_demo.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

linkedlist.o: linkedlist.c linkedlist.h
	$(CC) $(CFLAGS) -c linkedlist.c

list_demo.o: list_demo.c linkedlist.h
	$(CC) $(CFLAGS) -c list_demo.c

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
