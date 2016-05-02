//
//  AudioModule_LuaBinding.hpp
//  Wukong
//
//  Created by Xuhui on 16/5/1.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#ifndef AudioModule_LuaBinding_h
#define AudioModule_LuaBinding_h

#include "Runtime.h"

namespace WukongEngine {

namespace Runtime {

extern "C" APPCORE_EXPORT int luaopen_AudioModule(lua_State* L);

}

}

#endif /* AudioModule_LuaBinding_h */
