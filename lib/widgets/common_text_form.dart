import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unknown_note_flutter/bloc/setting/setting_bloc.dart';
import 'package:unknown_note_flutter/bloc/setting/setting_state.dart';
import 'package:unknown_note_flutter/constants/sizes.dart';
import 'package:unknown_note_flutter/enums/enum_font.dart';

class CommonTextForm extends StatefulWidget {
  final String? initText;
  final Function(String value)? getValue;
  final bool singleLine;
  final bool expanded;
  final bool dynamicSize;
  final String? hintText;

  const CommonTextForm({
    super.key,
    this.initText,
    this.getValue,
    this.singleLine = true,
    this.expanded = false,
    this.dynamicSize = false,
    this.hintText,
  });

  @override
  State<CommonTextForm> createState() => _CommonTextFormState();
}

class _CommonTextFormState extends State<CommonTextForm> {
  late TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initText);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CommonTextForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initText == null || oldWidget.initText != widget.initText) {
      _controller.dispose();
      _controller = TextEditingController(text: widget.initText);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) => TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: false,
        onTapOutside: (_) => _unfocus(),
        onChanged: widget.getValue,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: Sizes.size5,
          ),
          hintText: widget.hintText,
        ),
        cursorRadius: const Radius.circular(Sizes.size5),
        keyboardType: widget.singleLine ? null : TextInputType.multiline,
        maxLines: widget.singleLine ? 1 : null,
        style: TextStyle(
          fontFamily: state.font?.fontFamily ?? EFont.pretendard.fontFamily,
          fontSize: widget.dynamicSize ? state.getZoom() : Sizes.size14,
        ),
        expands: widget.expanded,
      ),
    );
  }
}
