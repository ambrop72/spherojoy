spherojoy
========

This program lets you control your Sphero using a joystick.
It is designed to run on Linux and is mostly written in my [NCD programming language](https://code.google.com/p/badvpn/wiki/NCD).

Feature list:
- Easy and precise calibration by holding a button and moving the stick around.
- Turbo mode using the trigger button.
- The throttle axis scales and limits the speed. This makes it easier to drive at low speeds.
- The Z-rotation axis is added to the XY angle to determine the desired direction.
- The LED color is dynamically adjusted based on the stick position (interpolated between two values).
- A blink button temporarily changes the color.
- Dead-zone is in effect around the zero position in the XY space (only speed is zeroed, not angle).
- Only connects to the Sphero when the joystick is connected and disconnects when it is disconnected.
  You can just leave the program running and connect the joystick whenever you want to play!

# Building

The only supported build/installation method is using the [Nix package manager](https://nixos.org/nix/).
If you are not familiar with Nix, the easiest way to proceed is to use the Nix installer (not distribution packages).

Build the software by running the following command from the source directory:

```
nix-build build.nix -o ~/spherojoy-build
```

# Bluetooth setup

To allow connecting to the Sphero, you have to bind an RFCOMM device.
Before you can do this, you need to determine the Bluetooth address of your Sphero:

```
[ambro@nixos:~]$ hcitool scan
Scanning ...
        68:86:E7:06:20:5D       Sphero-BPO
```

Now create an RFCOMM device binding for this device, as shown.
Note that you need to run this as root.

```
[root@nixos:/home/ambro]# rfcomm bind 0 68:86:E7:06:20:5D
```

This will create `/dev/rfcomm0` (or whatever device number you specified).

You will also need to give your user account permissions to use this device.
Typically, the device will have group ownership by `dialout`,
in which case you can add yourself to this group (`gpasswd -a your_user dialout`).
But you will need to log out and back in for this to take effect.

# Configuration

You need to create and adjust a configuration file.
Use the [the example configuration](spherojoy_config_example.ncdvalue) as a starting point.
Details regarding the configuration parameters can be found in the comments there.

# Running

Run the program, passing the path to your configuration file:

```
~/spherojoy-build/bin/spherojoy <path/to/spherojoy_config.ncdvalue>
```

If everything goes right, you should now be able to drive the Sphero with the joystick.
Note that it may take a few seconds for the connection to be established.
Also, it seems common that the first connection attempt fails and the program tries
a second time successfully.
