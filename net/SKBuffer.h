//
//  SKBuffer.h
//  AppCore
//
//  Created by Xuhui on 15/6/1.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Net__Buffer__
#define __Net__Buffer__

#include <vector>

namespace WukongEngine {
namespace Net {
    
class SKBuffer {
public:
    SKBuffer(size_t size);
    SKBuffer(const SKBuffer& buffer);
    SKBuffer(SKBuffer&& buffer);
    
    SKBuffer& operator=(const SKBuffer& buffer);
    SKBuffer& operator=(SKBuffer&& buffer);
    
    size_t headRoom() const;
    size_t tailRoom() const;
    
    void reserve(size_t len);
    void prepend(const char* data, size_t len);
    void append(const char* data, size_t len);
    const char* pop(size_t len);
    
    const char* data() const { return &*buffer_.begin() + dataIndex_; }
    size_t size() const { return tailIndex_ - dataIndex_; }
    
    void swap(SKBuffer& buffer);
    
private:
    
    void ensureTailRoom(size_t len);
    
    size_t headIndex_;
    size_t dataIndex_;
    size_t tailIndex_;
    
    std::vector<char> buffer_;
    
};
    
}
}

#endif /* defined(__Net__Buffer__) */
