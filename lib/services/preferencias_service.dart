import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  static const _chaveEmail = 'usuario_email';

  static Future<void> salvarDadosUsuario({required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveEmail, email);
  }

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
