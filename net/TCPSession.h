//
//  TCPSession.h
//  AppCore
//
//  Created by Xuhui on 15/5/31.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Net__TCPSession__
#define __Net__TCPSession__

#include "TCPSocket.h"
#include "IPAddress.h"

namespace WukongEngine {
namespace Net {
    
class TCPSession {
    
public:
    TCPSession(const std::shared_ptr<TCPSocket>& socket, const IPAddress& localAddress, const IPAddress& peerAddress);
    
    virtual ~TCPSession() {}
    
    void send(const Packet& packet);
    void send(Packet&& packet);
    
    void startRead();
    void stopRead();
    
    void shutdown();
    void close();
    
    void setReadCompleteCallback(const ReadCompleteCallback& cb)
    {
        readCompleteCallback_ = cb;
    }
    
    void setWriteCompleteCallback(const WriteCompleteCallback& cb)
    {
        writeCompleteCallback_ = cb;
    }
    
    void setCloseCallback(const CloseCallback& cb)
    {
        closeCallback_ = cb;
    }
    
private:
    
    enum State { kDisconnected, kConnecting, kConnected, kDisconnecting };
    
    void didReadComplete(std::shared_ptr<Base::IOBuffer>& buffer);
    void didWriteComplete(bool success);
    void didCloseComplete();
    
    void setState(State state) { state_ = state; }
    
    std::shared_ptr<TCPSocket> socket_;
    
    IPAddress localAddress_;
    IPAddress peerAddress_;
    
    State state_;
    
    ReadCompleteCallback readCompleteCallback_;
    WriteCompleteCallback writeCompleteCallback_;
    CloseCallback closeCallback_;
    
};
    
}
}

#endif /* defined(__Net__TCPSession__) */
