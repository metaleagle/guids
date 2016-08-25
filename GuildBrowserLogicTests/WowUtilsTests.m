//
//  WowUtilsTests.m
//  GuildBrowser
//
//  Created by Андрей Данишевский on 25.08.16.
//  Copyright © 2016 Charlie Fulton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WowUtils.h"

@interface WowUtilsTests : XCTestCase

@end

@implementation WowUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCharactersClassNameLookup
{
    XCTAssertEqualObjects(@"Warrior", [WoWUtils classFromCharacterType:1], @"ClassType should be Warrior");
    XCTAssertFalse([@"Mage" isEqualToString:[WoWUtils classFromCharacterType:2]]);
    XCTAssertTrue([@"Paladin" isEqualToString:[WoWUtils classFromCharacterType:2]]);
}


- (void)testRaceTypeLookup
{
    XCTAssertEqualObjects(@"Human", [WoWUtils raceFromRaceType:1]);
    XCTAssertEqualObjects(@"Orc", [WoWUtils raceFromRaceType:2]);
    XCTAssertFalse([@"Night Elf" isEqualToString:[WoWUtils raceFromRaceType:45]]);
    // add the rest as an exercise
}

- (void)testQualityLookup
{
    XCTAssertEqual(@"Grey", [WoWUtils qualityFromQualityType:1]);
    XCTAssertFalse([@"Purple" isEqualToString:[WoWUtils qualityFromQualityType:10]]);
    // add the rest as an exercise
}

@end
