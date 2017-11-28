// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:phillips_hue/phillips_hue.dart' as phillips;
import 'package:args/command_runner.dart' as cli;

class SetCommand extends cli.Command {
  // The [name] and [description] properties must be defined by every
  // subclass.

  @override
  final String name = "set";
  @override
  final String description = "Control lights";

  SetCommand() {
    argParser
      ..addOption('on', allowed: const <String>['true', 'false'])
      ..addOption('light', allowMultiple: true, splitCommas: true)
      ..addOption('config', help: 'Path to config file.');
  }

  @override
  Future<Null> run() async {
    final phillips.Configuration config =
        await _loadConfig(argResults['config']);
    final phillips.ApiClient client =
        new phillips.ApiClient(config.hostname, config.username);
    final Iterable<int> lights = argResults['light'];

    if (lights.isEmpty) {
      print(argParser.usage);
      return;
    }

    final bool turnOn = argResults['on'] == 'true';

    await Future.wait(lights.map((int id) async {
      if (turnOn) {
        await client.turnOn(id);
      } else {
        await client.turnOff(id);
      }
    }));
  }
}

class ListCommand extends cli.Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final String name = "list";
  @override
  final String description = "List available lights";

  ListCommand() {
    argParser.addOption('config', help: 'Path to config file.');
  }

  @override
  Future<Null> run() async {
    final phillips.Configuration config =
        await _loadConfig(argResults['config']);
    final phillips.ApiClient client =
        new phillips.ApiClient(config.hostname, config.username);

    final Stream<phillips.Light> lights = client.getStates();

    await for (phillips.Light l in lights) {
      print("id: ${l.id}, "
          "type: ${l.type}, "
          "on: ${l.state.isOn}, "
          "reachable: ${l.state.reachable}");
    }
  }
}

final convert.JsonEncoder json = new convert.JsonEncoder.withIndent('  ');

Future<phillips.Configuration> _loadConfig(final String path) async {
  return new phillips.Configuration.fromJson(
      convert.JSON.decode(await (new File(path).readAsString())));
}

Future<Null> main(List<String> args) async {
  final cli.CommandRunner runner = new cli.CommandRunner(
      "Philips Hue API client", "Simple API client for Phillips Hue bulbs")
    ..addCommand(new ListCommand())
    ..addCommand(new SetCommand());

  // Parse args and run application.
  await runner.run(args);
}
