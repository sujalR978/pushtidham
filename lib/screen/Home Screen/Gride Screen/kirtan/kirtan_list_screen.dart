import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/kirtan_model.dart';
import 'package:audioplayers/audioplayers.dart';
// REMOVED: kirtan_detail_screen import

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

  // Updated list with .wma assets
  final List<KirtanModel> _allKirtans = [
    KirtanModel(
      id: '1',
      number: '૦૧',
      title: 'યમુનાષ્ટક',
      imageAsset: 'assets/images/spleshScreen_image.png',
      // NOTE: WMA is not universally supported. MP3 is recommended for cross-platform compatibility.
      audioAsset: 'sounds/yamunashtak.wma',
    ),
    KirtanModel(
      id: '2',
      number: '૦૨',
      title: 'મંગલાચરણ',
      imageAsset: 'assets/images/spleshScreen_image.png',
      audioAsset: 'sounds/mangalacharan.wma',
    ),
  ];

  List<KirtanModel> _filteredKirtans = [];

  @override
  void initState() {
    super.initState();
    _filteredKirtans = _allKirtans;

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
      if (mounted) {
        _playNext();
      }
    });
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

  // Function to handle playing a Kirtan
  Future<void> _playKirtan(KirtanModel kirtan) async {
    // Stop current playback if a new kirtan is selected or if it's the same one
    if (_currentlyPlaying?.id != kirtan.id) {
      await _audioPlayer.stop();
    }

    setState(() {
      _currentlyPlaying = kirtan;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    // Play the new kirtan from assets
    await _audioPlayer.play(AssetSource(kirtan.audioAsset));
  }

  // Toggle play/pause for the currently selected kirtan
  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_currentlyPlaying != null) {
        // If paused, resume. If stopped, play from start.
        if (_playerState == PlayerState.paused) {
          await _audioPlayer.resume();
        } else {
          await _playKirtan(_currentlyPlaying!);
        }
      }
    }
  }

  // Function to play the next Kirtan
  void _playNext() {
    if (_currentlyPlaying == null) return;

    int currentIndex = _filteredKirtans.indexWhere(
      (k) => k.id == _currentlyPlaying!.id,
    );
    if (currentIndex != -1) {
      int nextIndex =
          (currentIndex + 1) % _filteredKirtans.length; // Loop back to start
      _playKirtan(_filteredKirtans[nextIndex]);
    } else {
      // If currently playing is not in the filtered list, play the first one
      if (_filteredKirtans.isNotEmpty) {
        _playKirtan(_filteredKirtans.first);
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. DYNAMIC THEMED SEARCH BAR
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

            // 2. KIRTAN LIST & MINI PLAYER STACK
            Expanded(
              child: Stack(
                children: [
                  // Main List
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
                            bottom: _currentlyPlaying != null ? 90 : 16,
                          ),
                          itemCount: _filteredKirtans.length,
                          itemBuilder: (context, index) {
                            final kirtan = _filteredKirtans[index];
                            final isThisPlaying =
                                _currentlyPlaying?.id == kirtan.id;

                            return Card(
                              elevation: isThisPlaying ? 2 : 0,
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
                              child: ListTile(
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
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.1),
                                              child: Icon(
                                                Icons.music_note,
                                                color:
                                                    theme.colorScheme.primary,
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
                                trailing: isThisPlaying
                                    ? _isPlaying
                                          ? Icon(
                                              Icons.graphic_eq,
                                              color: theme.colorScheme.primary,
                                            )
                                          : _playerState == PlayerState.paused
                                          ? Icon(
                                              Icons.pause,
                                              color: theme.colorScheme.primary,
                                            )
                                          : Icon(
                                              Icons.play_arrow_rounded,
                                              color: theme.colorScheme.primary,
                                            )
                                    : Icon(
                                        Icons.play_arrow_rounded,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.4),
                                        size: 28,
                                      ),
                                onTap: () {
                                  _playKirtan(kirtan);
                                },
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
                        height: 70,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Stack(
                            children: [
                              // Progress Bar background inside the capsule
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: LinearProgressIndicator(
                                  value: (_duration.inSeconds > 0)
                                      ? (_position.inSeconds /
                                                _duration.inSeconds)
                                            .clamp(0.0, 1.0)
                                      : 0.0,
                                  minHeight: 3,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              // Capsule Content
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    // Thumbnail
                                    ClipOval(
                                      child: Image.asset(
                                        _currentlyPlaying!.imageAsset,
                                        width: 46,
                                        height: 46,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => Container(
                                              width: 46,
                                              height: 46,
                                              color: theme.colorScheme.primary,
                                              child: Icon(
                                                Icons.music_note,
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Title & Time Length
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: theme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                          Text(
                                            // Real-time duration
                                            "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: theme
                                                  .colorScheme
                                                  .onPrimaryContainer
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Play/Pause Button
                                    IconButton(
                                      icon: Icon(
                                        _isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_filled,
                                        size: 38,
                                        color: theme.colorScheme.primary,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: _togglePlayPause,
                                    ),

                                    // Next Button
                                    IconButton(
                                      icon: Icon(
                                        Icons.skip_next_rounded,
                                        size: 32,
                                        color: theme
                                            .colorScheme
                                            .onPrimaryContainer
                                            .withOpacity(0.8),
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: _playNext,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
