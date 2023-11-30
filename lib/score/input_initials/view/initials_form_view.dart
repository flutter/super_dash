import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/score/input_initials/formatters/formatters.dart';
import 'package:super_dash/score/score.dart';

class InitialsFormView extends StatefulWidget {
  const InitialsFormView({super.key});

  @override
  State<InitialsFormView> createState() => _InitialsFormViewState();
}

class _InitialsFormViewState extends State<InitialsFormView> {
  final focusNodes = List.generate(3, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ScoreBloc, ScoreState>(
      listener: (context, state) {
        if (state.initialsStatus == InitialsFormStatus.blacklisted) {
          focusNodes.last.requestFocus();
        }
      },
      builder: (context, state) {
        if (state.initialsStatus == InitialsFormStatus.failure) {
          return const _ErrorBody();
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InitialFormField(
                  0,
                  focusNode: focusNodes[0],
                  key: ObjectKey(focusNodes[0]),
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
                const SizedBox(width: 16),
                _InitialFormField(
                  1,
                  key: ObjectKey(focusNodes[1]),
                  focusNode: focusNodes[1],
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
                const SizedBox(width: 16),
                _InitialFormField(
                  2,
                  key: ObjectKey(focusNodes[2]),
                  focusNode: focusNodes[2],
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.initialsStatus == InitialsFormStatus.loading)
              const CircularProgressIndicator(color: Colors.white)
            else
              GameElevatedButton(
                label: l10n.enter,
                onPressed: () {
                  context.read<ScoreBloc>().add(const ScoreInitialsSubmitted());
                },
              ),
            const SizedBox(height: 16),
            if (state.initialsStatus == InitialsFormStatus.blacklisted)
              _ErrorTextWidget(l10n.initialsBlacklistedMessage)
            else if (state.initialsStatus == InitialsFormStatus.invalid)
              _ErrorTextWidget(l10n.initialsErrorMessage),
          ],
        );
      },
    );
  }

  void _onInitialChanged(
    BuildContext context,
    String value,
    int index, {
    bool isBackspace = false,
  }) {
    var text = value;
    if (text == emptyCharacter) {
      text = '';
    }

    context
        .read<ScoreBloc>()
        .add(ScoreInitialsUpdated(character: text, index: index));
    if (text.isNotEmpty) {
      if (index < focusNodes.length - 1) {
        focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else if (index > 0) {
      if (isBackspace) {
        setState(() {
          focusNodes[index - 1] = FocusNode();
        });

        SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        });
      }
    }
  }
}

class _InitialFormField extends StatefulWidget {
  const _InitialFormField(
    this.index, {
    required this.onChanged,
    required this.focusNode,
    required this.onBackspace,
    super.key,
  });

  final int index;
  final void Function(int, String) onChanged;
  final void Function(int) onBackspace;
  final FocusNode focusNode;

  @override
  State<_InitialFormField> createState() => _InitialFormFieldState();
}

class _InitialFormFieldState extends State<_InitialFormField> {
  late final TextEditingController controller =
      TextEditingController.fromValue(lastValue);

  bool hasFocus = false;
  TextEditingValue lastValue = const TextEditingValue(
    text: emptyCharacter,
    selection: TextSelection.collapsed(offset: 1),
  );

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    if (mounted) {
      final hadFocus = hasFocus;
      final willFocus = widget.focusNode.hasPrimaryFocus;

      setState(() {
        hasFocus = willFocus;
      });

      if (!hadFocus && willFocus) {
        final text = controller.text;
        final selection = TextSelection.collapsed(offset: text.length);
        controller.selection = selection;
      }
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(onFocusChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = context.watch<ScoreBloc>();
    final blacklisted =
        bloc.state.initialsStatus == InitialsFormStatus.blacklisted;
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [
          Color(0x3DD0F7FB),
          Color(0x3D05B5CB),
        ],
      ),
      border: Border.all(
        color: blacklisted
            ? const Color(0xFFF3777E)
            : widget.focusNode.hasPrimaryFocus
                ? const Color(0xFF77F3B7)
                : Colors.white24,
        width: 2,
      ),
    );

    return Container(
      width: 64,
      height: 72,
      decoration: decoration,
      child: TextFormField(
        key: Key('initial_form_field_${widget.index}'),
        controller: controller,
        autofocus: widget.index == 0,
        focusNode: widget.focusNode,
        showCursor: false,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          BackspaceFormatter(
            onBackspace: () => widget.onBackspace(widget.index),
          ),
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          UpperCaseTextFormatter(),
          JustOneCharacterFormatter((value) {
            widget.onChanged(widget.index, value);
          }),
          EmptyCharacterAtEndFormatter(),
        ],
        style: textTheme.displayMedium,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        onChanged: (value) {
          widget.onChanged(widget.index, value);
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: 40),
        _ErrorTextWidget(l10n.scoreSubmissionErrorMessage),
        const SizedBox(height: 32),
        GameElevatedButton.icon(
          label: l10n.playAgain,
          icon: const Icon(Icons.refresh, size: 16),
          onPressed: () {
            context.flow<ScoreState>().complete();
          },
        ),
      ],
    );
  }
}

class _ErrorTextWidget extends StatelessWidget {
  const _ErrorTextWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          FontAwesomeIcons.circleExclamation,
          color: Color(0xFFF48B8B),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
