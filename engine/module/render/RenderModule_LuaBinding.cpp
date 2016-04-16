//
//  RenderModule_LuaBinding.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/14.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "RenderModule_LuaBinding.h"
#include "RenderModule.h"

extern "C" {
#include "texture.h"
#include "common/video.h"
#include "common/common.h"
}

#include <functional>
#include <iostream>

namespace WukongEngine {
namespace Runtime {
    
#define instance() (WukongEngine::Module::getInstance<RenderModule>(WukongEngine::Module::ModuleRender))
    
static int m_start(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    SDL_Window* window = (SDL_Window*)lua_touserdata(L, 1);
    SDL_GLContext context = (SDL_GLContext)lua_touserdata(L, 2);
    SDL_Renderer *renderer = (SDL_Renderer*)lua_touserdata(L, 3);
    instance->start(window, context, renderer);
    
    return 0;
}
    
static int m_clear(lua_State* L)
{
    std::shared_ptr<RenderModule>& instance = instance();
    SDL_Color c;
    c = videoGetColorRGB(L, 1);
    instance->clear(c.r, c.g, c.b, c.a);
    return 0;
}
    
static int m_draw(lua_State* L)
{
#define GET_RECT(idx, rect, rectptr) do {			\
    videoGetRect(L, idx, &rect);				\
    rectptr = &rect;					\
} while (/* CONSTCOND */ 0)
    std::shared_ptr<RenderModule>& instance = instance();
    SDL_Texture *tex = commonGetAs(L, 1, TextureName, SDL_Texture *);
    SDL_Point point, *pointptr = NULL;
    SDL_Rect srcr, *srcptr = NULL;
    SDL_Rect dstr, *dstptr = NULL;
    double angle;
    
    GET_RECT(2, srcr, srcptr);
    GET_RECT(3, dstr, dstptr);
    
    angle = lua_tonumber(L, 4);
    
    videoGetPoint(L, 5, &point);
    pointptr = &point;
    
    instance->draw(tex, srcptr, dstptr, angle, pointptr);
    
    return 0;
}
    
static int m_drawRect(lua_State* L)
{
#define GET_RECT(idx, rect, rectptr) do {			\
    videoGetRect(L, idx, &rect);				\
    rectptr = &rect;					\
} while (/* CONSTCOND */ 0)
    std::shared_ptr<RenderModule>& instance = instance();
    SDL_Color c;
    SDL_Rect dstr, *dstptr = NULL;
    c = videoGetColorRGB(L, 1);
    GET_RECT(2, dstr, dstptr);
    instance->drawRect(c.r, c.g, c.b, c.a, dstptr);
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
    lua_pushvalue(L, -1);
    int closureId = luaL_ref(L, LUA_REGISTRYINDEX);
    auto closure = [](lua_State* L, int closureId) {
        lua_getglobal(L, "debug");
        lua_getfield(L, -1, "traceback");
        lua_rawgeti(L, LUA_REGISTRYINDEX, closureId);
        if(lua_pcall(L, 0, 0, -2)) {
            std::cerr << "Uncaught Error: " << lua_tostring(L, -1) << std::endl;
            lua_pop(L, 1);
        }
        luaL_unref(L, LUA_REGISTRYINDEX, closureId);
    };
    instance->renderEnd(std::bind(closure, L, closureId));
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
