#pragma once

#include <robuffer.h>

#ifndef __cplusplus
EXTERN_C const IID IID_WindowsStorageStreams_IBufferByteAccess;

typedef interface WindowsStorageStreams_IBufferByteAccess WindowsStorageStreams_IBufferByteAccess;

typedef struct WindowsStorageStreams_IBufferByteAccessVtbl
{
    BEGIN_INTERFACE

    HRESULT (STDMETHODCALLTYPE* QueryInterface)(WindowsStorageStreams_IBufferByteAccess* This,
        REFIID riid,
        void** ppvObject);
    ULONG (STDMETHODCALLTYPE* AddRef)(WindowsStorageStreams_IBufferByteAccess* This);
    ULONG (STDMETHODCALLTYPE* Release)(WindowsStorageStreams_IBufferByteAccess* This);
    HRESULT (STDMETHODCALLTYPE* Buffer)(WindowsStorageStreams_IBufferByteAccess* This,
        BYTE** data);

    END_INTERFACE
} WindowsStorageStreams_IBufferByteAccessVtbl;

interface WindowsStorageStreams_IBufferByteAccess
{
    CONST_VTBL struct WindowsStorageStreams_IBufferByteAccessVtbl* lpVtbl;
};
#endif