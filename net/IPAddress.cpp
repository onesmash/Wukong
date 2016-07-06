//
//  IPAddress.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "IPAddress.h"
#include "uv.h"
#include "TCPSocket.h"
#include <arpa/inet.h>
#include <cstdlib>

namespace WukongEngine {
    
namespace Net {
    
IPAddress::IPAddress(uint16_t port, bool loopback, bool isIPv6)
{
    if(isIPv6) {
        bzero(&address6_, sizeof address6_);
        address6_.sin6_family = AF_INET6;
        in6_addr ip = loopback ? in6addr_loopback : in6addr_any;
        address6_.sin6_addr = ip;
        address6_.sin6_port = htons(port);
    } else {
        bzero(&address_, sizeof address_);
        address_.sin_family = AF_INET;
        in_addr_t ip = loopback ? INADDR_LOOPBACK : INADDR_ANY;
        address_.sin_addr.s_addr = ntohl(ip);
        address_.sin_port = htons(port);
    }
}
    
IPAddress::IPAddress(const sockaddr* address)
{
    if (address->sa_family == AF_INET)
        address_ = *(const sockaddr_in*)address;
    else if (address->sa_family == AF_INET6)
        address6_ = *(const sockaddr_in6*)address;
    else {
        perror("only support AF_INET and AF_INET6");
        abort();
    }
}
    
IPAddress::IPAddress(const std::string& ip, uint16_t port, bool isIPv6)
{
    if(isIPv6) {
        uv_ip4_addr(ip.c_str(), port, &address_);
    } else {
        uv_ip6_addr(ip.c_str(), port, &address6_);
    }
}
    
IPAddress::IPAddress(const IPAddress& address)
{
    address_ = address.address_;
}
    
IPAddress::~IPAddress()
{
    
}
    
const sockaddr* IPAddress::sockAddress() const
{
    return reinterpret_cast<const struct sockaddr*>(&address6_);
}
    
IPAddress IPAddress::getLocalAddress(const TCPSocket& socket)
{
    sockaddr_storage addr;
    int len = 0;
    uv_tcp_getsockname(socket.tcpSocketHandle(), reinterpret_cast<struct sockaddr*>(&addr), &len);
    return IPAddress(reinterpret_cast<struct sockaddr*>(&addr));
}

IPAddress IPAddress::getPeerAddress(const TCPSocket& socket)
{
    sockaddr_storage addr;
    int len = 0;
    uv_tcp_getpeername(socket.tcpSocketHandle(), reinterpret_cast<struct sockaddr*>(&addr), &len);
    return IPAddress(reinterpret_cast<struct sockaddr*>(&addr));
}
    
}
    
}