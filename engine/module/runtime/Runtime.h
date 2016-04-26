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
    
struct Size {
    int width;
    int height;
};
    
struct Rect {
    int x, y;
    int w, h;
};

struct Point
{
    int x, y;
};
    
struct Color
{
    int r, g, b, a;
};

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
    TypeObject,
    TypeMaxEnum
};
 
template <typename T>
struct Proxy {
    Type type;
    std::shared_ptr<T> object;
    //Object *object;
};
    
int luax_ensure_global(lua_State* L, const char* k);
    
int luax_ensure_runtime(lua_State* L, const char* k);
    
int luax_ensure_registry(lua_State* L, Registry r);
    
int luax_ensure_table(lua_State* L, int idx, const char *k);
    
int luax_preload(lua_State* L, lua_CFunction f, const char *name);
    
int luax_register_module(lua_State* L, const WrappedModule &m);
    
void luax_setfuncs(lua_State* L, const luaL_Reg *l);
 
int rt_gc(lua_State* L);
    
template<typename T>
void luax_push_objectPtr(lua_State* L, T* object)
{
    Proxy<T>** proxy = (Proxy<T>**)lua_newuserdata(L, sizeof(Proxy<T>*));
    *proxy = new Proxy<T>;
    (*proxy)->type = TypeObject;
    (*proxy)->object = std::shared_ptr<T>(object);
    typedef typename T::TypeName TypeName;
    luaL_newmetatable(L, TypeName::stringify());
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, rt_gc);
    lua_setfield(L, -2, "__gc");
    lua_setmetatable(L, -2);
}

template<typename T>
std::shared_ptr<T> luax_to_objectPtr(lua_State* L, int index)
{
    Proxy<T> **proxy = (Proxy<T> **)lua_touserdata(L, index);
    return (*proxy)->object;
}
    
Rect luax_to_rect(lua_State* L, int index);
    
Point luax_to_point(lua_State* L, int index);
    
}
    
}

#endif /* defined(__AppCore__Runtime__) */
