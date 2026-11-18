#!/usr/bin/env zsh

# Ask for the administrator password up front (pmset, the firewall and the system-wide
# preferences need it)
sudo -v

# Quit System Settings so it doesn't override the settings we're about to change,
# and quit every app whose preferences we write, so it doesn't overwrite them
# from memory when it exits later
quit_app() {
  pgrep -xq "$1" || return 0
  osascript -e "quit app \"$1\"" 2>/dev/null || killall "$1" 2>/dev/null
}

for app in "System Settings" \
  "Activity Monitor" \
  "AirBattery" \
  "AlDente" \
  "App Store" \
  "Archive Utility" \
  "BetterCapture" \
  "Calendar" \
  "Dia" \
  "Disk Utility" \
  "Fluor" \
  "Image Capture" \
  "Mail" \
  "Messages" \
  "Movist Pro" \
  "Photos" \
  "Safari" \
  "Shottr" \
  "TextEdit" \
  "Things3" \
  "Transmission"; do
  quit_app "$app"
done

###############################################################################
#                                                                             #
# System                                                                      #
#                                                                             #
###############################################################################

###############################################################################
# Appearance & dialogs                                                        #
###############################################################################

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Liquid Glass appearance: Tinted (slider, 0 = clear, 1 = fully tinted)
defaults write NSGlobalDomain NSGlassTintAmount -float 1

# Disable font smoothing (thinner, sharper text on Retina displays)
defaults -currentHost write NSGlobalDomain AppleFontSmoothing -int 0

# Double-click a window title bar to fill the screen
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Open dialogs default to list view
defaults write NSGlobalDomain NSNavPanelFileLastListModeForOpenModeKey -int 2
defaults write NSGlobalDomain NSNavPanelFileListModeForOpenMode2 -int 2

###############################################################################
# Language & Region                                                           #
###############################################################################

# English UI with Hungarian formats (24h, Monday, metric, Ft)
defaults write NSGlobalDomain AppleLanguages -array "en-US" "hu-HU"
defaults write NSGlobalDomain AppleLocale -string "en_US@rg=huzzzz"

# Show names with the family name first (1 = given name first, 2 = family name first)
defaults write NSGlobalDomain NSPersonNameDefaultDisplayNameOrder -int 2

###############################################################################
# Keyboard & Text                                                             #
###############################################################################

# Disable auto-capitalization, auto-period, auto-correct, smart quotes, smart dashes and
# inline predictions (all annoying when typing code)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false

# Fn / Globe key: change input source (0 = nothing, 2 = emoji picker, 3 = dictation)
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

# "Share..." = Option+Ctrl+S
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Share..." "~^s"

# Disable system hotkeys.
# Usage: disable_hotkey <id> <ascii-code> <key-code> <modifiers>
# The parameters must match the system's own values for that ID, otherwise the
# entry is ignored. ascii-code is 65535 for non-character keys (arrows).
disable_hotkey() {
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
    "<dict><key>enabled</key><false/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>$2</integer><integer>$3</integer><integer>$4</integer></array></dict></dict>"
}

# Screenshots - Shottr uses the same shortcuts
disable_hotkey 28  51 20 1179648      # Cmd+Shift+3        Save picture of screen as a file
disable_hotkey 29  51 20 1441792      # Cmd+Ctrl+Shift+3   Copy picture of screen to the clipboard
disable_hotkey 30  52 21 1179648      # Cmd+Shift+4        Save picture of selected area as a file
disable_hotkey 31  52 21 1441792      # Cmd+Ctrl+Shift+4   Copy picture of selected area to the clipboard
disable_hotkey 184 53 23 1179648      # Cmd+Shift+5        Screenshot and recording options

# Input sources - Ctrl+Space is Things Quick Entry, the Fn key switches layouts instead (above)
disable_hotkey 60  32 49 262144       # Ctrl+Space         Select the previous input source
disable_hotkey 61  32 49 786432       # Ctrl+Option+Space  Select next source in Input menu

# Spotlight - Raycast uses Cmd+Space
disable_hotkey 64  32 49 1048576      # Cmd+Space          Show Spotlight search
disable_hotkey 65  32 49 1572864      # Cmd+Option+Space   Show Finder search window

