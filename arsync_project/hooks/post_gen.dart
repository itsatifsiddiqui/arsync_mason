import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

final logger = Logger(level: Level.verbose);
void run(HookContext context) async {
  logger.info('Running Post Gen Script');

  final projectDirectory = context.vars['projectDirectory'];

  logger.alert('Project Directory: $projectDirectory');

  await _runFlutterPackagesUpgrade(projectDirectory);
  await _runFlutterPackagesGet(projectDirectory);
  await _runDartFix(projectDirectory);
  await _runFlutterFormat(projectDirectory);

  logger.alert('Project Generated Successfully :)');

  await _generateAndDisplaySHA(projectDirectory);
}

Future<void> _runFlutterPackagesUpgrade(String projectDirectory) async {
  final createProjectProgress = logger.progress(
    'Running flutter packages upgrade --major-versions --tighten inside $projectDirectory',
  );

  final result = await Process.run(
    'flutter',
    ['packages', 'upgrade', '--major-versions', '--tighten'],
    workingDirectory: projectDirectory,
    runInShell: true,
  );

  if (result.stderr.toString().isNotEmpty) {
    createProjectProgress.fail(result.stderr.toString());
    throw Exception('Error Upgrading Packages ${result.stderr.toString()}');
  }
  createProjectProgress.complete('Flutter packages upgraded successfully');
}

Future<void> _runFlutterPackagesGet(String projectDirectory) async {
  final createProjectProgress = logger.progress('Running flutter packages get');

  final result = await Process.run(
    'flutter',
    ['packages', 'get'],
    workingDirectory: projectDirectory,
    runInShell: true,
  );
  if (result.stderr.toString().isNotEmpty) {
    createProjectProgress.fail(result.stderr.toString());
    throw Exception('Error Fetching Packages');
  }
  createProjectProgress.complete('Flutter packages get success');
}

Future<void> _runDartFix(String projectDirectory) async {
  final createProjectProgress = logger.progress('Applying fixes');

  final result = await Process.run(
    'dart',
    ['fix', '--apply'],
    workingDirectory: projectDirectory,
    runInShell: true,
  );
  if (result.stderr.toString().isNotEmpty) {
    createProjectProgress.fail(result.stderr.toString());
    throw Exception('Applying Fixes Error');
  }
  createProjectProgress.complete('Fixes Applied');
}

Future<void> _runFlutterFormat(String projectDirectory) async {
  final createProjectProgress = logger.progress('Formatting Project');

  final result = await Process.run('dart', [
    'format',
    'lib',
  ], workingDirectory: projectDirectory);
  if (result.stderr.toString().isNotEmpty) {
    createProjectProgress.fail(result.stderr.toString());
    throw Exception('Formatting Project Error');
  }
  createProjectProgress.complete('Project Formatted');
}

Future<void> _generateAndDisplaySHA(String projectDirectory) async {
  logger.alert('Generating SHA keys');

  final homeDir =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  logger.alert('Home Directory: $homeDir');
  final keyStorePath = path.join(homeDir!, '.android', 'debug.keystore');

  // Create keys directory if it doesn't exist
  final keysDir = Directory(path.join(projectDirectory, 'keys'));

  logger.info('Checking if keys directory exists $keysDir');
  if (!await keysDir.exists()) {
    await keysDir.create(recursive: true);
    logger.info('Created keys directory');
  }

  // Generate debug SHA keys
  logger.info('Generating debug SHA keys');
  final debugSha = await _generateDebugSha(keyStorePath);

  // Generate release key and SHA values
  final releaseKeyPath = path.join(
    projectDirectory,
    'keys',
    'upload-keystore.jks',
  );
  logger.info('Generating release key');
  await _generateReleaseKey(releaseKeyPath);
  final releaseSha = await _generateReleaseSha(releaseKeyPath);

  // Write SHA values to notes.txt
  await _writeToNotesFile(
    projectDirectory,
    debugSha?.sha1,
    debugSha?.sha256,
    releaseSha?.sha1,
    releaseSha?.sha256,
  );
}

/// Generates debug SHA keys
Future<ShaKeys?> _generateDebugSha(String keyStorePath) async {
  if (!await File(keyStorePath).exists()) {
    logger.err('Debug keystore not found at $keyStorePath');
    return null;
  }

  final result = await Process.run('keytool', [
    '-list',
    '-v',
    '-alias',
    'androiddebugkey',
    '-keystore',
    keyStorePath,
    '-storepass',
    'android',
  ], runInShell: true);

  if (result.exitCode != 0) {
    logger.err('Failed to generate debug SHA. Error: ${result.stderr}');
    return null;
  }

  return _extractShaFromOutput(result.stdout as String);
}

