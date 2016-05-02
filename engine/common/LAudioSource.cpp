//
//  LAudioSource.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "LAudioSource.h"
#include "AudioSource.h"

namespace WukongEngine {

namespace Runtime {

static int t_new(lua_State* L)
{
    lua_newtable(L);
    lua_pushvalue(L, 1);
    lua_setmetatable(L, 2);
    luax_push_objectPtr(L, new AudioSource());
    lua_setfield(L, 2, "_cproxy");
    return 1;
}
    
static int t_setClip(lua_State* L)
{
    const std::shared_ptr<AudioSource>& audioSource = luax_to_cproxy<AudioSource>(L, 1);
    const std::shared_ptr<AudioClip>& audioClip = luax_to_cproxy<AudioClip>(L, 2);
    audioSource->setClip(audioClip);
    return 0;
}
    
extern "C" int runtime_audio_source(lua_State* L)
{
    luaL_Reg l[] = {
        {"new", t_new},
        {"setClip", t_setClip},
        { NULL, NULL },
    };
    luaL_newlib(L,l);
    return 1;
}
}
}