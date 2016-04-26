//
//  Module.h
//  AppCore
//
//  Created by Xuhui on 15/4/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore__Module__
#define __AppCore__Module__

#include "Object.h"

#include <string>
#include <memory>
#include <unordered_map>

namespace WukongEngine {
    
class Module: public Object
{
    
public:
    enum ModuleType {
        ModuleMessageLoop,
        ModuleTime,
        ModuleRender,
        ModuleResourceManager,
        ModuleMaxEnum
    };
    
    typedef TypeName<Module> TypeName;
    
    virtual ~Module() {}
    
    virtual ModuleType moduleType() const = 0;
    
    virtual std::string moduleName() const = 0;
    
    static void registerModule(const std::shared_ptr<Module>& module);
    
    template <typename T>
    static std::shared_ptr<T>& getInstance(ModuleType type)
    {
        return (std::shared_ptr<T>&)moduleRegistry[type];
    }
    
private:
    
    //static std::shared_ptr<Module> modules[ModuleMaxEnum];
    static std::unordered_map<int, std::shared_ptr<Module>> moduleRegistry;
    
};
    
}

#endif /* defined(__AppCore__Module__) */
