//
//  AudioModule_LuaBinding.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "AudioModule_LuaBinding.h"
#include "AudioModule.h"

namespace WukongEngine {
namespace Runtime {
    
#define instance() (WukongEngine::Module::getInstance<AudioModule>(WukongEngine::Module::ModuleAudio))
    
static int m_start(lua_State* L)
{
    std::shared_ptr<AudioModule>& instance = instance();
    instance->start();
    
    return 0;
}
    
static int m_play(lua_State* L)
{
    std::shared_ptr<AudioModule>& instance = instance();
    const std::shared_ptr<AudioSource>& audioSource = luax_to_cproxy<AudioSource>(L, 1);
    double limit = lua_tonumber(L, 2);
    instance->play(audioSource, limit);
    return 0;
}
    
static int m_playDelayed(lua_State* L)
{
    std::shared_ptr<AudioModule>& instance = instance();
    const std::shared_ptr<AudioSource>& audioSource = luax_to_cproxy<AudioSource>(L, 1);
    double seconds = lua_tonumber(L, 2);
    double limit = lua_tonumber(L, 3);
    instance->playDelayed(audioSource, seconds, limit);
    return 0;
}
    
static int m_stop(lua_State* L)
{
    std::shared_ptr<AudioModule>& instance = instance();
    const std::shared_ptr<AudioSource>& audioSource = luax_to_cproxy<AudioSource>(L, 1);
    instance->stop(audioSource);
    return 0;
}
 
static const luaL_Reg functions[] =
{
    {"start", m_start},
    {"play", m_play},
    {"playDelayed", m_playDelayed},
    {"stop", m_stop},
    {0, 0}
};

extern "C" int luaopen_AudioModule(lua_State* L)
{
    std::shared_ptr<AudioModule>& instance = instance();
    if(!instance) {
        instance = std::shared_ptr<AudioModule>(new AudioModule());
    }
    
    WrappedModule m;
    m.module = instance;
    m.name = "audio";
    m.functions = functions;
    
    return luax_register_module(L, m);
}
    
}
}
