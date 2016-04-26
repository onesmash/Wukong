//
//  RenderModule.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/14.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "RenderModule.h"
#include "Runtime.h"
#include "MessageLoop.h"
#include "SDL.h"

namespace WukongEngine {
namespace Runtime {
    
RenderModule::RenderModule():commandBuffer_()
{
    thread_ = std::shared_ptr<Base::Thread>(new Base::Thread("Render"));
}
    
RenderModule::~RenderModule()
{
    thread_->stop();
}
    
void RenderModule::start(Window *window, GLContext context, const std::shared_ptr<Renderer>& renderer)
{
    renderer_ = renderer;
    auto closure = [](Window *window, GLContext context) {
        SDL_GL_MakeCurrent(window, context);
    };
    thread_->start();
    thread_->messageLoop()->postTask(std::bind(closure, window, context));
}
    
void RenderModule::clear(uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    commandBuffer_.push_back(std::bind(&Renderer::clear, renderer_, r, g, b, a));
}
    
void RenderModule::renderBegin()
{
    commandBuffer_.clear();
}
    
void RenderModule::renderEnd()
{
    postTask(std::bind(&RenderModule::excute, this, std::move(commandBuffer_)));
}
    
void RenderModule::draw(const std::shared_ptr<Texture>& texture,
                        const Rect& srcrect,
                        const Rect& dstrect,
                        const double angle,
                        const Point& center)
{
    commandBuffer_.push_back(std::bind(&Renderer::draw, renderer_, texture, srcrect, dstrect, angle, center));
}
    
void RenderModule::drawRect(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const Rect& dstrect)
{
    commandBuffer_.push_back(std::bind(&Renderer::drawRect, renderer_, r, g, b, a, dstrect));
}
    
void RenderModule::present()
{
    commandBuffer_.push_back(std::bind(&Renderer::present, renderer_));
}
    
void RenderModule::excute(const CommandBuffer& commandBuffer)
{
    for (CommandBuffer::const_iterator iter = commandBuffer.begin(); iter != commandBuffer.end(); ++iter) {
        (*iter)();
    }
}
    
void RenderModule::postTask(const Base::Closure& closure)
{
    thread_->messageLoop()->postTask(closure);
}
}
    
}
