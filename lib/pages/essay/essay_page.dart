import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unknown_note_flutter/bloc/essay/essay_list_bloc.dart';
import 'package:unknown_note_flutter/bloc/essay/essay_list_event.dart';
import 'package:unknown_note_flutter/bloc/essay/essay_list_state.dart';
import 'package:unknown_note_flutter/constants/strings.dart';
import 'package:unknown_note_flutter/enums/enum_loading_status.dart';
import 'package:unknown_note_flutter/pages/essay/widgets/essay_slide_widget.dart';
import 'package:unknown_note_flutter/widgets/app_font.dart';
import 'package:unknown_note_flutter/widgets/common_button.dart';
import 'package:unknown_note_flutter/widgets/common_draggable.dart';
import 'package:unknown_note_flutter/widgets/common_icon_button.dart';
import 'package:unknown_note_flutter/widgets/common_loading_widget.dart';
import 'package:unknown_note_flutter/constants/gaps.dart';
import 'package:unknown_note_flutter/constants/sizes.dart';
import 'package:unknown_note_flutter/enums/enum_essay_category.dart';
import 'package:unknown_note_flutter/pages/essay/widgets/essay_appbar.dart';
import 'package:unknown_note_flutter/pages/essay/widgets/essay_listitem_widget.dart';

class EssayPage extends StatefulWidget {
  const EssayPage({super.key});

  @override
  State<EssayPage> createState() => _EssayPageState();
}

class _EssayPageState extends State<EssayPage> {
  @override
  void initState() {
    super.initState();

    final bloc = context.read<EssayListBloc>();
    if (bloc.state.list.isEmpty) {
      bloc.add(EssayListChangeCategory(category: EEssayCategory.poem));
    }
  }

  void _loadMore() {
    context.read<EssayListBloc>().add(EssayListLoadMore());
  }

  void _onCategoryTap() {
    DraggableMenu.open(
      context,
      CommonDraggable(
        child: BlocBuilder<EssayListBloc, EssayListState>(
          bloc: context.read<EssayListBloc>(),
          builder: (context, state) {
            return EssaySlideWidget(
              onSelected: _onCategoryChanged,
              selected: state.category,
            );
          },
        ),
      ),
    );
  }

  void _onCategoryChanged(EEssayCategory category) {
    var bloc = context.read<EssayListBloc>();

    if (bloc.state.category != category &&
        bloc.state.status != ELoadingStatus.loading) {
      bloc.add(EssayListChangeCategory(
        category: category,
      ));
    }
  }

  void _onTapAdd() {
    context.push('/write/essay');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        BlocBuilder<EssayListBloc, EssayListState>(
          builder: (context, state) => ListView.separated(
            padding: EdgeInsets.only(
              bottom: Sizes.size96 + MediaQuery.of(context).padding.bottom,
              top: Sizes.size72,
              left: Sizes.size20,
              right: Sizes.size20,
            ),
            itemBuilder: (context, index) {
              if (index < state.list.length) {
                return EssayListItemWidget(
                  essay: state.list[index],
                );
              } else {
                if (state.status == ELoadingStatus.error) {
                  return Column(
                    children: [
                      AppFont(state.message ?? Strings.unknownFail),
                      Gaps.v10,
                      CommonButton(
                        onTap: () {
                          context.read<EssayListBloc>().add(EssayListRetry());
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
        const EssayAppBar(),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                left: Sizes.size28,
                right: Sizes.size28,
                bottom: Sizes.size80,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonIconButton(
                    icon: Icons.add_rounded,
                    onTap: _onTapAdd,
                  ),
                  CommonIconButton(
                    icon: Icons.category_rounded,
                    onTap: _onCategoryTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
