import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
    selector: 'my-hero-detail',
    templateUrl: 'hero_detail_component.html',
    styleUrls: const ['hero_detail_component.css']
)
class HeroDetailComponent implements OnInit {

  @Input()
  Hero hero;

  final HeroService _heroService;
  final RouteParams _routeParams;
  final Location _location;


  HeroDetailComponent(this._heroService, this._routeParams, this._location);

  void goBack() => _location.back();

  @override
  Future<Null> ngOnInit() async {
    var idParam = _routeParams.get('id');
    var id = int.parse(idParam ?? '', onError: (_) => null);
    if (id != null) hero = await (_heroService.getHero(id));
  }
}