import 'package:flutter/material.dart';

enum ScreenType {
  rectangle(width: 917, height: 412),
  square(width: 1280, height: 800);

  const ScreenType({required this.width, required this.height});

  final double width;
  final double height;
}

enum ScaleMode {
  fitWidth,
  fitHeight,
  fitMin,
  fitMax,
  fill
}

mixin ScreenScaler {
  static ScreenType _globalScreenType = ScreenType.rectangle;
  static Size? _globalLastScreenSize;

  ScaleMode _localScaleMode = ScaleMode.fitWidth;
  double _localScaleFactor = 1.0;
  Size? _localLastCalculatedSize;

  ScaleMode get defaultScaleMode => ScaleMode.fitWidth;

  void setScaleMode(ScaleMode mode) {
    _localScaleMode = mode;
    _localLastCalculatedSize = null;
  }

  void _checkAndUpdateScaler(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_globalLastScreenSize != screenSize) {
      debugPrint("Screen size changed: ${screenSize.width} x ${screenSize.height}");
      _globalScreenType = _determineScreenType(screenSize);
      _globalLastScreenSize = screenSize;
    }

    if (_localLastCalculatedSize != screenSize) {
      if (_localScaleMode == ScaleMode.fitWidth && defaultScaleMode != ScaleMode.fitWidth) {
        _localScaleMode = defaultScaleMode;
      }
      _calculateScaleFactor(screenSize);
      _localLastCalculatedSize = screenSize;
    }
  }

  void _calculateScaleFactor(Size screenSize) {
    final referenceSize = _globalScreenType;

    switch (_localScaleMode) {
      case ScaleMode.fitWidth:
        _localScaleFactor = screenSize.width / referenceSize.width;
        break;
      case ScaleMode.fitHeight:
        _localScaleFactor = screenSize.height / referenceSize.height;
        break;
      case ScaleMode.fitMin:
        final widthScale = screenSize.width / referenceSize.width;
        final heightScale = screenSize.height / referenceSize.height;
        _localScaleFactor = widthScale < heightScale ? widthScale : heightScale;
        break;
      case ScaleMode.fitMax:
        final widthScale = screenSize.width / referenceSize.width;
        final heightScale = screenSize.height / referenceSize.height;
        _localScaleFactor = widthScale > heightScale ? widthScale : heightScale;
        break;
      case ScaleMode.fill:
        _localScaleFactor = 1.0;
        break;
    }
    debugPrint("Scale factor: $_localScaleFactor for mode $_localScaleMode");
  }

  ScreenType _determineScreenType(Size screenSize) {
    final aspectRatio = screenSize.width / screenSize.height;
    final rectangleRatio = ScreenType.rectangle.width / ScreenType.rectangle.height;
    final squareRatio = ScreenType.square.width / ScreenType.square.height;

    debugPrint("Current aspect ratio: $aspectRatio");
    debugPrint("Rectangle ratio (917/412): $rectangleRatio");
    debugPrint("Square ratio (1280/800): $squareRatio");

    final rectangleDiff = (aspectRatio - rectangleRatio).abs();
    final squareDiff = (aspectRatio - squareRatio).abs();

    debugPrint("Rectangle diff: $rectangleDiff");
    debugPrint("Square diff: $squareDiff");

    final result = rectangleDiff < squareDiff ? ScreenType.rectangle : ScreenType.square;
    debugPrint("Screen type: ${result.name}");
    return result;
  }

  double get scaleFactor {
    _checkAndUpdateScaler(context);
    return _localScaleFactor;
  }

  MediaQueryData? _getMediaQuery() {
    try {
      return MediaQuery.of(context);
    } catch (e) {
      print('Error getting MediaQuery: $e');
      return null;
    }
  }

  BuildContext get context;

  double scaleSize(double rectangleSize, double squareSize) {
    _checkAndUpdateScaler(context);
    final targetSize = _globalScreenType == ScreenType.rectangle ? rectangleSize : squareSize;
    return targetSize * _localScaleFactor;
  }

  double scaleWidth(double rectangleWidth, double squareWidth) {
    _checkAndUpdateScaler(context);
    final mediaQuery = _getMediaQuery();
    if (mediaQuery == null) return rectangleWidth;

    final screenWidth = mediaQuery.size.width;
    final referenceWidth = _globalScreenType.width;
    final targetWidth = _globalScreenType == ScreenType.rectangle ? rectangleWidth : squareWidth;
    return (targetWidth / referenceWidth) * screenWidth;
  }

  double scaleHeight(double rectangleHeight, double squareHeight) {
    _checkAndUpdateScaler(context);
    final mediaQuery = _getMediaQuery();
    if (mediaQuery == null) return rectangleHeight;

    final screenHeight = mediaQuery.size.height;
    final referenceHeight = _globalScreenType.height;
    final targetHeight = _globalScreenType == ScreenType.rectangle ? rectangleHeight : squareHeight;
    return (targetHeight / referenceHeight) * screenHeight;
  }

  EdgeInsets scalePadding(EdgeInsets rectanglePadding, EdgeInsets squarePadding) {
    _checkAndUpdateScaler(context);
    final targetPadding = _globalScreenType == ScreenType.rectangle ? rectanglePadding : squarePadding;
    final factor = _localScaleFactor;
    return EdgeInsets.only(
      left: targetPadding.left * factor,
      top: targetPadding.top * factor,
      right: targetPadding.right * factor,
      bottom: targetPadding.bottom * factor,
    );
  }

  Size scaleSize2D(Size rectangleSize, Size squareSize) {
    return Size(
      scaleWidth(rectangleSize.width, squareSize.width),
      scaleHeight(rectangleSize.height, squareSize.height),
    );
  }

  double get currentScaleFactor => _localScaleFactor;
  ScreenType get currentScreenType => _globalScreenType;
  ScaleMode get currentScaleMode => _localScaleMode;

  bool get isRectangle => _globalScreenType == ScreenType.rectangle;
  bool get isSquare => _globalScreenType == ScreenType.square;
}