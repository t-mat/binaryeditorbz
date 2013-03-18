/*
licenced by New BSD License

Copyright (c) 1996-2013, c.mos(Original Windows version) & devil.tamachan@gmail.com(MacOSX Cocoa Porting)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "BZDoc.h"
#include <sys/stat.h>

#define MAXONMEMORY 1024*1024
#define MAXMAPSIZE 64*1024*1024
#define READONLY true

@implementation BZDoc

- (id)init
{
    if (self == [super init]) {
        m_pData = NULL;
        m_dwTotal = 0;
        m_bReadOnly = READONLY;
        //m_hMapping = NULL;
        m_pFileMapping = 0;
        m_pMapStart = 0;
        m_dwFileOffset = 0;
        m_dwMapSize = 0;
    }
    return self;
}

- (void)DeleteContents
{
    if (m_pData) {
        if ([self IsFileMapping]) {
            munmap(m_pMapStart ? m_pMapStart : m_pData, m_dwMapSize);
            m_pMapStart = NULL;
            m_dwFileOffset = 0;
            m_dwMapSize = 0;
        } else {
            free(m_pData);
        }
        m_pData = NULL;
        m_dwTotal = 0;
        /*m_dwBase = 0;
        UpdateAllViews(NULL);*/
    }
    if ([self IsFileMapping]) {
        if (m_pDupDoc) {
            m_pDupDoc->m_pDupDoc = nil;
            m_pDupDoc = nil;
            //m_hMapping = NULL;
            m_pFileMapping = 0;
        } else {
            if (m_pFileMapping) {
                close(m_pFileMapping);
                m_pFileMapping = 0;
            }
        }
    }
    
    /*if (m_pUndo) {
        free(m_pUndo);
        m_pUndo = NULL;
    }*/
    m_bReadOnly = false;
}

-(off_t)GetFileLength:(int)fd
{
    off_t fposOld = lseek(fd, 0, SEEK_CUR); //backup position
    off_t fpos = lseek(fd, 0, SEEK_END); //seek to end
    lseek(fd, fposOld, SEEK_SET); //restore position
    if(fpos>0xffff)
    {
        return 0xffff;
    }
    return fpos;
}

-(BOOL)IsFileMapping
{
    return m_pFileMapping != 0;
}

- (BOOL)MapView
{
    m_dwMapSize = m_dwTotal;
    m_pData = mmap(NULL, m_dwMapSize, m_bReadOnly?PROT_READ : PROT_READ|PROT_WRITE, MAP_SHARED, m_pFileMapping, 0);
    if (m_pData==MAP_FAILED) {//Failed
        m_dwMapSize = MAXMAPSIZE;
        m_pData = mmap(NULL, m_dwMapSize, m_bReadOnly?PROT_READ : PROT_READ|PROT_WRITE, MAP_SHARED, m_pFileMapping, 0);
        if (m_pData!=MAP_FAILED) {//Success
            m_pMapStart = m_pData;
            m_dwFileOffset = 0;
        } else {
            return false;
        }
    }
    return true;
}

-(BOOL)OnOpenDocument:(NSURL *)url
{
    int fd = open([[url path] fileSystemRepresentation], O_RDWR|O_EXLOCK/*|O_NONBLOCK*/);
    if (fd==-1) {
        m_bReadOnly = true;
    }
    close(fd);
    
    fd = open([[url path] fileSystemRepresentation], O_RDONLY|O_EXLOCK/*|O_NONBLOCK*/);
    if(fd==-1)
    {
        return false;//err
    }
//    flock(fd, LOCK_EX|LOCK_NB);
    
    [self DeleteContents];
    
    off_t fsize = [self GetFileLength:fd];
    if(fsize<0)
    {
        close(fd);
        return false;//err
    }
    
    if (fsize >= MAXONMEMORY) { //file-mpping
        /*struct stat st;
        if(fstat(fd, &st)==-1)
        {
            return false;//err
        }*/
        //m_bReadOnly = /*options.bReadOnly||*/ st.mode;
        if (m_bReadOnly==false) {
            close(fd);
            fd = open([[url path] fileSystemRepresentation], O_RDWR|O_EXLOCK/*|O_NONBLOCK*/);
            if (fd == -1) {
                return false;//err
            }
        }
        m_pFileMapping = fd;
    }
    
    m_dwTotal = fsize;
    
    if ([self IsFileMapping]) {
        if([self MapView]==false) {
            close(fd);
            return false;//err
        }
    } else {
        if (!(m_pData = malloc(m_dwTotal))) {
            close(fd);
            return false;
        }
        ssize_t totalRead = read(fd, m_pData, m_dwTotal);
        if (totalRead < m_dwTotal) {
            free(m_pData);
            m_pData = NULL;
            close(fd);
            return false;//err
        }
        m_bReadOnly = READONLY;
    }

    //munmap(data, m_dwMapSize);
    close(fd);
    
    return true;
}

@end