import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/kirtan_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class KirtanListPage extends StatefulWidget {
  const KirtanListPage({super.key});

  @override
  State<KirtanListPage> createState() => _KirtanListPageState();
}

class _KirtanListPageState extends State<KirtanListPage> {
  final TextEditingController _searchController = TextEditingController();

  // Audio Player State
  final AudioPlayer _audioPlayer = AudioPlayer();
  KirtanModel? _currentlyPlaying;
  PlayerState? _playerState;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool get _isPlaying => _playerState == PlayerState.playing;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  // Updated list with IDs 1 to 10
  final List<KirtanModel> _allKirtans = [
    KirtanModel(
      id: '1',
      number: '૦૧',
      title: 'યમુનાષ્ટક',
      imageAsset: 'assets/images/img1.png',
      audioAsset: 'sounds/track_1.mp3',
    ),
    KirtanModel(
      id: '2',
      number: '૦૨',
      title: 'મંગલાચરણ',
      imageAsset: 'assets/images/img2.png',
      audioAsset: 'sounds/track_2.mp3',
    ),
    KirtanModel(
      id: '3',
      number: '૦૩',
      title: 'કૃષ્ણાશ્રય',
      imageAsset: 'assets/images/img3.png',
      audioAsset: 'sounds/track_3.mp3',
    ),
    KirtanModel(
      id: '4',
      number: '૦૪',
      title: 'ગોપીગીત',
      imageAsset: 'assets/images/img4.png',
      audioAsset: 'sounds/track_4.mp3',
    ),
    KirtanModel(
      id: '5',
      number: '૦૫',
      title: 'યુગલગીત',
      imageAsset: 'assets/images/img5.png',
      audioAsset: 'sounds/track_5.mp3',
    ),
    KirtanModel(
      id: '6',
      number: '૦૬',
      title: 'વેણુગીત',
      imageAsset: 'assets/images/img6.png',
      audioAsset: 'sounds/track_6.mp3',
    ),
    KirtanModel(
      id: '7',
      number: '૦૭',
      title: 'ભ્રમરગીત',
      imageAsset: 'assets/images/img7.png',
      audioAsset: 'sounds/track_7.mp3',
    ),
    KirtanModel(
      id: '8',
      number: '૦૮',
      title: 'મધુરાષ્ટક',
      imageAsset: 'assets/images/img8.png',
      audioAsset: 'sounds/track_8.mp3',
    ),
    // KirtanModel(
    //   id: '9',
    //   number: '૦૯',
    //   title: 'નવરત્ન',
    //   imageAsset: 'assets/images/img9.png',
    //   audioAsset: 'sounds/track_9.mp3',
    // ),
    // KirtanModel(
    //   id: '10',
    //   number: '૧૦',
    //   title: 'સિદ્ધાંત રહસ્ય',
    //   imageAsset: 'assets/images/img10.png',
    //   audioAsset: 'sounds/track_10.mp3',
    // ),
  ];

  List<KirtanModel> _filteredKirtans = [];

