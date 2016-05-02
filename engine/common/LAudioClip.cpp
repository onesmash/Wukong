//
//  LAudioClip.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "LAudioClip.h"
#include "AudioClip.h"

namespace WukongEngine {
    
namespace Runtime {
    
static int t_new(lua_State* L)
{
    lua_newtable(L);
    lua_pushvalue(L, 1);
    lua_setmetatable(L, 2);
    luax_push_objectPtr(L, new AudioClip());
    lua_setfield(L, 2, "_cproxy");
    return 1;
}
    
static int t_init(lua_State* L)
{
    const std::shared_ptr<AudioClip>& audioClip = luax_to_cproxy<AudioClip>(L, 1);
    const char* filePath = lua_tostring(L, 2);
    audioClip->init(filePath);
    return 0;
}
    
static int t_loadAudioData(lua_State* L)
{
    const std::shared_ptr<AudioClip>& audioClip = luax_to_cproxy<AudioClip>(L, 1);
    audioClip->loadAudioData();
    return 0;
}
    
extern "C" int runtime_audio_clip(lua_State* L)
{
    luaL_Reg l[] = {
        {"new", t_new},
        {"init", t_init},
        {"loadAudioData", t_loadAudioData},
        { NULL, NULL },
    };
    luaL_newlib(L,l);
    return 1;
}
}
}