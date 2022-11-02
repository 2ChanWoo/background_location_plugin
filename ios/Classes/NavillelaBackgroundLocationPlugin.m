#import "NavillelaBackgroundLocationPlugin.h"
#if __has_include(<navillela_background_location/navillela_background_location-Swift.h>)
#import <navillela_background_location/navillela_background_location-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "navillela_background_location-Swift.h"
#endif

@implementation NavillelaBackgroundLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNavillelaBackgroundLocationPlugin registerWithRegistrar:registrar];
}
@end
