import 'package:flutter/material.dart';

class OfflineItem {
  final String id;
  final String title;
  final String subTitle;
  final String type; // 'pdf' or 'audio'
  final String fileSize;

  OfflineItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.type,
    required this.fileSize,
  });
}

class OfflineContentPage extends StatefulWidget {
  const OfflineContentPage({super.key});

  @override
  State<OfflineContentPage> createState() => _OfflineContentPageState();
}

class _OfflineContentPageState extends State<OfflineContentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Curated mock downloaded dataset
  final List<OfflineItem> _offlineList = [
    OfflineItem(id: '1', title: 'શ્રી યમુનાષ્ટકમ (Yamunashtakam)', subTitle: 'Daily Stotra Reading', type: 'pdf', fileSize: '1.2 MB'),
    OfflineItem(id: '2', title: 'ષોડશ ગ્રંથ (Shodash Granth)', subTitle: 'Complete text package', type: 'pdf', fileSize: '4.8 MB'),
    OfflineItem(id: '3', title: 'પ્રાતઃ સ્મરણ ભજન (Pratah Smaran)', subTitle: 'Morning Chanting Recitation', type: 'audio', fileSize: '12.4 MB'),
    OfflineItem(id: '4', title: 'શ્રી કૃષ્ણ આશ્રય પાઠ (Krsna Asray)', subTitle: 'Kirtan Chants', type: 'audio', fileSize: '8.1 MB'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removeDownloadedItem(String id) {
    setState(() {
      _offlineList.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("કન્ટેન્ટ સ્ટોરેજમાંથી કાઢી નાખવામાં આવ્યું છે (Deleted from device storage)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter items dynamically into sub-tabs
    final pdfItems = _offlineList.where((item) => item.type == 'pdf').toList();
    final audioItems = _offlineList.where((item) => item.type == 'audio').toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("ઓફલાઇન કન્ટેન્ટ", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.secondary == Colors.black87 ? Colors.white : theme.colorScheme.secondary,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: "સાહિત્ય (Docs)"),
            Tab(icon: Icon(Icons.audiotrack), text: "ઑડિયો (Audio)"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContentList(pdfItems, theme, isAudio: false),
          _buildContentList(audioItems, theme, isAudio: true),
        ],
      ),
    );
  }

  Widget _buildContentList(List<OfflineItem> items, ThemeData theme, {required bool isAudio}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAudio ? Icons.cloud_off_outlined : Icons.find_in_page_outlined, 
              size: 64, 
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              "કોઈ ઓફલાઇન ફાઈલ નથી\n(No offline downloads here)",
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: theme.cardTheme.color,
          elevation: theme.cardTheme.elevation ?? 2,
          shape: theme.cardTheme.shape,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
              child: Icon(
                isAudio ? Icons.play_circle_filled : Icons.picture_as_pdf, 
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(item.subTitle, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.sd_storage_outlined, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text(item.fileSize, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              color: theme.colorScheme.surface,
              onSelected: (action) {
                if (action == 'delete') {
                  _removeDownloadedItem(item.id);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'read_play',
                  child: Row(
                    children: [
                      Icon(isAudio ? Icons.play_arrow : Icons.chrome_reader_mode, size: 18, color: theme.colorScheme.onSurface),
                      const SizedBox(width: 8),
                      Text(isAudio ? "ચલાવો (Play)" : "વાંચો (Read)"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text("કાઢી નાખો (Delete)", style: TextStyle(color: theme.colorScheme.error)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              // Trigger reading viewer or custom audio stream interface instantly
            },
          ),
        );
      },
    );
  }
}