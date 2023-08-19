import 'package:vector_math/vector_math_64.dart';
import 'package:web_os/web_os.dart' as web_os;

class ScrollBarController {
  Vector3 ballPos = Vector3(0.0, 0.0, 0.0);

  void moveBall(Vector3 speed, double? sizeY) {
    if (sizeY == null) {
      return;
    }
    final maxHeight = sizeY / 2.0;

    ballPos.add(speed);
    if (ballPos.y > maxHeight) ballPos.y = -maxHeight;
    if (ballPos.y < -maxHeight) ballPos.y = maxHeight;

    web_os.pointerScroll(0.0, -speed.y);
  }
}
