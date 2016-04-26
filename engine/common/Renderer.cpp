//
//  Renderer.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/20.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "Renderer.h"
#include "Runtime.h"
#include "SDL.h"

namespace WukongEngine {
    
Renderer::Renderer(SDL_Renderer* renderer):renderer_(renderer)
{
    
}
    
Renderer::~Renderer()
{
    SDL_DestroyRenderer(renderer_);
}
    
void Renderer::clear(uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    SDL_SetRenderDrawColor(renderer_, r, g, b, a);
    SDL_RenderClear(renderer_);
}

void Renderer::draw(const std::shared_ptr<Texture>& texture,
          const Rect& srcrect,
          const Rect& dstrect,
          const double angle,
          const Point& center)
{
    SDL_RenderCopyEx(renderer_, texture->texture(), (SDL_Rect*)&srcrect, (SDL_Rect*)&dstrect, angle, (SDL_Point*)&center, SDL_FLIP_NONE);
}

void Renderer::drawRect(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const Rect& dstrect)
{
    SDL_SetRenderDrawColor(renderer_, r, g, b, a);
    SDL_RenderDrawRect(renderer_, (SDL_Rect*)&dstrect);
}

void Renderer::present()
{
    SDL_RenderPresent(renderer_);
}
    
}