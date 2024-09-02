#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.4-alpha
# date: 2024-09-02 10:53:38
__0_user=""
function makeDir__0_v0 {
    local path=$1
    mkdir ${path};
    __AS=$?;
if [ $__AS != 0 ]; then
        if [ $(echo $__AS '!=' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            echo "Failed to create directory: ${path}!"
            __AF_makeDir0_v0=1;
            return 0
fi
fi
    __AF_makeDir0_v0=0;
    return 0
}
function setup__1_v0 {
    sudo apt-get update;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Couldn't update packages. Some install options may fail..."
fi
    sudo apt-get install -y curl unzip git steam flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_setup1_v0=''
return $__AS
fi
}
function installPackages__2_v0 {
    flatpak install app/org.blender.Blender/x86_64/stable app/org.gimp.GIMP/x86_64/stable app/md.obsidian.Obsidian/x86_64/stable app/org.inkscape.Inkscape/x86_64/stable;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "WARNING: Couldn't install flatpak packages"
        echo ""
fi
    echo "" && echo "Installing VSCode...";
    __AS=$?
    local vscodeLink="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    curl -Lo vscode_latest.deb ${vscodeLink} && sudo apt install ./vscode_latest.deb && rm vscode_latest.deb;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_installPackages2_v0=''
return $__AS
fi
    echo "" && echo "Installing Discord...";
    __AS=$?
    local discordLink="https://discord.com/api/download?platform=linux&format=deb"
    curl -o discord_latest.deb ${discordLink} && sudo apt install ./discord_latest.deb && rm discord_latest.deb;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "WARNING: Couldn't to install discord"
fi
}
function createApplicationEntry__3_v0 {
    local name=$1
    local pathToExe=$2
    local pathToIcon=$3
    local entry="
    [Desktop Entry]

    Name=${name}

    Exec=${pathToExe}

    Comment=

    Terminal=false

    Icon=${pathToIcon}

    Type=Application

    Hidden=false

    "
    local path="/home/${__0_user}/.local/share/applications"
    echo ${entry} > ${path}/${name}.desktop;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "WARNING: Couldn't to create desktop entry for application ${name}..."
fi
}
function installNeovim__4_v0 {
    local rootPath=$1
    local neovimPath="${rootPath}""/neovim"
    makeDir__0_v0 "${neovimPath}";
    __AF_makeDir0_v0__78_21=$__AF_makeDir0_v0;
    local hasFailed=$(echo $__AF_makeDir0_v0__78_21 '==' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local neovimInstallSuccess=1
    curl -Lo ${neovimPath}/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && tar -C ${neovimPath} -xzf ${neovimPath}/nvim-linux64.tar.gz &&
    mv ${neovimPath}/nvim-linux64/* ${neovimPath} && echo export PATH=\"\$PATH:${neovimPath}/bin\" >> ~/.bashrc &&
    echo export nvim=\"${neovimPath}/bin/nvim\" >> ~/.bashrc &&
    rm ${neovimPath}/nvim-linux64.tar.gz && rm -r ${neovimPath}/nvim-linux64;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "WARNING: Failed to install Neovim..."
        neovimInstallSuccess=0
fi
    curl -o ${neovimPath}/neovim_icon.png https://avatars2.githubusercontent.com/u/6471485?v=3&s=400;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_installNeovim4_v0=''
return $__AS
fi
    curl -Lo ${neovimPath}/neovide.AppImage https://github.com/neovide/neovide/releases/latest/download/neovide.AppImage &&
    chmod +x ${neovimPath}/neovide.AppImage;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Failed to install Neovide frontend!"
fi
    createApplicationEntry__3_v0 "neovide" "${neovimPath}/neovide.AppImage" "${neovimPath}/neovim_icon.png";
    __AF_createApplicationEntry3_v0__97_5=$__AF_createApplicationEntry3_v0;
    echo $__AF_createApplicationEntry3_v0__97_5 > /dev/null 2>&1
}
function installNextcloud__5_v0 {
    local rootPath=$1
    echo ""
    echo "Installing Nextcloud Desktop..."
    local nextcloudPath="${rootPath}""/nextcloud"
    makeDir__0_v0 "${nextcloudPath}";
    __AF_makeDir0_v0__106_21=$__AF_makeDir0_v0;
    local hasFailed=$(echo $__AF_makeDir0_v0__106_21 '==' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local nextcloudLink="https://github.com/nextcloud-releases/desktop/releases/download/v3.13.3/Nextcloud-3.13.3-x86_64.AppImage"
    local nextcloudIconLink="https://nextcloud.com/c/uploads/2024/07/logo_nextcloud_blue.png?original"
    curl -o ${nextcloudPath}/nextcloudLatest.AppImage ${nextcloudLink} && chmod +x nextcloudLatest.AppImage && curl -o ${nextcloudPath}/nextcloudImage.png ${nextcloudIconLink};
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "WARNING: Couldn't to install Nextcloud Desktop"
fi
    createApplicationEntry__3_v0 "Nextcloud" "${nextcloudPath}/nextcloudLatest.AppImage" "${nextcloudPath}/nextcloudImage.png";
    __AF_createApplicationEntry3_v0__114_5=$__AF_createApplicationEntry3_v0;
    echo $__AF_createApplicationEntry3_v0__114_5 > /dev/null 2>&1
}
function installGodot__6_v0 {
    local rootPath=$1
    local godotPath="${rootPath}""/godot"
    local shouldBail=0
    echo "Installing Godot..."
    makeDir__0_v0 "${godotPath}";
    __AF_makeDir0_v0__124_18=$__AF_makeDir0_v0;
    shouldBail=$(echo $__AF_makeDir0_v0__124_18 '==' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo  '!' ${shouldBail} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        curl -Lo ${godotPath}/godot_latest.zip https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip && unzip -q ${godotPath}/godot_latest.zip -d ${godotPath};
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "WARNING: Couldn't unzip the Godot download!"
            shouldBail=1
fi
        rm ${godotPath}/godot_latest.zip;
        __AS=$?
        curl -Lo ${godotPath}/godot_icon.png https://godotengine.org/assets/press/icon_color.png;
        __AS=$?
        __AMBER_VAL_0=$(ls ${godotPath} | grep -Ei x86_64 | grep -Eiv .zip);
        __AS=$?;
        local file="${__AMBER_VAL_0}"
        chmod +x ${godotPath}/${file};
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "WARNING: Couldn't to make Godot executable"
fi
fi
}
function installApplications__7_v0 {
    local rootPath=$1
    installGodot__6_v0 "${rootPath}";
    __AF_installGodot6_v0__150_5=$__AF_installGodot6_v0;
    echo $__AF_installGodot6_v0__150_5 > /dev/null 2>&1
    installNextcloud__5_v0 "${rootPath}";
    __AF_installNextcloud5_v0__151_5=$__AF_installNextcloud5_v0;
    echo $__AF_installNextcloud5_v0__151_5 > /dev/null 2>&1
    installNeovim__4_v0 "${rootPath}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_installApplications7_v0=''
return $__AS
fi;
    __AF_installNeovim4_v0__152_5=$__AF_installNeovim4_v0;
    echo $__AF_installNeovim4_v0__152_5 > /dev/null 2>&1
}

    __AMBER_VAL_1=$(whoami);
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Failed to determine current user, bailing!"
fi;
    __0_user="${__AMBER_VAL_1}"
    echo "Greetings ${__0_user}!"
    echo "The following packages will be installed:

    Packages:
    - Flatpak
        - GIMP
        - Obsidian
        - Blender
        - Inkscape
    - VSCode
    - Steam
    - Discord
    - Nextcloud Desktop
    - Neovim
    "
    shouldInstallPackages=0
    while :
do
        echo -n "Sound good? (y/N):";
        __AS=$?
        installPackages=""
        read installPackages;
        __AS=$?
        if [ $(echo $([ "_${installPackages}" != "_Y" ]; echo $?) '||' $([ "_${installPackages}" != "_y" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            shouldInstallPackages=1
            break
fi
        if [ $(echo $([ "_${installPackages}" != "_N" ]; echo $?) '||' $([ "_${installPackages}" != "_n" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            shouldInstallPackages=0
            break
fi
done
    if [ $(echo ${shouldInstallPackages} '==' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        echo "Installing packages.."
else
        echo "Skipping package install.."
fi
    echo ""
    if [ ${shouldInstallPackages} != 0 ]; then
        shouldBail=0
        setup__1_v0 ;
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "Failed to install required packages for setup. Aborting install..."
            shouldBail=1
fi;
        __AF_setup1_v0__209_9=$__AF_setup1_v0;
        echo $__AF_setup1_v0__209_9 > /dev/null 2>&1
        if [ $(echo  '!' ${shouldBail} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            installPackages__2_v0 ;
            __AS=$?;
if [ $__AS != 0 ]; then
                echo "Failed to install packages..."
fi;
            __AF_installPackages2_v0__217_13=$__AF_installPackages2_v0;
            echo $__AF_installPackages2_v0__217_13 > /dev/null 2>&1
            makeDir__0_v0 "/home/${__0_user}/Documents/apps";
            __AF_makeDir0_v0__221_13=$__AF_makeDir0_v0;
            echo $__AF_makeDir0_v0__221_13 > /dev/null 2>&1
            installApplications__7_v0 "/home/${__0_user}/Documents/apps";
            __AS=$?;
if [ $__AS != 0 ]; then
                echo "Installation of application failed..."
fi;
            __AF_installApplications7_v0__222_13=$__AF_installApplications7_v0;
            echo $__AF_installApplications7_v0__222_13 > /dev/null 2>&1
fi
fi