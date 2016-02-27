//
//  ServiceMgr_LuaBinding.h
//  AppCore
//
//  Created by Xuhui on 15/6/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore__ServiceMgr_LuaBinding__
#define __AppCore__ServiceMgr_LuaBinding__

#include "Config.h"
#include "Runtime.h"

namespace AppCore {
namespace Service {
    
extern "C" APPCORE_EXPORT int luaopen_appcore_servicemgr(lua_State* L);
    
}
}

#endif /* defined(__AppCore__ServiceMgr_LuaBinding__) */
