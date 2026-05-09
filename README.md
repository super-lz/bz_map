# bz_map

`bz_map` 是基于 `amap_flutter_map 3.0.0` 迁移出来的自有 Flutter 插件，已按 Flutter `3.38.10` 创建新的 pub 工程并适配当前工程结构。

## 设计定位

- 保留高德原始 Flutter 地图插件的核心 Dart API、平台视图和 overlay 实现。
- 内嵌原 `amap_flutter_base` 里 `LatLng`、`AMapApiKey`、隐私声明、POI 等基础类型，避免再额外依赖第三个 pub。
- 工程层面升级到 Flutter 3.38.10 生成的插件骨架，并改成 `bz_map` 包名。

## 参考基线

- pub 基线：`amap_flutter_map 3.0.0`
- 高德 Flutter 文档基线：地图 Flutter 插件 `3.0.0`
- 官方兼容性文档说明：Flutter 插件 `3.0.0` 基于地图 SDK `8.1.0` 开发，适配 `8.1.0+`
- 官方文档入口：
  - <https://pub.dev/packages/amap_flutter_map>
  - <https://lbs.amap.com/api/flutter/guide/map-flutter-plug-in/map-compatibility>
  - <https://lbs.amap.com/api/flutter/guide/map-flutter-plug-in/integrate-map-flutter-plugin>

## 接入说明

1. 申请高德 Key，并分别准备 Android / iOS Key。
2. Android 宿主工程引入高德地图 SDK。
3. iOS 宿主工程通过 CocoaPods 引入 `AMap3DMap`。
4. 在首次使用前完成高德隐私合规声明。
5. 用 `AMapWidget` 创建地图，并传入 `apiKey`、`privacyStatement`、`initialCameraPosition`。

### iOS 模拟器

高德官方当前 CocoaPods 包在 Apple Silicon iOS 模拟器上不能直接链接真实 SDK。原因是 `AMapFoundation` 官方 podspec 会对 iOS Simulator 排除 `arm64`，而 Apple Silicon 模拟器需要 `arm64`。

可选方式：

1. iOS 真机：调试真实地图。
2. Apple Silicon iOS 模拟器：启用 Stub 模式，只调试宿主 App UI。
3. Rosetta / x86_64 模拟器：可尝试运行真实高德 SDK，但依赖本机 Xcode、模拟器 runtime、Flutter 和 CocoaPods 环境，不保证可用。

启用 Stub 模式：

```bash
AMAP_IOS_SIMULATOR_STUBS=1 pod install
```

切换 Stub / 真实 SDK 后，需要重新安装 Pods。

## 最小示例

```dart
const AMapWidget(
  apiKey: AMapApiKey(
    androidKey: 'your-android-key',
    iosKey: 'your-ios-key',
  ),
  privacyStatement: AMapPrivacyStatement(
    hasContains: true,
    hasShow: true,
    hasAgree: true,
  ),
  initialCameraPosition: CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10,
  ),
)
```

## 说明

- 当前实现以“可迁移、可继续二次开发”为目标，优先保持与高德原插件 API 兼容。
- `flutter analyze` 在当前代码上仍有较多历史风格提示，但核心编译错误已清理，单测可通过。

## 兼容处理

### 空定位回调

Android 地图 SDK 在定位蓝点尚未产生有效位置时，可能触发 `location#changed` 且 payload 中的 `location` 为空。插件会忽略空定位或结构不完整的定位 payload，避免 Dart 侧空值强制解包导致异常。

### iOS 模拟器 Stub 实现

设置环境变量后，podspec 会使用 `ios/ClassesStub` 中的模拟器实现：

```bash
AMAP_IOS_SIMULATOR_STUBS=1
```

- 注册 `com.bz.flutter.map` 平台视图
- 不链接 `AMap3DMap`
- 不提供真实地图渲染能力
