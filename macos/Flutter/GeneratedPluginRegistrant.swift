//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_session
import audioplayers
import desktop_window
import just_audio
import path_provider_macos
import shared_preferences_macos
import window_size

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  AudioplayersPlugin.register(with: registry.registrar(forPlugin: "AudioplayersPlugin"))
  DesktopWindowPlugin.register(with: registry.registrar(forPlugin: "DesktopWindowPlugin"))
  JustAudioPlugin.register(with: registry.registrar(forPlugin: "JustAudioPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WindowSizePlugin.register(with: registry.registrar(forPlugin: "WindowSizePlugin"))
}
