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
