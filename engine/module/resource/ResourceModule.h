//
//  ResourceModule.hpp
//  Wukong
//
//  Created by Xuhui on 16/4/19.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef ResourceModule_h
#define ResourceModule_h

#include "Module.h"

namespace WukongEngine {
namespace Runtime {
    
class ResourceModule: public Module
{
public:
    ResourceModule() {}
    virtual ~ResourceModule() {}
    
    virtual ModuleType moduleType() const { return ModuleRender; }
    
    virtual std::string moduleName() const { return "runtime.resource"; }
    
    
private:
};
}
}

#endif /* ResourceModule_h */
