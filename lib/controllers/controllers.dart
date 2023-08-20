import 'package:web_os_control/controllers/button_controller.dart';
import 'package:web_os_control/controllers/channel_controller.dart';
import 'package:web_os_control/controllers/network_controller.dart';
import 'package:web_os_control/controllers/pointer_controller.dart';
import 'package:web_os_control/controllers/system_controller.dart';
import 'package:web_os_control/controllers/volume_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_button_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_channel_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_pointer_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_system_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_volume_controller.dart';

import 'package:web_os/web_os.dart';

final Map<Type, Object> controllers = {
  WebOsVolumeController: VolumeController(WEB_OS.audio),
  WebOsButtonController: ButtonController(WEB_OS.button),
  WebOsChannelController: ChannelController(WEB_OS.channel),
  WebOsNetworkController: NetworkController(networkAPI: WEB_OS.network),
  WebOsPointerController: PointerController(WEB_OS.pointer),
  WebOsSystemController: SystemController(WEB_OS.system),
};

T getController<T>(){
    
    return controllers[T] as T;
}