/// Generates a release keystore file
Future<bool> _generateReleaseKey(String keyStorePath) async {
  if (await File(keyStorePath).exists()) {
    logger.info('Release keystore already exists at $keyStorePath');
    return true;
  }

  logger.info('Generating release keystore at $keyStorePath');

  // Create a list of responses for the keytool prompts
  final responses = [
    'arsynckeypass\n', // Enter keystore password
    'arsynckeypass\n', // Re-enter new password
    'Atif Siddiqui\n', // First and last name
    'None\n', // Organizational unit
    'Arync Solutions\n', // Organization
    'isb\n', // City
    'isb\n', // State
    'PK\n', // Country code
    'yes\n', // Confirm information
  ];

  // Start the keytool process
  final process = await Process.start('keytool', [
    '-genkey',
    '-v',
    '-keystore',
    keyStorePath,
    '-keyalg',
    'RSA',
    '-keysize',
    '2048',
    '-validity',
    '10000',
    '-alias',
    'upload',
  ]);

  // Write responses to the process stdin
  for (final response in responses) {
    process.stdin.write(response);
    // Give time for the process to process each input
    await Future.delayed(Duration(milliseconds: 500));
  }

  // Close stdin to signal we're done with input
  await process.stdin.close();

  // Wait for the process to complete
  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    logger.err('Failed to generate release keystore. Exit code: $exitCode');
    return false;
  }

  logger.info('Release keystore generated successfully');
  return true;
}

/// Generates release SHA keys
Future<ShaKeys?> _generateReleaseSha(String keyStorePath) async {
  if (!await File(keyStorePath).exists()) {
    logger.err('Release keystore not found at $keyStorePath');
    return null;
  }

  final result = await Process.run('keytool', [
    '-list',
    '-v',
    '-alias',
    'upload',
    '-keystore',
    keyStorePath,
    '-storepass',
    'arsynckeypass',
  ], runInShell: true);

  if (result.exitCode != 0) {
    logger.err('Failed to generate release SHA. Error: ${result.stderr}');
    return null;
  }

  return _extractShaFromOutput(result.stdout as String);
}

/// Extracts SHA-1 and SHA-256 values from keytool output
ShaKeys? _extractShaFromOutput(String output) {
  final sha1Match = RegExp(r'SHA1: (.+)').firstMatch(output);
  final sha256Match = RegExp(r'SHA256: (.+)').firstMatch(output);

  if (sha1Match != null && sha256Match != null) {
    final sha1 = sha1Match.group(1)!.trim();
    final sha256 = sha256Match.group(1)!.trim();

    return ShaKeys(sha1: sha1, sha256: sha256);
  }

  logger.err('Failed to extract SHA values from the output.');
  return null;
}

/// Class to hold SHA key values
class ShaKeys {
  final String sha1;
  final String sha256;

  ShaKeys({required this.sha1, required this.sha256});
}

/// Writes the SHA-1 and SHA-256 values to the notes.txt file
Future<void> _writeToNotesFile(
  String projectDirectory,
  String? debugSha1,
  String? debugSha256,
  String? releaseSha1,
  String? releaseSha256,
) async {
  try {
    final notesFile = File(path.join(projectDirectory, 'notes.txt'));
    final shaContent = StringBuffer();

    shaContent.writeln('# Firebase SHA Keys');
    shaContent.writeln(
      'These SHA keys are required for Firebase Authentication and other Google services.',
    );
    shaContent.writeln();

    if (debugSha1 != null && debugSha256 != null) {
      shaContent.writeln('## Debug SHA Keys');
      shaContent.writeln('SHA-1:   $debugSha1');
      shaContent.writeln('SHA-256: $debugSha256');
      shaContent.writeln();
    }

    if (releaseSha1 != null && releaseSha256 != null) {
      shaContent.writeln('## Release SHA Keys');
      shaContent.writeln('SHA-1:   $releaseSha1');
      shaContent.writeln('SHA-256: $releaseSha256');
      shaContent.writeln();
    }
    shaContent.writeln();
    shaContent.writeln(
      'Remember to add these keys to your Firebase project console.',
    );

    await notesFile.writeAsString(shaContent.toString(), mode: FileMode.append);
    logger.info('SHA keys written to notes.txt');
  } catch (e) {
    logger.err('Failed to write SHA keys to notes.txt: $e');
  }
}
