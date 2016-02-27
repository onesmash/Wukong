//
//  Runtime.h
//  AppCore
//
//  Created by Xuhui on 15/6/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore__Runtime__
#define __AppCore__Runtime__

#include <memory>
#include "Config.h"

extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

namespace WukongEngine {
    
class Object;
class Module;

namespace Runtime {
    

    
struct WrappedModule {
    std::shared_ptr<Module> module;
    
    const char *name;
    
    const luaL_Reg *functions;
};
    
enum Registry {
    REGISTRY_MODULES,
};
    
enum Type {
    TypeModule,
    TypeMaxEnum
};
    
struct Proxy {
    Type type;
    std::shared_ptr<Object> object;
    //Object *object;
};
    
int luax_ensure_global(lua_State* L, const char* k);
    
int luax_ensure_runtime(lua_State* L, const char* k);
    
int luax_ensure_registry(lua_State *L, Registry r);
    
int luax_ensure_table(lua_State *L, int idx, const char *k);
    
int luax_preload(lua_State *L, lua_CFunction f, const char *name);
    
int luax_register_module(lua_State *L, const WrappedModule &m);
    
void luax_setfuncs(lua_State *L, const luaL_Reg *l);
    
}
    
}

#endif /* defined(__AppCore__Runtime__) */
