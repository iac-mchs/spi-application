//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <desktop_window/desktop_window_plugin.h>
#include <flutter_audio_desktop/flutter_audio_desktop_plugin.h>
#include <window_size/window_size_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) desktop_window_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopWindowPlugin");
  desktop_window_plugin_register_with_registrar(desktop_window_registrar);
  g_autoptr(FlPluginRegistrar) flutter_audio_desktop_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterAudioDesktopPlugin");
  flutter_audio_desktop_plugin_register_with_registrar(flutter_audio_desktop_registrar);
  g_autoptr(FlPluginRegistrar) window_size_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowSizePlugin");
  window_size_plugin_register_with_registrar(window_size_registrar);
}
