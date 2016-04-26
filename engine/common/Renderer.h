//
//  Renderer.hpp
//  Wukong
//
//  Created by Xuhui on 16/4/20.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h

#include "Object.h"
#include "Texture.h"

struct SDL_Renderer;

namespace WukongEngine {
    
struct Rect;
struct Point;
    
class Renderer: public Object
{
public:
    typedef TypeName<Renderer> TypeName;
    Renderer(SDL_Renderer* renderer);
    virtual ~Renderer();

    SDL_Renderer* renderer() { return renderer_; }
    
    void clear(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    
    void draw(const std::shared_ptr<Texture>& texture,
              const Rect& srcrect,
              const Rect& dstrect,
              const double angle,
              const Point& center);
    
    void drawRect(uint8_t r, uint8_t g, uint8_t b, uint8_t a, const Rect& dstrect);
    
    void present();
    
private:
    
    
    
    SDL_Renderer* renderer_;
};
}

#endif /* Renderer_h */
