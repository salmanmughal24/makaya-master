package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin;
import com.notrait.deviceid.DeviceIdPlugin;
import io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterFirebaseFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin"));
    DeviceIdPlugin.registerWith(registry.registrarFor("com.notrait.deviceid.DeviceIdPlugin"));
    FlutterFirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin"));
    FlutterFirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterToastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
