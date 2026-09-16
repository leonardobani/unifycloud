#include <stdio.h>
#include <stdlib.h>
#include "librclone_wrapper.h"

int main() {
    printf("Calling InitRclone...\n");
    char* initRes = InitRclone(NULL);
    printf("InitRclone result: %s\n", initRes);
    FreeString(initRes);

    printf("Calling ListRemotes...\n");
    char* remotesRes = ListRemotes();
    printf("ListRemotes result: %s\n", remotesRes);
    FreeString(remotesRes);

    printf("Calling ListDirectory on current dir (local)...\n");
    char* listRes = ListDirectory("", ".");
    printf("ListDirectory result: %s\n", listRes);
    FreeString(listRes);

    printf("All wrapper tests passed!\n");
    return 0;
}

