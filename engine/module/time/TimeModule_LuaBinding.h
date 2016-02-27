//
//  TimeModule_LuaBinding.hpp
//  AppCore
//
//  Created by Xuhui on 16/1/21.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef TimeModule_LuaBinding_hpp
#define TimeModule_LuaBinding_hpp

#include "Runtime.h"

namespace WukongEngine {
    
namespace Runtime {
    
extern "C" APPCORE_EXPORT int luaopen_TimeModule(lua_State* L);
    
}
    
}

#endif /* TimeModule_LuaBinding_h */
