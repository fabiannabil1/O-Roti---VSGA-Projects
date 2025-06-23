import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showCheckButton;
  final VoidCallback? onCheckPressed;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showCheckButton = false,
    this.onCheckPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading:
          Navigator.of(context).canPop()
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                color: Colors.white,
              )
              : null,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        if (showCheckButton)
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: onCheckPressed,
          ),
      ],
      centerTitle: true,
      elevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A), // blue-800
              Color(0xFF3B82F6), // blue-500
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
