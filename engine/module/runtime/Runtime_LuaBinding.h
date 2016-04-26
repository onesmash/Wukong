//
//  Runtime_LuaBinding.h
//  AppCore
//
//  Created by Xuhui on 15/6/16.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Wukong__Runtime_LuaBinding__
#define __Wukong__Runtime_LuaBinding__

#include "Runtime.h"

namespace WukongEngine {
    
namespace Runtime {
    
extern "C" APPCORE_EXPORT int luaopen_runtime(lua_State* L);
    
}
    
}



#endif /* defined(__Wukong__Runtime_LuaBinding__) */
