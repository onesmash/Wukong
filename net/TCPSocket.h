//
//  TCPSocket.h
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Net__TCPSocket__
#define __Net__TCPSocket__

#include "IPAddress.h"
#include "IOBuffer.h"
#include "uv.h"
#include "Packet.h"
#include "MessageLoop.h"
#include <functional>
#include <memory>
#include <unordered_set>

namespace WukongEngine {
    
class MessageLoop;

namespace Net {
    
#define kReadBufSize 4096
   
class TCPSocket;
    
typedef std::function<void(std::shared_ptr<Base::IOBuffer>&)> ReadCompleteCallback;
typedef std::function<void(bool)> WriteCompleteCallback;
typedef std::function<void(const std::shared_ptr<TCPSocket>&)> ConnectionAcceptCallback;
typedef std::function<void(bool)> ConnectCallback;
typedef std::function<void(bool)> CloseCallback;

class TCPSocket {
public:
    typedef uv_tcp_t TCPSocketHandle;
    
    TCPSocket();
    virtual ~TCPSocket();
    
    int open(Base::MessageLoop* messageLoop);
    
    int bind(const IPAddress& address);
    
    int listen(int backlog);
    
    int connect(const IPAddress& address);
    
    int startRead();
    int stopRead();
    
    int write(const Packet& packet);
    int write(Packet&& packet);
    
    int shutdown();
    
    int close();
    
    void setReadBufSize(int size);
    
    char* readBuf() const { return (char*)&readBuffer; }
    size_t readBufSize() const { return kReadBufSize; }
    
    const TCPSocketHandle* tcpSocketHandle() const { return &tcpSocket_; }
    
    void setConnectionAcceptCallback(const ConnectionAcceptCallback& cb)
    {
        connectionAcceptCallback_ = cb;
    }
    
    void setReadCompleteCallback(const ReadCompleteCallback& cb)
    {
        readCompleteCallback_ = cb;
    }
    
    void setWriteCompleteCallback(const WriteCompleteCallback& cb)
    {
        writeCompleteCallback_ = cb;
    }
    
    void setConnectCallback(const ConnectCallback& cb)
    {
        connectCallback_ = cb;
    }
    
    void setCloseCallback(const CloseCallback& cb)
    {
        closeCallback_ = cb;
    }
    
private:
    
    typedef uv_shutdown_t TCPSocketShutdownRequest;
    typedef uv_write_t TCPSocketWriteRequest;
    typedef uv_connect_t TCPSocketConnectRequest;
    
    struct WriteRequest {
        TCPSocketWriteRequest writeRequest;
        Packet packet;
    };
    
public:
    void didAcceptComplete();
    
    void didConnectComplete(bool sucess);
    
    void didReadComplete(std::shared_ptr<Base::IOBuffer>& buffer);
    
    void didWriteComplete(TCPSocketWriteRequest* request, bool success);
    
    void didCloseComplete();
    
private:
    
    Base::MessageLoop* messageLoop_;
    
    char readBuffer[kReadBufSize];
    TCPSocketHandle tcpSocket_;
    TCPSocketConnectRequest tcpConnectReq_;
    TCPSocketShutdownRequest tcpShutdownReq_;
    std::unordered_set<std::shared_ptr<WriteRequest>> writeRequestSet_;
    
    ConnectionAcceptCallback connectionAcceptCallback_;
    ReadCompleteCallback readCompleteCallback_;
    WriteCompleteCallback writeCompleteCallback_;
    ConnectCallback connectCallback_;
    CloseCallback closeCallback_;
    
};
    
}
    
}

#endif /* defined(__Net__TCPSocket__) */
