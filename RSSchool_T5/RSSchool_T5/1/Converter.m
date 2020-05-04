#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary *)converToPhoneNumberNextString:(NSString *)string {
    if (!string || !string.length) return @{KeyPhoneNumber: @"", KeyCountry: @""};
        
    NSString *firstCharacter = [string substringToIndex:1];
        
    if ([firstCharacter isEqualToString:@"+"]) string = [string substringFromIndex:1];
    if ([string length] > 12) string = [string substringToIndex:12];

    NSString *countryKey;
    
    if ([string hasPrefix:@"77"]) countryKey = @"KZ";
    else if ([string hasPrefix:@"7"]) countryKey = @"RU";
    else if ([string hasPrefix:@"373"]) countryKey = @"MD";
    else if ([string hasPrefix:@"374"]) countryKey = @"AM";
    else if ([string hasPrefix:@"375"]) countryKey = @"BY";
    else if ([string hasPrefix:@"380"]) countryKey = @"UA";
    else if ([string hasPrefix:@"992"]) countryKey = @"TJ";
    else if ([string hasPrefix:@"993"]) countryKey = @"TM";
    else if ([string hasPrefix:@"994"]) countryKey = @"AZ";
    else if ([string hasPrefix:@"996"]) countryKey = @"KG";
    else if ([string hasPrefix:@"998"]) countryKey = @"UZ";
    else countryKey = @"";
    
    if ([countryKey isEqual: @""]) {
        string = [NSString stringWithFormat:@"+%@", string];
        return @{KeyPhoneNumber: string, KeyCountry: @""};
    }
    
    NSDictionary *countries = @{
        @"RU": @{ @"code": @"7", @"length": @10, @"region": @3 },
        @"KZ": @{ @"code": @"7", @"length": @10, @"region": @3 },
        @"MD": @{ @"code": @"373", @"length": @8, @"region": @2 },
        @"AM": @{ @"code": @"374", @"length": @8, @"region": @2 },
        @"BY": @{ @"code": @"375", @"length": @9, @"region": @2 },
        @"UA": @{ @"code": @"380", @"length": @9, @"region": @2 },
        @"TJ": @{ @"code": @"992", @"length": @9, @"region": @2 },
        @"TM": @{ @"code": @"993", @"length": @8, @"region": @2 },
        @"AZ": @{ @"code": @"994", @"length": @9, @"region": @2 },
        @"KG": @{ @"code": @"996", @"length": @9, @"region": @2 },
        @"UZ": @{ @"code": @"998", @"length": @9, @"region": @2 }
    };
    
    NSDictionary *country = countries[countryKey];
    NSMutableString *number = [string mutableCopy];

    NSInteger maxLength = MIN([country[@"code"] length] + [country[@"length"] intValue], [number length]);
    if ([number length] - maxLength > 0) [number deleteCharactersInRange:NSMakeRange(maxLength, [number length] - maxLength)];
    
    [number insertString:@"+" atIndex:0];

    NSInteger opened = [country[@"code"] length] + 1;
    NSInteger closed = opened + [country[@"region"] intValue] + 2;
    if (opened < [number length]) [number insertString:@" (" atIndex:opened];
    if (closed < [number length]) [number insertString:@") " atIndex:closed];
    
    NSString *separator = @"";
    switch ([country[@"length"] intValue]) {
        case 8: case 9: case 10:
            separator = @"-";
            break;
        default:
            break;
    }

    NSInteger first = closed + 2 + 3;
    if (first < [number length]) [number insertString:separator atIndex:first];
    
    NSInteger second = [country[@"length"] isEqualToNumber:@8] ? 0 : first + 1 + 2;
    if (second && second < [number length]) [number insertString:separator atIndex:second];
    
    return @{KeyPhoneNumber: [number copy], KeyCountry: countryKey};
}
@end
