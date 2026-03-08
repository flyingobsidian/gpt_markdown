import 'package:flutter_test/flutter_test.dart';
import '../utils/test_helpers.dart';

void main() {
  group('HTML SPAN Tags with CSS Styles', () {
    group('Basic styling', () {
      testWidgets('simple span with color', (tester) async {
        await pumpMarkdown(tester, '<span style="color:red">red text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('red text'));
      });

      testWidgets('span with background-color', (tester) async {
        await pumpMarkdown(tester, '<span style="background-color:yellow">highlighted</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('highlighted'));
      });

      testWidgets('span with font-weight: bold', (tester) async {
        await pumpMarkdown(tester, '<span style="font-weight:bold">bold text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('bold text'));
        expect(output, contains('[bold]'));
      });

      testWidgets('span with font-style: italic', (tester) async {
        await pumpMarkdown(tester, '<span style="font-style:italic">italic text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('italic text'));
        expect(output, contains('[italic]'));
      });
    });

    group('Multiple properties', () {
      testWidgets('color + font-weight combined', (tester) async {
        await pumpMarkdown(tester, '<span style="color:blue;font-weight:bold">blue bold</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('blue bold'));
        expect(output, contains('[bold]'));
      });

      testWidgets('color + background-color combined', (tester) async {
        await pumpMarkdown(tester, '<span style="color:white;background-color:black">contrast</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('contrast'));
      });

      testWidgets('all properties together', (tester) async {
        await pumpMarkdown(tester, '<span style="color:red;background-color:yellow;font-weight:bold;font-style:italic">all styles</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('all styles'));
      });
    });

    group('Text decoration', () {
      testWidgets('text-decoration: underline', (tester) async {
        await pumpMarkdown(tester, '<span style="text-decoration:underline">underlined</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('underlined'));
        expect(output, contains('[underline]'));
      });

      testWidgets('text-decoration: line-through', (tester) async {
        await pumpMarkdown(tester, '<span style="text-decoration:line-through">strikethrough</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('strikethrough'));
      });

      testWidgets('text-decoration: overline', (tester) async {
        await pumpMarkdown(tester, '<span style="text-decoration:overline">overlined</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('overlined'));
      });
    });

    group('Nested formatting', () {
      testWidgets('span inside bold', (tester) async {
        await pumpMarkdown(tester, '**<span style="color:red">red in bold</span>**');
        final output = getSerializedOutput(tester);
        expect(output, contains('red in bold'));
        expect(output, contains('[bold]'));
      });

      testWidgets('bold inside span', (tester) async {
        await pumpMarkdown(tester, '<span style="color:green">**bold green**</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('bold green'));
        expect(output, contains('[bold]'));
      });

      testWidgets('italic inside span', (tester) async {
        await pumpMarkdown(tester, '<span style="color:blue">*blue italic*</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('blue italic'));
        expect(output, contains('[italic]'));
      });

      testWidgets('span with inline code', (tester) async {
        await pumpMarkdown(tester, '<span style="color:orange">`code` text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('code'));
        expect(output, contains('text'));
      });
    });

    group('Named colors', () {
      testWidgets('common named colors work', (tester) async {
        await pumpMarkdown(tester, '<span style="color:red">red</span> <span style="color:blue">blue</span> <span style="color:green">green</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('red'));
        expect(output, contains('blue'));
        expect(output, contains('green'));
      });

      testWidgets('named color background', (tester) async {
        await pumpMarkdown(tester, '<span style="background-color:yellow">yellow bg</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('yellow bg'));
      });

      testWidgets('case insensitive color names', (tester) async {
        await pumpMarkdown(tester, '<span style="color:RED">text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('text'));
      });
    });

    group('Hex colors', () {
      testWidgets('hex color #RRGGBB format', (tester) async {
        await pumpMarkdown(tester, '<span style="color:#FF0000">red hex</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('red hex'));
      });

      testWidgets('hex color #RGB format', (tester) async {
        await pumpMarkdown(tester, '<span style="color:#F00">red short</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('red short'));
      });

      testWidgets('hex with alpha #RRGGBBAA', (tester) async {
        await pumpMarkdown(tester, '<span style="color:#FF0000FF">opaque red</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('opaque red'));
      });
    });

    group('Font sizes', () {
      testWidgets('font-size in pixels', (tester) async {
        await pumpMarkdown(tester, '<span style="font-size:20px">large</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('large'));
      });

      testWidgets('font-size without unit', (tester) async {
        await pumpMarkdown(tester, '<span style="font-size:18">sized</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('sized'));
      });

      testWidgets('font-size with em unit', (tester) async {
        await pumpMarkdown(tester, '<span style="font-size:1.5em">big</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('big'));
      });
    });

    group('Font weights', () {
      testWidgets('font-weight w100 to w900', (tester) async {
        await pumpMarkdown(tester, '<span style="font-weight:w700">w700</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('w700'));
      });

      testWidgets('font-weight normal', (tester) async {
        await pumpMarkdown(tester, '<span style="font-weight:normal">normal</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('normal'));
      });
    });

    group('Edge cases', () {
      testWidgets('whitespace in style attribute', (tester) async {
        await pumpMarkdown(tester, '<span style="  color: red ; font-weight: bold  ">text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('text'));
      });

      testWidgets('invalid CSS property ignored', (tester) async {
        await pumpMarkdown(tester, '<span style="invalid-prop:value;color:blue">valid color</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('valid color'));
      });

      testWidgets('invalid color falls back to default', (tester) async {
        await pumpMarkdown(tester, '<span style="color:notacolor">fallback</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('fallback'));
      });

      testWidgets('empty style attribute', (tester) async {
        await pumpMarkdown(tester, '<span style="">no styles</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('no styles'));
      });

      testWidgets('case insensitive CSS keywords', (tester) async {
        await pumpMarkdown(tester, '<span style="FONT-WEIGHT:BOLD">BOLD</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('BOLD'));
      });

      testWidgets('span with mixed content and markup', (tester) async {
        await pumpMarkdown(tester, '<span style="color:red">Red **bold** text</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('Red'));
        expect(output, contains('bold'));
        expect(output, contains('text'));
      });
    });

    group('Integration with other markdown', () {
      testWidgets('span in list items', (tester) async {
        await pumpMarkdown(tester, '- <span style="color:red">red item</span>\n- normal item');
        final output = getSerializedOutput(tester);
        expect(output, contains('red item'));
        expect(output, contains('normal item'));
      });

      testWidgets('multiple spans in one line', (tester) async {
        await pumpMarkdown(tester, '<span style="color:red">red</span> and <span style="color:blue">blue</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('red'));
        expect(output, contains('and'));
        expect(output, contains('blue'));
      });

      testWidgets('span with strikethrough + bold', (tester) async {
        await pumpMarkdown(tester, '<span style="text-decoration:line-through;font-weight:bold">crossed bold</span>');
        final output = getSerializedOutput(tester);
        expect(output, contains('crossed bold'));
      });

      testWidgets('nested markdown tags', (tester) async {
        await pumpMarkdown(tester, 'Text <span style="color:red">with **bold** and *italic*</span> inside');
        final output = getSerializedOutput(tester);
        expect(output, contains('Text'));
        expect(output, contains('with'));
        expect(output, contains('inside'));
      });
    });
  });
}
