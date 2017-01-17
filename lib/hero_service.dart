import 'dart:async';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:http/http.dart';

import 'hero.dart';

@Injectable()
class HeroService {
  static const _heroesUrl = "api/heroes";
  static final _headers = {'Content-Type': 'application/json'};

  final Client _http;

  HeroService(this._http);

  /// Using our client service, fetch all the heroes we can get
  Future<List<Hero>> getHeroes() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = _extractData(response)
          .map((value) => new Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch a hero from our API, individually by the id
  Future<Hero> getHero(int id) async {
    try {
      final response = await _http.get('$_heroesUrl/$id');
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update the body of the Hero with new data
  Future<Hero> updateHero(Hero hero) async {
    try {
      final url = '$_heroesUrl/${hero.id}';
      final response =
      await _http.put(url, headers: _headers, body: JSON.encode(hero));

      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new Hero in our backing data layer
  Future<Hero> create(final String name) async {
    try {
      final response = await _http.post(_heroesUrl,
          headers: _headers, body: JSON.encode({ 'name': name }));

      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove a hero from the backing data layer, by id
  Future<Null> delete(int id) async {
    try {
      final url = '$_heroesUrl/$id';
      await _http.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => JSON.decode(resp.body)['data'];

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return new Exception('Server error; cause: $e');
  }
}
