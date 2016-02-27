//
//  IOBuffer.h
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Base__IOBuffer__
#define __Base__IOBuffer__

namespace WukongEngine {

namespace Base {
    
class IOBuffer {
public:
    IOBuffer(int size);
    IOBuffer(char* data, int size);
    IOBuffer(IOBuffer&& other);
    IOBuffer(const IOBuffer& other);
    virtual ~IOBuffer();
    
    char* data() { return data_; }
    int size() { return size_; }
    
protected:
    
    int size_;
    char* data_;
};
    
}
    
}

#endif /* defined(__Base__IOBuffer__) */
