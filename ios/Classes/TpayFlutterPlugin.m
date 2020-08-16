#import "TpayFlutterPlugin.h"
#if __has_include(<tpay_flutter/tpay_flutter-Swift.h>)
#import <tpay_flutter/tpay_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tpay_flutter-Swift.h"
#endif

@implementation TpayFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTpayFlutterPlugin registerWithRegistrar:registrar];
}
@end
