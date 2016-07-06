//
//  TCPConnector.h
//  Wukong
//
//  Created by Xuhui on 16/7/4.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef TCPConnector_h
#define TCPConnector_h

#include "IPAddress.h"
#include "TCPSocket.h"

namespace WukongEngine {
    
namespace Base {
class MessageLoop;
}

namespace Net {
    
class TCPConnector {
public:
    typedef std::function<void(const std::shared_ptr<TCPSocket>&)> NewTCPSessionCallback;
    
    TCPConnector(Base::MessageLoop* messageLoop, const IPAddress& serverAddress);
    ~TCPConnector();
    
    void connect();
    
    void setNewTCPSessionCallback(const NewTCPSessionCallback& cb)
    {
        newTCPSessionCallback_ = cb;
    }
    
private:
    void connectInLoop();
    
    void didConnectComplete(bool success);
    
    NewTCPSessionCallback newTCPSessionCallback_;
    
    Base::MessageLoop* messageLoop_;
    IPAddress serverAddress_;
    std::shared_ptr<TCPSocket> socket_;
};
}
}

#endif /* TCPConnector_h */
