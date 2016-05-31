//
//  Texture.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/19.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "Texture.h"
#include "Runtime.h"
#include "Renderer.h"
#include "Canvas.h"
#include "SDL.h"
#include "SDL_image.h"

namespace WukongEngine {
    
Texture::~Texture()
{
    SDL_DestroyTexture(texture_);
}
    
void Texture::loadImage(Renderer& renderer, const std::string& path)
{
    if(texture_) {
        SDL_DestroyTexture(texture_);
        texture_ = nullptr;
    }
    texture_ = IMG_LoadTexture((SDL_Renderer*)renderer.renderer(), path.c_str());
    SDL_SetTextureBlendMode(texture_, SDL_BLENDMODE_BLEND);
}
    
void Texture::loadCanvas(Renderer& renderer, const Canvas& canvas)
{
    if(texture_) {
        SDL_DestroyTexture(texture_);
        texture_ = nullptr;
    }
    texture_ = SDL_CreateTextureFromSurface((SDL_Renderer*)renderer.renderer(), (SDL_Surface *)canvas.surface());
}
    
Size Texture::size()
{
    int width = 0, height = 0;
    SDL_QueryTexture(texture_, nullptr, nullptr, &width, &height);
    return (Size){width, height};
}
}