//
//  RenderModule.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/14.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "RenderModule.h"
#include "MessageLoop.h"

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
    
void RenderModule::start(SDL_Window *window, SDL_GLContext context, SDL_Renderer *renderer)
{
    renderer_ = renderer;
    auto closure = [](SDL_Window *window, SDL_GLContext context) {
        SDL_GL_MakeCurrent(window, context);
    };
    thread_->start();
    thread_->messageLoop()->postTask(std::bind(closure, window, context));
}
    
void RenderModule::clear(uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    commandBuffer_.push_back(std::bind(SDL_SetRenderDrawColor, renderer_, r, g, b, a));
    commandBuffer_.push_back(std::bind(SDL_RenderClear, renderer_));
}
    
void RenderModule::renderBegin()
{
    //printf("queue size %d", thread_->messageLoop()->taskQueueSize());
    commandBuffer_.clear();
}
    
void RenderModule::renderEnd(const Base::Closure& completionHandler)
{
    commandBuffer_.push_back(std::bind(&Base::MessageLoop::postTask, Base::MessageLoop::current(), completionHandler));
    postTask(std::bind(&RenderModule::excute, this, std::move(commandBuffer_)));
}
    
void RenderModule::draw(SDL_Texture* texture,
                        const SDL_Rect* srcrect,
                        const SDL_Rect* dstrect,
                        const double angle,
                        const SDL_Point* center)
{
    commandBuffer_.push_back(std::bind(&RenderModule::drawInternal, this, texture, *srcrect, *dstrect, angle, *center));
}
    
void RenderModule::drawRect(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const SDL_Rect* dstrect)
{
    commandBuffer_.push_back(std::bind(&RenderModule::drawRectInternal, this, r, g, b, a, *dstrect));
}
    
void RenderModule::present()
{
    commandBuffer_.push_back(std::bind(SDL_RenderPresent, renderer_));
}
    
void RenderModule::excute(const CommandBuffer& commandBuffer)
{
    for (CommandBuffer::const_iterator iter = commandBuffer.begin(); iter != commandBuffer.end(); ++iter) {
        (*iter)();
    }
}

void RenderModule::drawInternal(SDL_Texture* texture,
                                const SDL_Rect& srcrect,
                                const SDL_Rect& dstrect,
                                const double angle,
                                const SDL_Point& center)
{
    SDL_RenderCopyEx(renderer_, texture, &srcrect, &dstrect, angle, &center, SDL_FLIP_NONE);
}
    
void RenderModule::drawRectInternal(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const SDL_Rect& dstrect)
{
    SDL_SetRenderDrawColor(renderer_, r, g, b, a);
    SDL_RenderDrawRect(renderer_, &dstrect);
}
    
void RenderModule::postTask(const Base::Closure& closure)
{
    thread_->messageLoop()->postTask(closure);
}
}
    
}
