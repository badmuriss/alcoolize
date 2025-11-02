import 'package:flutter/material.dart';
import '../services/game_repository.dart';
import '../localization/generated/app_localizations.dart';

/// Screen for managing universal content packs
class PackManagerScreen extends StatefulWidget {
  const PackManagerScreen({super.key});

  @override
  State<PackManagerScreen> createState() => _PackManagerScreenState();
}

class _PackManagerScreenState extends State<PackManagerScreen> {
  final Color _primaryColor = const Color(0xFF6A0DAD);
  GameRepository? _repository;
  List<UniversalPack> _allPacks = [];
  Set<String> _enabledPackIds = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    try {
      _repository = await GameRepository.create();
      await _repository!.initializeDefaults();
      await _loadData();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load packs: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    if (_repository == null) return;

    try {
      final packs = await _repository!.getAllPacks();
      final enabledIds = _repository!.getEnabledPackIds();

      setState(() {
        _allPacks = packs;
        _enabledPackIds = enabledIds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePack(String packId, bool enabled) async {
    await _repository?.setPackEnabled(packId, enabled);
    setState(() {
      if (enabled) {
        _enabledPackIds.add(packId);
      } else {
        _enabledPackIds.remove(packId);
      }
    });
  }

  List<UniversalPack> get _filteredPacks {
    var packs = List<UniversalPack>.from(_allPacks);

    // Sort: enabled first, then alphabetically
    packs.sort((a, b) {
      final aEnabled = _enabledPackIds.contains(a.id);
      final bEnabled = _enabledPackIds.contains(b.id);
      if (aEnabled != bEnabled) {
        return aEnabled ? -1 : 1;
      }
      final locale = 'pt';
      return a.manifest.getLocalizedName(locale)
          .compareTo(b.manifest.getLocalizedName(locale));
    });

    return packs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: Text(
          AppLocalizations.of(context)?.managePacks ?? 'Manage Content Packs',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            _initializeRepository();
                          },
                          child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    _buildPackStats(),
                    Expanded(child: _buildPackList()),
                  ],
                ),
    );
  }






  Widget _buildPackStats() {
    final enabled = _enabledPackIds.length;
    final total = _allPacks.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.check_circle, AppLocalizations.of(context)?.enabled ?? 'Enabled', '$enabled'),
          _buildStatItem(Icons.apps, AppLocalizations.of(context)?.total ?? 'Total', '$total'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPackList() {
    final packs = _filteredPacks;

    if (packs.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)?.noPacksAvailable ?? 'No packs available',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packs.length,
      itemBuilder: (context, index) => _buildPackCard(packs[index]),
    );
  }

  Widget _buildPackCard(UniversalPack pack) {
    final locale = 'pt';
    final isEnabled = _enabledPackIds.contains(pack.id);

    // Count items in pack
    int totalItems = 0;
    pack.games.forEach((gameType, gameData) {
      if (gameData is Map) {
        gameData.forEach((key, value) {
          if (value is Map && value.containsKey('pt')) {
            final list = value['pt'];
            if (list is List) {
              totalItems += list.length;
            }
          }
        });
      }
    });

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isEnabled ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isEnabled ? _primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showPackDetails(pack, totalItems),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pack.manifest.getLocalizedName(locale),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isEnabled ? _primaryColor : Colors.black87,
                                ),
                              ),
                            ),
                            if (pack.manifest.premium)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'PREMIUM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pack.manifest.getLocalizedDescription(locale),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    activeColor: _primaryColor,
                    onChanged: (value) => _togglePack(pack.id, value),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPackBadge(
                    Icons.local_fire_department,
                    pack.manifest.getSpiceLevelName(locale),
                    _getSpiceColor(pack.manifest.spice),
                  ),
                  const SizedBox(width: 8),
                  _buildPackBadge(
                    Icons.format_list_numbered,
                    '$totalItems ${AppLocalizations.of(context)?.items ?? 'items'}',
                    Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSpiceColor(int spice) {
    switch (spice) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


  void _showPackDetails(UniversalPack pack, int totalItems) {
    final locale = 'pt'; // TODO: Get from prefs
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pack.manifest.getLocalizedName(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pack.manifest.getLocalizedDescription(locale),
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildDetailRow(
                    AppLocalizations.of(context)?.version ?? 'Version',
                    pack.manifest.version,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)?.spiceLevel ?? 'Spice Level',
                    pack.manifest.getSpiceLevelName(locale),
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)?.totalItems ?? 'Total Items',
                    '$totalItems',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)?.gamesIncluded ?? 'Games Included:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...pack.games.keys.map((gameType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            _getGameDisplayName(gameType),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getGameDisplayName(String gameType) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return gameType;

    switch (gameType) {
      case 'truth_or_dare':
        return localizations.truthOrDare;
      case 'drunk_trivia':
        return localizations.drunkTrivia;
      case 'cards':
        return localizations.cards;
      case 'never_have_i_ever':
        return localizations.neverHaveIEver;
      case 'most_likely_to':
        return localizations.mostLikelyTo;
      case 'paranoia':
        return localizations.paranoia;
      case 'forbidden_word':
        return localizations.forbiddenWord;
      case 'scratch_card':
        return localizations.scratchCard;
      default:
        return gameType;
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          AppLocalizations.of(context)?.contentPacks ?? 'Content Packs',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)?.contentPacksDescription ??
                'Content packs allow you to customize your experience with different sets of questions and challenges.',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.spiceLevels ?? 'Spice Levels:',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)?.spiceLevelsDescription ??
                '• Mild: Family-friendly content\n• Medium: Party atmosphere\n• Spicy: Bolder content\n• Hot: Adults only',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.enablePacksInfo ??
                'Enable the packs you want to use in your games.',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)?.understood ?? 'Got it',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
