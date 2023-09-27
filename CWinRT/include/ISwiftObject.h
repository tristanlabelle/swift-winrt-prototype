#pragma once

#include <combaseapi.h>

#ifndef __cplusplus
EXTERN_C const IID IID_ISwiftObject;

typedef interface ISwiftObject
{
    CONST_VTBL struct IUnknownVtbl* lpVtbl;
} ISwiftObject;
#endif