## Prepare the OS

This assumes Debian. Make sure you have the `contrib` component enabled if you're using Debian. If you're not, you'll need equivalents of these packages.

```bash
apt install -yy repo swig build-essential python3-dev device-tree-compiler cmake file ninja-build python3.11-venv wget
```

## Prepare git

Repo will fail unless you set `user.email` and `user.name`

```bash
git config --global user.email test@user.com
git config --global user.name ugh
```

## get the latest version of "repo"
wget https://storage.googleapis.com/git-repo-downloads/repo
chmod 755 repo
sudo cp -a repo /usr/bin

## Prepare the checkout

```bash
mkdir chromium
cd chromium
```

```bash
# It's this gist! As a repo!
repo init -u https://github.com/jcdutton/FW-firmwware-tools.git -m framework.xml
repo sync
```

## Prepare python

Virtualenvs are very nice for this.

```bash
python3 -m venv .
```

Activate it

```bash
. ./bin/activate
```

If you're not using Debian, or Debian has changed since this guide was written, you may need to `pip install setuptools` (or `apt install python3-setuptools`) before installing `.../binman`.

```bash
# This is important to un-break binman (setuptools complains about the license)
sed -e 's/>=61.0/==68.2.2/' -i src/third_party/u-boot/files/tools/binman/pyproject.toml
# Install everything
pip install pyyaml pykwalify packaging pyelftools colorama src/platform/ec/zephyr/zmake binary-manager setuptools
```

## Prepare the Zephyr SDK

I just followed the path of least resistance and installed it in `/opt` like it says.

```
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.5-1/zephyr-sdk-0.16.5-1_linux-x86_64.tar.xz
tar -x -f zephyr-sdk-0.16.5-1_linux-x86_64.tar.xz -C /opt
/opt/zephyr-sdk-0.16.5-1/setup.sh
```

Answer the questions!

## Build the EC image


If you have a FW13 FW13 AMD Ryzen 7840U:  The firmware to build is "azalea"
```bash
zmake -j8 build azalea
It will show up in (breathe) `src/platform/ec/build/zephyr/azalea/out/ec.bin`
```

If you have a FW13 AMD Ryzen 7840HS: The firmware to build is "lotus"
```bash
zmake -j8 build lotus
It will show up in (breathe) `src/platform/ec/build/zephyr/lotus/out/ec.bin`
```

If you have any other FW13, we don't have a working solution yet.

In the future, just...

```
. ./bin/activate

### do your work

zmake -j8 build azalea
or
zmake -j8 build lotus

```

