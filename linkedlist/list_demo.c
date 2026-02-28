#include "linkedlist.h"
#include <stdio.h>

int main(void) {
    linked_list_t *list = list_create();
    if (NULL == list) { printf("Error in main: Couldn't allocate linked_list_t`\n"); return(1);}

    list_add_front(list, "ALICE");
    list_add_front(list, "BOB");
    list_add_front(list, "CARA");

    list_print(list);
    list_free(list);
    return 0;
}
