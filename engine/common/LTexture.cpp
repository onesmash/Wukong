//
//  LTexture.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/20.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "LTexture.h"
#include "Runtime.h"
#include "Texture.h"
#include "Renderer.h"

namespace WukongEngine {
    
namespace Runtime {
    
static int t_new(lua_State* L)
{
    lua_newtable(L);
    lua_pushvalue(L, 1);
    lua_setmetatable(L, 2);
    luax_push_objectPtr(L, new Texture());
    lua_setfield(L, 2, "_cproxy");
    return 1;
}
    
static int t_size(lua_State* L)
{
    lua_getfield(L, 1, "_cproxy");
    Proxy<Texture>** proxyP = (Proxy<Texture>**)lua_touserdata(L, -1);
    const std::shared_ptr<Texture>& texture = (*proxyP)->object;
    const Size& size = texture->size();
    lua_pushinteger(L, size.width);
    lua_pushinteger(L, size.height);
    return 2;
}
    
static int t_loadImage(lua_State* L)
{
    lua_getfield(L, 1, "_cproxy");
    Proxy<Texture>** textureProxyP = (Proxy<Texture>**)lua_touserdata(L, -1);
    Proxy<Renderer>** rendererProxyP = (Proxy<Renderer>**)lua_touserdata(L, 2);
    const std::string path(lua_tostring(L, 3));
    const std::shared_ptr<Texture> texture = (*textureProxyP)->object;
    const std::shared_ptr<Renderer> renderer = (*rendererProxyP)->object;
    texture->loadImage(*renderer, path);
    return 0;
}
    
extern "C" int runtime_texture(lua_State* L)
{
    luaL_Reg l[] = {
        {"new", t_new},
        {"size", t_size},
        {"loadImage", t_loadImage},
        { NULL, NULL },
    };
    luaL_newlib(L,l);
    return 1;
}
}
}