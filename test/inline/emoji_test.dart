import 'package:flutter_test/flutter_test.dart';
import '../utils/test_helpers.dart';

void main() {
  group('Emoji', () {
    testWidgets('simple emoji renders correctly', (tester) async {
      await pumpMarkdown(tester, ':smile:');
      final output = getSerializedOutput(tester);
      expect(output, contains('😊'));
    });

    testWidgets('multiple emoji in text', (tester) async {
      await pumpMarkdown(tester, ':fire: :heart: :thumbsup:');
      final output = getSerializedOutput(tester);
      expect(output, contains('🔥'));
      expect(output, contains('❤️'));
      expect(output, contains('👍'));
    });

    testWidgets('emoji with surrounding text', (tester) async {
      await pumpMarkdown(tester, 'This is great :star: awesome');
      final output = getSerializedOutput(tester);
      expect(output, contains('This is great'));
      expect(output, contains('⭐'));
      expect(output, contains('awesome'));
    });

    testWidgets('unknown emoji renders as original text', (tester) async {
      await pumpMarkdown(tester, ':unknown_emoji:');
      final output = getSerializedOutput(tester);
      expect(output, contains(':unknown_emoji:'));
    });

    testWidgets('emoji in bold text', (tester) async {
      await pumpMarkdown(tester, '**:fire: hot**');
      final output = getSerializedOutput(tester);
      expect(output, contains('🔥'));
      expect(output, contains('[bold]'));
    });

    testWidgets('emoji in italic text', (tester) async {
      await pumpMarkdown(tester, '*:heart: love*');
      final output = getSerializedOutput(tester);
      expect(output, contains('❤️'));
      expect(output, contains('[italic]'));
    });

    testWidgets('emoji in strikethrough text', (tester) async {
      await pumpMarkdown(tester, '~~:poop: bad~~');
      final output = getSerializedOutput(tester);
      expect(output, contains('💩'));
      expect(output, contains('[strike]'));
    });

    testWidgets('emoji in underlined text', (tester) async {
      await pumpMarkdown(tester, '<u>:rainbow: colorful</u>');
      final output = getSerializedOutput(tester);
      expect(output, contains('🌈'));
      expect(output, contains('[underline]'));
    });

    testWidgets('emoji with inline code should not render', (tester) async {
      await pumpMarkdown(tester, '`code :smile: here`');
      final output = getSerializedOutput(tester);
      // Inside backticks, emoji should NOT be rendered (code escaping)
      expect(output, contains(':smile:'));
      expect(output, contains('highlight'));
    });

    testWidgets('emoji in list item', (tester) async {
      await pumpMarkdown(tester, '- Task :checkered_flag: done');
      final output = getSerializedOutput(tester);
      expect(output, contains('🏁'));
      expect(output, contains('UL_ITEM'));
    });

    testWidgets('emoji names are case sensitive', (tester) async {
      await pumpMarkdown(tester, ':Smile:');
      final output = getSerializedOutput(tester);
      // :Smile: should not match :smile: (case sensitive)
      expect(output, contains(':Smile:'));
    });

    testWidgets('emoji with underscores in name', (tester) async {
      await pumpMarkdown(tester, ':heart_eyes: :stuck_out_tongue:');
      final output = getSerializedOutput(tester);
      expect(output, contains('😍'));
      expect(output, contains('😛'));
    });

    testWidgets('emoji with plus sign', (tester) async {
      await pumpMarkdown(tester, ':+1:');
      final output = getSerializedOutput(tester);
      expect(output, contains('👍'));
    });

    testWidgets('emoji with minus/hyphen', (tester) async {
      await pumpMarkdown(tester, ':-1:');
      final output = getSerializedOutput(tester);
      expect(output, contains('👎'));
    });

    testWidgets('partial emoji syntax does not match', (tester) async {
      await pumpMarkdown(tester, ': smile : or :smile or smile:');
      final output = getSerializedOutput(tester);
      // These should not be recognized as emoji
      expect(output, contains(': smile :'));
      expect(output, contains(':smile'));
      expect(output, contains('smile:'));
    });

    testWidgets('consecutive emoji', (tester) async {
      await pumpMarkdown(tester, ':fire::fire::fire:');
      final output = getSerializedOutput(tester);
      expect('🔥'.allMatches(output).length, equals(3));
    });

    testWidgets('emoji with special characters around', (tester) async {
      await pumpMarkdown(tester, '(:smile:)!');
      final output = getSerializedOutput(tester);
      expect(output, contains('😊'));
      expect(output, contains('('));
      expect(output, contains(')'));
      expect(output, contains('!'));
    });

    testWidgets('emoji at start and end of text', (tester) async {
      await pumpMarkdown(tester, ':wave: hello world :heart:');
      final output = getSerializedOutput(tester);
      expect(output, contains('👋'));
      expect(output, contains('❤️'));
    });

    testWidgets('common emoji work correctly', (tester) async {
      await pumpMarkdown(tester, ':smile: :fire: :heart: :star: :thumbsup:');
      final output = getSerializedOutput(tester);
      expect(output, contains('😊'));
      expect(output, contains('🔥'));
      expect(output, contains('❤️'));
      expect(output, contains('⭐'));
      expect(output, contains('👍'));
    });

    testWidgets('emoji in ordered list item', (tester) async {
      await pumpMarkdown(tester, '1. First :checkered_flag: prize');
      final output = getSerializedOutput(tester);
      expect(output, contains('🏁'));
    });
  });
}
