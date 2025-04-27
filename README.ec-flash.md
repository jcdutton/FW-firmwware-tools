This is how to compile edk2 and the "ectool.efi" that is used to flash the EC firmware.

git clone https://github.com/tianocore/edk2.git
cd edk2
git clone https://github.com/jcdutton/FrameworkHacksPkg.git
git submodule update --init
make -j1 -C BaseTools
source edksetup.sh
build -p FrameworkHacksPkg/FrameworkHacksPkg.dsc -a X64 -b RELEASE -t GCC5


The flashing tool will then be in:
./Build/FrameworkHacksPkg/RELEASE_GCC5/X64/ECTool.efi

Assuming you have you EFI partition mounted on /boot/efi

mkdir /boot/efi/EFI/ectool
cp -a ../ectool.efi/ectool/* /boot/efi/EFI/ectool


Now we will do a BACKUP of the current EC firmware.  Note: This part is very very important to do.

1) Reboot and press F2 so that you get into the BIOS.
2) Select boot from file.
3) navigate to EFI/ectool  and select to boot "bootx64.efi"
4) This should reach an EFI command shell. If not, you have done something wrong, so recheck your steps.
5) At the EFI command shell backup the EC firmware with:
backup.nsh
6) That should have created a file called "ec-backup1.bin".  You can use "dir" to check.


Reboot into Linux and copy the ec-backup1.bin onto some removable media for backup purposes.
If you brick your laptop, at least you will have a backup.
I should point out, that if you do brick your laptop, I do not have any instructions on how to recover appart from returning the mainboard to the manufacturer.


Now we will actually flash the new EC firmware:

WARNING: This step can permanently brick your laptop, meaning it will never work again.
Be very careful and only continue if you are absolutely sure.
DISCLAIMER of LIABILITY. The information provided is offered 'as is' and without any warranties, express or implied. I disclaim any and all liability for any actions taken based on the contents here.

The firmware has two images.
1) RO
This is the fallback firmware. For this we never wish to make any changes to the RO image. If we do, we will never have anything to fallback to if the EC flash process fails.
2) RW
This is the RW image we will write the new EC firmware to.
States that determine which firmware image is running:
1) If you start with the FW laptop powered off and the PSU disconnected for more than 2 minutes, the EC firmware will fallback to useing the RO image.
If you have messed up, you can get the laptop to fallback to using the RO image simply by powering it off and unplugging the PSU for more than 2 minutes.
2) If you power off the laptop and leave the PSU connected, it will stay in whatever image it was in. 
3) If you suspend the laptop and leave it with or without the PSU connected, it will stay in whatever image it was in.
4) In Linux, you can do "sudo ectool sysinfo" to find out which image it is using right now:
sudo ectool sysinfo
interfaces:0xffffffff
comm_init_dev being used /dev/cros_ec
Reset flags: 0x00000448 (power-on hibernate sysjump)
Firmware copy: 0x02:RW      <- This tells us which image it is using. Here it is telling use that it is using the RW image right now.
Jumped: yes
Recovery: no
Flags: 0x00000008 ( unlocked )

1) copy the firmware you created in the "README.chromium.md" instructions into the "/boot/efi/EFI/ectool" directory. Rename the filename to "ec-new1.bin"
2) Reboot and press F2 so that you get into the BIOS.
3) Select boot from file.
4) navigate to EFI/ectool  and select to boot "bootx64.efi"
5) This should reach an EFI command shell. If not, you have done something wrong, so recheck your steps.
6) Make sure you have the mains Power supply unit connected. 
7) At the EFI command shell FLASH the EC firmware with:
backup.nsh
The "backup.nsh" runs the command: ECTool.efi reflash --rw --yes ec-new1.bin
8) It takes a while to complete
9) Type the command to switch the EC to use the new firmware. The "RW" image.  It will reboot or power off the laptop.
ECTool.efi reboot rw
The next time you power on the laptop, it should be using the RW image.


