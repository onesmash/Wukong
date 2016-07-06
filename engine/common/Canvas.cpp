//
//  Canvas.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/30.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "Canvas.h"
#include "SDL.h"
#include "Renderer.h"
#include "TTFont.h"

namespace WukongEngine {
    
Canvas::~Canvas()
{
    SDL_FreeSurface(surface_);

}
    
void Canvas::init(int width, int height)
{
    width_ = width;
    height_ = height;
    surface_ = SDL_CreateRGBSurface(SDL_SWSURFACE,
                                    width_,
                                    height_,
                                    32, 0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000);
}
    
void Canvas::drawText(const std::string& text, const TTFont& font, uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    SDL_Rect rect = {0, 0, width_, height_};
    SDL_FillRect(surface_, &rect, backgroundColor_);
    SDL_Surface* textSurface = TTF_RenderUTF8_Blended_Wrapped((TTF_Font*)font.font(), text.c_str(), {r, g, b, a}, width_);
    int dstX = (width_ - textSurface->w) / 2;
    int dstY = (height_ - textSurface->h) / 2;
    int dstW = SDL_min(width_, textSurface->w);
    int dstH = SDL_min(height_, textSurface->h);
    SDL_Rect dstRect = {dstX, dstY, dstW, dstH};
    SDL_BlitSurface(textSurface, NULL, surface_, &dstRect);
    SDL_FreeSurface(textSurface);
}
}