//
//  IPAddress.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "IPAddress.h"
#include "uv.h"
#include <arpa/inet.h>

namespace WukongEngine {
    
namespace Net {
    
IPAddress::IPAddress(uint16_t port, bool loopback)
{
    const char *ip = loopback ? "127.0.0.1" : "0.0.0.0";
    uv_ip4_addr(ip, port, &address_);
}
    
IPAddress::IPAddress(const std::string& ip, uint16_t port)
{
    uv_ip4_addr(ip.c_str(), port, &address_);
}
    
IPAddress::IPAddress(const IPAddress& address)
{
    address_ = address.address_;
}
    
IPAddress::~IPAddress()
{
    
}
    
const sockaddr_in* IPAddress::sockAddress() const
{
    return &address_;
}
    
}
    
}