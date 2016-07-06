//
//  TCPSocket.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/26.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "TCPSocket.h"
#include "Packet.h"
#include <cstdlib>

namespace WukongEngine {
namespace Net {
    
void onAllocBuf(uv_handle_t* handle, size_t suggested_size, uv_buf_t* buf)
{
    TCPSocket* socket = (TCPSocket*)handle->data;
    buf->len = socket->readBufSize();
    buf->base = socket->readBuf();
}
    
void onConnectReq(uv_stream_t* server, int status)
{
    if(status == 0) {
        TCPSocket* serverSocket = (TCPSocket*)server->data;
        serverSocket->didAcceptComplete();
    } else {
        
    }
}
    
void onConnectComplete(uv_connect_t* req, int status)
{
    bool sucess = status >= 0 && status != UV_ECANCELED;
    TCPSocket* socket = (TCPSocket*)req->handle->data;
    socket->didConnectComplete(sucess);
}
    
void onReadComplete(uv_stream_t* stream, ssize_t nread, const uv_buf_t* buf)
{
    if(nread > 0) {
        TCPSocket* socket = (TCPSocket*)stream->data;
        Base::IOBuffer* buffer = new Base::IOBuffer(buf->base, (int)nread);
        std::shared_ptr<Base::IOBuffer> ptr = std::shared_ptr<Base::IOBuffer>(buffer);
        socket->didReadComplete(ptr);
    } else {
        
    }
}
    
void onWriteComplete(uv_write_t* req, int status)
{
    bool sucess = status >= 0 && status != UV_ECANCELED;
    TCPSocket* socket = (TCPSocket*)req->handle->data;
    socket->didWriteComplete(req, sucess);
}
    
void onShutdownComplete(uv_shutdown_t* req, int status)
{
    
}
    
void onCloseComplete(uv_handle_t* handle)
{
    TCPSocket* socket = (TCPSocket*)handle->data;
    socket->didCloseComplete();
}
    
TCPSocket::TCPSocket()
{
}
    
TCPSocket::~TCPSocket()
{
}
    
int TCPSocket::open(Base::MessageLoop* messageLoop)
{
    messageLoop_ = messageLoop;
    int res = uv_tcp_init(&messageLoop_->eventLoop(), &tcpSocket_);
    tcpSocket_.data = this;
    return res;
}
    
int TCPSocket::bind(const IPAddress& address)
{
    return -uv_tcp_bind(&tcpSocket_, (const struct sockaddr*)address.sockAddress(), 0);
}
    
int TCPSocket::listen(int backlog)
{
    return -uv_listen((uv_stream_t*)&tcpSocket_, backlog, onConnectReq);
}
    
int TCPSocket::connect(const IPAddress& address)
{
    return -uv_tcp_connect(&tcpConnectReq_, &tcpSocket_, address.sockAddress(), onConnectComplete);
}
    
int TCPSocket::startRead()
{
    return -uv_read_start((uv_stream_t*)&tcpSocket_, onAllocBuf, onReadComplete);
}
    
int TCPSocket::stopRead()
{
    return -uv_read_stop((uv_stream_t*)&tcpSocket_);
}
    
int TCPSocket::write(const Packet& packet)
{
    WriteRequest* writeRequest = new WriteRequest;
    writeRequest->packet = packet;
    writeRequest->writeRequest.data = writeRequest;
    uv_buf_t buf = uv_buf_init((char*)writeRequest->packet.data(), (unsigned)writeRequest->packet.size());
    std::shared_ptr<WriteRequest> ptr = std::shared_ptr<WriteRequest>(writeRequest);
    writeRequestSet_.insert(ptr);
    return -uv_write(&writeRequest->writeRequest, (uv_stream_t*)&tcpSocket_, &buf, 1, onWriteComplete);
}
    
int TCPSocket::write(Packet&& packet)
{
    WriteRequest* writeRequest = new WriteRequest;
    writeRequest->packet = std::move(packet);
    writeRequest->writeRequest.data = writeRequest;
    uv_buf_t buf = uv_buf_init((char*)writeRequest->packet.data(), (unsigned)writeRequest->packet.size());
    std::shared_ptr<WriteRequest> ptr = std::shared_ptr<WriteRequest>(writeRequest);
    writeRequestSet_.insert(ptr);
    return -uv_write(&writeRequest->writeRequest, (uv_stream_t*)&tcpSocket_, &buf, 1, onWriteComplete);
}
    
int TCPSocket::shutdown()
{
    return -uv_shutdown(&tcpShutdownReq_, (uv_stream_t*)&tcpSocket_, onShutdownComplete);
}
    
int TCPSocket::close()
{
    uv_close((uv_handle_t*)&tcpSocket_, onCloseComplete);
    return 0;
}
    
void TCPSocket::didAcceptComplete()
{
    std::shared_ptr<TCPSocket> socketP = std::shared_ptr<TCPSocket>(new TCPSocket());
    int res = uv_accept((uv_stream_t*)&tcpSocket_, (uv_stream_t*)socketP->tcpSocketHandle());
    if(res > 0)
        connectionAcceptCallback_(socketP);
}
    
void TCPSocket::didConnectComplete(bool success)
{
    connectCallback_(success);
}
    
void TCPSocket::didReadComplete(std::shared_ptr<Base::IOBuffer>& buffer)
{
    readCompleteCallback_(buffer);
}
    
void TCPSocket::didWriteComplete(TCPSocketWriteRequest* request, bool success)
{
    WriteRequest* writeRequest = (WriteRequest*)request->data;
    writeCompleteCallback_(success);
    std::shared_ptr<WriteRequest> ptr = std::shared_ptr<WriteRequest>(writeRequest);
    writeRequestSet_.erase(ptr);
}
    
void TCPSocket::didCloseComplete()
{
    closeCallback_(true);
}
    
    
}
}