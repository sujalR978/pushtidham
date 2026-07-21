import 'package:flutter/material.dart';
import 'package:pushtidham/model/varta_model.dart';

class ChorasiVartaDetailPage extends StatefulWidget {
  final VartaModel varta;
  final bool isBrajLanguage;

  const ChorasiVartaDetailPage({
    super.key,
    required this.varta,
    this.isBrajLanguage = false,
  });

  @override
  State<ChorasiVartaDetailPage> createState() => _ChorasiVartaDetailPageState();
}

class _ChorasiVartaDetailPageState extends State<ChorasiVartaDetailPage> {
  double _fontSize = 17.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = widget.isBrajLanguage
        ? widget.varta.titleBraj
        : widget.varta.titleGujarati;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "(${widget.varta.number}) $title",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () {
              if (_fontSize > 13.0) setState(() => _fontSize -= 2.0);
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              if (_fontSize < 28.0) setState(() => _fontSize += 2.0);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sanskrit Shloka Block
              if (widget.varta.shloka.isNotEmpty) ...[
                Text(
                  widget.varta.shloka,
                  style: TextStyle(
                    fontSize: _fontSize + 1,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 2. Arth (Meaning) Block
              if (widget.varta.arth.isNotEmpty) ...[
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: _fontSize,
                      height: 1.6,
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      const TextSpan(
                        text: "અર્થ :- ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.varta.arth),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 3. Varta Story Paragraph
              if (widget.varta.vartaContent.isNotEmpty) ...[
                Text(
                  widget.varta.vartaContent,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: _fontSize,
                    height: 1.6,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 4. Saar (Summary) Block
              if (widget.varta.saar.isNotEmpty) ...[
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: _fontSize,
                      height: 1.6,
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      const TextSpan(
                        text: "(સાર) ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.varta.saar),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
