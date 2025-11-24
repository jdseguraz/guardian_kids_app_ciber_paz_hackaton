import 'package:flutter/material.dart';
import 'dart:math';
import '../models/app_usage.dart';

class AlertInfo {
  final String title;
  final String description;
  final String severity; // 'high', 'medium', 'low'
  final DateTime timestamp;

  AlertInfo({
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
  });
}

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  List<AppUsageInfo> _appUsageList = [];
  List<AlertInfo> _alerts = [];
  bool _isLoading = false;
  String _selectedPeriod = 'Hoy';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    setState(() {
      _isLoading = true;
    });

    // Simular carga de datos
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _appUsageList = _generateMockAppUsage();
        _alerts = _generateMockAlerts();
        _isLoading = false;
      });
    });
  }

  List<AppUsageInfo> _generateMockAppUsage() {
    final random = Random();
    final now = DateTime.now();
    
    final apps = [
      {'name': 'TikTok', 'icon': '📱'},
      {'name': 'WhatsApp', 'icon': '💬'},
      {'name': 'Instagram', 'icon': '📷'},
      {'name': 'YouTube', 'icon': '📺'},
      {'name': 'Facebook', 'icon': '👥'},
      {'name': 'Snapchat', 'icon': '👻'},
      {'name': 'Discord', 'icon': '🎮'},
      {'name': 'Twitter', 'icon': '🐦'},
      {'name': 'Telegram', 'icon': '✈️'},
      {'name': 'Roblox', 'icon': '🎯'},
      {'name': 'Minecraft', 'icon': '⛏️'},
      {'name': 'Spotify', 'icon': '🎵'},
    ];

    return apps.map((app) {
      final baseMinutes = _selectedPeriod == 'Hoy' 
          ? random.nextInt(180) + 10
          : _selectedPeriod == 'Esta semana'
              ? random.nextInt(600) + 50
              : random.nextInt(1500) + 200;
      
      return AppUsageInfo(
        appName: '${app['icon']} ${app['name']}',
        packageName: 'com.${app['name']!.toLowerCase()}.app',
        usageTimeInMinutes: baseMinutes,
        lastTimeUsed: now.subtract(Duration(minutes: random.nextInt(60))),
      );
    }).toList()
      ..sort((a, b) => b.usageTimeInMinutes.compareTo(a.usageTimeInMinutes));
  }

  List<AlertInfo> _generateMockAlerts() {
    final now = DateTime.now();
    
    return [
      AlertInfo(
        title: 'Conversación sospechosa detectada',
        description: 'Se detectó una conversación en WhatsApp con un patrón de grooming. Revisar mensajes recientes.',
        severity: 'high',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      AlertInfo(
        title: 'Uso excesivo de redes sociales',
        description: 'TikTok ha sido usado por más de 4 horas hoy. Considera establecer límites.',
        severity: 'medium',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      AlertInfo(
        title: 'Nueva app instalada',
        description: 'Se instaló Discord. Es una app de mensajería frecuentemente usada por adolescentes.',
        severity: 'low',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      AlertInfo(
        title: 'Actividad nocturna detectada',
        description: 'Uso de Instagram a las 2:30 AM. Considera activar el control parental nocturno.',
        severity: 'medium',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
      ),
    ];
  }

  int _getTotalMinutes() {
    return _appUsageList.fold(0, (sum, app) => sum + app.usageTimeInMinutes);
  }

  String _formatTotalTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final mins = minutes % 60;
      return '${hours}h ${mins}min';
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'high':
        return Icons.warning_amber_rounded;
      case 'medium':
        return Icons.info_outline;
      case 'low':
        return Icons.notification_important_outlined;
      default:
        return Icons.circle;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inDays}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Módulo Padre',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  _buildUsageSection(),
                  const SizedBox(height: 24),
                  _buildAlertsSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Período de análisis',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: ['Hoy', 'Esta semana', 'Este mes'].map((period) {
              final isSelected = _selectedPeriod == period;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(period),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPeriod = period;
                        _loadMockData();
                      });
                    }
                  },
                  selectedColor: const Color(0xFF7433FF),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey[100],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageSection() {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiempo de pantalla',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7433FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatTotalTime(_getTotalMinutes()),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7433FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._appUsageList.map((app) => _buildAppUsageItem(app)).toList(),
        ],
      ),
    );
  }

  Widget _buildAppUsageItem(AppUsageInfo app) {
    final totalMinutes = _getTotalMinutes();
    final percentage = totalMinutes > 0 ? (app.usageTimeInMinutes / totalMinutes) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  app.appName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                app.formattedUsageTime,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7433FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7433FF)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Color(0xFF7433FF),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Alertas de seguridad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Detectadas por IA',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ..._alerts.map((alert) => _buildAlertCard(alert)).toList(),
        ],
      ),
    );
  }

  Widget _buildAlertCard(AlertInfo alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getSeverityColor(alert.severity).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(alert.severity).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getSeverityIcon(alert.severity),
                color: _getSeverityColor(alert.severity),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _getSeverityColor(alert.severity),
                  ),
                ),
              ),
              Text(
                _getTimeAgo(alert.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
