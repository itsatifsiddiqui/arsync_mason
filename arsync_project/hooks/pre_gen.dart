import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

/// # Arsync Project Generator Instructions
///
/// ## Prerequisites
///
/// Before running this generator, please ensure:
///
/// 1. You have **already created** the project folder manually using:
///    ```
///    mkdir projectname
///    ```
///    or by using Finder/File Explorer.
///
/// 2. You are running the mason command **inside** this newly created folder.
///    This generator will NOT create a project folder for you.
///
/// 3. Flutter is installed and available in your PATH.
///
/// ## Usage
///
/// Navigate to your manually created project folder and run:
/// ```
/// mason make cracklog_project
/// ```
///
/// The generator will then guide you through the setup process.

final _logger = Logger(level: Level.verbose);

void run(HookContext context) async {
  final vars = <String, dynamic>{};
  final defaultProjectDirectory = _getDefaultProjectDirectory();

  // Display formatted instructions
  _logger.info('');
  _logger
      .info('╔════════════════════════════════════════════════════════════╗');
  _logger.info('║             Arsync PROJECT GENERATOR                     ║');
  _logger
      .info('╚════════════════════════════════════════════════════════════╝');
  _logger.info('');
  _logger.info('IMPORTANT INSTRUCTIONS:');
  _logger.info('');
  _logger.info(
      '1. This generator should be run INSIDE a manually created project folder');
  _logger.info('   It will NOT create a project folder for you');
  _logger.info('');
  _logger.info('2. If you haven\'t created a project folder yet, please:');
  _logger.info('   - Exit this generator');
  _logger.info('   - Create a folder using: mkdir projectname');
  _logger.info('   - Navigate into that folder: cd projectname');
  _logger.info('   - Run this generator again');
  _logger.info('');
  _logger.info('3. Flutter must be installed and available in your PATH');
  _logger.info('');

  // Option to continue or abort
  final shouldContinue = _logger.confirm(
    'Do you want to continue with the project generation?',
    defaultValue: true,
  );

  if (!shouldContinue) {
    _logger.info('Project generation aborted. Please run again when ready.');
    throw Exception('Project generation aborted');
  }

  _logger.info('Welcome to Arsync Project Generator!');
  _logger.info('Let\'s set up your new Flutter project.');

  final projectDirectory = _logger.prompt(
    'Enter the directory for your project:',
    defaultValue: defaultProjectDirectory,
  );

  final projectname = Directory.current.path.split('/').last;
  // final projectname = _getProjectName();
  vars['projectname'] = projectname;

  final org = _getOrgName();
  vars['org'] = org;
  final currentProjectDirectory = await _createFlutterProject(
    projectDirectory,
    projectname,
    org,
  );
  vars['projectDirectory'] = currentProjectDirectory;

  await _deleteDefaultProjectContent(currentProjectDirectory);

  final hasCustomFont = _logger.confirm(
    'Does this project include custom fonts?',
    defaultValue: false,
  );
  vars['hasCustomFont'] = hasCustomFont;
  String fontname = '';
  if (hasCustomFont) {
    fontname = _logger.prompt('Enter font name:', defaultValue: '');
  }
  vars['fontname'] = fontname;

  final primaryColorHexCode = _logger.prompt(
    'Enter Primary Color Hex Code without # (3d81f1):',
    defaultValue: '3d81f1',
  );
  vars['primaryColorHexCode'] = primaryColorHexCode;

  final hasDarkMode = _logger.confirm(
    'Does this project has dark mode?',
    defaultValue: false,
  );
  vars['hasDarkMode'] = hasDarkMode;
  String primaryColorHexCodeDark = '';
  if (hasDarkMode) {
    primaryColorHexCodeDark = _logger.prompt(
      'Enter Dark Mode Primary Color Hex Code without # (3d81f1):',
      defaultValue: '3d81f1',
    );
  }
  vars['primaryColorHexCodeDark'] = primaryColorHexCodeDark;

  final borderRadius = _logger.prompt(
    'Enter Border Radius for project',
    defaultValue: '8.0',
  );
  vars['borderRadius'] = num.tryParse(borderRadius)?.toDouble() ?? 8.0;

  _logger.alert('Generating Your Project Now :)');

  _logger.info(_prettyJson(vars));

  context.vars = vars;
}

Future<void> _deleteDefaultProjectContent(
    String currentProjectDirectory) async {
  _logger.warn(currentProjectDirectory, tag: 'Current Project Directory');

  final deleteProjectFilesProgress =
      _logger.progress('Deleting Current Project Contents');

  final deleteContentResult = await Process.run(
    'rm',
    [
      '-rf',
      'android/app/build.gradle',
      'android/app/build.gradle.kts',
      'android/app/src/main/AndroidManifest.xml',
      'ios/Runner/Info.plist',
      'lib/main.dart',
      'test',
      'web',
      'pubspec.yaml',
      'pubspec.lock',
      'analysis_options.yaml',
    ],
    workingDirectory: currentProjectDirectory,
  );

  if (deleteContentResult.stderr.toString().isNotEmpty) {
    deleteProjectFilesProgress.fail(deleteContentResult.stderr);
    throw Exception('Error Deleteing Project Content');
  }

  deleteProjectFilesProgress.complete('Project Content Deleted Successfully');
}

String _getDefaultProjectDirectory() {
  final workingDirectory = '${Directory.current.path}';
  final splittedDirectory = workingDirectory.split('/');
  splittedDirectory.removeLast();
  final defaultProjectDirectory = '${splittedDirectory.join('/')}/';
  return defaultProjectDirectory;
}

// String _getProjectName() {
//   final projectName = _logger.prompt(
//     'Enter the name for your project:',
//     defaultValue: 'mason_test_project',
//   );
//   if (projectName.isEmpty) {
//     _logger.err('Project name cannot be empty');
//     throw Exception('Project name cannot be empty');
//   }

//   _logger.warn(projectName, tag: 'Project Name');
//   return projectName;
// }

String _getOrgName() {
  final orgname = _logger.prompt(
    'Enter the organization name:',
    defaultValue: 'arsync',
  );
  if (orgname.isEmpty) {
    _logger.err('Organization name cannot be empty');
    throw Exception('Organization name cannot be empty');
  }

  _logger.warn(orgname, tag: 'Organiation Name');
  return orgname;
}

Future<String> _createFlutterProject(
  String projectDirectory,
  String projectname,
  String org,
) async {
  final createProjectProgress = _logger.progress('Creating Flutter Project');

  final result = await Process.run(
    'flutter',
    [
      'create',
      '--platforms',
      'ios,android',
      '--org',
      'com.${org}',
      projectname,
    ],
    workingDirectory: projectDirectory,
  );
  if (result.stderr.toString().isNotEmpty) {
    createProjectProgress.fail(result.stderr.toString());
    throw Exception('Error Creating Flutter Project');
  }
  createProjectProgress.complete('Project Created');

  final currentProjectDirectory =
      '$projectDirectory$projectname'.split(' ').join('\ ');
  return currentProjectDirectory;
}

String _prettyJson(Map value) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(value);
}
