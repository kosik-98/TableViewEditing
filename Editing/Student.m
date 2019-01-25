//
//  Students.m
//  Editing
//
//  Created by Admin on 14.01.19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "Student.h"

@implementation Student

+(Student*) randomStudent
{
    Student* student  = [[Student alloc] init];
    
    student.name = [NSString stringWithFormat:@"Student %d", arc4random()%41];
    student.mark = arc4random()%11;
    
    return student;
}

@end
