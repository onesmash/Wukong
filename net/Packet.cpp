//
//  Packet.cpp
//  AppCore
//
//  Created by Xuhui on 15/6/1.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "Packet.h"
#include "Endian.h"

namespace WukongEngine {
namespace Net {
    
const int kTCPSessionHeadSize = 4;    
    
Packet::Packet(size_t headRoom, size_t dataRoom): buffer_(headRoom + dataRoom)
{
    
}
    
Packet::~Packet()
{
    
}
    
void Packet::prependInt8(int8_t x)
{
    buffer_.prepend((const char*)&x, sizeof(int8_t));
}

void Packet::prependInt16(int16_t x)
{
    uint16_t d = htons(x);
    buffer_.prepend((const char*)&d, sizeof(int16_t));
}

void Packet::prependInt32(int32_t x)
{
    uint32_t d = htonl(x);
    buffer_.prepend((const char*)&d, sizeof(int32_t));
}

void Packet::prependInt64(int64_t x)
{
    uint64_t d = htonll(x);
    buffer_.prepend((const char*)&d, sizeof(int64_t));
}
    
void Packet::prependUInt8(uint8_t x)
{
    prependInt8(x);
}

void Packet::prependUInt16(uint16_t x)
{
    prependInt16(x);
}

void Packet::prependUInt32(uint32_t x)
{
    prependInt32(x);
}

void Packet::prependUInt64(uint64_t x)
{
    prependInt64(x);
}

void Packet::appendInt8(int8_t x)
{
    buffer_.append((const char*)&x, sizeof(int8_t));
}

void Packet::appendInt16(int16_t x)
{
    uint16_t d = htons(x);
    buffer_.append((const char*)&d, sizeof(int16_t));
}

void Packet::appendInt32(int32_t x)
{
    uint32_t d = htonl(x);
    buffer_.append((const char*)&d, sizeof(int32_t));

}

void Packet::apppendInt64(int64_t x)
{
    uint64_t d = htonll(x);
    buffer_.append((const char*)&d, sizeof(int64_t));
}
    
void Packet::appendUInt8(uint8_t x)
{
    appendInt8(x);
}

void Packet::appendUInt16(uint16_t x)
{
    appendInt16(x);
}

void Packet::appendUInt32(uint32_t x)
{
    appendInt32(x);
}

void Packet::apppendUInt64(uint64_t x)
{
    apppendInt64(x);
}

int8_t Packet::popInt8()
{
    return *(buffer_.pop(sizeof(int8_t)));
}

int16_t Packet::popInt16()
{
    uint16_t d;
    memcpy(&d, buffer_.pop(sizeof(int16_t)), sizeof(int16_t));
    return ntohs(d);
}

int32_t Packet::popInt32()
{
    uint32_t d;
    memcpy(&d, buffer_.pop(sizeof(int32_t)), sizeof(int32_t));
    return ntohl(d);
}

int64_t Packet::popInt64()
{
    uint64_t d;
    memcpy(&d, buffer_.pop(sizeof(int64_t)), sizeof(int64_t));
    return ntohll(d);
}
    
}
}
