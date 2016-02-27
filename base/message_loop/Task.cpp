//
//  Task.cpp
//  AppCore
//
//  Created by Xuhui on 15/5/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "Task.h"

namespace WukongEngine {

namespace Base {
    
Task::Task(const Closure& closure, const TimePoint& delayedRunTime):
    sequenceNum_(0),
    delayedRunTime_(delayedRunTime),
    closure_(closure)
{
        
}
    
Task::Task(const Task& task):
    sequenceNum_(task.sequenceNum_),
delayedRunTime_(task.delayedRunTime_),
closure_(task.closure_)
{
    
}
    
Task::Task(Task&& task): sequenceNum_(task.sequenceNum_), delayedRunTime_(std::move(task.delayedRunTime_)), closure_(std::move(task.closure_))
{
    
}
    
Task::~Task()
{
    
}
    
void Task::run()
{
    closure_();
}
    
bool Task::operator<(const Task& other) const {
    // Since the top of a priority queue is defined as the "greatest" element, we
    // need to invert the comparison here.  We want the smaller time to be at the
    // top of the heap.
    
    if (delayedRunTime_ < other.delayedRunTime_)
        return false;
    
    if (delayedRunTime_ > other.delayedRunTime_)
        return true;
    
    // If the times happen to match, then we use the sequence number to decide.
    // Compare the difference to support integer roll-over.
    return (sequenceNum_ - other.sequenceNum_) > 0;
}
    
Task& Task::operator=(Task&& task)
{
    sequenceNum_ = task.sequenceNum_;
    delayedRunTime_ = std::move(task.delayedRunTime_);
    closure_ = std::move(task.closure_);
    return *this;
}
    
}

}