# Mission Control
disable_hotkey 79  65535 123 8650752  # Ctrl+Left          Move left a space
disable_hotkey 81  65535 124 8650752  # Ctrl+Right         Move right a space

###############################################################################
# Trackpad & Mouse                                                            #
###############################################################################

# Disable "natural" (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Tap to click on the built-in and Bluetooth trackpads
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Three-finger drag (disable swipe gestures so three fingers are free for dragging)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0

# Accessibility: zoom with Ctrl+scroll wheel
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.AppleMultitouchTrackpad HIDScrollZoomModifierMask -int 262144
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad HIDScrollZoomModifierMask -int 262144

###############################################################################
# Menu Bar & Control Center                                                   #
###############################################################################

# Show input menu (language switcher) in the menu bar
defaults write com.apple.TextInputMenu visible -bool true

# Clock: always show the date (0 = when space allows, 1 = always, 2 = never)
defaults write com.apple.menuextra.clock ShowDate -int 1

# Hide the Battery menu bar item (AlDente replaces it)
defaults -currentHost write com.apple.controlcenter Battery -int 8

# Hide other Control Center items from the menu bar (8 = hide; Now Playing: 2 = show
# when active, 18 = always show, 24 = don't show)
defaults -currentHost write com.apple.controlcenter NowPlaying -int 24
defaults -currentHost write com.apple.controlcenter VPN -int 8
defaults -currentHost write com.apple.controlcenter VoiceControl -int 8
defaults -currentHost write com.apple.controlcenter Weather -int 8

###############################################################################
# Dock & Mission Control                                                      #
###############################################################################

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 50

# Set the magnification icon size of Dock items
defaults write com.apple.dock largesize -int 100

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Enable magnification
defaults write com.apple.dock magnification -bool true

# Minimize windows using Scale effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Don't show recently used apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Remove all persistent app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Add Downloads folder to the right side of the Dock:
# arrangement 2 = by date added, displayas 0 = stack, showas 1 = fan
defaults write com.apple.dock persistent-others -array \
  '<dict>
    <key>tile-data</key>
    <dict>
      <key>arrangement</key><integer>2</integer>
      <key>displayas</key><integer>0</integer>
      <key>file-label</key><string>Downloads</string>
      <key>file-type</key><integer>2</integer>
      <key>showas</key><integer>1</integer>
      <key>file-data</key>
      <dict>
        <key>_CFURLString</key><string>file://'"$HOME"'/Downloads/</string>
        <key>_CFURLStringType</key><integer>15</integer>
      </dict>
    </dict>
    <key>tile-type</key><string>directory-tile</string>
  </dict>'

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

# Don't automatically switch to a Space that has open windows for an app
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false

# Disable the bottom-right hot corner (Quick Note by default)
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Desktop & Windows                                                           #
###############################################################################

# Hide desktop icons
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true

# Don't reveal desktop by clicking the wallpaper
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Hide widgets on the desktop
defaults write com.apple.WindowManager StandardHideWidgets -bool true

# Tiled windows have no margins
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Don't reopen windows when logging back in
defaults write com.apple.loginwindow TALLogoutSavesState -bool false

###############################################################################
# Siri, Privacy & Sharing                                                     #
###############################################################################

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Don't share Siri & Dictation audio with Apple (1 = opted in, 2 = opted out)
defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -int 2

# Don't share search queries with Apple (Help Apple Improve Search; 2 = opted out)
defaults write com.apple.assistant.support "Search Queries Data Sharing Status" -int 2

# Don't summarize notification previews (Apple Intelligence)
defaults write com.apple.ncprefs summarize_previews -bool false

# Disable personalized ads (on by default when signed in with an Apple Account)
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false

# Disable people suggestions in the Share menu
defaults write com.apple.Sharing SharingPeopleSuggestionsDisabled -bool true

###############################################################################
# Security                                                                    #
###############################################################################

# Touch ID for sudo (sudo_local survives system updates)
if ! grep -q '^auth.*pam_tid.so' /etc/pam.d/sudo_local 2>/dev/null; then
  sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local >/dev/null
fi

# Enable the firewall with stealth mode
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on >/dev/null

