//
//  LTTFont.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/26.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "LTTFont.h"
#include "TTFont.h"

namespace WukongEngine {
    
namespace Runtime {
   
static int t_new(lua_State* L)
{
    lua_newtable(L);
    lua_pushvalue(L, 1);
    lua_setmetatable(L, 2);
    luax_push_objectPtr(L, new TTFont());
    lua_setfield(L, 2, "_cproxy");
    return 1;
}
    
static int t_init(lua_State* L)
{
    const std::shared_ptr<TTFont>& font = luax_to_cproxy<TTFont>(L, 1);
    const char* fontPath = lua_tostring(L, 2);
    lua_Integer fontSize = lua_tointeger(L, 3);
    font->init(fontPath, (int)fontSize);
    return 0;
}
    
extern "C" int runtime_ttfont(lua_State* L)
{
    luaL_Reg l[] = {
        {"new", t_new},
        {"init", t_init},
        { NULL, NULL },
    };
    luaL_newlib(L, l);
    return 1;
}
    
}
}