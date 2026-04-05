import 'package:flutter/material.dart';
import '../widgets/navbar_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/urgency_bar.dart';
import '../widgets/stats_section.dart';
import '../widgets/section_01_conviction.dart';
import '../widgets/section_02_pillars.dart';
import '../widgets/section_03_profile.dart';
import '../widgets/section_04_tests.dart';
import '../widgets/section_05_chat.dart';
import '../widgets/section_06_roadmap.dart';
import '../widgets/section_07_team.dart';
import '../widgets/section_08_ethics.dart';
import '../widgets/cta_section.dart';
import '../widgets/form_section.dart';
import '../widgets/footer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey();
  final _testsKey = GlobalKey();
  final _accompagnementKey = GlobalKey();

  void _scrollToForm() {
    _scrollToKey(_formKey);
  }

  void _scrollToTests() {
    _scrollToKey(_testsKey);
  }

  void _scrollToAccompagnement() {
    _scrollToKey(_accompagnementKey);
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  onReserve: _scrollToForm,
                  onDiscoverTests: _scrollToTests,
                ),
                const UrgencyBar(),
                const StatsSection(),
                const Section01Conviction(),
                const Section02Pillars(),
                const Section03Profile(),
                Section04Tests(sectionKey: _testsKey),
                Section05Chat(sectionKey: _accompagnementKey),
                const Section06Roadmap(),
                const Section07Team(),
                const Section08Ethics(),
                CtaSection(onReserve: _scrollToForm),
                FormSection(sectionKey: _formKey),
              ],
            ),
          ),
          // Fixed navbar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavbarWidget(
              scrollController: _scrollController,
              onReserve: _scrollToForm,
              onScrollToTests: _scrollToTests,
              onScrollToAccompagnement: _scrollToAccompagnement,
            ),
          ),
        ],
      ),
    );
  }
}
