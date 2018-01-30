//
//  readlink.c
//  NeXTTY
//
//  Created by Sem Voigtländer on 23/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#include "readlink.h"
char* ADVCMDS_READLINK(char* input)
{
    struct stat sb;
    char *buf;
    ssize_t nbytes, bufsiz;
    if(lstat(input, &sb) == -1)
    {
        return "lstat failed: -1.";
    }
    bufsiz = sb.st_size + 1;
    if(sb.st_size == 0)
    {
        bufsiz = PATH_MAX;
    }
    buf = (char*)malloc(bufsiz);
    if(buf == NULL)
    {
        return "malloc failed: out of memory?";
    }
    nbytes = readlink(input, buf, bufsiz);
    if(nbytes == -1)
    {
        return "readlink failed: -1.";
    }
    char *result;
    asprintf(&result, "'%s' => /%.*s",input, (int)nbytes, buf);
    return result;
}
