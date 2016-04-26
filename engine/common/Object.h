//
//  Object.h
//  AppCore
//
//  Created by Xuhui on 15/12/24.
//  Copyright © 2015年 Xuhui. All rights reserved.
//

#ifndef __AppCore__Object
#define __AppCore__Object

#include <memory>

namespace WukongEngine {
    
#define CLASS_NAME(clz) template<> struct TypeName<clz> { static const char *stringify() { return #clz; }};

class Object {
public:
    template <typename T>
    struct TypeName
    {
        static const char* stringify()
        {
            return typeid(T).name();
        }
    };
    
    Object() {
    }
    virtual ~Object() = 0;
};
    
}

#endif /* Object_h */
