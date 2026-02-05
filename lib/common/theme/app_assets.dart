enum AppAssets {
  ///SVG
  logoSVG('${_svgPath}logo.svg'),
  splashIconPNG('${_svgPath}splash-icon.png'),
  walletBackground('${_svgPath}wallet_background.png'),
  onboard1('${_svgPath}onboard1.svg'),
  onboard2('${_svgPath}onboard2.svg'),
  onboard3('${_svgPath}onboard3.svg'),
  onboard4('${_svgPath}onboard4.svg'),
  // Using the default logo asset until the lev-2 version is added to the bundle.
  logoLev2('${_svgPath}logo.svg'),
  profileImage('${_svgPath}profile-image.svg'),
  pixIcon('${_svgPath}pix-icon.svg'),
  phoneCheck('${_svgPath}phone_check.svg'),
  ordersNav('${_svgPath}pedidos.svg'),
  searchNav('${_svgPath}search.svg'),
  homeNav('${_svgPath}home.svg'),
  checkGreen('${_svgPath}check-green.svg'),
  checkRed('${_svgPath}cancel.svg'),

  file('assets/svg/file.svg');

  final String path;
  const AppAssets(this.path);
}

const _svgPath = 'assets/icons/';
