//
//  RenderModule_LuaBinding.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/14.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "RenderModule_LuaBinding.h"
#include "RenderModule.h"
#include "Texture.h"

#include <functional>
#include <iostream>

namespace WukongEngine {
namespace Runtime {
    
#define instance() (WukongEngine::Module::getInstance<RenderModule>(WukongEngine::Module::ModuleRender))
    
static int m_start(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    Window* window = (Window*)lua_touserdata(L, 1);
    GLContext context = (GLContext)lua_touserdata(L, 2);
    const std::shared_ptr<Renderer>& renderer = luax_to_objectPtr<Renderer>(L, 3);
    instance->start(window, context, renderer);
    
    return 0;
}
    
static int m_clear(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    int r = (int)lua_tointeger(L, 1);
    int g = (int)lua_tointeger(L, 2);
    int b = (int)lua_tointeger(L, 3);
    int a = (int)lua_tointeger(L, 4);
    instance->clear(r, g, b, a);
    
    return 0;
}
    
static int m_draw(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    lua_getfield(L, 1, "_cproxy");
    const std::shared_ptr<Texture>& texture = luax_to_objectPtr<Texture>(L, -1);
    const Rect& srcRect = luax_to_rect(L, 2);
    const Rect& dstRect = luax_to_rect(L, 3);
    double angle = lua_tonumber(L, 4);
    const Point& center = luax_to_point(L, 5);
    instance->draw(texture, srcRect, dstRect, angle, center);
    
    return 0;
}
    
static int m_drawRect(lua_State* L)
{

    return 0;
}
    
static int m_present(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    instance->present();
    return 0;
}
    
static int m_renderBegin(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    instance->renderBegin();
    return 0;
}
    
static int m_renderEnd(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    instance->renderEnd();
    return 0;
}

static const luaL_Reg functions[] =
{
    {"start", m_start},
    {"clear", m_clear},
    {"draw", m_draw},
    {"drawRect", m_drawRect},
    {"present", m_present},
    {"renderBegin", m_renderBegin},
    {"renderEnd", m_renderEnd},
    {0, 0}
};

extern "C" int luaopen_RenderModule(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    if(!instance) {
        instance = std::shared_ptr<RenderModule>(new RenderModule());
    }
    
    WrappedModule m;
    m.module = instance;
    m.name = "render";
    m.functions = functions;
    
    return luax_register_module(L, m);
}
    
}
}
