/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple_pay_icon.svg
  SvgGenImage get applePayIcon =>
      const SvgGenImage('assets/icons/apple_pay_icon.svg');

  /// File path: assets/icons/cash_icon.svg
  SvgGenImage get cashIcon => const SvgGenImage('assets/icons/cash_icon.svg');

  /// File path: assets/icons/delete_icon.svg
  SvgGenImage get deleteIcon =>
      const SvgGenImage('assets/icons/delete_icon.svg');

  /// File path: assets/icons/edit_payment_icon.svg
  SvgGenImage get editPaymentIcon =>
      const SvgGenImage('assets/icons/edit_payment_icon.svg');

  /// File path: assets/icons/error_validation_icon.svg
  SvgGenImage get errorValidationIcon =>
      const SvgGenImage('assets/icons/error_validation_icon.svg');

  /// File path: assets/icons/notifications_icon.svg
  SvgGenImage get notificationsIcon =>
      const SvgGenImage('assets/icons/notifications_icon.svg');

  /// File path: assets/icons/promo_code_icon.svg
  SvgGenImage get promoCodeIcon =>
      const SvgGenImage('assets/icons/promo_code_icon.svg');

  /// File path: assets/icons/selected_card_icon.svg
  SvgGenImage get selectedCardIcon =>
      const SvgGenImage('assets/icons/selected_card_icon.svg');

  /// File path: assets/icons/selected_home_icon.svg
  SvgGenImage get selectedHomeIcon =>
      const SvgGenImage('assets/icons/selected_home_icon.svg');

  /// File path: assets/icons/success_bottom_sheet_icon.svg
  SvgGenImage get successBottomSheetIcon =>
      const SvgGenImage('assets/icons/success_bottom_sheet_icon.svg');

  /// File path: assets/icons/success_validation_icon.svg
  SvgGenImage get successValidationIcon =>
      const SvgGenImage('assets/icons/success_validation_icon.svg');

  /// File path: assets/icons/unselected_account_icon.svg
  SvgGenImage get unselectedAccountIcon =>
      const SvgGenImage('assets/icons/unselected_account_icon.svg');

  /// File path: assets/icons/unselected_card_icon.svg
  SvgGenImage get unselectedCardIcon =>
      const SvgGenImage('assets/icons/unselected_card_icon.svg');

  /// File path: assets/icons/unselected_save_icon.svg
  SvgGenImage get unselectedSaveIcon =>
      const SvgGenImage('assets/icons/unselected_save_icon.svg');

  /// File path: assets/icons/unselected_saves_icon.svg
  SvgGenImage get unselectedSavesIcon =>
      const SvgGenImage('assets/icons/unselected_saves_icon.svg');

  /// File path: assets/icons/unselected_search_icon.svg
  SvgGenImage get unselectedSearchIcon =>
      const SvgGenImage('assets/icons/unselected_search_icon.svg');

  /// File path: assets/icons/visa_card_icon.svg
  SvgGenImage get visaCardIcon =>
      const SvgGenImage('assets/icons/visa_card_icon.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        applePayIcon,
        cashIcon,
        deleteIcon,
        editPaymentIcon,
        errorValidationIcon,
        notificationsIcon,
        promoCodeIcon,
        selectedCardIcon,
        selectedHomeIcon,
        successBottomSheetIcon,
        successValidationIcon,
        unselectedAccountIcon,
        unselectedCardIcon,
        unselectedSaveIcon,
        unselectedSavesIcon,
        unselectedSearchIcon,
        visaCardIcon
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/onboarding_image.png
  AssetGenImage get onboardingImage =>
      const AssetGenImage('assets/images/onboarding_image.png');

  /// File path: assets/images/splash_centered_icon.svg
  SvgGenImage get splashCenteredIcon =>
      const SvgGenImage('assets/images/splash_centered_icon.svg');

  /// List of all assets
  List<dynamic> get values => [onboardingImage, splashCenteredIcon];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
