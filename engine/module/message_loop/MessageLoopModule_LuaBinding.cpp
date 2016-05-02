//
//  MessageLoopModule_LuaBinding.cpp
//  AppCore
//
//  Created by Xuhui on 15/12/14.
//  Copyright © 2015年 Xuhui. All rights reserved.
//

#include "MessageLoopModule_LuaBinding.h"
#include "MessageLoopModule.h"

#include <functional>
#include <iostream>

namespace WukongEngine {
namespace Runtime {
    
#define instance() (WukongEngine::Module::getInstance<MessageLoopModule>(WukongEngine::Module::ModuleMessageLoop))
    
static void callLuaCallback(lua_State* L, int closureId)
{
    lua_getglobal(L, "debug");
    lua_getfield(L, -1, "traceback");
    lua_rawgeti(L, LUA_REGISTRYINDEX, closureId);
    if(lua_pcall(L, 0, 0, -2)) {
        std::cerr << "Uncaught Error: " << lua_tostring(L, -1) << std::endl;
        lua_pop(L, 2);
    }
    lua_pop(L, 2);
    luaL_unref(L, LUA_REGISTRYINDEX, closureId);
}
    
static int m_postTask(lua_State* L)
{
    lua_pushvalue(L, -1);
    int closureId = luaL_ref(L, LUA_REGISTRYINDEX);
    std::shared_ptr<MessageLoopModule>& instance = instance();
    instance->postTask(std::bind(callLuaCallback, L, closureId));
    return 0;
}
    
static int m_postDelayTask(lua_State* L)
{
    lua_pushvalue(L, 1);
    int closureId = luaL_ref(L, LUA_REGISTRYINDEX);
    lua_Number delay = luaL_checknumber(L, 2);
    std::shared_ptr<MessageLoopModule>& instance = instance();
    instance->postDelayTask(std::bind(callLuaCallback, L, closureId), delay);
    return 0;
}
    
static const luaL_Reg functions[] =
{
    {"postTask", m_postTask},
    {"postDelayTask", m_postDelayTask},
    {0, 0}
};
    
extern "C" int luaopen_MessageLoopModule(lua_State* L)
{
    std::shared_ptr<MessageLoopModule>& instance = instance();
    if(!instance) {
        instance = std::shared_ptr<MessageLoopModule>(new MessageLoopModule());
    }
    
    WrappedModule m;
    m.module = instance;
    m.name = "messageloop";
    m.functions = functions;
    
    return luax_register_module(L, m);
}
    
}
}