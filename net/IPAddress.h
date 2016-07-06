//
//  IPAddress.h
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Net__IPAddress__
#define __Net__IPAddress__

#include <string>
#include <netinet/in.h>
#include <arpa/inet.h>


namespace WukongEngine {
    
namespace Net {
    
class TCPSocket;
    
class IPAddress {
    
public:
    IPAddress();
    virtual ~IPAddress();
    IPAddress(uint16_t port, bool loopback = false, bool isIPv6 = false);
    IPAddress(const std::string& ip, uint16_t port, bool isIPv6 = false);
    IPAddress(const sockaddr* address);
    IPAddress(const IPAddress& address);
    
    const sockaddr* sockAddress() const;
    
    static IPAddress getLocalAddress(const TCPSocket& socket);
    static IPAddress getPeerAddress(const TCPSocket& socket);
    
private:
    
    union {
        sockaddr_in address_;
        sockaddr_in6 address6_;
    };
    
    
};
    
}
    
}

#endif /* defined(__Net__IPAddress__) */
