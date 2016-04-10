//
//  AppCore.cpp
//  AppCore
//
//  Created by Xuhui on 15/6/21.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "WukongEngine.h"
#include "Runtime_LuaBinding.h"
#include "MessageLoop.h"
#include "lfs.h"
#include "SDL.h"

#include <iostream>

extern "C" {
#include "renderer.h"
#include <common/common.h>
}

extern "C" int luaopen_SDL(lua_State*);
extern "C" int luaopen_SDL_image(lua_State*);

namespace WukongEngine {
WukongEngine::WukongEngine(const std::string& name)
{
    L_ = luaL_newstate();
    thread_ = std::shared_ptr<Base::Thread>(new Base::Thread(name));
}
    
WukongEngine::~WukongEngine()
{
    thread_->stop();
    lua_close(L_);
}
    
void WukongEngine::start(const EngineEnv& env)
{
    env_ = env;
    thread_->start();
    thread_->messageLoop()->postTask(std::bind(&WukongEngine::startInternal, this));
}
    
void WukongEngine::stop()
{
    thread_->messageLoop()->postTask(std::bind(&WukongEngine::stopInternal, this));
}
    
void WukongEngine::startInternal()
{
    luaL_openlibs(L_);
    Runtime::luax_preload(L_, Runtime::luaopen_runtime, "runtime");
    Runtime::luax_preload(L_, luaopen_lfs, "lfs");
    Runtime::luax_preload(L_, luaopen_SDL, "SDL");
    Runtime::luax_preload(L_, luaopen_SDL_image, "SDL.image");
    
    lua_getglobal(L_, "require");
    lua_pushstring(L_, "SDL");
    lua_call(L_, 1, 1);
    lua_getglobal(L_, "require");
    lua_pushstring(L_, "runtime");
    lua_call(L_, 1, 1);
    lua_pushstring(L_, env_.moduleDirectory.c_str());
    lua_setfield(L_, -2, "_moduleDirectory");
    lua_pushstring(L_, env_.serviceDirectory.c_str());
    lua_setfield(L_, -2, "_serviceDirectory");
    lua_pushstring(L_, env_.scriptDirectory.c_str());
    lua_setfield(L_, -2, "_scriptDirectory");
    commonPush(L_, "p", RendererName, env_.renderer);
    lua_setfield(L_, -2, "_renderer");
    lua_pop(L_, 1);
    
    SDL_GL_MakeCurrent(env_.window, env_.context);
    
    lua_getglobal(L_, "debug");
    lua_getfield(L_, -1, "traceback");
    
    std::string bootScriptFilePath = env_.scriptDirectory + "/boot.lua";
    if (luaL_loadfile(L_,  bootScriptFilePath.c_str()) == LUA_OK) {
        if(lua_pcall(L_, 0, 0, -2)) {
            std::cerr << "Uncaught Error: " << lua_tostring(L_, -1) << std::endl;
            lua_pop(L_, 2);
            return;
        }
    }
    lua_pop(L_, 1);
}
    
void WukongEngine::stopInternal()
{
    thread_->stop();
}
    
}