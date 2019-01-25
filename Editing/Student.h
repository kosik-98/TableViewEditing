//
//  Students.h
//  Editing
//
//  Created by Admin on 14.01.19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong,nonatomic) NSString* name;
@property (assign,nonatomic) NSInteger mark;

+(Student*) randomStudent;

@end
