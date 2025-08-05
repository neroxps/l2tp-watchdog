# L2TP VPN Watchdog for OpenWrt

A Luci web interface for managing the L2TP VPN Watchdog service on OpenWrt routers.

## Features

- Web-based configuration interface
- Real-time status monitoring
- One-click service control
- Log viewing
- Automatic VPN connection recovery

## Installation

### Building from Source

1. Clone this repository to your OpenWrt SDK package directory:
   ```
   cd /path/to/openwrt-sdk/package/
   git clone https://github.com/yourusername/luci-app-l2tp-watchdog.git
   ```

2. In your OpenWrt SDK root directory, run:
   ```
   make menuconfig
   ```
   
3. Navigate to `LuCI` -> `Applications` and select `luci-app-l2tp-watchdog`.

4. Build the package:
   ```
   make package/luci-app-l2tp-watchdog/compile V=s
   ```

### Installing the Package

After building, install the generated `.ipk` package on your OpenWrt router:
```
opkg install luci-app-l2tp-watchdog_*.ipk
```

Or if you have internet access on your router:
```
opkg update
opkg install luci-app-l2tp-watchdog
```

## Configuration

After installation, access the configuration interface through:
LuCI -> Services -> VPN看门狗

### Configuration Options

- **VPN Interface Name**: The logical name of your VPN interface (default: VPN)
- **VPN Gateway**: The IP address of your VPN gateway (default: 10.2.0.1)
- **External Test IP**: IP address used to test internet connectivity (default: 223.5.5.5)
- **Check Interval**: Regular check interval in seconds (default: 5)
- **Initial Delay**: Delay time after system boot in seconds (default: 120)
- **Max Retries**: Maximum retry attempts after connection failure (default: 5)
- **Retry Delay**: Retry interval in seconds (default: 10)
- **Connection Timeout**: VPN connection establishment timeout in seconds (default: 30)

## Usage

1. Configure the parameters according to your VPN setup
2. Use the Control page to start/stop the service
3. Monitor the status on the Status page
4. View logs on the Log page

## License

Licensed under the Apache License 2.0.
