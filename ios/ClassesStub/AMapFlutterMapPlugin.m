#import "AMapFlutterMapPlugin.h"
#import <UIKit/UIKit.h>

static NSString *const BZMapViewType = @"com.bz.flutter.map";

// Simulator-only platform-view fallback. It preserves channel registration
// without linking the native AMap iOS SDK.
@interface BZStubMapView : NSObject<FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    messenger:(NSObject<FlutterBinaryMessenger> *)messenger;
@end

@interface BZStubMapViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;
@end

@implementation AMapFlutterMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  BZStubMapViewFactory *factory =
      [[BZStubMapViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:factory withId:BZMapViewType];
}
@end

@implementation BZStubMapViewFactory {
  NSObject<FlutterBinaryMessenger> *_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                    viewIdentifier:(int64_t)viewId
                                         arguments:(id)args {
  return [[BZStubMapView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                    messenger:_messenger];
}
@end

@implementation BZStubMapView {
  UIView *_view;
  FlutterMethodChannel *_channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    messenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  self = [super init];
  if (self) {
    _view = [[UIView alloc] initWithFrame:frame];
    _view.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:0.95 alpha:1.0];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"AMap iOS simulator stub";
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [_view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
      [label.centerXAnchor constraintEqualToAnchor:_view.centerXAnchor],
      [label.centerYAnchor constraintEqualToAnchor:_view.centerYAnchor],
    ]];

    NSString *channelName = [NSString stringWithFormat:@"bz_map_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName
                                           binaryMessenger:messenger];
    [_channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
      if ([call.method isEqualToString:@"map#takeSnapshot"]) {
        result(nil);
      } else if ([call.method isEqualToString:@"map#getMapContentApprovalNumber"] ||
                 [call.method isEqualToString:@"map#getSatelliteImageApprovalNumber"]) {
        result(@"simulator-stub");
      } else {
        result(nil);
      }
    }];
  }
  return self;
}

- (UIView *)view {
  return _view;
}
@end
