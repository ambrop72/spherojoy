spherojoy
========

This program lets you control your Sphero using a joystick.
It is designed to run on Linux and is mostly written in my [NCD programming language](https://code.google.com/p/badvpn/wiki/NCD).

Feature list:
- Easy and precise calibration by holding a button and moving the stick around.
- Turbo mode using the trigger button.
- The throttle axis scales scales and limits the speed. This makes it easier to drive at low speeds.
- The Z-rotation axis affects the target rotation (is added to the XY angle).
- LED color is interpolated based on the stick position.
- A blink button temporarily changes the color to a fixed value.
- Dead-zone around zero position in the XY space (only speed is zeroed, not angle).
- Only connects to the Sphero when the joystick is connected and disconnects when it is disconnected.
  Yoy can just leave the program running and connect the youstick whenever you want to play!

# Building

The only supported build/installation method is using the [Nix package manager](https://nixos.org/nix/).
If you are not familiar with Nix, the easiest way to proceeed is to use the Nix installer (not distribution packages).

Build the software by running the following command from the source directory:

```
nix-build build.nix -o ~/spherojoy-build
```

# Bluetooth setup

To allow connecting to the Sphero, you have to bind an RFCOMM device.

First, determine the Bluetooth address of your Sphero:

```
[ambro@nixos:~]$ hcitool scan
Scanning ...
        68:86:E7:06:20:5D       Sphero-BPO
```

Now create an RFCOMM device binding for this device.
Note that you need to run this as root.

```
[root@nixos:/home/ambro]# rfcomm bind 0 68:86:E7:06:20:5D
```

This will create `/dev/rfcomm0` (or whatever device number you specified).

You will also need to give your user account permissions to use this device.
Typically, the device will have group ownership by `dialout`, so you can add yourself to this group.
But you will need to log in and out for this to take effect.

# Configuration

You need to create and adjust a configuration file. Use the `spherojoy_config_example.ncdvalue` as a starting point.
Details regarding the configuration parameters can be found in the comments there.

# Running

Run the program, passing the path to your configuration file:

```
~/spherojoy-build/bin/spherojoy <path/to/spherojoy_config.ncdvalue>
```

If everything goes right, you should now be able to drive the Sphero with the joystick.
Note that it may take a few seconds for the connection to be established.
Also, it seems common that the first connection attempt fails and the program retries
a second time, with success.
