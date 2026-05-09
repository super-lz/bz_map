# bz_map

`bz_map` 是高德地图 Flutter 插件封装，提供地图显示、地图控件、地图事件和覆盖物能力。适合需要在 Flutter 页面中接入高德地图的项目。

## 安装

在宿主工程的 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  bz_map:
    git:
      url: https://github.com/super-lz/bz_map.git
```

然后执行：

```bash
flutter pub get
```

## 高德 Key

高德地图 Key 需要按平台分别申请。

| 平台 | 高德开放平台配置 | 宿主工程配置 |
| --- | --- | --- |
| Android | 选择 Android 平台，填写包名和 SHA1 | 包名必须与 `applicationId` 一致 |
| iOS | 选择 iOS 平台，填写 Bundle ID | Bundle ID 必须与 Xcode 工程一致 |

Android 调试包和发布包通常使用不同签名。如果调试包无法显示地图，优先检查高德后台的调试版 SHA1、发布版 SHA1 和包名是否匹配。

## 平台配置

### Android

宿主工程需要声明网络和定位相关权限。按业务需要保留最小权限集合：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Android 6.0 及以上还需要在运行时申请定位权限，否则地图的蓝点定位能力无法正常使用。

### iOS

iOS 需要在 `ios/Runner/Info.plist` 中声明定位用途文案：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>用于在地图上显示当前位置</string>
```

如果业务需要后台定位，还需要补充对应的后台定位权限和 Xcode Capability。

## 隐私合规

高德 SDK 要求在创建地图前完成隐私合规声明。示例：

```dart
const privacyStatement = AMapPrivacyStatement(
  hasContains: true,
  hasShow: true,
  hasAgree: true,
);
```

## 基础用法

```dart
const AMapWidget(
  apiKey: AMapApiKey(
    androidKey: 'your-android-key',
    iosKey: 'your-ios-key',
  ),
  privacyStatement: privacyStatement,
  initialCameraPosition: CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 12,
  ),
)
```

常见能力：

| 能力 | 入口 |
| --- | --- |
| 创建地图 | `AMapWidget` |
| 设置初始视角 | `initialCameraPosition` |
| 获取控制器 | `onMapCreated` |
| 移动地图视角 | `AMapController.moveCamera` |
| 监听地图点击 | `onTap` |
| 监听相机移动 | `onCameraMove` / `onCameraMoveEnd` |
| 覆盖物 | `markers` / `polylines` / `polygons` / `circles` |

## iOS 模拟器

高德官方 iOS SDK 的 CocoaPods 包目前不能在 Apple Silicon iOS 模拟器上直接链接真实地图 SDK。真机不受这个限制。

可选调试方式：

| 场景 | 建议 |
| --- | --- |
| 调试真实地图 | 使用 iOS 真机 |
| 只调试 Flutter 页面和业务 UI | 启用模拟器占位模式 |
| 必须在模拟器尝试真实 SDK | 可尝试 Rosetta / x86_64 模拟器环境，但不保证可用 |

启用模拟器占位模式：

```bash
AMAP_IOS_SIMULATOR_STUBS=1 pod install
AMAP_IOS_SIMULATOR_STUBS=1 flutter run
```

切回真机真实地图：

```bash
pod install
flutter run
```

切换模式后建议清理并重新安装 iOS Pods，避免 Xcode 继续使用旧的构建产物：

```bash
rm -rf ios/Pods ios/Podfile.lock
pod install
```

占位模式只用于让 App 在 iOS 模拟器启动，不提供真实地图渲染能力。需要验证地图显示、定位蓝点、覆盖物渲染等能力时，请使用真机。

## 注意事项

| 问题 | 排查方向 |
| --- | --- |
| Android 地图空白 | 检查 Key、包名、SHA1、网络权限 |
| iOS 地图空白 | 检查 Key、Bundle ID、隐私合规声明 |
| 蓝点不移动 | 检查系统定位开关、运行时定位权限、设备是否有有效定位 |
| 模拟器无法链接 iOS SDK | 使用模拟器占位模式或改用真机 |
