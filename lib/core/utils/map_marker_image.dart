import 'dart:typed_data';
import 'dart:ui' as ui;

/// Downscales marker PNGs for crisp map symbols and stable rotation.
///
/// Large source assets (2000+ px) with tiny [iconSize] values often render
/// squashed or blurry on MapLibre/Gebeta when rotated.
Future<Uint8List> resizeMarkerPng(
  Uint8List bytes, {
  int targetWidth = 160,
}) async {
  final codec = await ui.instantiateImageCodec(bytes, targetWidth: targetWidth);
  final frame = await codec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  frame.image.dispose();
  if (data == null) {
    throw StateError('Failed to encode resized marker image');
  }
  return data.buffer.asUint8List();
}
