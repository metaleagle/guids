//
//  GuidTests.m
//  GuildBrowser
//
//  Created by Андрей Данишевский on 30.08.16.
//  Copyright © 2016 Charlie Fulton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WoWApiClient.h" 
#import <OCMock/OCMock.h> 
#import "Guild.h"
#import "TestSemaphor.h" 
#import "Character.h"

@interface GuildTests : XCTestCase

@end

@implementation GuildTests {
    // 1
    Guild *_guild;
    NSDictionary *_testGuildData;
}


- (void)setUp {
    // 2
    NSURL *dataServiceURL = [[NSBundle bundleForClass:self.class] URLForResource:@"guild" withExtension:@"json"];
    NSData *sampleData = [NSData dataWithContentsOfURL:dataServiceURL];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:sampleData options:kNilOptions error:&error];
    _testGuildData = json;
}


- (void)tearDown {
    // Tear-down code here.
    _guild = nil;
    _testGuildData = nil; }

- (void)testCreatingGuilDataFromWowApiClient {
    id mockWowApiClient = [OCMockObject mockForClass:[WoWApiClient class]];
    // using OCMock to mock our WowApiClient object
    [[[mockWowApiClient stub] andDo:^(NSInvocation *invocation) {
        // how the success block is defined from our client
        // this is how we return data to caller from stubbed method
        
        void (^successBlock)(Guild *guild);
        
        // gets the success block from the call to our stub method
        // The hidden arguments self (of type id) and _cmd (oftype SEL) are at indices 0 and 1;
        // method-specific arguments begin at index 2.
        
        [invocation getArgument:&successBlock atIndex:4];
        
        // first create sample guild from file vs network call
        Guild *testData = [[Guild alloc] initWithGuildData:_testGuildData];
        successBlock(testData);
    }]
     // the actual method we are stubb'ing, accepting any args
     guildWithName:[OCMArg any]
     onRealm:[OCMArg any]
     success:[OCMArg any]
     error:[OCMArg any]];
    
    // String used to wait for block to complete
    
    NSString *semaphoreKey = @"membersLoaded";
    
    // now call the stubbed out client, by calling the real method
    
    [mockWowApiClient guildWithName:@"Dream Catchers" onRealm:@"Borean Tundra"
                            success:^(Guild *guild)
    {
        _guild = guild;
        // this will allow the test to continue by lifting the semaphore key
        // and satisfying the running loop that is waiting on it to lift
        // 11
        [[TestSemaphor sharedInstance] lift:semaphoreKey];
    } error:^(NSError *error) { // 12
        [[TestSemaphor sharedInstance] lift:semaphoreKey];
    }];
    // 13
    // Marin is so awesome
    [[TestSemaphor sharedInstance] waitForKey:semaphoreKey];
    // 14
    XCTAssertNotNil(_guild, @"");
    XCTAssertEqualObjects(_guild.name, @"Dream Catchers", @"");
    XCTAssertTrue([_guild.members count] == [[_testGuildData valueForKey:@"members"] count]);
    //
    // Now validate that each type of class was loaded in the correct order
    // this tests the calls that our CharacterViewController will be making
    // for the UICollectionViewDataSource methods //
    // 15
    //
    // Validate 1 Death Knight ordered by level, acheivement points
    //
    NSArray *characters = [_guild membersByWowClassTypeName:WowClassTypeDeathKnight];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Lixiu");
    //
    // Validate 3 Druids ordered by level, acheivement points //
    characters = [_guild
                  membersByWowClassTypeName:WowClassTypeDruid];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Elassa");
    XCTAssertEqualObjects(((Character*)characters[1]).name, @"Ivymoon");
    XCTAssertEqualObjects(((Character*)characters[2]).name, @"Everybody");
    //
    // Validate 2 Hunter ordered by level, acheivement points //
    characters = [_guild
                  membersByWowClassTypeName:WowClassTypeHunter];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Bulldogg");
    XCTAssertEqualObjects(((Character*)characters[1]).name, @"Bluekat");
    //
    // Validate 2 Mage ordered by level, acheivement points //
    characters = [_guild
                  membersByWowClassTypeName:WowClassTypeMage];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Mirai");
    XCTAssertEqualObjects(((Character*)characters[1]).name, @"Greatdane");
    //
    // Validate 3 Paladin ordered by level, acheivement points //
    characters = [_guild
                  membersByWowClassTypeName:WowClassTypePaladin];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Verikus");
    XCTAssertEqualObjects(((Character*)characters[1]).name, @"Jonan");
    XCTAssertEqualObjects(((Character*)characters[2]).name, @"Desplaines");
    //
    // Validate 3 Priest ordered by level, acheivement points //
    characters = [_guild
                  membersByWowClassTypeName:WowClassTypePriest];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Mercpriest");
    XCTAssertEqualObjects(((Character*)characters[1]).name, @"Monk");
    XCTAssertEqualObjects(((Character*)characters[2]).name, @"Bliant");
    //
    // Validate 3 Rogue ordered by level, acheivement points //
    characters = [_guild
                  membersByWowClassTypeName:WowClassTypeRogue];
    XCTAssertEqualObjects(((Character*)characters[0]).name, @"Lailet");
    XCTAssertEqualObjects(((Character*)characters[1]).name, @"Britaxis");
    XCTAssertEqualObjects(((Character*)characters[2]).name, @"Josephus");
}

@end
