// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:phillips_hue/phillips_hue.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  final String jsonTestString = '''{
	"state": {
		"on": false,
		"bri": 254,
		"hue": 6291,
		"sat": 251,
		"effect": "none",
		"xy": [
			0.5612,
			0.4042
		],
		"ct": 500,
		"alert": "select",
		"colormode": "xy",
		"reachable": true
	},
	"type": "Extended color light",
	"name": "Hue color lamp 1",
	"modelid": "LCT010",
	"manufacturername": "Philips",
	"uniqueid": "00:17:88:01:02:78:46:59-0b",
	"swversion": "1.15.0_r18729",
	"swconfigid": "F921C859",
	"productid": "Philips-LCT010-1-A19ECLv4"
}''';

  group('Model test', () {
    setUp(() {});
    test('Encode/decode', () {
      final Light l = new Light.fromJson(JSON.decode(jsonTestString));

      expect(l, isNotNull);
      expect(l.toJson(), equals(JSON.decode(jsonTestString)));
    });
  });
}
