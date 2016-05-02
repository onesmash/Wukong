//
//  RenderModule_LuaBinding.hpp
//  Wukong
//
//  Created by Xuhui on 16/4/14.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef RenderModule_LuaBinding_h
#define RenderModule_LuaBinding_h

#include "Runtime.h"

namespace WukongEngine {
    
namespace Runtime {
    
extern "C" APPCORE_EXPORT int luaopen_RenderModule(lua_State* L);
    
}
    
}

#endif /* RenderModule_LuaBinding_h */
