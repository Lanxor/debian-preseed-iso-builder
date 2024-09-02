# Debian Preseed ISO Builder

**Objective**: Create a Debian ISO file that includes a preseed configuration for the Debian Installer.

## How to Use It?

1. Download the Debian netinst or DVD ISO file and place it at the root of the project directory.
2. Set hash password output of the following command in `preseed.cfg` file at root account password.

    ```sh
    sudo apt install -y whois
    mkpasswd -m sha256crypt
    ```

3. Run the Makefile with the following command:

    ```sh
    make ISOBASEFILE=debian-12.0.0-amd64-DVD-1.iso
    ```

4. Use the generated ISO file to install Debian with the pre-configured settings.

## How to update the Preseed File

The preseed file is located at: `preseed.cfg`. To update it, modify the file as needed, save your changes, and then build a new ISO file using the instructions above.

## Why Are the Language and Keymap settings not updated with `preseed.cfg`?

The language and keymap settings are loaded before the preseed file is read, so we need to specify these parameters directly to the kernel. This is where the `isolinux` files come into play:

- `isolinux/isolinux.cfg`: IsoLinux is the bootloader that instructs the Debian Installer on how to execute. It allows the user to install the Debian system automatically by defining boot parameters. This file specifies the default behavior and includes the `menu.cfg` file, which further includes `txt.cfg` where the `install` menu option is located.
- `isolinux/txt.cfg`: This file defines the commands that the kernel bootloader needs to execute with the `initrd` program. Here, we specify the language and keymap preseed arguments to be used before the Debian Installer runs.

## Sources

- <https://www.debian.org/releases/stable/amd64/apbs04.en.html>
- <https://www.debian.org/distrib/>
- <https://wiki.debian.org/DebianInstaller/Preseed>
- <https://www.makeuseof.com/types-of-syslinux-bootloaders/>
- <https://unix.stackexchange.com/questions/532252/how-to-automate-selection-of-type-of-installation-by-editing-isolinux>
