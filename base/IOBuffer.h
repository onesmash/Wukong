//
//  IOBuffer.h
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Base__IOBuffer__
#define __Base__IOBuffer__

#include <vector>

namespace WukongEngine {

namespace Base {
    
class IOBuffer {
public:
    IOBuffer(size_t size = 0);
    IOBuffer(const char* data, size_t size);
    IOBuffer(const std::vector<char>& buffer);
    IOBuffer(std::vector<char>&& buffer);
    IOBuffer(IOBuffer&& other);
    IOBuffer(const IOBuffer& other);
    virtual ~IOBuffer();
    
    IOBuffer& operator=(const IOBuffer& other);
    IOBuffer& operator=(IOBuffer&& other);
    
    const char* data() const { return &*data_.begin(); }
    size_t size() const { return data_.size(); }
    
protected:
    
    std::vector<char> data_;
};
    
}
    
}

#endif /* defined(__Base__IOBuffer__) */
