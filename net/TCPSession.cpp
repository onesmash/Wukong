//
//  TCPSession.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/31.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "TCPSession.h"
#include "Packet.h"

namespace WukongEngine {
namespace Net {
    
TCPSession::TCPSession(const std::shared_ptr<TCPSocket>& socket, const IPAddress& localAddress, const IPAddress& peerAddress)
    :   socket_(socket),
        localAddress_(localAddress),
        peerAddress_(peerAddress),
        state_(kConnecting)
{
    socket_->setWriteCompleteCallback(std::bind(&TCPSession::didWriteComplete, this, std::placeholders::_1));
    socket_->setReadCompleteCallback(std::bind(&TCPSession::didReadComplete, this, std::placeholders::_1));
    socket_->setCloseCallback(std::bind(&TCPSession::didCloseComplete, this));
}
    
void TCPSession::send(const Packet& packet)
{
    socket_->write(packet);
}

void TCPSession::send(Packet&& packet)
{
    socket_->write(std::move(packet));
}
    
void TCPSession::startRead()
{
    socket_->startRead();
}

void TCPSession::stopRead()
{
    socket_->stopRead();
}
    
void TCPSession::shutdown()
{
    socket_->shutdown();
}
    
void TCPSession::close()
{
    socket_->close();
}
    
void TCPSession::didWriteComplete(bool success)
{
    writeCompleteCallback_(success);
}
    
void TCPSession::didReadComplete(std::shared_ptr<Base::IOBuffer>& buffer)
{
    readCompleteCallback_(buffer);
}
    
void TCPSession::didCloseComplete()
{
    closeCallback_(true);
}

}
}