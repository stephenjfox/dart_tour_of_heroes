import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:angular2/core.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'hero.dart';

@Injectable()
class InMemoryDataService extends MockClient {
  static final _initialHeroes = [
    {'id': 11, 'name': 'Mr. Nice'},
    {'id': 12, 'name': 'Narco'},
    {'id': 13, 'name': 'Bombasto'},
    {'id': 14, 'name': 'Celeritas'},
    {'id': 15, 'name': 'Magneta'},
    {'id': 16, 'name': 'RubberMan'},
    {'id': 17, 'name': 'Dynama2'},
    {'id': 18, 'name': 'Dr IQ'},
    {'id': 19, 'name': 'Magma'},
    {'id': 20, 'name': 'Tornado'}
  ];
  static final List<Hero> _heroesDb =
  _initialHeroes.map((json) => new Hero.fromJson(json)).toList();
  static int _nextId = _heroesDb.map((hero) => hero.id).fold(0, max) + 1;

  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        data = parseGetRequest(request);
        break;
      case 'POST':
        data = parsePostRequest(request);
        break;
      case 'PUT':
        data = parsePutChanges(request);
        break;
      case 'DELETE':
        var id = int.parse(request.url.pathSegments.last);
        _heroesDb.removeWhere((hero) => hero.id == id);
        // No data, so leave it as null.
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    return new Response(JSON.encode({'data': data}), 200,
        headers: {'content-type': 'application/json'});
  }

  static parsePutChanges(Request request) {
    var heroChanges = new Hero.fromJson(JSON.decode(request.body));
    var targetHero = _heroesDb.firstWhere((h) => h.id == heroChanges.id);
    targetHero.name = heroChanges.name;
    return targetHero;
  }

  static parsePostRequest(Request request) {
    var name = JSON.decode(request.body)['name'];
    var newHero = new Hero(_nextId++, name);
    _heroesDb.add(newHero);
    return newHero;
  }

  static parseGetRequest(Request request) {
    var data;
    final id = int.parse(request.url.pathSegments.last, onError: (_) => null);
    if (id != null) {
      data = _heroesDb.firstWhere((hero) => hero.id == id); // throws if no match
    } else {
      String prefix = request.url.queryParameters['name'] ?? '';
      final regExp = new RegExp(prefix, caseSensitive: false);
      data = _heroesDb.where((hero) => hero.name.contains(regExp)).toList();
    }
    return data;
  }

  InMemoryDataService() : super(_handler);
}
