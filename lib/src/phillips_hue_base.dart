// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

abstract class _Key {
  static const String isOn = "on";
  static const String brightness = "bri";
  static const String hue = "hue";
  static const String saturation = "sat";
  static const String effect = "effect";
  static const String xy = "xy";
  static const String alert = "alert";
  static const String ct = "ct";
  static const String colorMode = "colormode";
  static const String reachable = "reachable";
  static const String state = 'state';
  static const String type = 'type';
  static const String name = 'name';
  static const String modelId = 'modelid';
  static const String manufacturerName = 'manufacturername';
  static const String uniqueId = 'uniqueid';
  static const String softwareVersion = 'swversion';
  static const String softwareConfigId = 'swconfigid';
  static const String productId = 'productid';
}

class Light {
  final int id;
  final LightState state;
  final String type;
  final String name;
  final String modelId;
  final String manufacturerName;
  final String uniqueId;
  final String softwareVersion;
  final String softwareConfigId;
  final String productId;

  Light(
      this.state,
      this.type,
      this.name,
      this.modelId,
      this.manufacturerName,
      this.uniqueId,
      this.softwareVersion,
      this.softwareConfigId,
      this.productId,
      {this.id = -1});

  factory Light.fromJson(Map<String, dynamic> map, {int id = -1}) {
    return new Light(
        new LightState.fromJson(map[_Key.state]),
        map[_Key.type],
        map[_Key.name],
        map[_Key.modelId],
        map[_Key.manufacturerName],
        map[_Key.uniqueId],
        map[_Key.softwareVersion],
        map[_Key.softwareConfigId],
        map[_Key.productId],
        id: id);
  }

  Map<String, dynamic> toJson() =>
      new Map<String, dynamic>.unmodifiable(<String, dynamic>{
        _Key.state: state.toJson(),
        _Key.type: type,
        _Key.name: name,
        _Key.modelId: modelId,
        _Key.manufacturerName: manufacturerName,
        _Key.uniqueId: uniqueId,
        _Key.softwareVersion: softwareVersion,
        _Key.softwareConfigId: softwareConfigId,
        _Key.productId: productId
      });
}

class LightState {
  final bool isOn;
  final int brightness;
  final int hue;
  final int saturation;
  final String effect;
  final List<num> xy;
  final int ct;
  final String alert;
  final String colorMode;
  final bool reachable;

  const LightState(
      this.isOn,
      this.brightness,
      this.hue,
      this.saturation,
      this.effect,
      this.xy,
      this.ct,
      this.alert,
      this.colorMode,
      this.reachable);

  factory LightState.fromJson(Map<String, dynamic> map) {
    return new LightState(
      map[_Key.isOn],
      map[_Key.brightness],
      map[_Key.hue],
      map[_Key.saturation],
      map[_Key.effect],
      map[_Key.xy],
      map[_Key.ct],
      map[_Key.alert],
      map[_Key.colorMode],
      map[_Key.reachable],
    );
  }

  Map<String, dynamic> toJson() =>
      new Map<String, dynamic>.unmodifiable(<String, dynamic>{
        _Key.isOn: isOn,
        _Key.brightness: brightness,
        _Key.hue: hue,
        _Key.saturation: saturation,
        _Key.effect: effect,
        _Key.xy: xy,
        _Key.ct: ct,
        _Key.alert: alert,
        _Key.colorMode: colorMode,
        _Key.reachable: reachable
      });

  @override
  String toString() => toJson().toString();
}
