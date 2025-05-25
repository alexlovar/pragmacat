import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Required for opening URLs

/// A stateless widget that displays a label followed by a tappable hyperlink.
/// This widget is useful for showing links  alongside labels.
class BuildTextLink extends StatelessWidget {
  final String label; // The label to show
  final String url; // The actual URL to launch

  const BuildTextLink({super.key, required this.label, required this.url});

  /// Function to launch a URL using url_launcher package
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ), // Adds spacing above and below
      child: Row(
        children: [
          // Label (e.g., "Wikipedia:")
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8), // Spacing between label and link
          Expanded(
            // The clickable text link
            child: InkWell(
              onTap: () => _launchURL(url), // Launches the link when tapped
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue, // Blue text to indicate a link
                  decoration:
                      TextDecoration.underline, // Underline like a hyperlink
                ),
                overflow:
                    TextOverflow.ellipsis, // Truncates long URLs with ellipsis
              ),
            ),
          ),
        ],
      ),
    );
  }
}
