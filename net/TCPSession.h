//
//  TCPSession.h
//  AppCore
//
//  Created by Xuhui on 15/5/31.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Net__TCPSession__
#define __Net__TCPSession__

#include "Packer.h"
#include "TCPSocket.h"

namespace WukongEngine {
namespace Net {
    
class TCPSession: public Packer  {
    
public:
    
    virtual ~TCPSession() {}
    
    virtual bool pack(std::shared_ptr<Packet>& packet);
    virtual bool unpack(std::shared_ptr<Packet>& packet);
    
private:
    
    std::shared_ptr<TCPSocket> localSocket_;
    std::shared_ptr<TCPSocket> peerSocket_;
    
};
    
}
}

#endif /* defined(__Net__TCPSession__) */
