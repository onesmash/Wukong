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
    SDL_FillRect(surface_, &rect, background_color_);
    SDL_Surface* text_surface = TTF_RenderUTF8_Blended_Wrapped((TTF_Font*)font.font(), text.c_str(), {r, g, b, a}, width_);
    int dst_x = (width_ - text_surface->w) / 2;
    int dst_y = (height_ - text_surface->h) / 2;
    int dst_w = SDL_min(width_, text_surface->w);
    int dst_h = SDL_min(height_, text_surface->h);
    SDL_Rect dst_rect = {dst_x, dst_y, dst_w, dst_h};
    SDL_BlitSurface(text_surface, NULL, surface_, &dst_rect);
    SDL_FreeSurface(text_surface);
}
}