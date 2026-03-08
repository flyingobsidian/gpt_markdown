import 'package:flutter_test/flutter_test.dart';
import '../utils/test_helpers.dart';

void main() {
  group('Inline Checkboxes and Radio Buttons', () {
    group('Inline checkbox', () {
      testWidgets('unchecked checkbox renders', (WidgetTester tester) async {
        await pumpMarkdown(tester, '[ ]');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=false'));
      });

      testWidgets('checked checkbox renders', (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x]');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
      });

      testWidgets('uppercase X checkbox renders as checked',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '[X]');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
      });

      testWidgets('checkbox in text renders inline',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, 'Task: [x] complete this');
        final output = getSerializedOutput(tester);
        expect(output, contains('Task: '));
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
        expect(output, contains('complete this'));
      });

      testWidgets('multiple checkboxes in text',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x] First [ ] Second [x] Third');
        final output = getSerializedOutput(tester);
        expect('CHECKBOX'.allMatches(output).length, equals(3));
      });

      testWidgets('checkbox with bold text', (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x] **Important task**');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
        expect(output, contains('[bold]'));
      });

      testWidgets('checkbox with italic text', (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x] *Optional task*');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
        expect(output, contains('[italic]'));
      });

      testWidgets('checkbox with inline code', (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x] Run `flutter test`');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
        expect(output, contains('Run '));
        expect(output, contains('flutter test'));
      });

      testWidgets('checkbox in unordered list', (WidgetTester tester) async {
        await pumpMarkdown(tester, '- [x] Item one\n- [ ] Item two');
        final output = getSerializedOutput(tester);
        expect('CHECKBOX'.allMatches(output).length, equals(2));
      });

      testWidgets('checkbox in ordered list', (WidgetTester tester) async {
        await pumpMarkdown(tester, '1. [x] Step one\n2. [ ] Step two');
        final output = getSerializedOutput(tester);
        expect('CHECKBOX'.allMatches(output).length, equals(2));
      });

      testWidgets('checkbox does not match incomplete syntax',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x incomplete]');
        final output = getSerializedOutput(tester);
        expect(output, contains('[x incomplete]')); // Not parsed as checkbox
      });

      testWidgets('checkbox with single space unchecked',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '[ ]'); // Single space = unchecked
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=false'));
      });

      testWidgets('checkbox in bold context', (WidgetTester tester) async {
        await pumpMarkdown(tester, '**[x] Bold checkbox**');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('checked=true'));
        expect(output, contains('[bold]'));
      });

      testWidgets('consecutive checkboxes', (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x][x][ ]');
        final output = getSerializedOutput(tester);
        expect('CHECKBOX'.allMatches(output).length, equals(3));
      });
    });

    group('Inline radio button', () {
      testWidgets('unchecked radio button renders',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '( )');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=false'));
      });

      testWidgets('checked radio button renders', (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x)');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
      });

      testWidgets('uppercase X radio button renders as checked',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '(X)');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
      });

      testWidgets('radio button in text renders inline',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, 'Option: (x) Yes or ( ) No');
        final output = getSerializedOutput(tester);
        expect(output, contains('Option: '));
        expect(output, contains('RADIO'));
        expect(output, contains('Yes'));
        expect(output, contains('No'));
      });

      testWidgets('multiple radio buttons in text',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x) Option A ( ) Option B ( ) Option C');
        final output = getSerializedOutput(tester);
        expect('RADIO'.allMatches(output).length, equals(3));
      });

      testWidgets('radio button with bold text', (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x) **Recommended option**');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
        expect(output, contains('[bold]'));
      });

      testWidgets('radio button with italic text', (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x) *Optional selection*');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
        expect(output, contains('[italic]'));
      });

      testWidgets('radio button with inline code', (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x) Use `--flag` option');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
        expect(output, contains('Use '));
        expect(output, contains('--flag'));
      });

      testWidgets('radio button in unordered list',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '- (x) Choice one\n- ( ) Choice two');
        final output = getSerializedOutput(tester);
        expect('RADIO'.allMatches(output).length, equals(2));
      });

      testWidgets('radio button in ordered list', (WidgetTester tester) async {
        await pumpMarkdown(tester, '1. (x) First\n2. ( ) Second');
        final output = getSerializedOutput(tester);
        expect('RADIO'.allMatches(output).length, equals(2));
      });

      testWidgets('radio button does not match incomplete syntax',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x incomplete)');
        final output = getSerializedOutput(tester);
        expect(output, contains('(x incomplete)')); // Not parsed as radio
      });

      testWidgets('radio button with single space unchecked',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '( )'); // Single space = unchecked
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=false'));
      });

      testWidgets('radio button in bold context', (WidgetTester tester) async {
        await pumpMarkdown(tester, '**(x) Bold radio**');
        final output = getSerializedOutput(tester);
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
        expect(output, contains('[bold]'));
      });

      testWidgets('consecutive radio buttons', (WidgetTester tester) async {
        await pumpMarkdown(tester, '(x)( )( )');
        final output = getSerializedOutput(tester);
        expect('RADIO'.allMatches(output).length, equals(3));
      });
    });

    group('Mixed checkboxes and radio buttons', () {
      testWidgets('checkboxes and radio buttons together',
          (WidgetTester tester) async {
        await pumpMarkdown(tester, '[x] Check this (x) Select this');
        final output = getSerializedOutput(tester);
        expect(output, contains('CHECKBOX'));
        expect(output, contains('RADIO'));
        expect(output, contains('checked=true'));
      });

      testWidgets('checkbox and radio in alternating list',
          (WidgetTester tester) async {
        await pumpMarkdown(tester,
            '- [x] Task\n- (x) Choice\n- [ ] Pending\n- ( ) Option');
        final output = getSerializedOutput(tester);
        expect(output.split('CHECKBOX').length - 1, 2);
        expect(output.split('RADIO').length - 1, 2);
      });
    });

  });
}
