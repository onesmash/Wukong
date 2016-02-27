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
    
    bool TCPSession::pack(std::shared_ptr<Packet>& packet)
    {
        return true;
    }
    
    bool TCPSession::unpack(std::shared_ptr<Packet>& packet)
    {
        return true;
    }

}
}