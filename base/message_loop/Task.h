//
//  Task.h
//  AppCore
//
//  Created by Xuhui on 15/5/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Base__Task__
#define __Base__Task__
#include "Closure.h"
#include "Time.h"
#include <queue>

namespace WukongEngine {

namespace Base {

class Task {

public:
    Task(const Closure& closure, const TimePoint& delayedRunTime);
    Task(const Task& task);
    Task(Task&& task);
    ~Task();
    
    bool operator<(const Task& other) const;
    
    Task& operator=(Task&& task);
    
    int sequenceNum_;
    
    TimePoint delayedRunTime_;
    
    void run();
    
private:
    
    Closure closure_;
    

};
    
typedef std::queue<Task> TaskQueue;
typedef std::priority_queue<Task> DelayedTaskQueue;
    
}
    
}

#endif /* defined(__Base__Task__) */
