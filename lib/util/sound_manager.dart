import 'package:audioplayers/audioplayers.dart';
import 'package:ipotato_timer/util/app_constants.dart';

class SoundManager {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playBell() {
    return audioPlayer.play(AssetSource(Assets.bellSound));
  }
}
