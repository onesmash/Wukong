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

#include <string>

struct SDL_Texture;

namespace WukongEngine {

struct Size;
    
class Renderer;
    
class Texture: public Object
{
public:
    typedef TypeName<Texture> TypeName;
    Texture(): texture_(nullptr) {}
    virtual ~Texture();
    
    void loadImage(Renderer& renderer, const std::string& path);
    
    Size size();
    
    SDL_Texture* texture() { return texture_; }
private:
    SDL_Texture* texture_;
};
}

#endif /* Texture_h */
