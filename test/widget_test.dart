import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Future<void> save(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Menu works on a small screen and card navigation supports Back',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectFormPage), findsOneWidget);
      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(ProjectFormPage));
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(find.byType(MyHomePage), findsOneWidget);
    },
  );

  testWidgets('Drawer navigates from Home to form and back', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Form validates, displays input, and resets all saved values', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Portfolio');
    await tester.enterText(fields.at(1), 'A mobile portfolio');
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(2), 'Flutter');
    await tester.enterText(fields.at(3), 'https://example.com');
    await save(tester);
    expect(find.text('Nama Proyek: Portfolio'), findsOneWidget);
    expect(find.text('Deskripsi: A mobile portfolio'), findsOneWidget);
    expect(find.text('Kategori: Other'), findsOneWidget);
    expect(find.text('Teknologi: Flutter'), findsOneWidget);
    expect(find.text('Tautan: https://example.com'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }
    await tester.enterText(fields.at(0), 'Second project');
    await tester.enterText(fields.at(1), 'Second description');
    await save(tester);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
