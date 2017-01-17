import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
import 'package:dart_tour_of_heroes/app_component.dart';
import 'package:dart_tour_of_heroes/in_memory_data_service.dart';
import 'package:http/http.dart';

void main() {
  bootstrap(AppComponent, [
    provide(Client, useClass: InMemoryDataService)
    // For actual deployment, import http/browser_client and uncomment
    //    provide(BrowserClient, useFactory: () => new BrowserClient(), deps: [])
  ]);
}
