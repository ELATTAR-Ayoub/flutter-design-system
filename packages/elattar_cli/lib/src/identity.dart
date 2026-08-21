library;

const String cliName = 'elattar';
const String cliVersion = '0.0.1';
const int supportedConfigSchemaVersion = 1;
const int supportedRegistrySchemaVersion = 1;
const String configSchemaUri = 'https://elattar.dev/schema/config.json';

enum FoundationMode { source, package }

class CliIdentity {
  const CliIdentity._();

  static const String name = cliName;
  static const String version = cliVersion;
  static const int configSchemaVersion = supportedConfigSchemaVersion;
  static const int registrySchemaVersion = supportedRegistrySchemaVersion;
}
