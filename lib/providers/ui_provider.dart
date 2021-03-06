import 'package:flutter/cupertino.dart';

class UiProvider extends ChangeNotifier {
  //la opcion de abajo representa las opciones de menu del body
  //mapas o direcciones de la carpeta PAGES.
  int _selectedMenuOpt = 1;

  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int i) {
    this._selectedMenuOpt = i;
    //se notifica a cualquier widget que este escuchando ese Provider
    notifyListeners();
  }
}
