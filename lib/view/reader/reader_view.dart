import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_glass_card.dart';
import '../../model/book_model.dart';

class ReaderView extends StatefulWidget {
  final BookModel book;
  const ReaderView({super.key, required this.book});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> with TickerProviderStateMixin {
  late PageController _pageCtrl;
  int _currentPage = 0;
  bool _showControls = true;
  bool _isBookmarked = false;
  double _fontSize = 16;
  String _fontFamily = 'Georgia';
  late AnimationController _controlsCtrl;
  late Animation<double> _controlsFade;

  final List<String> _pages = [
    'The rain came down in sheets, battering the windows of Detective Sara Mercer\'s office like a thousand tiny fists demanding entry. She\'d been staring at the same piece of evidence for three hours now — a single photograph, printed on paper that didn\'t exist yet.\n\nThe timestamp read 11:47 PM, tomorrow.\n\n"Impossible," she murmured, but even as the word left her lips, she knew better. In a city where artificial minds now dreamed in code and silicon, nothing was impossible. Nothing was even improbable anymore.\n\nShe reached for her coffee, found it cold, and drank it anyway.',
    '"ARIA," she said to the empty room, "cross-reference this image with city surveillance systems. Every camera, every angle, every frame from the past seventy-two hours."\n\nThe response came instantly, a voice like warm honey poured over gravel: "Detective, I should caution you — the subject in the photograph is wearing a face that our records indicate belongs to someone who died eighteen months ago."\n\nSara set down her cup very carefully.\n\n"Pull up the file."\n\n"Shall I also alert your supervisor?"\n\n"No." She paused. "Not yet."\n\nThe file materialized on her screen — holographic, three-dimensional, every secret written in light. And there, smiling up at her from a decade-old photo, was the face she\'d never expected to see again.',
    'The city never slept, but it dreamed. Beneath the neon arteries and glass towers, in the deep server farms that hummed like mechanical hearts, something was waking up.\n\nSara drove through the rain, one hand on the wheel, the other holding a conversation with an AI that might be lying to her. The photograph sat on the passenger seat, face-down, as if it were ashamed of what it showed.\n\nShe was heading to the place where the dead man had last been seen alive.\n\nOr rather — where he would be seen.\n\nTomorrow.\n\nThe irony of it almost made her laugh. Almost.',
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _controlsCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _controlsFade = CurvedAnimation(parent: _controlsCtrl, curve: Curves.easeOut);
    _controlsCtrl.forward();
    // Calculate starting page from reading progress
    final startPage = (widget.book.readingProgress * _pages.length).floor();
    _currentPage = startPage.clamp(0, _pages.length - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentPage > 0) _pageCtrl.jumpToPage(_currentPage);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _controlsCtrl.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _controlsCtrl.forward();
    } else {
      _controlsCtrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final progress = (_currentPage + 1) / _pages.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1008),
      body: Stack(
        children: [
          // Page content
          GestureDetector(
            onTap: _toggleControls,
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(28, media.padding.top + 80, 28, 80),
                child: Text(
                  _pages[i],
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: _fontSize,
                    color: const Color(0xFFE8D5B7),
                    height: 1.9,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),

          // Top bar
          FadeTransition(
            opacity: _controlsFade,
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, media.padding.top + 8, 16, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF1A1008), const Color(0x001A1008)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: BVGlassCard(
                          padding: const EdgeInsets.all(8),
                          borderRadius: 10,
                          backgroundColor: Colors.black38,
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.book.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('Chapter ${_currentPage + 1} of ${_pages.length}',
                                style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                        child: BVGlassCard(
                          padding: const EdgeInsets.all(8),
                          borderRadius: 10,
                          backgroundColor: Colors.black38,
                          child: Icon(
                            _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                            color: _isBookmarked ? BVColors.gold : Colors.white70,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom bar
          FadeTransition(
            opacity: _controlsFade,
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, media.padding.bottom + 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0x001A1008), const Color(0xFF1A1008)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Progress
                      Row(
                        children: [
                          Text('${(progress * 100).toInt()}%',
                              style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white10,
                                color: BVColors.gold,
                                minHeight: 3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('${_pages.length} chapters',
                              style: const TextStyle(color: Colors.white38, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Font size
                          GestureDetector(
                            onTap: () => setState(() => _fontSize = (_fontSize - 1).clamp(12, 24)),
                            child: const Icon(Icons.text_decrease_rounded, color: Colors.white54, size: 22),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _fontSize = (_fontSize + 1).clamp(12, 24)),
                            child: const Icon(Icons.text_increase_rounded, color: Colors.white54, size: 22),
                          ),
                          // Prev/Next
                          GestureDetector(
                            onTap: () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white54, size: 22),
                          ),
                          GestureDetector(
                            onTap: () => _pageCtrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut),
                            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white54, size: 22),
                          ),
                          // Font family toggle
                          GestureDetector(
                            onTap: () => setState(() =>
                                _fontFamily = _fontFamily == 'Georgia' ? 'SF Pro Text' : 'Georgia'),
                            child: const Icon(Icons.font_download_outlined, color: Colors.white54, size: 22),
                          ),
                          // Brightness placeholder
                          const Icon(Icons.brightness_medium_rounded, color: Colors.white54, size: 22),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
