import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../core/localization/app_localizations.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.translate('about_title'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.black),
            onSelected: (String value) {
              final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
              if (value == 'en') {
                languageProvider.setLocale(const Locale('en'));
              } else if (value == 'es') {
                languageProvider.setLocale(const Locale('es'));
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'en',
                child: Text(localizations.translate('english')),
              ),
              PopupMenuItem(
                value: 'es',
                child: Text(localizations.translate('spanish')),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'eco',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'Guardians',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7433FF),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              localizations.translate('about_subtitle'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 32),
            
            _buildSection(
              localizations,
              icon: Icons.gamepad_rounded,
              iconColor: const Color(0xFF7433FF),
              title: localizations.translate('child_module_title'),
              content: [
                _buildParagraph(localizations.translate('child_module_desc')),
                _buildSubtitle(localizations.translate('how_it_works')),
                _buildBullet(localizations.translate('how_it_works_1')),
                _buildBullet(localizations.translate('how_it_works_2')),
                _buildBullet(localizations.translate('how_it_works_3')),
                _buildBullet(localizations.translate('how_it_works_4')),
                _buildBullet(localizations.translate('how_it_works_5')),
                const SizedBox(height: 12),
                _buildSubtitle(localizations.translate('educational_scenarios')),
                _buildBullet(localizations.translate('scenario_grooming')),
                _buildBullet(localizations.translate('scenario_sexting')),
                _buildBullet(localizations.translate('scenario_cyberbullying')),
                const SizedBox(height: 12),
                _buildParagraph(localizations.translate('unique_experience')),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              localizations,
              icon: Icons.shield_outlined,
              iconColor: Colors.green,
              title: localizations.translate('parent_module_title'),
              content: [
                _buildParagraph(localizations.translate('parent_module_desc')),
                _buildSubtitle(localizations.translate('functionalities')),
                _buildBullet(localizations.translate('func_screen_time')),
                _buildBullet(localizations.translate('func_periods')),
                _buildBullet(localizations.translate('func_alerts')),
                _buildBullet(localizations.translate('func_patterns')),
                _buildBullet(localizations.translate('func_night')),
                const SizedBox(height: 12),
                _buildParagraph(localizations.translate('alerts_desc')),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              localizations,
              icon: Icons.psychology_outlined,
              iconColor: Colors.orange,
              title: localizations.translate('how_solves'),
              content: [
                _buildParagraph(localizations.translate('how_solves_desc')),
                const SizedBox(height: 12),
                _buildSubtitle(localizations.translate('education_for_kids')),
                _buildBullet(localizations.translate('edu_active')),
                _buildBullet(localizations.translate('edu_no_consequences')),
                _buildBullet(localizations.translate('edu_feedback')),
                _buildBullet(localizations.translate('edu_gamification')),
                const SizedBox(height: 12),
                _buildSubtitle(localizations.translate('empowerment_parents')),
                _buildBullet(localizations.translate('emp_visibility')),
                _buildBullet(localizations.translate('emp_detection')),
                _buildBullet(localizations.translate('emp_dialogue')),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              localizations,
              icon: Icons.school_outlined,
              iconColor: const Color(0xFF7433FF),
              title: localizations.translate('education_promotion'),
              content: [
                _buildParagraph(localizations.translate('education_promotion_desc')),
                const SizedBox(height: 12),
                _buildBullet(localizations.translate('promo_critical')),
                _buildBullet(localizations.translate('promo_protection')),
                _buildBullet(localizations.translate('promo_resilience')),
                _buildBullet(localizations.translate('promo_communication')),
                _buildBullet(localizations.translate('promo_continuous')),
                const SizedBox(height: 12),
                _buildParagraph(localizations.translate('final_message')),
              ],
            ),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7433FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF7433FF).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb,
                    color: Color(0xFF7433FF),
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.translate('our_mission'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7433FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.translate('mission_text'),
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    AppLocalizations localizations, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...content,
      ],
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
