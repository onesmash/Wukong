//
//  MessageLoopModule.h
//  AppCore
//
//  Created by Xuhui on 15/12/20.
//  Copyright © 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore_Module__MessageLoop_h
#define __AppCore_Module__MessageLoop_h

#include "base/message_loop/Closure.h"
#include "Time.h"
#include "Module.h"

namespace WukongEngine {
namespace Runtime {
   
class MessageLoopModule: public Module
{
    
public:
    virtual ~MessageLoopModule() {}
    
    virtual ModuleType moduleType() const { return ModuleMessageLoop; }
    
    virtual std::string moduleName() const { return "runtime.messageloop"; }
    
    void postTask(const WukongBase::Base::Closure& closure);
    
    void postDelayTask(const WukongBase::Base::Closure& closure, double seconds);
    
};
        
}
}


#endif /* MessageLoopModule_h */
