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
#include <functional>
#include <memory>
#include <unordered_set>

namespace WukongEngine {

namespace Net {
   
class TCPSocket;
class Packet;
    
typedef std::function<void(const std::shared_ptr<Base::IOBuffer>&)> ReadCompleteCallBack;
typedef std::function<void(bool)> WriteCompleteCallBack;
typedef std::function<void(const std::shared_ptr<TCPSocket>&)> ConnectionAcceptCallBack;
typedef std::function<void(bool)> ConnectCallBack;
typedef std::function<void(bool)> CloseCallBack;

class TCPSocket {
public:
    typedef uv_tcp_t TCPSocketHandle;
    typedef uv_write_t TCPSocketWriteRequest;
    typedef uv_connect_t TCPSocketConnectRequest;
    TCPSocket();
    virtual ~TCPSocket();
    
    int open();
    
    int bind(const IPAddress& address);
    
    int listen(int backlog, const ConnectionAcceptCallBack& connectionAcceptCallBack);
    
    int connect(const IPAddress& address, const ConnectCallBack& connectCallBack);
    
    int read(const ReadCompleteCallBack& readCompleteCallBack);
    
    int write(std::shared_ptr<Packet>& packet, WriteCompleteCallBack& writeCompleteCallBack);
    
    int close(const CloseCallBack& closeCallBack);
    
    void didAcceptComplete();
    
    void didConnectComplete(bool sucess);
    
    void didReadComplete(const std::shared_ptr<Base::IOBuffer>& buffer);
    
    void didWriteComplete(TCPSocketWriteRequest* request, bool sucess);
    
    void didCloseComplete();
    
    void setReadBufSize(int size);
    
    char* readBuf() { return readBuffer->data(); }
    int readBufSize() { return readBuffer->size(); }
    
    TCPSocketHandle* tcpSocketHandle() { return &tcpSocket_; }
    
private:
    
    struct WriteRequest {
        uv_write_t writeRequest;
        std::shared_ptr<Packet> packet;
        WriteCompleteCallBack writeCompleteCallBack;
    };
    
    std::shared_ptr<Base::IOBuffer> readBuffer;
    TCPSocketHandle tcpSocket_;
    TCPSocketConnectRequest tcpConnectReq_;
    std::unordered_set<std::shared_ptr<WriteRequest>> writeRequestSet_;
    
    ConnectionAcceptCallBack connectionAcceptCallBack_;
    ReadCompleteCallBack readCompleteCallBack_;
    ConnectCallBack connectCallBack_;
    CloseCallBack closeCallBack_;
    
};
    
}
    
}

#endif /* defined(__Net__TCPSocket__) */
