#! /bin/sh

echo 'Start installing...'

variable=`xcode-select -v 2> /dev/null`
rc=$?

if [[ $rc != 0 ]]
then
		echo -e "Installing XCode..."
		xcode-select --install
else
		echo -e "XCode already installed."
fi

variable=`brew -v 2> /dev/null`
rc=$?

if [[ $rc != 0 ]]
then
		echo -e "Installing Homebrew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew doctor
else
		echo -e "Homebrew already installed."
fi
