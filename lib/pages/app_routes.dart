import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unknown_note_flutter/bloc/diary/write_diary_bloc.dart';
import 'package:unknown_note_flutter/bloc/essay/write_essay_bloc.dart';
import 'package:unknown_note_flutter/models/diary/diary_model.dart';
import 'package:unknown_note_flutter/models/essay/essay_model.dart';
import 'package:unknown_note_flutter/pages/home/home_page.dart';
import 'package:unknown_note_flutter/pages/read_diary/read_diary_page.dart';
import 'package:unknown_note_flutter/pages/read_essay/read_essay_page.dart';
import 'package:unknown_note_flutter/pages/write_diary/write_diary_page.dart';
import 'package:unknown_note_flutter/pages/write_essay/write_essay_page.dart';

class AppRoutes extends StatefulWidget {
  const AppRoutes({super.key});

  @override
  State<AppRoutes> createState() => _AppRoutesState();
}

class _AppRoutesState extends State<AppRoutes> {
  late GoRouter _routerConfig;

  @override
  void initState() {
    super.initState();
    _routerConfig = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/essay/:id',
          builder: (context, state) => ReadEssayPage(
            essay: state.extra as EssayModel,
          ),
        ),
        GoRoute(
          path: '/write/essay',
          builder: (context, state) => BlocProvider(
            create: (context) => WriteEssayBloc(),
            child: const WriteEssayPage(),
          ),
        ),
        GoRoute(
          path: '/diary/:id',
          builder: (context, state) => ReadDiaryPage(
            diary: state.extra as DiaryModel,
          ),
        ),
        GoRoute(
          path: '/write/diary',
          builder: (context, state) => BlocProvider(
            create: (context) => WriteDiaryBloc(),
            child: const WriteDiaryPage(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _routerConfig,
      title: 'Unknown Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
