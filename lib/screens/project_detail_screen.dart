import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});
  final Project project;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(project.title)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (project.projectImageUrl.isNotEmpty)
          Image.network(
            project.projectImageUrl,
            errorBuilder: (_, error, stack) =>
                const Text('Gambar gagal dimuat'),
          ),
        Text(project.description),
        Text('Tech stack: ${project.techStack}'),
        SelectableText(project.projectUrl),
      ],
    ),
  );
}
