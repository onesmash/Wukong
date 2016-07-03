//
//  LCanvas.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/30.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "LCanvas.h"
#include "Canvas.h"
#include "Renderer.h"
#include "TTFont.h"

namespace WukongEngine {
    
namespace Runtime {
static int t_new(lua_State* L)
{
    lua_newtable(L);
    lua_pushvalue(L, 1);
    lua_setmetatable(L, 2);
    luax_push_objectPtr(L, new Canvas());
    lua_setfield(L, 2, "_cproxy");
    return 1;
}
    
static int t_init(lua_State* L)
{
    const std::shared_ptr<Canvas>& font = luax_to_cproxy<Canvas>(L, 1);
    lua_Integer width = lua_tointeger(L, 2);
    lua_Integer height = lua_tointeger(L, 3);
    font->init((int)width, (int)height);
    return 0;
}

static int t_drawText(lua_State* L)
{
    const std::shared_ptr<Canvas>& canvas = luax_to_cproxy<Canvas>(L, 1);
    const std::string text(lua_tostring(L, 2));
    const std::shared_ptr<TTFont>& font = luax_to_cproxy<TTFont>(L, 3);
    const Color color = luax_to_color(L, 4);
    canvas->drawText(text, *font, color.r, color.g, color.b, color.a);
    return 0;
}

extern "C" int runtime_canvas(lua_State* L)
{
    luaL_Reg l[] = {
        {"new", t_new},
        {"init", t_init},
        {"drawText", t_drawText},
        { NULL, NULL },
    };
    luaL_newlib(L, l);
    return 1;
}
}
}
