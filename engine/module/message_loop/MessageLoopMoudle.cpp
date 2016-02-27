//
//  MessageLoopModule.cpp
//  AppCore
//
//  Created by Xuhui on 15/12/20.
//  Copyright © 2015年 Xuhui. All rights reserved.
//

#include "MessageLoopModule.h"
#include "MessageLoop.h"

namespace WukongEngine {
namespace Runtime {
    
void MessageLoopModule::postTask(const Base::Closure& closure)
{
    Base::MessageLoop::current()->postTask(closure);
}
    
void MessageLoopModule::postDelayTask(const Base::Closure& closure, double seconds)
{
    Base::MessageLoop::current()->postDelayTask(closure, timeDeltaFromSeconds(seconds));
}
    
}
}