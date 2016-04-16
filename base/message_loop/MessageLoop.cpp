//
//  MessageLoop.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/10.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "MessageLoop.h"
#include <cstdlib>
#include <unistd.h>
#include <iostream>
using namespace std;

namespace WukongEngine {

namespace Base {
    
static uv_key_t messageLoopTLSKey;

void onTimer(uv_timer_t* handle)
{
    MessageLoop* messageLoop = (MessageLoop*)handle->data;
    handle->data = nullptr;
    messageLoop->scheduleDelayedWork();
}
    
void onClose(uv_handle_t* handle)
{
    
}
    
void allocBuf(uv_handle_t* handle, size_t suggested_size, uv_buf_t* buf)
{
    MessageLoop* messageLoop = (MessageLoop*)handle->data;
    buf->len = 2;
    buf->base = messageLoop->wakeUpPipeMessageBuf();
}

void onWakeUp(uv_stream_t* stream, ssize_t nread, const uv_buf_t* buf)
{
    MessageLoop *messageLoop = (MessageLoop*)stream->data;
    messageLoop->breakMessageLoop();
}

MessageLoop::MessageLoop():
    running_(false),
    mutex_()
{
    uv_loop_init(&eventLoop_);
    pendingTaskQueue_ = std::shared_ptr<ConcurrentTaskQueue>(new ConcurrentTaskQueue(this));
    int fds[2];
    if (pipe(fds)) {
        cout << "pipe() failed, errno: " << errno;
        abort();
    }
    wakeUpPipeInId_ = fds[1];
    wakeUpPipeOutId_ = fds[0];
    uv_pipe_init(&eventLoop_, &wakeUpPipeOut_, 0);
    wakeUpPipeOut_.data = this;
    uv_pipe_open(&wakeUpPipeOut_, wakeUpPipeOutId_);
    uv_read_start((uv_stream_t*)&wakeUpPipeOut_, allocBuf, Base::onWakeUp);
    uv_timer_init(&eventLoop_, &timer_);
    recentNow_ = Time::now();
    std::unique_lock<std::mutex> lock(mutex_);
    if(messageLoopTLSKey <= 0) {
        uv_key_create(&messageLoopTLSKey);
    }
    uv_key_set(&messageLoopTLSKey, this);
}
    
MessageLoop::~MessageLoop()
{
    if(wakeUpPipeInId_ > 0) {
        close(wakeUpPipeInId_);
    }
    if(wakeUpPipeOutId_ > 0) {
        close(wakeUpPipeOutId_);
    }
    uv_close((uv_handle_t*)&wakeUpPipeOut_, onClose);
    uv_key_delete(&messageLoopTLSKey);
    if(uv_loop_close(&eventLoop_) == UV_EBUSY) {
        abort();
    }
}
    
MessageLoop* MessageLoop::current()
{
    return (MessageLoop*)uv_key_get(&messageLoopTLSKey);
}
    
void MessageLoop::postTask(const Closure& closure)
{
    pendingTaskQueue_->pushTask(closure);
}
    
void MessageLoop::postDelayTask(const Closure& closure, const TimeDelta& delayTime)
{
    pendingTaskQueue_->pushTask(closure, delayTime);
}
    
void MessageLoop::scheduleWork(bool wasEmpty)
{
    if(wasEmpty) {
        
        static char buf = 0;
        ssize_t nwrite;
        do {
            nwrite = write(wakeUpPipeInId_, &buf, 1);
        } while (nwrite < 0 && errno == EINTR);
    }
}
    
void MessageLoop::scheduleDelayedWork()
{
    doDelayedWork();
}
    
void MessageLoop::run()
{
    if(running_) return;
    running_ = true;
    for (; ; ) {
        
        bool didWork = doWork();
        if(!running_)
            break;
        
        uv_run(&eventLoop_, UV_RUN_NOWAIT);
        if(!running_)
            break;
        
        didWork |= doDelayedWork();
        if(!running_)
            break;
        
        if(didWork) {
            continue;
        }
        uv_run(&eventLoop_, UV_RUN_ONCE);
    }
    running_ = false;
}
    
void MessageLoop::loadPendingTask()
{
    if(taskQueue_.empty()) {
        pendingTaskQueue_->swap(taskQueue_);
    }
}
    
void MessageLoop::runTask(Task& task)
{
    task.run();
}
    
bool MessageLoop::doWork()
{
    for (; ; ) {
        loadPendingTask();
        if(taskQueue_.empty()) {
            break;
        }
        do {
            Task task(std::move(taskQueue_.front()));
            taskQueue_.pop();
            if(task.delayedRunTime_ != TimePoint::min()) {
                int sequenceNum = task.sequenceNum_;
                delayedTaskQueue_.push(std::move(task));
                if(delayedTaskQueue_.top().sequenceNum_ == sequenceNum) {
                    if(doDelayedWork()) {
                        return true;
                    }
                }
            } else {
                runTask(task);
                return true;
            }
        } while (!taskQueue_.empty());
    }
    
    return false;
}
    
bool MessageLoop::doDelayedWork()
{
    if(delayedTaskQueue_.empty()) {
        return doWork();
    } else {
        Task task = delayedTaskQueue_.top();
        if(task.delayedRunTime_ > recentNow_) {
            recentNow_ = Time::now();
            uint64_t delayTime = timeDeltaToMilliseconds(task.delayedRunTime_ - recentNow_);
            if(task.delayedRunTime_ > recentNow_ && delayTime > 0) {
                uv_timer_stop(&timer_);
                uv_timer_init(&eventLoop_, &timer_);
                timer_.data = this;
                uv_timer_start(&timer_, onTimer, timeDeltaToMilliseconds(task.delayedRunTime_ - recentNow_), 0);
                return false;
            }
        }
        delayedTaskQueue_.pop();
        runTask(task);
        return true;
    }
}
    
void MessageLoop::quite()
{
    running_ = false;
    scheduleWork(true);
}
    
void MessageLoop::breakMessageLoop()
{
    uv_stop(&eventLoop_);
}
    
//void MessageLoop::addObserver(MessageLoopObserver& observer)
//{
//    observer.sequenceNumber_ = observerSequenceNumber_++;
//    
//}
//    
//void MessageLoop::removeObserver(const MessageLoopObserver& observer)
//{
//    
//}
    
}

}