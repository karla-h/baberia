import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url = 'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace de WhatsApp.';
    }
  }
}
