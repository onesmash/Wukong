//
//  IOBuffer.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "IOBuffer.h"
#include <cstring>

namespace WukongEngine {
    
namespace Base {
    
IOBuffer::IOBuffer(size_t size): data_(std::vector<char>(size))
{
}

IOBuffer::IOBuffer(const char* data, size_t size): data_(std::vector<char>(data, data + size))
{
}
    
IOBuffer::IOBuffer(const std::vector<char>& buffer): data_(buffer)
{
}

IOBuffer::IOBuffer(std::vector<char>&& buffer): data_(std::move(buffer))
{
}
    
IOBuffer::IOBuffer(IOBuffer&& other): data_(std::move(other.data_))
{
}

IOBuffer::IOBuffer(const IOBuffer& other)
{
    data_ = other.data_;
}

IOBuffer::~IOBuffer()
{
}
    
IOBuffer& IOBuffer::operator=(const IOBuffer& other)
{
    data_ = other.data_;
    return *this;
}

IOBuffer& IOBuffer::operator=(IOBuffer&& other)
{
    data_ = std::move(other.data_);
    return *this;
}
    
}
    
}