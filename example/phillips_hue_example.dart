// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert' as convert;
import 'package:phillips_hue/phillips_hue.dart' as phillips;
import 'package:args/command_runner.dart' as cli;

phillips.ApiClient _client;

class SetCommand extends cli.Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "set";
  final description = "Control lights";

  SetCommand() {
    argParser.addOption('on', allowed: ['true', 'false']);
    argParser.addOption('light', allowMultiple: true, splitCommas: true);
  }

  Future run() async {
    Iterable<int> lights = argResults['light'];
    if (lights.isEmpty) {
      print(argParser.usage);
      return;
    }

    bool turnOn = argResults['on'] == 'true';

    print(lights);

    await Future.wait(lights.map((int id) async {
      if (turnOn) {
        await _client.turnOn(id);
      } else {
        await _client.turnOff(id);
      }
    }));

    //Iterable<int> lights = argResults.arguments['light']
  }
}

class ListCommand extends cli.Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "list";
  final description = "List available lights";

  ListCommand();

  Future run() async {
    Stream<phillips.Light> lights = _client.getStates();

    await for (phillips.Light l in lights) {
      print("id: ${l.id}, "
          "type: ${l.type}, "
          "on: ${l.state.isOn}, "
          "reachable: ${l.state.reachable}");
    }
  }
}

convert.JsonEncoder json = new convert.JsonEncoder.withIndent('  ');

Future<Null> main(List<String> args) async {
  final String uname = 'please_set me!';
  final String host = '192.168.1.218';

  var runner = new cli.CommandRunner(
      "Philips Hue API client", "Simple API client for Phillips Hue bulbs")
    ..addCommand(new ListCommand())
    ..addCommand(new SetCommand())
    ..run(args);
  _client = new phillips.ApiClient(host, uname);
  //
  // while (true) {
  //   try {
  //     await new Future.delayed(new Duration(seconds: 1));
  //     Stream<phillips.Light> lights = _client.getStates();
  //
  //     lights.forEach((phillips.Light l) {
  //       print(json.convert(l));
  //     });
  //
  //     if ((await _client.getState(3)).state.isOn) {
  //       await _client.turnOff(3);
  //     } else {
  //       await _client.turnOn(3);
  //     }
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //   }
  //   //await new Future.delayed(new Duration(seconds: 1));
  //}
}
