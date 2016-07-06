//
//  TCPConnector.cpp
//  Wukong
//
//  Created by Xuhui on 16/7/4.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "TCPConnector.h"
#include "MessageLoop.h"

namespace WukongEngine {

namespace Net {
    
TCPConnector::TCPConnector(Base::MessageLoop* messageLoop, const IPAddress& serverAddress)
:   messageLoop_(messageLoop),
    serverAddress_(serverAddress)
{

}
    
TCPConnector::~TCPConnector()
{
    
}
    
void TCPConnector::connect()
{
    messageLoop_->postTask(std::bind(&TCPConnector::connectInLoop, this));
}
    
void TCPConnector::connectInLoop()
{
    TCPSocket* socket = new TCPSocket();
    socket_ = std::shared_ptr<TCPSocket>(socket);
    socket_->open(messageLoop_);
    socket_->setConnectCallback(std::bind(&TCPConnector::didConnectComplete, this, std::placeholders::_1));
    socket_->connect(serverAddress_);
}
    
void TCPConnector::didConnectComplete(bool success)
{
    if(success) {
        newTCPSessionCallback_(socket_);
    }
}
}
}