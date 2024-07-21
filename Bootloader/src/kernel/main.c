#include "stdint.h"
#include "stdio.h"
#include "asmDisk.h"

void _cdecl cstart_ (){
    uint8_t error;

    x86_Disk_Reset(10,&error0;)
    printf("Error %d\r\n",error);
}
