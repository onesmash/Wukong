//
//  ServiceMgr.h
//  AppCore
//
//  Created by Xuhui on 15/6/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore__ServiceMgr__
#define __AppCore__ServiceMgr__

#include "Module.h"

namespace AppCore {
    
namespace RunTime {
    
class ServiceMgr: public Module
{
public:
    
    virtual ~ServiceMgr() {}
    
    virtual ModuleType moduleType() { return ModuleServiceMgr; }
    
};
    
}
    
}



#endif /* defined(__AppCore__ServiceMgr__) */
