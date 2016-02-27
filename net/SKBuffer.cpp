//
//  SKBuffer.cpp
//  AppCore
//
//  Created by Xuhui on 15/6/1.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "SKBuffer.h"
#include <cassert>

namespace WukongEngine {
namespace Net {
    
SKBuffer::SKBuffer(size_t size):
    headIndex_(0),
    dataIndex_(0),
    tailIndex_(0),
    buffer_(size)
{
    
}
    
size_t SKBuffer::headRoom() const
{
    return dataIndex_;
}

size_t SKBuffer::tailRoom() const
{
    return buffer_.size() - tailIndex_;
}
    
void SKBuffer::reserve(size_t len)
{
    dataIndex_ = (tailIndex_+=len);
}
    
void SKBuffer::prepend(const char* data, size_t len)
{
    assert(dataIndex_ > len);
    dataIndex_ -= len;
    std::copy(data, data + len, &*buffer_.begin() + dataIndex_);
}
    
void SKBuffer::append(const char* data, size_t len)
{
    ensureTailRoom(len);
    std::copy(data, data + len, &*buffer_.begin() + tailIndex_);
    tailIndex_ += len;
}
    
const char* SKBuffer::pop(size_t len)
{
    assert(tailIndex_ - dataIndex_ >= len);
    char* data = &*buffer_.begin() + dataIndex_;
    dataIndex_ += len;
    return data;
}
    
void SKBuffer::ensureTailRoom(size_t len)
{
    if(tailRoom() < len) {
        buffer_.resize(tailIndex_ + 2 * len);
    }
}
    
}
}