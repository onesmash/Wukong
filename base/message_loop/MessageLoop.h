//
//  MessageLoop.h
//  AppCore
//
//  Created by Xuhui on 15/5/10.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Base__MessageLoop__
#define __Base__MessageLoop__
#include "uv.h"
#include "Closure.h"
#include "Time.h"
#include "Task.h"
#include "ConcurrentTaskQueue.h"
#include <memory>
#include <unordered_map>
#include <list>

namespace WukongEngine {

namespace Base {
    
class MessageLoop {
    
public:
    
    typedef uv_loop_t EventLoop;
    
    MessageLoop();
    
    virtual ~MessageLoop();
    
    static MessageLoop* current();
    
    EventLoop& eventLoop() { return eventLoop_; }
    
    bool running();
    
    void postTask(const Closure& closure);
    
    void postDelayTask(const Closure& closure, const TimeDelta& delayTime);
    
    void scheduleWork(bool wasEmpty);
    
    void scheduleDelayedWork();
    
    void breakMessageLoop();
    
    char* wakeUpPipeMessageBuf() { return wakeUpPipeMessageBuf_; }
    
    int taskQueueSize() { return taskQueue_.size(); }
    
//    void addObserver(MessageLoopObserver& observer);
//    
//    void removeObserver(const MessageLoopObserver& observer);
    
    TimePoint recentNow_;
    
protected:
    
    void run();
    
    void quite();
    
private:
    
    friend class Thread;
    
    void loadPendingTask();
    
    void runTask(Task& task);
    
    bool doWork();
    
    bool doDelayedWork();
    
    EventLoop eventLoop_;
    
    bool running_;
    
    std::shared_ptr<ConcurrentTaskQueue> pendingTaskQueue_;
    
    TaskQueue taskQueue_;
    DelayedTaskQueue delayedTaskQueue_;
    int wakeUpPipeInId_;
    int wakeUpPipeOutId_;
    uv_pipe_t wakeUpPipeOut_;
    char wakeUpPipeMessageBuf_[2];
    uv_timer_t timer_;
    
    std::mutex mutex_;
    
};
    
}
    
}

#endif /* defined(__Base__MessageLoop__) */
