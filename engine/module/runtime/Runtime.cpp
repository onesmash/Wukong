//
//  Runtime.cpp
//  AppCore
//
//  Created by Xuhui on 15/6/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "Runtime.h"
#include "Object.h"
#include "Module.h"

namespace WukongEngine {
    
namespace Runtime {
    
static int rt_gc(lua_State* L)
{
    Proxy **p = (Proxy **) lua_touserdata(L, 1);
    delete *p;
    *p = nullptr;
    return 0;
}
    
int luax_ensure_global(lua_State* L, const char* k)
{
    lua_getglobal(L, k);
    if(!lua_istable(L, -1)) {
        lua_pop(L, 1);
        lua_newtable(L);
        lua_pushvalue(L, -1);
        lua_setglobal(L, k);
    }
    return 1;
}
    
int luax_ensure_runtime(lua_State* L, const char* k)
{
    luax_ensure_global(L, "runtime");
    luax_ensure_table(L, -1, k);
    
    lua_replace(L, -2);
    
    return 1;
}
    
int luax_ensure_registry(lua_State *L, Registry r)
{
    switch (r) {
        case REGISTRY_MODULES:
            return luax_ensure_runtime(L, "_modules");
        default:
            return luaL_error(L, "Attempted to use invalid registry.");
    }
}
    
int luax_ensure_table(lua_State *L, int idx, const char *k)
{
    if (idx < 0 && idx > LUA_REGISTRYINDEX)
        idx += lua_gettop(L) + 1;
    
    lua_getfield(L, idx, k);
    
    if (!lua_istable(L, -1))
    {
        lua_pop(L, 1);
        lua_newtable(L);
        lua_pushvalue(L, -1);
        lua_setfield(L, idx, k);
    }
    
    return 1;
}

int luax_preload(lua_State *L, lua_CFunction f, const char *name)
{
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    lua_pushcfunction(L, f);
    lua_setfield(L, -2, name);
    lua_pop(L, 2);
    return 1;
}
    
int luax_register_module(lua_State *L, const WrappedModule &m)
{
    luax_ensure_registry(L, REGISTRY_MODULES);
    
    Proxy **proxy = (Proxy **)lua_newuserdata(L, sizeof(Proxy *));
    *proxy = new Proxy;
    (*proxy)->type = TypeModule;
    (*proxy)->object = m.module;
    
    luaL_newmetatable(L, m.module->moduleName().c_str());
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, rt_gc);
    lua_setfield(L, -2, "__gc");
    
    lua_setmetatable(L, -2);
    lua_setfield(L, -2, m.name); // _modules[name] = proxy
    lua_pop(L, 1);
    
    luax_ensure_global(L, "runtime");
    
    lua_newtable(L);
    
    if (m.functions != nullptr)
        luax_setfuncs(L, m.functions);
    
    lua_pushvalue(L, -1);
    lua_setfield(L, -3, m.name);
    lua_remove(L, -2);
    
    WukongEngine::Module::registerModule(m.module);
    
    return 1;
}
    
void luax_setfuncs(lua_State *L, const luaL_Reg *l)
{
    if (l == nullptr)
        return;
    
    for (; l->name != nullptr; l++) {
        lua_pushcfunction(L, l->func);
        lua_setfield(L, -2, l->name);
    }
}
    
}

}