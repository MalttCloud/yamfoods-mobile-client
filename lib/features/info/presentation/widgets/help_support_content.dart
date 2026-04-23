import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../domain/entities/help_support.dart';
import 'help_support_item_card.dart';

/// Renders Help & Support details as a list of tappable cards.
///
/// Each item is displayed as: icon + title + value, and launches the correct URL
/// (tel/mailto/http/maps) via the card's internal launcher.
class HelpSupportContent extends StatelessWidget {
  final HelpSupport data;

  const HelpSupportContent({
    super.key,
    required this.data,
  });

  String? _clean(String? v) {
    final s = v?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  String _mailto(String email) => 'mailto:$email';

  String _tel(String phone) => 'tel:$phone';

  String _geo(String address) {
    final q = Uri.encodeComponent(address);
    return 'geo:0,0?q=$q';
  }

  String _mapsQuery(String address) {
    final q = Uri.encodeComponent(address);
    return 'https://www.google.com/maps/search/?api=1&query=$q';
  }

  String _asHttps(String raw) {
    final v = raw.trim();
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    if (v.startsWith('//')) return 'https:$v';
    return 'https://$v';
  }

  String _socialUrl({
    required String value,
    required String base,
    String? prefix,
  }) {
    final v = value.trim().replaceFirst(RegExp(r'^@'), '');
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    final p = (prefix ?? '').trim();
    return '$base$p$v';
  }

  String _handleFromUrlOrValue(String value) {
    final v = value.trim().replaceFirst(RegExp(r'^@'), '');
    try {
      final uri = Uri.tryParse(v);
      if (uri != null && uri.hasScheme) {
        // grab last non-empty segment
        final segs = uri.pathSegments.where((e) => e.trim().isNotEmpty).toList();
        if (segs.isEmpty) return v;
        // TikTok profiles often like /@username
        return segs.last.replaceFirst(RegExp(r'^@'), '');
      }
    } catch (_) {}
    return v;
  }

  List<String> _telegramLaunchUrls(String value) {
    final handle = _handleFromUrlOrValue(value);
    final web = _socialUrl(value: value, base: 'https://t.me/');
    final deep = 'tg://resolve?domain=$handle';
    return [deep, web];
  }

  List<String> _instagramLaunchUrls(String value) {
    final handle = _handleFromUrlOrValue(value);
    final web = _socialUrl(value: value, base: 'https://instagram.com/');
    final deep = 'instagram://user?username=$handle';
    return [deep, web];
  }

  List<String> _facebookLaunchUrls(String value) {
    final web = _socialUrl(value: value, base: 'https://facebook.com/');
    final encoded = Uri.encodeComponent(web);
    // Uses Facebook app "facewebmodal" to open a URL inside the app if installed.
    final deep = 'fb://facewebmodal/f?href=$encoded';
    return [deep, web];
  }

  List<String> _tiktokLaunchUrls(String value) {
    final handle = _handleFromUrlOrValue(value);
    final web = _socialUrl(
      value: value,
      base: 'https://www.tiktok.com/@',
      prefix: '',
    );
    final deep = 'tiktok://user/@$handle';
    return [deep, web];
  }

  @override
  Widget build(BuildContext context) {
    final email = _clean(data.email);
    final phone1 = _clean(data.phone1);
    final phone2 = _clean(data.phone2);
    final telegram = _clean(data.telegram);
    final instagram = _clean(data.instagram);
    final facebook = _clean(data.facebook);
    final tiktok = _clean(data.tiktok);
    final website = _clean(data.website);
    final address = _clean(data.address);

    final items = <Widget>[];

    if (email != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.solidEnvelope,
          title: 'Email',
          value: email,
          launchUrls: [_mailto(email)],
          iconColor: AppColors.info,
        ),
      );
    }

    if (phone1 != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.phone,
          title: 'Phone',
          value: phone1,
          launchUrls: [_tel(phone1)],
          iconColor: AppColors.success,
        ),
      );
    }

    if (phone2 != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.phoneVolume,
          title: 'Phone (Alt)',
          value: phone2,
          launchUrls: [_tel(phone2)],
          iconColor: AppColors.success,
        ),
      );
    }

    if (telegram != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.telegram,
          title: 'Telegram',
          value: telegram,
          launchUrls: _telegramLaunchUrls(telegram),
          iconColor: const Color(0xFF229ED9),
        ),
      );
    }

    if (instagram != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.instagram,
          title: 'Instagram',
          value: instagram,
          launchUrls: _instagramLaunchUrls(instagram),
          iconColor: const Color(0xFFE1306C),
        ),
      );
    }

    if (facebook != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.facebook,
          title: 'Facebook',
          value: facebook,
          launchUrls: _facebookLaunchUrls(facebook),
          iconColor: const Color(0xFF1877F2),
        ),
      );
    }

    if (tiktok != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.tiktok,
          title: 'TikTok',
          value: tiktok,
          launchUrls: _tiktokLaunchUrls(tiktok),
          iconColor: AppColors.black,
        ),
      );
    }

    if (website != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.globe,
          title: 'Website',
          value: website,
          launchUrls: [_asHttps(website)],
          iconColor: AppColors.primary,
        ),
      );
    }

    if (address != null) {
      items.add(
        HelpSupportItemCard(
          icon: FontAwesomeIcons.locationDot,
          title: 'Address',
          value: address,
          launchUrls: [_geo(address), _mapsQuery(address)],
          iconColor: AppColors.lightRed,
        ),
      );
    }

    return Column(
      children: [
        for (final w in items) ...[
          w,
          const SizedBox(height: AppSizes.sm),
        ],
      ],
    );
  }
}

