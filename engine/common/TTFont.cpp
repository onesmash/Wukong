//
//  TTFont.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/26.
//  Copyright © 2016年 Xuhui. All rights reserved.
//


#include "TTFont.h"

namespace WukongEngine {

TTFont::TTFont(): fontPath_(), fontSize_(0), style_(kTTFontStyleNormal), font_(nullptr)
{
    
}
    
void TTFont::init(const std::string& fontPath, int fontSize)
{
    fontPath_ = fontPath;
    fontSize_ = fontSize;
    font_ = TTF_OpenFont(fontPath.c_str(), fontSize);
}
    
void TTFont::setFontStyle(TTFontStyle style)
{
    if(style_ != style) {
        style_ = style;
        TTF_SetFontStyle(font_, style);
    }
}
    
TTFont::~TTFont()
{
    TTF_CloseFont(font_);
}
    
}