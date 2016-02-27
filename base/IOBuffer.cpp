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
    
IOBuffer::IOBuffer(int size): size_(size)
{
    data_ = new char[size];
}

IOBuffer::IOBuffer(char* data, int size)
{
    data_ = data;
    size_ = size;
}
    
IOBuffer::IOBuffer(IOBuffer&& other): size_(other.size()), data_(other.data())
{
    other.size_ = 0;
    other.data_ = nullptr;
    
}

IOBuffer::IOBuffer(const IOBuffer& other)
{
    size_ = other.size_;
    data_ = new char[size_];
    ::memcpy(data_, other.data_, size_);
}

IOBuffer::~IOBuffer()
{
    delete [] data_;
    size_ = 0;
}
}
    
}