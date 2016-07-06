//
//  main.cpp
//  AppCore
//
//  Created by Xuhui on 16/2/2.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "SDL.h"
#include "base/thread/Thread.h"
#include "base/message_loop/MessageLoop.h"
#include "WukongEngine.h"
#include <memory>
#import <UIKit/UIKit.h>

std::shared_ptr<WukongEngine::WukongEngine> engine_;

int main(int argc, char *argv[])
{
    @autoreleasepool {
        SDL_Window *window;         /* main window */
        SDL_Renderer *renderer;
        /* initialize SDL */
        if (SDL_Init(SDL_INIT_VIDEO) < 0) {
            printf("Could not initialize SDL");
            exit(1);
        }
        
        SDL_DisplayMode displayMode;
        SDL_GetCurrentDisplayMode(0, &displayMode);
        
        /* create main window and renderer */
        window = SDL_CreateWindow(NULL, 0, 0, displayMode.w, displayMode.h,
                                  SDL_WINDOW_OPENGL |
                                  SDL_WINDOW_BORDERLESS);
        renderer = SDL_CreateRenderer(window, 0, 0);

        engine_ = std::shared_ptr<WukongEngine::WukongEngine>(new WukongEngine::WukongEngine("wukong"));
        WukongEngine::WukongEngine::EngineEnv env;
        env.moduleDirectory = [[[NSBundle mainBundle] resourcePath] UTF8String];
        env.serviceDirectory = [[[NSBundle mainBundle] resourcePath] UTF8String];
        env.scriptDirectory = [[[NSBundle mainBundle] resourcePath] UTF8String];
        env.tempDirectory = [NSTemporaryDirectory() UTF8String];
        env.window = window;
        env.renderer = renderer;
        env.screenWidth = displayMode.w;
        env.screenHeight = displayMode.h;
        env.refreshRate = displayMode.refresh_rate > 0 ? displayMode.refresh_rate : 60;
        env.context = SDL_GL_GetCurrentContext();
        engine_->start(env);
    }
    return 0;
}