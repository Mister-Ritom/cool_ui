import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';

/// Avatar widget with rounded styling and fallback support
class CoolAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String? text;
  final String? name; // For fallback initials
  final String? username; // For fallback initials
  final IconData? icon;
  final double? radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? badge;
  
  const CoolAvatar({
    super.key,
    this.image,
    this.text,
    this.name,
    this.username,
    this.icon,
    this.radius,
    this.backgroundColor,
    this.foregroundColor,
    this.badge,
  });
  
  String _getInitials() {
    if (text != null && text!.isNotEmpty) {
      return text!.length > 2 ? text!.substring(0, 2).toUpperCase() : text!.toUpperCase();
    }
    if (name != null && name!.isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name!.substring(0, name!.length > 2 ? 2 : name!.length).toUpperCase();
    }
    if (username != null && username!.isNotEmpty) {
      return username!.substring(0, username!.length > 2 ? 2 : username!.length).toUpperCase();
    }
    return '?';
  }
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final avatarRadius = radius ?? 20.0;
    final bgColor = backgroundColor ?? 
        coolColors?.resolve(CoolColorToken.primary) ?? 
        Colors.blue;
    final fgColor = foregroundColor ?? 
        coolColors?.resolve(CoolColorToken.onPrimary) ?? 
        Colors.white;
    
    Widget avatar;
    
    if (image != null) {
      avatar = CircleAvatar(
        radius: avatarRadius,
        backgroundImage: image,
        onBackgroundImageError: (_, __) {
          // Image failed to load - will fall through to initials
        },
        child: _buildFallbackAvatar(avatarRadius, bgColor, fgColor),
      );
    } else {
      avatar = _buildFallbackAvatar(avatarRadius, bgColor, fgColor);
    }
    
    if (badge != null) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -4,
            top: -4,
            child: badge!,
          ),
        ],
      );
    }
    
    return avatar;
  }
  
  Widget _buildFallbackAvatar(double radius, Color bgColor, Color fgColor) {
    if (text != null && text!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Text(
          text!.length > 2 ? text!.substring(0, 2).toUpperCase() : text!.toUpperCase(),
          style: TextStyle(
            color: fgColor,
            fontSize: radius * 0.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    
    if (icon != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Icon(
          icon,
          color: fgColor,
          size: radius * 0.8,
        ),
      );
    }
    
    // Fallback to initials from name or username
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        _getInitials(),
        style: TextStyle(
          color: fgColor,
          fontSize: radius * 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

