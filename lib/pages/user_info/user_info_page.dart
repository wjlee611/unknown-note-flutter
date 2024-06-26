import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:unknown_note_flutter/bloc/authentication/auth_bloc_singleton.dart';
import 'package:unknown_note_flutter/bloc/authentication/auth_state.dart';
import 'package:unknown_note_flutter/bloc/user_info/user_essay_bloc.dart';
import 'package:unknown_note_flutter/bloc/user_info/user_essay_event.dart';
import 'package:unknown_note_flutter/bloc/user_info/user_essay_state.dart';
import 'package:unknown_note_flutter/bloc/user_info/user_info_bloc.dart';
import 'package:unknown_note_flutter/bloc/user_info/user_info_event.dart';
import 'package:unknown_note_flutter/bloc/user_info/user_info_state.dart';
import 'package:unknown_note_flutter/constants/gaps.dart';
import 'package:unknown_note_flutter/constants/sizes.dart';
import 'package:unknown_note_flutter/constants/strings.dart';
import 'package:unknown_note_flutter/enums/enum_emotion.dart';
import 'package:unknown_note_flutter/enums/enum_loading_status.dart';
import 'package:unknown_note_flutter/models/user/user_model.dart';
import 'package:unknown_note_flutter/models/user/user_profile_model.dart';
import 'package:unknown_note_flutter/pages/essay/widgets/essay_listitem_widget.dart';
import 'package:unknown_note_flutter/pages/user_info/widgets/user_info_flower.dart';
import 'package:unknown_note_flutter/pages/user_info/widgets/user_info_graph.dart';
import 'package:unknown_note_flutter/pages/user_info/widgets/user_info_heatmap.dart';
import 'package:unknown_note_flutter/pages/user_info/widgets/user_info_profile_widget.dart';
import 'package:unknown_note_flutter/pages/user_info/widgets/user_info_statics.dart';
import 'package:unknown_note_flutter/pages/user_info/widgets/user_info_sub_button.dart';
import 'package:unknown_note_flutter/widgets/app_font.dart';
import 'package:unknown_note_flutter/widgets/common_blur_container.dart';
import 'package:unknown_note_flutter/widgets/common_button.dart';
import 'package:unknown_note_flutter/widgets/common_loading_widget.dart';
import 'package:unknown_note_flutter/widgets/common_snackbar.dart';

class UserInfoPage extends StatefulWidget {
  final bool popAble;
  final int userId;
  final String? nickName;

