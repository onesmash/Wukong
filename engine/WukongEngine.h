//
//  AppCore.h
//  AppCore
//
//  Created by Xuhui on 15/6/21.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore__AppCore__
#define __AppCore__AppCore__
#include "base/thread/Thread.h"
#include <memory>
#include <string>
#include <list>

extern "C" struct lua_State;
extern "C" struct SDL_Window;
extern "C" struct SDL_Renderer;

namespace WukongEngine {
    
class WukongEngine {
public:
    struct EngineEnv {
        std::string moduleDirectory;
        std::string serviceDirectory;
        std::string scriptDirectory;
        std::string tempDirectory;
        SDL_Window *window;
        SDL_Renderer *renderer;
        void *context;
        int screenWidth;
        int screenHeight;
        int refreshRate;
    };
    explicit WukongEngine(const std::string& name);
    virtual ~WukongEngine();
    void start(const EngineEnv& env);
    void stop();
    
private:
    
    void startInternal();
    void stopInternal();
    
    std::shared_ptr<WukongBase::Base::Thread> thread_;
    lua_State *L_;
    EngineEnv env_;
    //std::list<Base::MessageLoop::MessageLoopObserver> observers_;
};
}

#endif /* defined(__AppCore__AppCore__) */
