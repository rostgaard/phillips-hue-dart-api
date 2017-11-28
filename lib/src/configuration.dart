abstract class _Key {
  static const String username = 'username';
  static const String hostname = 'hostname';
}

/// Class for holding configuration values.
class Configuration {
  /// The username needed to authenticate against the Hue bridge.
  final String username;

  /// The hostname of the Hue bridge.
  final String hostname;

  /// Create a new immutable [Configuration] object.
  Configuration(this.username, this.hostname);

  /// Create a new [Configuration] object from the [json] map.
  factory Configuration.fromJson(final Map<String, dynamic> json) {
    final String username = json[_Key.username];
    final String hostname = json[_Key.hostname];

    return new Configuration(username, hostname);
  }

  /// JSON serialization function.
  /// Can be used to create a loadable config file.
  Map<String, dynamic> toJson() => new Map<String, dynamic>.unmodifiable(
      <String, dynamic>{_Key.username: username, _Key.hostname: hostname});
}
