//
//  ConcurrentTaskQueue.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/17.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "ConcurrentTaskQueue.h"
#include "MessageLoop.h"

namespace WukongEngine {

namespace Base {

ConcurrentTaskQueue::ConcurrentTaskQueue(MessageLoop* messageLoop):
messageLoop_(messageLoop),
queue_(),
sequenceNumber_(0)
{
    
}
    
ConcurrentTaskQueue::~ConcurrentTaskQueue() {
    
}

void ConcurrentTaskQueue::pushTask(const Closure& closure)
{
    Task task(closure, TimePoint::min());
    pushTask(std::move(task));
}
    
void ConcurrentTaskQueue::pushTask(const Closure& closure, const TimeDelta& delayTime)
{
    Task task(closure, Time::now() + delayTime);
    pushTask(std::move(task));
}
  
void ConcurrentTaskQueue::pushTask(Task& task)
{
    std::lock_guard<std::mutex> lock(mutex_);
    task.sequenceNum_ = sequenceNumber_++;
    bool empty = queue_.empty();
    queue_.push(task);
    messageLoop_->scheduleWork(empty);
}
    
void ConcurrentTaskQueue::pushTask(Task&& task)
{
    std::lock_guard<std::mutex> lock(mutex_);
    task.sequenceNum_ = sequenceNumber_++;
    bool empty = queue_.empty();
    queue_.push(std::move(task));
    messageLoop_->scheduleWork(empty);
}
    
void ConcurrentTaskQueue::swap(TaskQueue& taskQueue)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if(!queue_.empty())
        queue_.swap(taskQueue);
}
    
}

}