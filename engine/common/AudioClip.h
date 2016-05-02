//
//  AudioClip.hpp
//  Wukong
//
//  Created by Xuhui on 16/4/26.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef AudioClip_h
#define AudioClip_h

#include "Object.h"
#include "SDL_mixer.h"

#include <string>

namespace WukongEngine {
    
class AudioClip: public Object
{
public:
    typedef TypeName<AudioClip> TypeName;
    AudioClip();
    virtual ~AudioClip();
    
    void init(const std::string& filePath);
    
    void loadAudioData();
    
    Mix_Chunk* clip() { return soundChunk_; }
    
private:
    std::string filePath_;
    Mix_Chunk* soundChunk_;
    bool isAudioDataLoaded_;
};
}

#endif /* AudioClip_h */
