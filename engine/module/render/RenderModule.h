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
#include "Renderer.h"
#include "Texture.h"

#include <vector>

struct SDL_Window;
typedef void *SDL_GLContext;

namespace WukongEngine {
    
typedef SDL_Window Window;
typedef SDL_GLContext GLContext;
    
struct Rect;
struct Point;
    
namespace Runtime {
    
class RenderModule: public Module
{
    
public:
    
    typedef std::vector<Base::Closure> CommandBuffer;
    
    RenderModule();
    virtual ~RenderModule();
    
    virtual ModuleType moduleType() const { return ModuleRender; }
    
    virtual std::string moduleName() const { return "runtime.render"; }
    
    void start(Window *window, GLContext context, const std::shared_ptr<Renderer>& renderer);
    
    void clear(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    
    void draw(const std::shared_ptr<Texture>& texture,
              const Rect& srcrect,
              const Rect& dstrect,
              const double angle,
              const Point& center);
    
    void drawRect(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const Rect& dstrect);
    
    void present();
    
    void renderBegin();
    void renderEnd();
    
private:
    
    void excute(const std::vector<Base::Closure>& commandBuffer);
    
    void postTask(const Base::Closure& closure);
    
    std::shared_ptr<Base::Thread> thread_;
    std::shared_ptr<Renderer> renderer_;
    
    CommandBuffer commandBuffer_;
    
};
    
}
}

#endif /* RenderModule_hpp */
