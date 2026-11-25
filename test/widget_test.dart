import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  late List<Map<String, dynamic>> projects;
  late MyApp app;
  setUp(() {
    projects = [];
    app = MyApp(
      apiClient: ApiClient(
        client: MockClient((request) async {
          switch (request.url.path) {
            case '/api/v1/auth/token/':
              expect(jsonDecode(request.body), {
                'username': 'student',
                'password': 'test',
              });
              return http.Response('{"token":"session"}', 200);
            case '/api/v1/auth/logout/':
              expect(request.headers['Authorization'], 'Token session');
              return http.Response('', 204);
            case '/api/v1/projects/':
              if (request.method == 'GET') {
                return http.Response(jsonEncode(projects), 200);
              }
              expect(request.headers['Authorization'], 'Token session');
              final data = jsonDecode(request.body) as Map<String, dynamic>;
              expect(data.containsKey('id'), false);
              projects.add({...data, 'id': 'project-id'});
              return http.Response(jsonEncode(projects.last), 201);
            default:
              throw StateError(request.url.path);
          }
        }),
      ),
    );
  });
  testWidgets('Drawer requests login and cancellation returns home', (
    tester,
  ) async {
    await tester.pumpWidget(app);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Password'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(find.text('Tambah Proyek'), findsOneWidget);
  });
  testWidgets('Login, create project, logout and open public detail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app);
    Future<void> tap(Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tap(find.text('Tambah Proyek'));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'student');
    await tester.enterText(fields.at(1), 'test');
    await tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tap(find.text('Save'));
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    for (final (index, value) in [
      'Portfolio',
      'Mobile app',
      'Flutter',
      'https://example.com',
    ].indexed) {
      await tester.enterText(fields.at(index), value);
    }
    await tap(find.text('Save'));
    expect(find.text('Proyek tersimpan'), findsOneWidget);
    await tap(find.text('OK'));
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).first)
          .controller
          .text,
      isEmpty,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tap(find.text('Logout'));
    await tap(find.text('Lihat Proyek'));
    await tap(find.text('Portfolio'));
    expect(find.text('https://example.com'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
