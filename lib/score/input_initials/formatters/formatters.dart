import 'package:flutter/services.dart';

const emptyCharacter = '\u200b';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class EmptyCharacterAtEndFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    var text = newText;
    var selection = newValue.selection;
    if (newText.isEmpty) {
      text = emptyCharacter;
      selection = const TextSelection.collapsed(offset: 1);
    }
    return TextEditingValue(
      text: text,
      selection: selection,
    );
  }
}

class BackspaceFormatter extends TextInputFormatter {
  BackspaceFormatter({
    required this.onBackspace,
  });

  final VoidCallback onBackspace;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    // Heuristic for detecting backspace press on an empty field on mobile.
    if (oldText == emptyCharacter && newText.isEmpty) {
      onBackspace();
    }
    return newValue;
  }
}

class JustOneCharacterFormatter extends TextInputFormatter {
  JustOneCharacterFormatter(this.onSameValue);

  /// If after truncation the text is the same as the previous one,
  /// this callback will force an "onChange" behavior.
  final ValueChanged<String> onSameValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    var text = newText;
    var selection = newValue.selection;
    if (newText.length > 1) {
      text = newText.substring(newText.length - 1);
      selection = const TextSelection.collapsed(offset: 1);
      if (text == oldValue.text) {
        onSameValue(text);
      }
    }
    return TextEditingValue(
      text: text,
      selection: selection,
    );
  }
}
