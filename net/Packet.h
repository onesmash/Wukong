//
//  Packet.h
//  AppCore
//
//  Created by Xuhui on 15/6/1.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Net__Packet__
#define __Net__Packet__
#include "SKBuffer.h"

namespace WukongEngine {
namespace Net {
    
extern const int kTCPSessionHeadSize;
    
class Packet {
    
public:

    Packet(size_t headRoom, size_t dataRoom);
    virtual ~Packet();
    
    void prependInt8(int8_t x);
    void prependInt16(int16_t x);
    void prependInt32(int32_t x);
    void prependInt64(int64_t x);
    void prependUInt8(uint8_t x);
    void prependUInt16(uint16_t x);
    void prependUInt32(uint32_t x);
    void prependUInt64(uint64_t x);
    
    void appendInt8(int8_t x);
    void appendInt16(int16_t x);
    void appendInt32(int32_t x);
    void apppendInt64(int64_t x);
    void appendUInt8(uint8_t x);
    void appendUInt16(uint16_t x);
    void appendUInt32(uint32_t x);
    void apppendUInt64(uint64_t x);
    
    int8_t popInt8();
    int16_t popInt16();
    int32_t popInt32();
    int64_t popInt64();
    uint8_t popUInt8();
    uint16_t popUInt16();
    uint32_t popUInt32();
    uint64_t popUInt64();
    
    const char* data() { return buffer_.data(); }
    size_t size() { return buffer_.size(); }
    
private:
    
    SKBuffer buffer_;
    
};
    
}
}

#endif /* defined(__Net__Packet__) */
