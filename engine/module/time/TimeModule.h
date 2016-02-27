//
//  TimeModule.hpp
//  AppCore
//
//  Created by Xuhui on 16/1/20.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef __AppCore_Module__Time_h
#define __AppCore_Module__Time_h

#include "Module.h"

namespace WukongEngine {
namespace Runtime {
    
class TimeModule: public Module
{
    
public:
    virtual ~TimeModule() {}
    
    virtual ModuleType moduleType() const { return ModuleTime; }
    
    virtual std::string moduleName() const { return "runtime.time"; }
    
    double now();
};
    
}
}


#endif /* TimeModule_h */
