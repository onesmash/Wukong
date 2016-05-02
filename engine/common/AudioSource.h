//
//  AudioSource.hpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef AudioSource_h
#define AudioSource_h

#include "Object.h"
#include "AudioClip.h"

namespace WukongEngine {
class AudioSource: public Object
{
public:
    typedef TypeName<AudioSource> TypeName;
    AudioSource();
    virtual ~AudioSource();
    
    void setClip(const std::shared_ptr<AudioClip>& clip);
    
    void setPlaying(bool playing) { playing_ = playing; }
    
    int play(double limit);
    
    void stop();
    
    int channel() { return channel_; }
    
private:
    
    std::shared_ptr<AudioClip> clip_;
    bool playing_;
    int channel_;
    
};
}

#endif /* AudioSource_h */
