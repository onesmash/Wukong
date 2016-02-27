//
//  ServiceMgr_LuaBinding.cpp
//  AppCore
//
//  Created by Xuhui on 15/6/14.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#include "ServiceMgr_LuaBinding.h"
#include <cstdlib>
#include <string>

namespace AppCore {
namespace Service {
extern "C" int luaopen_appcore_servicemgr(lua_State* L)
{
    std::string serviceDirectory(getenv("MODULE_DIRECTORY"));
    serviceDirectory += "/serviceMgr.lua";
    if (luaL_loadfile(L,  serviceDirectory.c_str()) == LUA_OK)
        lua_call(L, 0, 1);
    
    return 1;
}
}
}