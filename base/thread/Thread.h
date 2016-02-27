//
//  Thread.h
//  AppCore
//
//  Created by Xuhui on 15/5/10.
//  Copyright (c) 2015年 Xuhui. All rights reserved.
//

#ifndef __Base__Thread__
#define __Base__Thread__

#include <string>
#include <thread>
#include <memory>

namespace WukongEngine {
    
namespace Base {
    
class MessageLoop;
    
class Thread {
    
public:
    explicit Thread(const std::string& name);
    
    virtual ~Thread();
    
    bool start();
    
    void stop();
    
    MessageLoop* messageLoop() {
        return messageLoop_;
    }
   
private:
    
    friend class MessageLoop;
    
    friend class std::thread;
    
    void threadMain();
    
    void stopMessageLoop();
    
    std::string name_;
    
    std::shared_ptr<std::thread> thread_;
    
    MessageLoop* messageLoop_;
    
    bool started_;
    
    std::mutex mutex_;
    std::condition_variable cv_;
    
};
    
}
    
}

#endif /* defined(__Base__Thread__) */
