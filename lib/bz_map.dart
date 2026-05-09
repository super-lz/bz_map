/// 高德地图Flutter插件入口文件
library bz_map;

import 'dart:async';
import 'dart:typed_data';

import 'package:bz_map/src/base/bz_map_base.dart';
import 'package:bz_map/src/core/amap_flutter_platform.dart';
import 'package:bz_map/src/core/map_event.dart';
import 'package:bz_map/src/core/method_channel_bz_map.dart';
import 'package:bz_map/src/types/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:bz_map/src/types/types.dart';
export 'package:bz_map/src/base/bz_map_base.dart';

part 'src/amap_controller.dart';
part 'src/amap_widget.dart';