# Require the password 5 minutes after sleep or screen saver begins
# (asks for the login password, but only when the delay is not set yet)
if ! sysadminctl -screenLock status 2>&1 | grep -q "screenLock delay is 300 seconds"; then
  sysadminctl -screenLock 300 -password -
fi

###############################################################################
# Software Update                                                             #
###############################################################################

# Install macOS updates and App Store updates automatically
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

###############################################################################
# Power                                                                       #
###############################################################################

# Display sleep: 5 minutes on both battery and AC power
sudo pmset -a displaysleep 5

# Never start the screen saver
defaults -currentHost write com.apple.screensaver idleTime -int 0

###############################################################################
# Screenshots                                                                 #
###############################################################################

mkdir -p ~/Screenshots

# Change screenshots location (screenshots and screen recordings are stored separately)
defaults write com.apple.screencapture location-screenshot "${HOME}/Screenshots"
defaults write com.apple.screencapture location-screenrecording "${HOME}/Screenshots"

# Change screenshots type
defaults write com.apple.screencapture type -string "heic"

###############################################################################
# Time Machine                                                                #
###############################################################################

# Don't offer new disks for Time Machine backup
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
#                                                                             #
# Finder                                                                      #
#                                                                             #
###############################################################################

# Set Downloads as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads"

# Finder: show hidden files and all filename extensions
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show search results in list view
defaults write com.apple.finder FXPreferredSearchViewStyle -string "Nlsv"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning when moving files out of iCloud Drive
defaults write com.apple.bird com.apple.clouddocs.unshared.moveOut.suppress -int 1

# Default arrangement
defaults write com.apple.finder FXPreferredGroupBy -string "Name"

# Delete all .DS_Store files in the home folder, so every folder falls back to the
# default view settings below (this also resets window sizes and icon positions)
find "$HOME" -name .DS_Store -type f -delete 2>/dev/null

# Icon view settings, the same everywhere:
#   StandardViewSettings     folders without their own saved view
#   FK_StandardViewSettings  new windows
#   ICloudViewSettings       iCloud Drive
#   ComputerViewSettings     Computer (Go > Computer)
#   NetworkViewSettings      Network
#   TrashViewSettings        Trash
#   PackageViewSettings      package contents (Show Package Contents)
icon_view_settings='<dict>
  <key>arrangeBy</key><string>name</string>
  <key>gridSpacing</key><real>80</real>
  <key>iconSize</key><real>100</real>
  <key>labelOnBottom</key><true/>
  <key>textSize</key><real>13</real>
  <key>showItemInfo</key><true/>
  <key>showIconPreview</key><true/>
</dict>'
for key in StandardViewSettings FK_StandardViewSettings ICloudViewSettings \
  ComputerViewSettings NetworkViewSettings TrashViewSettings PackageViewSettings; do
  defaults write com.apple.finder "$key" -dict-add IconViewSettings "$icon_view_settings"
done

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show ~/Library in the Finder
chflags nohidden ~/Library

# Expanded sections in Get Info (Cmd+I)
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  Comments -bool true \
  MetaData -bool true \
  Name -bool true \
  OpenWith -bool true \
  Privileges -bool true

###############################################################################
#                                                                             #
# Apple apps                                                                  #
#                                                                             #
###############################################################################

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show all processes, open on the Memory tab
defaults write com.apple.ActivityMonitor ShowCategory -int 100
defaults write com.apple.ActivityMonitor SelectedTab -int 1

# Memory tab column order: name, anonymous, resident size, threads, ports, PID, UID
defaults write com.apple.ActivityMonitor "UserColumnsPerTab v6.0" -dict-add \
  1 '(Command, anonymousMemory, ResidentSize, Threads, Ports, PID, UID)'

###############################################################################
# App Store                                                                   #
###############################################################################

# Don't auto-play video previews in the App Store
defaults write com.apple.AppStore AutoPlayVideoSetting -string "off"
defaults write com.apple.AppStore UserSetAutoPlayVideoSetting -bool true

###############################################################################
# Archive Utility                                                             #
###############################################################################

# Move the archive to the Trash after expanding it
defaults write com.apple.archiveutility dearchive-move-after -string "."
defaults write com.apple.archiveutility dearchive-move-after-location -dict Selection -string "MoveToTrash"

