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
    
void Canvas::drawText(const std::string& text, const TTFont& font, uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    if(surface_) {
        SDL_FreeSurface(surface_);
        surface_ = nullptr;
    }
    surface_ = TTF_RenderUTF8_Blended((TTF_Font*)font.font(), text.c_str(), {r, g, b, a});
}
}