  const UserInfoPage({
    super.key,
    this.popAble = false,
    required this.userId,
    this.nickName,
  });

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  static const double _expandedHeight = 250;
  static const double _appbarHeight = Sizes.size52;
  late final ScrollController _scrollController;
  late final TabController _tabController;
  late final PageController _pageController;
  final ValueNotifier<double> _titleBottomPadding = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(
      length: widget.popAble ? 2 : 4,
      vsync: this,
    );
    _tabController.addListener(_tabListener);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    const ratio = 0.3;
    if (_expandedHeight - _appbarHeight * ratio > _scrollController.offset) {
      _titleBottomPadding.value = 0;
    }
    if (_expandedHeight - _appbarHeight * ratio <= _scrollController.offset &&
        _expandedHeight + _appbarHeight * (1 - ratio) >=
            _scrollController.offset) {
      _titleBottomPadding.value =
          _scrollController.offset - _expandedHeight + _appbarHeight * ratio;
    }
    if (_expandedHeight + _appbarHeight * (1 - ratio) <
        _scrollController.offset) {
      _titleBottomPadding.value = _appbarHeight;
    }
  }

  void _tabListener() {
    _pageController.animateToPage(
      _tabController.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onSettingTap() async {
    var res = await context.push<bool?>(
      '/edit/profile',
      extra: true, // popAble
    );

    if (res == true && mounted) {
      context.read<UserInfoBloc>().add(UserInfoUpdateUser(
          (AuthBlocSingleton.bloc.state as AuthAuthState).user));
    }
  }

  void _loadMore() {
    context.read<UserEssayBloc>().add(UserEssayLoadMore());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        if (state.subStatus == ELoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            CommonSnackbar(
              context,
              content: AppFont(state.message ?? Strings.unknownFail),
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: ValueListenableBuilder(
            valueListenable: _titleBottomPadding,
            builder: (context, value, child) => AnimatedContainer(
              duration: const Duration(milliseconds: 1),
              margin: EdgeInsets.only(
                bottom: value * 2,
                top: _appbarHeight,
              ),
              child: child,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: _appbarHeight,
                  child: Center(
                    child: AppFont(
                      widget.popAble ? '작성자 정보' : '내 정보',
                      color: Colors.white,
                      size: Sizes.size16,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: _appbarHeight,
                  child: Center(
                    child: AppFont(
                      widget.nickName ??
                          state.userProfile?.user?.nickName ??
                          Strings.nullStr,
                      color: Colors.white,
                      size: Sizes.size16,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          leading: widget.popAble ? null : const SizedBox(),
          actions: [
            Container(
              width: Sizes.size56,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size5,
              ),
              child: !widget.popAble
                  ? IconButton(
                      onPressed: _onSettingTap,
                      icon: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                      ),
                    )
                  : UserInfoSubButton(
                      userId: widget.userId,
                    ),
            ),
          ],
        ),
        body: Stack(
          children: [
            _buildBody(state),
            if (state.infoStatus == ELoadingStatus.error)
              _buildError(state.message),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(UserInfoState state) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: _expandedHeight,
            child: UserInfoProfileWidget(
              nickName: widget.nickName,
              user: state.userProfile?.user ?? UserModel(),
              diaryCount: state.userProfile?.diaryCount ?? 0,
              essayCount: state.userProfile?.essayCount ?? 0,
              flower: state.userProfile?.flower,
              status: state.infoStatus,
            ),
          ),
        ),
        SliverStickyHeader(
          header: CommonBlurContainer(
            child: TabBar(
              controller: _tabController,
              dividerColor: Theme.of(context).primaryColor,
              indicatorColor: Colors.white,
              tabs: [
                if (!widget.popAble)
                  const Tab(
                    child: AppFont(
                      '감정 분석',
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                const Tab(
                  child: AppFont(
                    '활동 기록',
                    color: Colors.white,
                    weight: FontWeight.w700,
                  ),
                ),
                if (!widget.popAble)
                  const Tab(
                    child: AppFont(
                      '기분 통계',
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                const Tab(
                  child: AppFont(
                    '이달의 꽃',
                    color: Colors.white,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          sliver: SliverToBoxAdapter(
            child: ExpandablePageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              animationCurve: Curves.easeOut,
              children: [
                if (!widget.popAble)
                  UserInfoGraph(
                    graphData: state.userProfile?.recentGraph ?? [],
                    status: state.status,
                  ),
                UserInfoHeatmap(
                  monthlyData: state.userProfile?.monthlyAct ?? [],
                ),
                if (!widget.popAble)
                  UserInfoStatics(
                    emotionsData: state.userProfile?.monthlyEmotions ??
                        UserMonthlyEmotionModel(),
                  ),
                UserInfoFlower(
                  flower: state.userProfile?.flower ?? EEmotion.happy,
                  status: state.status,
                ),
              ],
            ),
          ),
        ),
        SliverStickyHeader(
          header: CommonBlurContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppFont(
                    '작성한 수필',
                    color: Colors.white,
                    weight: FontWeight.w700,
                    size: Sizes.size16,
                  ),
                  AppFont(
                    'Total ${state.userProfile?.essayCount ?? 0}',
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          sliver: SliverPadding(
            padding: const EdgeInsets.only(top: Sizes.size20),
            sliver: BlocBuilder<UserEssayBloc, UserEssayState>(
              builder: (context, state) => SliverList.separated(
                itemBuilder: (context, index) {
                  if (index < state.list.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size20,
                      ),
                      child: EssayListItemWidget(
                        essay: state.list[index],
                      ),
                    );
                  } else {
                    if (state.status == ELoadingStatus.error) {
                      return Column(
                        children: [
                          AppFont(state.message ?? Strings.unknownFail),
                          Gaps.v10,
                          CommonButton(
                            onTap: () {
                              context
                                  .read<UserEssayBloc>()
                                  .add(UserEssayRetry());
                            },
                            child: const AppFont('재시도'),
                          ),
                        ],
                      );
                    }
                    return CommonLoadingWidget(whenBuild: _loadMore);
                  }
                },
                separatorBuilder: (context, index) => Gaps.v20,
                itemCount: state.list.length + 1,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + Sizes.size96,
          ),
        ),
      ],
    );
  }

  Widget _buildError(String? message) {
    return CommonBlurContainer(
      height: double.infinity,
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppFont(
              message ?? Strings.unknownFail,
              color: Colors.white,
            ),
            Gaps.v20,
            CommonButton(
              onTap: () {
                context.read<UserInfoBloc>().add(UserInfoGet(widget.userId));
              },
              child: const AppFont('재시도'),
            ),
          ],
        ),
      ),
    );
  }
}