###############################################################################
# Calendar                                                                    #
###############################################################################

# Show declined events
defaults write com.apple.iCal ShowDeclinedEvents -bool true

###############################################################################
# Disk Utility                                                                #
###############################################################################

# Show all devices (not just volumes) in the sidebar
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true

# Show APFS snapshots
defaults write com.apple.DiskUtility WorkspaceShowAPFSSnapshots -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Don't show contact photos in the message list
defaults write com.apple.mail EnableContactPhotos -int 0

# No preview lines in the message list, unread messages in bold
defaults write com.apple.mail NumberOfSnippetLines -int 0
defaults write com.apple.mail ShouldShowUnreadMessagesInBold -bool true

# Don't warn when sending from an address that doesn't match the account domain
defaults write com.apple.mail AlertForNonmatchingDomains -bool false

# Custom flag names (2 = yellow, 3 = green, 5 = purple)
defaults write com.apple.mail FlagNames -dict-add 2 "Set Aside" 3 "Info" 5 "Reply Later"

###############################################################################
# Messages                                                                    #
###############################################################################

# Automatically delete one-time verification codes after use
defaults write com.apple.onetimepasscodes DeleteVerificationCodes -bool true

# Don't summarize messages (Apple Intelligence)
defaults write com.apple.MobileSMS messageSummarizationEnabled -bool false

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when a device is plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Safari                                                                      #
###############################################################################

# Show the link URL at the bottom when hovering (status bar)
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Make Safari's search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari WebKitPreferences.developerExtrasEnabled -bool true

# Disable built-in AutoFill (1Password handles it)
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
defaults write com.apple.Safari AutoFillFromiCloudKeychain -bool false

# Blank homepage and empty new tabs
defaults write com.apple.Safari HomePage -string "about:blank"
defaults write com.apple.Safari NewTabBehavior -int 4

# Compact tab layout
defaults write com.apple.Safari ShowStandaloneTabBar -bool false
defaults write com.apple.Safari EnableNarrowTabs -bool true

# Don't print headers and footers
defaults write com.apple.Safari PrintHeadersAndFooters -bool false

# Don't let websites ask for permission to send notifications
defaults write com.apple.Safari CanPromptForPushNotifications -bool false

# Search: no top-hit preloading, no website-specific search shortcuts
defaults write com.apple.Safari PreloadTopHit -bool false
defaults write com.apple.Safari WebsiteSpecificSearchEnabled -bool false

# Don't open links in apps (Universal Links)
defaults write com.apple.Safari UniversalLinksEnabled -bool false

# Disallow user-installed fonts
defaults write com.apple.Safari WebKitPreferences.shouldAllowUserInstalledFonts -bool false

# Feature flag: don't cap page rendering at 60fps (use full ProMotion refresh rate)
defaults write com.apple.Safari WebKitExperimentalPreferPageRenderingUpdatesNear60FPSEnabled -bool false

###############################################################################
# TextEdit                                                                    #
###############################################################################

