//
//  Runtime_LuaBinding.cpp
//  AppCore
//
//  Created by Xuhui on 15/6/16.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "Runtime_LuaBinding.h"

namespace WukongEngine {
namespace Runtime {
    
extern "C"
{
extern int luaopen_MessageLoopModule(lua_State*);
extern int luaopen_TimeModule(lua_State*);
extern int luaopen_RenderModule(lua_State*);
extern int runtime_texture(lua_State* L);
}

static const luaL_Reg modules[] =
{
    {"runtime.messageloop", luaopen_MessageLoopModule},
    {"runtime.time", luaopen_TimeModule},
    {"runtime.render", luaopen_RenderModule},
    {0, 0}
};
    
static const luaL_Reg types[] =
{
    {"runtime.texture.c", runtime_texture},
    {0, 0}
};
    
extern "C" int luaopen_runtime(lua_State* L)
{
    luax_ensure_global(L, "runtime");
    const luaL_Reg *reg = &types[0];
    for (; reg->name != nullptr; reg++) {
        luaL_requiref(L, reg->name, reg->func, 0);
    }
    for (int i = 0; modules[i].name != 0; i++) {
        luax_preload(L, modules[i].func, modules[i].name);
    }
    return 1;
}
    
}
}