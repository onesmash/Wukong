//
//  TimeModule_LuaBinding.cpp
//  AppCore
//
//  Created by Xuhui on 16/1/21.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "TimeModule_LuaBinding.h"
#include "TimeModule.h"

namespace WukongEngine {
namespace Runtime {
    
#define instance() (WukongEngine::Module::getInstance<TimeModule>(WukongEngine::Module::ModuleTime))
    
static int m_now(lua_State* L)
{
    std::shared_ptr<TimeModule>& instance = instance();
    lua_pushnumber(L, instance->now());
    return 1;
}
    
static const luaL_Reg functions[] =
{
    {"now", m_now},
    {0, 0}
};

extern "C" int luaopen_TimeModule(lua_State* L)
{
    std::shared_ptr<TimeModule>& instance = instance();
    if(!instance) {
        instance = std::shared_ptr<TimeModule>(new TimeModule());
    }
    
    WrappedModule m;
    m.module = instance;
    m.name = "time";
    m.functions = functions;
    
    return luax_register_module(L, m);
}
    
    
}
}