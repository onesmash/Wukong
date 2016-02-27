//
//  TimeModule.cpp
//  AppCore
//
//  Created by Xuhui on 16/1/20.
//  Copyright © 2016年 Xuhui. All rights reserved.
//

#include "TimeModule.h"

#include <chrono>

namespace WukongEngine {
namespace Runtime {
    
double TimeModule::now()
{
    std::chrono::time_point<std::chrono::system_clock> time = std::chrono::system_clock::now();
    std::chrono::duration<double> deltaTime = std::chrono::duration_cast<std::chrono::duration<double>>(time.time_since_epoch());
    return deltaTime.count();
}
}
}