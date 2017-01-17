import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'hero.dart';
import 'package:dart_tour_of_heroes/hero_service.dart';

@Component(
    selector: 'my-heroes',
    templateUrl: 'heroes_component.html',
    styleUrls: const [
      'heroes_component.css'
    ])
class HeroesComponent implements OnInit {
  final String title = "Tour of Heroes";
  final HeroService _heroService;
  final Router _router;
  List<Hero> heroes;
  Hero selectedHero;

  HeroesComponent(this._heroService, this._router);

  @override
  void ngOnInit() {
    fetchHeroes();
  }

  Future<Null> fetchHeroes() async {
    heroes = await _heroService.getHeroes();
  }

  Future<Null> gotoDetail() => _router.navigate([
    'HeroDetail',
    { 'id': selectedHero.id.toString() }
    ]);

  Future<Null> add(String name) async {
    name = name.trim();
    if (name.isEmpty) return;
    heroes.add(await _heroService.create(name));
    selectedHero = null;
  }

  onSelect(Hero hero) {
    selectedHero = hero;
  }
}
