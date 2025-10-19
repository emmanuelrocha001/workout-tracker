import 'package:web/web.dart' as web;

class WebHelper {
  static bool isMobileWeb() {
    var userAgent = (web.window.navigator.userAgent).toLowerCase();
    return userAgent.contains('mobile') || // General mobile devices
        userAgent.contains('android') || // Android devices
        userAgent.contains('iphone') || // iPhone
        userAgent.contains('ipad'); // iPad
  }

  static void launchUrlString(String url) {
    web.window.open('youtube://$url', "_self");
  }
}
