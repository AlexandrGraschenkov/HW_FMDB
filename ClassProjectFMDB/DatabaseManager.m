//
//  DatabaseManager.m
//  ClassProjectFMDB
//
//  Created by Alexander on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDB.h>
#import "FruitModel.h"

@implementation DBResult

- (id)initWithObjects:(NSArray *)arr totalCount:(NSInteger)count {
    self = [super init];
    if (self) {
        _objects = arr;
        _totalCount = count;
    }
    return self;
}

@end


@implementation DatabaseManager

{
    FMDatabase *db;
    //dispatch_queue_t queue;
    FMDatabaseQueue *queue;
}


+ (instancetype)shared
{
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"%@", docDir);
        NSString *path = [docDir stringByAppendingPathComponent:@"db.sqlite"];
        db = [[FMDatabase alloc] initWithPath:path];
        //__weak typeof(self) weakSelf = self;
        queue = [FMDatabaseQueue databaseQueueWithPath:path];
        //queue = dispatch_queue_create("Database Queue", DISPATCH_QUEUE_SERIAL);
        
        [db open];
        
    }
    return self;
}

- (void)dealloc {
    [db close];
}

#pragma mark -
- (NSArray *)getFruitsArray {
    FMResultSet __block *set;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        set = [db executeQuery:@"select * from Fruits"];
        if (![set next]) {
            *rollback = YES;
            return;
        };
    }];
    
    NSMutableArray *arr = [NSMutableArray new];
    while (set.next) {
        [arr addObject:[[FruitModel alloc] initWithFMDBSet:set]];
    }

    return arr;
}


-(FruitModel*)loadModel:(NSInteger)fruitID{
    NSLog(@"%@", @"load model");
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Fruits WHERE id=%li", fruitID];
    FMResultSet __block *set;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        set=[db executeQuery:sql];
        if (![set next]) {
            *rollback = YES;
            return;
        }
        
    }];
    FruitModel *model = [[FruitModel alloc] initWithFMDBSet:set];
    return model;
}

-(void)saveModel:(FruitModel*)model{
    NSLog(@"%@", @"save model");
    NSString *sql = [NSString stringWithFormat:@"UPDATE Fruits SET name='%@', descript='%@' WHERE id=%li", model.name, model.descript,model.fruitId];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL b =[db executeUpdate:sql];
        if (!b){
            *rollback=YES;
            return;
        }
        
    }];
}

- (DBResult *)getFruitsArrayWithLimit:(NSInteger)limit offset:(NSInteger)offset {
    NSString *sql = [NSString stringWithFormat:@"select * from Fruits limit %ld offset %ld", limit, offset];
    FMResultSet __block *set;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        set = [db executeQuery:sql];
        if (![set next]) {
            *rollback = YES;
            return;
        }

    }];
    NSMutableArray *arr = [NSMutableArray new];
    while (set.next) {
        [arr addObject:[[FruitModel alloc] initWithFMDBSet:set]];
    }
    
    FMResultSet __block *countSet;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        countSet = [db executeQuery:@"select count(*) from Fruits"];
        if (![set next]) {
            *rollback = YES;
            return;
        }
        
    }];
    NSInteger count = 0;
    if (countSet.next) {
        count = [countSet longForColumnIndex:0];
    }
    
    return [[DBResult alloc] initWithObjects:arr totalCount:count];
}


#pragma mark - Migrations
- (void)migrateDatabaseIfNescessary {
    
    NSInteger version = 0;
    FMResultSet *versionSet = [db executeQuery:@"PRAGMA user_version;"];
    if (versionSet.next) {
        version = [versionSet longForColumnIndex:0];
    }
    
    if (version == 0) {
        [db executeUpdate:@"create table IF NOT EXISTS Fruits (id integer primary key autoincrement, name text, descript text, thumb_url text, image_url text);"];
        
        NSArray *objectsArray = [self initialData];
        for (NSDictionary *dic in objectsArray) {
            [db executeUpdate:@"insert into Fruits (name, thumb_url, image_url) values (:title, :thumb, :img);" withParameterDictionary:dic];
        }
    }
    
    NSInteger newVersion = 1;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version=%ld;", newVersion];
    [db executeUpdate:sql];
}

- (NSArray *)initialData {
    NSString *jsonStr = @"[{\"title\":\"Ananas\",\"thumb\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Ananas_tb.png\",\"img\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Ananas.png\"},\n{\"title\":\"Apple\",\"thumb\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Apple_tb.png\",\"img\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Apple.png\"},\n{\"title\":\"Apricot\",\"thumb\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Apricot_tb.png\",\"img\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Apricot.png\"},\n{\"title\":\"Banana\",\"thumb\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Banana_tb.png\",\"img\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Banana.png\"},\n{\"title\":\"Pear\",\"thumb\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Pear_tb.png\",\"img\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Pear.jpg\"},\n{\"title\":\"Cherry\",\"thumb\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Cherry_tb.png\",\"img\":\"https://dl.dropboxusercontent.com/u/55523423/Images/Cherry.jpg\"}]";
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
    NSMutableArray *mutArr = [NSMutableArray new];
    for (NSInteger i = 0; i < 10; i++) {
        [mutArr addObjectsFromArray:arr];
    }
    return mutArr;
}

@end
