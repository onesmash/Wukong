//
//  Module.cpp
//  AppCore
//
//  Created by Xuhui on 15/4/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "Module.h"

#include <utility>

namespace WukongEngine {

void Module::registerModule(const std::shared_ptr<Module>& module)
{
    moduleRegistry.insert(std::make_pair(module->moduleType(), module));
}
    
std::unordered_map<int, std::shared_ptr<Module>> Module::moduleRegistry;
    
}