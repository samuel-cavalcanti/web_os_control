# WEB OS Remote Control

Controle remoto para TVs que utilizam o sistema [WebOS](https://webostv.developer.lge.com/).
Essa aplicação foi feita Utilizando Flutter-dart e Tokio-rust, suportando Linux e Android. Basicamente essa aplicação é uma interface gráfica para
minha biblioteca https://github.com/samuel-cavalcanti/lg-webos-client, ao mesmo tempo que verifico como seria desenvolver uma aplicação utilizando
o framework Flutter com rust.

<p align="center">
  <img  src="/docs/assets/remote%20control%20page.png">
</p>


## Get Started

Para compilar esta aplicação é preciso ter instalado tando [Flutter](https://docs.flutter.dev/get-started/install) quando o toolkit do [rust](https://www.rust-lang.org/tools/install).
Para compilar o código em rust para android e linux, é necessário adicionar as **abis**:

```bash
rustup target add armv7-linux-androideabi   # for arm
rustup target add i686-linux-android        # for x86
rustup target add aarch64-linux-android     # for arm64
rustup target add x86_64-linux-android      # for x86_64
rustup target add x86_64-unknown-linux-gnu  # for linux-x86-64
```

Instale a versão correta do **NDK** localizada no arquivo [build.gradle](./web_os/android/build.gradle). Essa aplicação utiliza o plugin da mozilla [rust-android-gradle](https://github.com/mozilla/rust-android-gradle).


## Executando testes

Executando testes em dart-flutter

```bash
flutter test
```

Executando testes do código em rust na maquina host (linux)

```bash
cd ./web_os
cargo t
```

é possível executar os testes unitários no android, utilizando o [dinghy](https://github.com/sonos/dinghy). Será necessário conectar o dispositivo com adb veja em [Comandos úteis](#comandos-úteis).

```bash
# no caso estou utilizando  wireless debug, ao invés de um cabo do tipo USB
cargo dinghy -d <device ip>:<port> test
```


## Executando aplicativo localmente

```bash
flutter run -d linux
```

## Comandos úteis

Desenvolvendo para o dispositivo Android sem a necessidade do cabo USB

```bash
# Parear um dispositivo android
adb pair <phone-ip>:<port>
# conectando ao dispositovo android
adb connect <phone-ip>:<port>
```
