//
//  TTFont.hpp
//  Wukong
//
//  Created by Xuhui on 16/5/26.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef TTFont_h
#define TTFont_h

#include "Object.h"
#include "SDL_ttf.h"

#include <string>


namespace WukongEngine {
class TTFont: public Object
{
public:
    typedef enum {
        kTTFontStyleNormal          = TTF_STYLE_NORMAL,
        kTTFontStyleBold            = TTF_STYLE_BOLD,
        kTTFontStyleItalic          = TTF_STYLE_ITALIC,
        kTTFontStyleUnderline       = TTF_STYLE_UNDERLINE,
        kTTFontStyleStrikethrough   = TTF_STYLE_STRIKETHROUGH
    } TTFontStyle;
    typedef TypeName<TTFont> TypeName;
    TTFont();
    virtual ~TTFont();
    
    void init(const std::string& fonPath, int fontSize);
    
    void setFontStyle(TTFontStyle style);
    TTFontStyle fontStyle() { return style_; }
    
    const TTF_Font* font() const { return font_; }
private:
    std::string fontPath_;
    int fontSize_;
    TTFontStyle style_;
    TTF_Font* font_;
    
};
}


#endif /* TTFont_h */