# Use plain text mode for new TextEdit documents, UTF-8 encoding
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Always use light background (don't inherit system dark mode)
defaults write com.apple.TextEdit AlwaysLightBackground -bool true

###############################################################################
#                                                                             #
# Third-party apps                                                            #
#                                                                             #
###############################################################################

###############################################################################
# AirBattery                                                                  #
###############################################################################

# Don't show devices in the Dock or the menu bar
defaults write com.lihaoyun6.AirBattery showOn -string "none"

# Read Apple Pencil, iDevices over BLE
defaults write com.lihaoyun6.AirBattery readPencil -bool true
defaults write com.lihaoyun6.AirBattery ideviceOverBLE -bool true

# Read BLE devices
defaults write com.lihaoyun6.AirBattery readBLEDevice -bool true

# Launch at login
defaults write com.lihaoyun6.AirBattery launchAtLogin -bool true

# Don't show the third-party device note again
defaults write com.lihaoyun6.AirBattery neverRemindMe -array "ab.third-party-device.note"

###############################################################################
# AlDente                                                                     #
###############################################################################

# Charge limit 60% (limits below 80% must be explicitly allowed since 1.39)
defaults write com.apphousekitchen.aldente-pro allowChargeLimitsBelow80 -bool true
defaults write com.apphousekitchen.aldente-pro chargeVal -int 60

# Warn about a low charge limit
defaults write com.apphousekitchen.aldente-pro lowChargeLimitWarning -bool true

# Heat protection
defaults write com.apphousekitchen.aldente-pro heatProtectMode -bool true

# Hide the Dock icon
defaults write com.apphousekitchen.aldente-pro showDockIcon -bool false

# Discharge automatically down to the limit
defaults write com.apphousekitchen.aldente-pro automaticDischarge -bool true

# Keep inhibiting charge during sleep and after quitting
defaults write com.apphousekitchen.aldente-pro sleepInhibitCharge -bool true
defaults write com.apphousekitchen.aldente-pro exitInhibitCharge -bool true

# MagSafe LED: off when not charging
defaults write com.apphousekitchen.aldente-pro magsafeOff -int 2

# Menu bar icon style
defaults write com.apphousekitchen.aldente-pro menuBarIconStyle -int 2

# Menu bar: no percentage next to the icon
defaults write com.apphousekitchen.aldente-pro showPercentage -bool false

# Reduce transparency in the UI
defaults write com.apphousekitchen.aldente-pro reduceTransparency -bool true

# No "What's New" after updates
defaults write com.apphousekitchen.aldente-pro showWhatsNewOnUpdate -bool false

# Calibration: charge back to 60% afterwards
defaults write com.apphousekitchen.aldente-pro calibrationBackupPercentage -int 60

###############################################################################
# BetterCapture                                                               #
###############################################################################

# Record the microphone
defaults write com.sattlerjoshua.BetterCapture captureMicrophone -bool true

# MP4 at 30 fps
defaults write com.sattlerjoshua.BetterCapture containerFormat -string "mp4"
defaults write com.sattlerjoshua.BetterCapture frameRate -int 30
# (the output directory is a security-scoped bookmark, it can't be set from here)

###############################################################################
# Dia                                                                         #
###############################################################################

# Don't warn before quitting
defaults write company.thebrowser.dia shouldWarnBeforeQuitting -bool false

# Don't automatically clean up inactive tabs
defaults write company.thebrowser.dia autoCleanInactiveTabsEnabled -bool false

###############################################################################
# Fluor                                                                       #
###############################################################################

# Use F-keys as standard function keys in Rider
defaults write com.pyrolyse.Fluor AppRules -array '{ behavior = 2; id = "com.jetbrains.rider"; path = "/Applications/Rider.app"; }'

# No notification permission popup
defaults write com.pyrolyse.Fluor hideNotificationAuthorizationPopup -bool true

###############################################################################
# Movist Pro                                                                  #
###############################################################################

# Prefer Hungarian audio and subtitles
defaults write com.movist.MovistPro Movist_audiovisualLanguage -string "hun"
defaults write com.movist.MovistPro Movist_subtitleLanguage -string "hun"

# Fill the screen, don't autoplay on entering full screen
defaults write com.movist.MovistPro Movist_fillingType -int 1
defaults write com.movist.MovistPro Movist_playsWhenEnterFullScreen -bool false

# Always-on-top mode
defaults write com.movist.MovistPro Movist_topmostMode -int 2

# Playback: pixel matching, elapsed instead of remaining time
defaults write com.movist.MovistPro Movist_usesPixelMatching -bool true
defaults write com.movist.MovistPro Movist_showsRemainedTime -bool false

# Find related media and subtitle files automatically
defaults write com.movist.MovistPro Movist_findsAllMedia -bool true
defaults write com.movist.MovistPro Movist_findsAllForOne -bool true

# Audio equalizer preset
defaults write com.movist.MovistPro Movist_defaultAudioEQPresetId -int 14

# AirPlay: transcode to HEVC
defaults write com.movist.MovistPro Movist_airPlayTranscodeVideoCodec -string "hevc"

###############################################################################
# Shottr                                                                      #
###############################################################################

# Change screenshots location (the folder is created in the Screenshots section above)
defaults write cc.ffitch.shottr defaultFolder "${HOME}/Screenshots"

# Default filename template
defaults write cc.ffitch.shottr fileNameTemplate 'Screenshot %Y-%m-%d at %H.%M.%S'

# Area capture:      Cmd+Shift+4
defaults write cc.ffitch.shottr KeyboardShortcuts_area -string '{"carbonModifiers":768,"carbonKeyCode":21}'
# Fullscreen:        Cmd+Shift+3
defaults write cc.ffitch.shottr KeyboardShortcuts_fullscreen -string '{"carbonModifiers":768,"carbonKeyCode":20}'
# Window capture:    Cmd+Shift+5
defaults write cc.ffitch.shottr KeyboardShortcuts_anyWindow -string '{"carbonModifiers":768,"carbonKeyCode":23}'
# Scrolling capture: Cmd+Shift+7
defaults write cc.ffitch.shottr KeyboardShortcuts_scrolling -string '{"carbonModifiers":768,"carbonKeyCode":26}'

# After capture: copy to clipboard and save to disk, don't open the editor
defaults write cc.ffitch.shottr afterGrabCopy -int 1
defaults write cc.ffitch.shottr afterGrabSave -int 1
defaults write cc.ffitch.shottr afterGrabShow -int 0

# Esc in the editor saves
defaults write cc.ffitch.shottr saveOnEsc -int 1

# Editor: always on top
defaults write cc.ffitch.shottr alwaysOnTop -int 1

# Editor: growing toolbar
defaults write cc.ffitch.shottr growingToolbar -string "1"

# Use system notifications
defaults write cc.ffitch.shottr notificationType -string "system"

# No telemetry, no intro
defaults write cc.ffitch.shottr allowTelemetry -int 0
defaults write cc.ffitch.shottr showIntro -int 0

###############################################################################
# Things                                                                      #
###############################################################################

# Things is sandboxed and keeps its preferences in its app group container, not in
# ~/Library/Preferences, so address the plist by path (defaults accepts a path
# without the .plist extension as the domain).
things_prefs="$HOME/Library/Group Containers/JLMPQHK86H.com.culturedcode.ThingsMac/Library/Preferences/JLMPQHK86H.com.culturedcode.ThingsMac"

# Quick Entry (default shortcut Ctrl+Space, freed up from input source switching
# in the Keyboard section): new items go to the Inbox
defaults write "$things_prefs" quickEntryDefaultDestination -int 0

# Show calendar events in Today and Upcoming
defaults write "$things_prefs" calendarEventsEnabled -bool true

# Dock badge count: deadlines only (0 = none, 1 = deadlines only, 2 = Today, 3 = Today + Inbox)
defaults write "$things_prefs" badgeCountMode -int 1

# Show Someday items inside Anytime projects
defaults write "$things_prefs" showSomedayTasksInAnytimeProjects -bool true

# Resizing the sidebar keeps the window width
defaults write "$things_prefs" preserveWindowWidthWhenResizingSidebar -bool true

# Enable the things:/// URL scheme
defaults write "$things_prefs" uriSchemeEnabled -bool true

# Shortcuts: don't ask for confirmation when editing or deleting many items
defaults write "$things_prefs" intentsSkipsConfirmationForEditingOrDeletingLargeAmountsOfData -bool true

###############################################################################
# Transmission                                                                #
###############################################################################

mkdir -p ~/Downloads/torrent

# Don't show the legal warning and the donate message on launch
defaults write org.m0k.transmission WarningLegal -bool false
defaults write org.m0k.transmission WarningDonate -bool false

# Change download folder
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/torrent"

# Delete torrent file after adding
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Trash original torrent files
defaults write org.m0k.transmission TrashOriginalTorrent -bool true

# Automatically size window to fit transfers
defaults write org.m0k.transmission AutoSize -bool true

# IP block list
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "https://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Don't ask for confirmation when quitting with active transfers
defaults write org.m0k.transmission CheckQuit -bool false

# Local peer discovery
defaults write org.m0k.transmission LocalPeerDiscoveryGlobal -bool true

# Show the filter bar
defaults write org.m0k.transmission FilterBar -bool true

# Use the compact view
defaults write org.m0k.transmission SmallView -bool true

echo "Done. Restart the Mac to apply the changes."
