import 'package:angular2/core.dart';
import 'hero_service.dart';
import 'heroes_component.dart';

@Component(
    selector: 'my-app',
    template: '''
      <h1>{{title}}</h1>
      <my-heroes></my-heroes>''',
    directives: const [HeroesComponent],
    providers: const [HeroService])
class AppComponent {
  final String title = "Tour of Heroes";
}
