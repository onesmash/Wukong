//
//  AudioModule.cpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "AudioModule.h"
#include "MessageLoop.h"

namespace WukongEngine {
namespace Runtime {
    
    
#define instance() (WukongEngine::Module::getInstance<AudioModule>(WukongEngine::Module::ModuleAudio))

static void audioPlayCallback(int channel)
{
    std::shared_ptr<AudioModule>& instance = instance();
    instance->playStoppedNotify(channel);
}
    
AudioModule::AudioModule(): playingAudioSources_()
{
    thread_ = std::shared_ptr<Base::Thread>(new Base::Thread("Audio"));
}

AudioModule::~AudioModule()
{
    thread_->stop();
}

void AudioModule::start()
{
    thread_->start();
    thread_->messageLoop()->postTask(std::bind(&AudioModule::startInternal, this));
}
    
void AudioModule::play(const std::shared_ptr<AudioSource>& source, double limit)
{
    thread_->messageLoop()->postTask(std::bind(&AudioModule::playInternal, this, source, limit));
}

void AudioModule::playDelayed(const std::shared_ptr<AudioSource>& source, double seconds, double limit)
{
    thread_->messageLoop()->postDelayTask(std::bind(&AudioModule::playInternal, this, source, limit), timeDeltaFromSeconds(seconds));
}
    
void AudioModule::stop(const std::shared_ptr<AudioSource>& source)
{
    
}
    
void AudioModule::playStoppedNotify(int channel)
{
    playingAudioSources_.erase(channel);
}
    
void AudioModule::startInternal()
{
    Mix_ChannelFinished(audioPlayCallback);
    Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 1, 4096);
}
    
void AudioModule::playInternal(const std::shared_ptr<AudioSource>& source, double limit)
{
    int channel = source->play(limit);
    playingAudioSources_.insert(std::unordered_map<int, std::shared_ptr<AudioSource>>::value_type(channel, source));
}
    
void AudioModule::stopInternal(const std::shared_ptr<AudioSource>& source)
{
    int channel = source->channel();
    source->stop();
    playingAudioSources_.erase(channel);
}
    
    
}
}
