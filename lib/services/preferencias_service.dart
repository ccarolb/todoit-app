import 'package:shared_preferences/shared_preferences.dart';

//Classe que utiliza a lib do SharedPreferences para salvar e carregar as preferências do usuário
// Neste caso, o tema do app (claro ou escuro)
class PreferenciasService {
  static Future<void> salvarPreferenciaTemaApp(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_escuro', escuro);
    print('Preferência salva: $escuro');
  }

  static Future<bool> carregarTemaPreferido() async {
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getBool('modo_escuro') ?? false;
    print('Preferência carregada: $valor');
    return valor;
  }
}
