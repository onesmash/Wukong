//
//  AudioSource.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "AudioSource.h"

namespace WukongEngine {
    
AudioSource::AudioSource(): playing_(false), channel_(-1)
{
    
}

AudioSource::~AudioSource()
{
    
}

void AudioSource::setClip(const std::shared_ptr<AudioClip>& clip)
{
    clip_ = clip;
}

int AudioSource::play(double limit)
{
    if(!clip_) return -1;
    clip_->loadAudioData();
    channel_ = Mix_PlayChannelTimed(channel_, clip_->clip(), 0, limit * 1000);
    return channel_;
}
    
void AudioSource::stop()
{
    Mix_HaltChannel(channel_);
}

}