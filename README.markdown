# Tim Rayburn's PowerShell Utilities

This repository includes my various scripts and modules for PowerShell.

## BasicSetup.ps1
This script can be executed to setup a development environment to my liking.  It's aliases to http://bit.ly/tr-dev and can be executed as follows:
```
(new-object Net.WebClient).DownloadString('http://bit.ly/tr-dev') | iex
```

## TRayburn-Utils.psm1
This modules imports the contents of General, Development and TestData to define functions which are useful to me.  They are tested using Pester.

## OSReport
This directory contains three scripts, which are meant to be piped one to another, that scan for packages.config recursively and produces a markdown report of what it finds.  This is a work in progress, but will eventually be able to produce a truly useful report.