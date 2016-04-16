//
//  RenderModule.hpp
//  Wukong
//
//  Created by Xuhui on 16/4/14.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef RenderModule_h
#define RenderModule_h

#include "Closure.h"
#include "Module.h"
#include "Thread.h"
#include "SDL.h"

#include <vector>

namespace WukongEngine {
namespace Runtime {
    
class RenderModule: public Module
{
    
public:
    
    typedef std::vector<Base::Closure> CommandBuffer;
    
    RenderModule();
    virtual ~RenderModule();
    
    virtual ModuleType moduleType() const { return ModuleRender; }
    
    virtual std::string moduleName() const { return "runtime.renderer"; }
    
    void start(SDL_Window *window, SDL_GLContext context, SDL_Renderer *renderer);
    
    void clear(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    
    void draw(SDL_Texture* texture,
              const SDL_Rect* srcrect,
              const SDL_Rect* dstrect,
              const double angle,
              const SDL_Point* center);
    
    void drawRect(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const SDL_Rect* dstrect);
    
    void present();
    
    void renderBegin();
    void renderEnd(const Base::Closure& completionHandler);
    
private:
    
    void drawInternal(SDL_Texture* texture,
                      const SDL_Rect& srcrect,
                      const SDL_Rect& dstrect,
                      const double angle,
                      const SDL_Point& center);
    
    void drawRectInternal(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const SDL_Rect& dstrect);
    
    void excute(const std::vector<Base::Closure>& commandBuffer);
    
    void postTask(const Base::Closure& closure);
    
    std::shared_ptr<Base::Thread> thread_;
    SDL_Renderer* renderer_;
    
    CommandBuffer commandBuffer_;
    
};
    
}
}

#endif /* RenderModule_hpp */
