import 'dart:convert';
import 'dart:io';

String fixtureString(String name) =>
    File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> fixtureJson(String name) =>
    jsonDecode(fixtureString(name)) as Map<String, dynamic>;
