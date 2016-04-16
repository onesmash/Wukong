//
//  ConcurrentTaskQueue.h
//  AppCore
//
//  Created by Xuhui on 15/5/17.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Base__ConcurrentTaskQueue__
#define __Base__ConcurrentTaskQueue__

#include "Closure.h"
#include "Task.h"
#include "Time.h"
#include <mutex>

namespace WukongEngine {

namespace Base {
    
class MessageLoop;
    
class ConcurrentTaskQueue {
public:
    
    explicit ConcurrentTaskQueue(MessageLoop* messageLoop);
    
    ~ConcurrentTaskQueue();
    
    void pushTask(const Closure& closure);
    
    void pushTask(const Closure& closure, const TimeDelta& delayTime);
    
    void swap(TaskQueue& taskQueue);
    
private:
    
    void pushTask(Task& task);
    
    void pushTask(Task&& task);
    
    MessageLoop* messageLoop_;
    
    TaskQueue queue_;
    
    std::mutex mutex_;
    
    int sequenceNumber_;
    
};
    
}
    
}

#endif /* defined(__Base__ConcurrentTaskQueue__) */