  @override
  void initState() {
    super.initState();
    _filteredKirtans = _allKirtans;
    _setupAudioPlayerForBackground();

    // Listen to player state changes
    _playerStateChangeSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted) setState(() => _playerState = state);
    });

    // Listen to audio duration changes
    _durationSubscription = _audioPlayer.onDurationChanged.listen((
      newDuration,
    ) {
      if (mounted) setState(() => _duration = newDuration);
    });

    // Listen to audio position changes
    _positionSubscription = _audioPlayer.onPositionChanged.listen((
      newPosition,
    ) {
      if (mounted) setState(() => _position = newPosition);
    });

    // Listen for when the audio completes and play the next one
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) _playNext();
    });
  }

  void _setupAudioPlayerForBackground() {
    AudioPlayer.global.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );
  }

  void _filterKirtan(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredKirtans = _allKirtans;
      } else {
        _filteredKirtans = _allKirtans
            .where(
              (item) =>
                  item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.number.contains(query),
            )
            .toList();
      }
    });
  }

  Future<void> _playKirtan(KirtanModel kirtan) async {
    if (_currentlyPlaying?.id != kirtan.id) {
      await _audioPlayer.stop();
    }
    setState(() {
      _currentlyPlaying = kirtan;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _audioPlayer.play(AssetSource(kirtan.audioAsset));
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_currentlyPlaying != null) {
        if (_playerState == PlayerState.paused) {
          await _audioPlayer.resume();
        } else {
          await _playKirtan(_currentlyPlaying!);
        }
      }
    }
  }

  void _playNext() {
    if (_currentlyPlaying == null) return;
    int currentIndex = _filteredKirtans.indexWhere(
      (k) => k.id == _currentlyPlaying!.id,
    );
    if (currentIndex != -1) {
      int nextIndex = (currentIndex + 1) % _filteredKirtans.length;
      _playKirtan(_filteredKirtans[nextIndex]);
    } else if (_filteredKirtans.isNotEmpty) {
      _playKirtan(_filteredKirtans.first);
    }
  }

  // --- WEBSITE REDIRECT LOGIC ---
  Future<void> _openDownloadWebsite() async {
    // Replace this URL with your actual Kirtan download website
    final Uri url = Uri.parse(
      'https://soundcloud.com/pushtimarg-kirtan/albums',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the website.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.grid_kirtan,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _openDownloadWebsite,
              icon: Icon(
                Icons.download_rounded,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                "Download",
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              color: theme.colorScheme.primary,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.colorScheme.onPrimary),
                onChanged: _filterKirtan,
                decoration: InputDecoration(
                  hintText: l10n.search_placeholder,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onPrimary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: theme.colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterKirtan('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.onPrimary.withOpacity(0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // KIRTAN LIST & MINI PLAYER STACK
            Expanded(
              child: Stack(
                children: [
                  _filteredKirtans.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.queue_music,
                                size: 60,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.search_placeholder,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 12,
                            right: 12,
                            bottom: _currentlyPlaying != null ? 110 : 16,
                          ),
                          itemCount: _filteredKirtans.length,
                          itemBuilder: (context, index) {
                            final kirtan = _filteredKirtans[index];
                            final isThisPlaying =
                                _currentlyPlaying?.id == kirtan.id;

                            return Card(
                              elevation: isThisPlaying ? 2 : 0,
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isThisPlaying
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline.withOpacity(
                                          0.1,
                                        ),
                                  width: isThisPlaying ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        kirtan.imageAsset,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.1),
                                                  child: Icon(
                                                    Icons.music_note,
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    title: Text(
                                      kirtan.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isThisPlaying
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "કીર્તન ક્રમાંક: ${kirtan.number}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isThisPlaying && _isPlaying
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_filled_rounded,
                                      ),
                                      iconSize: 32,
                                      color: isThisPlaying
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface
                                                .withOpacity(0.4),
                                      onPressed: () {
                                        if (isThisPlaying) {
                                          _togglePlayPause();
                                        } else {
                                          _playKirtan(kirtan);
                                        }
                                      },
                                    ),
                                  ),
                                  if (isThisPlaying)
                                    LinearProgressIndicator(
                                      value: (_duration.inSeconds > 0)
                                          ? (_position.inSeconds /
                                                    _duration.inSeconds)
                                                .clamp(0.0, 1.0)
                                          : 0.0,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.primary,
                                      ),
                                      minHeight: 3,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                  // Floating Mini-Player (Capsule)
                  if (_currentlyPlaying != null)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Container(
                        height:
                            100, // Taller to fit content + slider comfortably
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Audio Details & White Controls (Moved to top)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 12,
                                top: 12,
                                bottom: 4,
                              ),
                              child: Row(
                                children: [
                                  // Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      _currentlyPlaying!.imageAsset,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 44,
                                                height: 44,
                                                color: Colors.white24,
                                                child: const Icon(
                                                  Icons.music_note,
                                                  color: Colors.white,
                                                ),
                                              ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Title & Time Length (White Text)
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _currentlyPlaying!.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Play/Pause Button (White)
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      size: 42,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed: _togglePlayPause,
                                  ),

                                  // Next Button (White)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_next_rounded,
                                      size: 34,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed: _playNext,
                                  ),
                                ],
                              ),
                            ),

                            // Progress Slider (Moved to bottom)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 6,
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                height: 20,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                    ),
                                    overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 14,
                                    ),
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.white
                                        .withOpacity(0.3),
                                    thumbColor: Colors.white,
                                  ),
                                  child: Slider(
                                    value: (_duration.inSeconds > 0)
                                        ? _position.inSeconds.toDouble().clamp(
                                            0.0,
                                            _duration.inSeconds.toDouble(),
                                          )
                                        : 0.0,
                                    max: (_duration.inSeconds > 0)
                                        ? _duration.inSeconds.toDouble()
                                        : 1.0,
                                    onChanged: (val) {
                                      _audioPlayer.seek(
                                        Duration(seconds: val.toInt()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
