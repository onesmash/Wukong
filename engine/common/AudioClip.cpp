//
//  AudioClip.cpp
//  Wukong
//
//  Created by Xuhui on 16/4/26.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "AudioClip.h"

namespace WukongEngine {
    
AudioClip::AudioClip(): soundChunk_(nullptr), isAudioDataLoaded_(false)
{
    
}
    
AudioClip::~AudioClip()
{
    Mix_FreeChunk(soundChunk_);
}
    
void AudioClip::init(const std::string& filePath)
{
    filePath_ = filePath;
}
    
void AudioClip::loadAudioData()
{
    if(isAudioDataLoaded_) return;
    soundChunk_ = Mix_LoadWAV(filePath_.c_str());
    isAudioDataLoaded_ = true;
}
    
}