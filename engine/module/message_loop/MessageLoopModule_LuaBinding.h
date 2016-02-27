//
//  MessageLoopModule_LuaBinding.h
//  AppCore
//
//  Created by Xuhui on 15/12/14.
//  Copyright © 2015年 Xuhui. All rights reserved.
//

#ifndef MessageLoopModule_LuaBinding_h
#define MessageLoopModule_LuaBinding_h

#include "Runtime.h"

namespace WukongEngine {
    
namespace Runtime {
    
extern "C" APPCORE_EXPORT int luaopen_MessageLoopModule(lua_State* L);
    
}
    
}

#endif /* MessageLoopModule_LuaBinding_h */
