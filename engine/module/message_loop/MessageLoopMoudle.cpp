//
//  MessageLoopModule.cpp
//  AppCore
//
//  Created by Xuhui on 15/12/20.
//  Copyright © 2015年 Xuhui. All rights reserved.
//

#include "MessageLoopModule.h"
#include "base/message_loop/MessageLoop.h"

namespace WukongEngine {
namespace Runtime {
    
void MessageLoopModule::postTask(const WukongBase::Base::Closure& closure)
{
    WukongBase::Base::MessageLoop::current()->postTask(closure);
}
    
void MessageLoopModule::postDelayTask(const WukongBase::Base::Closure& closure, double seconds)
{
    WukongBase::Base::MessageLoop::current()->postDelayTask(closure, timeDeltaFromSeconds(seconds));
}
    
}
}