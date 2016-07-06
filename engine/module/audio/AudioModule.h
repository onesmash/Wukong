//
//  AudioModule.hpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef AudioModule_h
#define AudioModule_h

#include "Module.h"
#include "base/thread/Thread.h"
#include "AudioSource.h"

#include <unordered_map>

namespace WukongEngine {
namespace Runtime {
    
class AudioModule: public Module
{
public:
    AudioModule();
    virtual ~AudioModule();
    
    virtual ModuleType moduleType() const { return ModuleAudio; }
    
    virtual std::string moduleName() const { return "runtime.audio"; }
    
    void start();
    
    void play(const std::shared_ptr<AudioSource>& source, double limit);
    
    void playDelayed(const std::shared_ptr<AudioSource>& source, double seconds, double limit);
    
    void stop(const std::shared_ptr<AudioSource>& source);
    
    void playStoppedNotify(int channel);
    
private:
    
    void startInternal();
    
    void playInternal(const std::shared_ptr<AudioSource>& source, double limit);
    
    void stopInternal(const std::shared_ptr<AudioSource>& source);
    
    std::shared_ptr<WukongBase::Base::Thread> thread_;
    
    std::unordered_map<int, std::shared_ptr<AudioSource>> playingAudioSources_;
    
};
    
}
}

#endif /* AudioModule_h */
