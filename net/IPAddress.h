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

namespace WukongEngine {
    
namespace Net {
    
class IPAddress {
    
public:
    IPAddress();
    virtual ~IPAddress();
    IPAddress(uint16_t port, bool loopback = false);
    IPAddress(const std::string& ip, uint16_t port);
    IPAddress(const IPAddress& address);
    
    const sockaddr_in* sockAddress() const;
    
private:
    
    sockaddr_in address_;
    
};
    
}
    
}

#endif /* defined(__Net__IPAddress__) */
