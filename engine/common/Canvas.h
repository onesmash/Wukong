//
//  Canvas.hpp
//  Wukong
//
//  Created by Xuhui on 16/5/30.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef Canvas_h
#define Canvas_h

#include "Object.h"

#include <string>

struct SDL_Surface;

namespace WukongEngine {
    
class Renderer;
    
class TTFont;
    
class Canvas: public Object
{
public:
    typedef TypeName<Canvas> TypeName;
    Canvas(): width_(0), height_(0), backgroundColor_(0x00000000), surface_(nullptr) {}
    virtual ~Canvas();
    
    void init(int width, int height);
    
    void drawText(const std::string& text, const TTFont& font, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    
    const SDL_Surface* surface() const { return surface_; }
    
private:
    int width_;
    int height_;
    unsigned backgroundColor_;
    SDL_Surface* surface_;
    
};
}

#endif /* Canvas_h */
