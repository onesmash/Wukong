//
//  Texture.hpp
//  Wukong
//
//  Created by Xuhui on 16/4/19.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef Texture_h
#define Texture_h

#include "Object.h"
#include "TTFont.h"

#include <string>

struct SDL_Texture;

namespace WukongEngine {

struct Size;
    
class Renderer;
    
class Canvas;
    
class Texture: public Object
{
public:
    typedef TypeName<Texture> TypeName;
    Texture(): texture_(nullptr) {}
    virtual ~Texture();
    
    void loadImage(Renderer& renderer, const std::string& path);
    void loadCanvas(Renderer& renderer, const Canvas& canvas);
    //void loadText(Renderer& renderer, const TTFont& font, const std::string& text, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    
    Size size();
    
    bool isCanvas() { return isCanvas_; }
    
    const std::string& imagePath() { return imagePath_; }
    
    const SDL_Texture* texture() const { return texture_; }
private:
    SDL_Texture* texture_;
    bool isCanvas_;
    std::string imagePath_;
};
}

#endif /* Texture_h */
