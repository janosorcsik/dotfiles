#!/usr/bin/env zsh

# Close any open System Settings panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Settings" to quit'

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable "natural" (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Hide icons in menu bar menus
defaults write -g NSMenuEnableActionImages -bool NO

# Disable floating (transparent) sidebar appearance
defaults write -g NSSplitViewItemSidebarDefaultsToFloatingAppearance -bool false

# Disable Big Sur-style window tabs (Solarium)
defaults write -g NSSolariumWindowTabs -bool NO

# Liquid Glass appearance: Tinted
defaults write NSGlobalDomain NSGlassDiffusionSetting -int 1

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Double-click a window title bar to fill the screen
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"

# Full keyboard access: Tab moves focus between all controls in dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable auto-capitalization, auto-period and auto-correct (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# No margins between tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Open dialogs default to list view (macOS has stored this under several keys over time)
defaults write NSGlobalDomain NSNavPanelFileLastListModeForOpenModeKey -int 2
defaults write NSGlobalDomain NavPanelFileListModeForOpenMode -int 2
defaults write NSGlobalDomain NSNavPanelFileListModeForOpenMode2 -int 2

###############################################################################
# Trackpad & Mouse                                                            #
###############################################################################

# Disable three-finger tap (Look up & data detectors)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0

# Magic Mouse: disable smart zoom (one-finger double tap)
defaults write com.apple.AppleMultitouchMouse MouseOneFingerDoubleTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture -int 0

###############################################################################
# Siri                                                                        #
###############################################################################

# Hide Siri from the menu bar and disable "Hey Siri"
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

###############################################################################
# Region & Language                                                           #
###############################################################################

# English UI with Hungarian formats (24h, Monday, metric, Ft)
defaults write NSGlobalDomain AppleLanguages -array "en-US" "hu-HU"
defaults write NSGlobalDomain AppleLocale -string "en_US@rg=huzzzz"

###############################################################################
# Privacy                                                                     #
###############################################################################

# Disable personalized ads
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false

###############################################################################
# Dock                                                                        #
###############################################################################

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 50

# Set the magnification icon size of Dock items
defaults write com.apple.dock largesize -int 100

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Enable magnification
defaults write com.apple.dock magnification -bool true

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

# Enable launch animation
defaults write com.apple.dock launchanim -bool true

# Minimize windows using Scale effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool true

# Don't show recently used apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Disable the bottom-right hot corner (Quick Note by default)
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Finder                                                                      #
###############################################################################

# Set Downloads as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads"

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name (in windows and on the Desktop)
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show search results in list view
defaults write com.apple.finder FXPreferredSearchViewStyle -string "Nlsv"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Set icon view as default
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

# Default arrangement
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"
defaults write com.apple.finder FXPreferredGroupBy -string "Name"

# Desktop icons
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Desktop view settings
defaults write com.apple.finder DesktopViewSettings -dict-add IconViewSettings '
{
    arrangeBy = "name";
    gridSpacing = 80;
    iconSize = 100;
    labelOnBottom = 1;
    textSize = 13;
    showItemInfo = 0;
    showIconPreview = 1;
}'

# Standard view settings for icon view
defaults write com.apple.finder StandardViewSettings -dict-add IconViewSettings '
{
    arrangeBy = "name";
    gridSpacing = 80;
    iconSize = 100;
    labelOnBottom = 1;
    textSize = 13;
    showItemInfo = 0;
    showIconPreview = 1;
}'

# FK_StandardViewSettings for new windows
defaults write com.apple.finder FK_StandardViewSettings -dict-add IconViewSettings '
{
    arrangeBy = "name";
    gridSpacing = 80;
    iconSize = 100;
    textSize = 13;
    showItemInfo = 0;
}'

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

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

# Enable the internal Debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

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

# Don't show the sidebar in new windows
defaults write com.apple.Safari ShowSidebarInNewWindows -bool false

# Show all items in the Reading List
defaults write com.apple.Safari ShowAllItemsInReadingList -bool true

# Require Touch ID / password to view locked Private Browsing tabs
defaults write com.apple.Safari PrivateBrowsingRequiresAuthentication -bool true

# Don't print headers and footers
defaults write com.apple.Safari PrintHeadersAndFooters -bool false

# Don't let websites ask for permission to send notifications
defaults write com.apple.Safari CanPromptForPushNotifications -bool false

# Search: no top-hit preloading, no website-specific search shortcuts
defaults write com.apple.Safari PreloadTopHit -bool false
defaults write com.apple.Safari WebsiteSpecificSearchEnabled -bool false

# Don't open links in apps (Universal Links)
defaults write com.apple.Safari UniversalLinksEnabled -bool false

# Allow pop-ups, disallow user-installed fonts
defaults write com.apple.Safari WebKitPreferences.javaScriptCanOpenWindowsAutomatically -bool true
defaults write com.apple.Safari WebKitPreferences.shouldAllowUserInstalledFonts -bool false

###############################################################################
# Screenshot                                                                  #
###############################################################################

mkdir -p ~/Screenshots

# Change screenshots location
defaults write com.apple.screencapture location "${HOME}/Screenshots"

# Change screenshots type
defaults write com.apple.screencapture type -string "heic"

###############################################################################
# Shottr                                                                      #
###############################################################################

# Change screenshots location
defaults write cc.ffitch.shottr defaultFolder "${HOME}/Screenshots"

# Default filename template
defaults write cc.ffitch.shottr fileNameTemplate 'Screenshot %Y-%m-%d at %H.%M.%S'

# Area capture:      Ctrl+Shift+4
defaults write cc.ffitch.shottr KeyboardShortcuts_area -string '{"carbonModifiers":768,"carbonKeyCode":21}'
# Fullscreen:        Ctrl+Shift+3
defaults write cc.ffitch.shottr KeyboardShortcuts_fullscreen -string '{"carbonModifiers":768,"carbonKeyCode":20}'
# Window capture:    Ctrl+Shift+5
defaults write cc.ffitch.shottr KeyboardShortcuts_anyWindow -string '{"carbonModifiers":768,"carbonKeyCode":23}'
# Scrolling capture: Ctrl+Shift+7
defaults write cc.ffitch.shottr KeyboardShortcuts_scrolling -string '{"carbonModifiers":768,"carbonKeyCode":26}'
# OCR:               Ctrl+Option+Cmd+O
defaults write cc.ffitch.shottr KeyboardShortcuts_ocr -string '{"carbonModifiers":6400,"carbonKeyCode":31}'

# After capture: copy to clipboard and save to disk, don't open the editor
defaults write cc.ffitch.shottr afterGrabCopy -int 1
defaults write cc.ffitch.shottr afterGrabSave -int 1
defaults write cc.ffitch.shottr afterGrabShow -int 0

# Area capture shows a preview first
defaults write cc.ffitch.shottr areaCaptureMode -string "preview"

# Esc in the editor copies and saves
defaults write cc.ffitch.shottr copyOnEsc -int 1
defaults write cc.ffitch.shottr saveOnEsc -int 1

# Editor: always on top, expandable canvas, transparent window shadow
defaults write cc.ffitch.shottr alwaysOnTop -int 1
defaults write cc.ffitch.shottr expandableCanvas -int 1
defaults write cc.ffitch.shottr windowShadow -string "transparent"

# Snapping mode
defaults write cc.ffitch.shottr snappingMode -int 2

# Use system notifications
defaults write cc.ffitch.shottr notificationType -string "system"

# OCR language
defaults write cc.ffitch.shottr primaryOCRLang -string "en-US"

# No telemetry, no intro
defaults write cc.ffitch.shottr allowTelemetry -int 0
defaults write cc.ffitch.shottr showIntro -int 0

###############################################################################
# TextEdit                                                                    #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

###############################################################################
# Transmission                                                                #
###############################################################################

mkdir -p ~/Downloads/torrent

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false

# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

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

# Show the filter bar and status bar
defaults write org.m0k.transmission FilterBar -bool true
defaults write org.m0k.transmission StatusBar -bool true

###############################################################################
# Arc                                                                         #
###############################################################################

# Disable "New Little Arc Window" global hotkey (conflicts with Rider Option+Cmd+N)
defaults write company.thebrowser.Browser globalLittleBrowserHotkeyEnabled -bool false

# Restore windows on relaunch
defaults write company.thebrowser.Browser NSQuitAlwaysKeepsWindows -bool true
defaults write company.thebrowser.Browser arc_quitAlwaysKeepsWindows -bool true

# Don't open external links in Little Arc
defaults write company.thebrowser.Browser openExternalLinksInLittleBrowserEnabled -bool false

# Disable Arc Max auto opt-in, Instant Links, Tidy Tabs, built-in ad block, Share Quote links
defaults write company.thebrowser.Browser arcMaxAutoOptInEnabled -bool false
defaults write company.thebrowser.Browser instantLinksEnabled -bool false
defaults write company.thebrowser.Browser tidyTabsEnabled -bool false
defaults write company.thebrowser.Browser nativeAdBlockEnabled -bool false
defaults write company.thebrowser.Browser shareQuoteLinkEnabled -bool false

# Disable history clusters
defaults write company.thebrowser.Browser disableHistoryClusters -bool true

# App icon
defaults write company.thebrowser.Browser currentAppIconName -string "arc.candy"

###############################################################################
# Keyboard Shortcuts                                                          #
###############################################################################

# "Share..." = Option+Ctrl+S
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Share..." "~^s"

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Arc" \
  "ControlCenter" \
  "Dock" \
  "Finder" \
  "Safari" \
  "Shottr" \
  "SystemUIServer" \
  "TextEdit" \
  "Transmission"; do
  killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
