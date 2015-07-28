TODO
====

CMD
---

The actual app-ps1 command constructs the header line for the command prompt
by getting the info from the App::PS1 module. The actual used prompt is
defined by the $APP_PS1 environment variable.

### $APP_PS1

This is a semi-colon seperated list of plugins that are to be used to make up
the command prompt. The plugins accept JSON formatted arguments after the
name and before the next colon eg:

    APP_PS1='smile;directory{"abreviate":true};uptime'

### Path

An option for directory parameter is to abreviate parent directories

eg:

    # convert
    ~/My/Long/directory/path/to/here
    # to
    ~/M/L/d/p/t/here

Screen
------

Need to fix the current issue with screen realestate where when the output is
too long nothing is shown.

Libraries
---------

The base App::PS1 module provides helper methods for the plugin modules and
loads all the plugins App::PS1::Plugin::* modules.

Daemon
------

The daemon part of PS1 (App::PS1::Daemon) runs in the background processing
last known directories and process counts. When one of the library modules
wants to know the info open the bi-directional socket (/tmp/ps1-$USER.socket),
writing the current directory and reading the number of processes and directory
info.

One daemon is shareable amoungst many command lines for one user.

### Things the Daemon can supply

* Directory info (usage, files, directories)
* Processes (count, number under parent bash?)
* Uptime (uptime when the Daemon starts plus daemon run time)
* Version control repository branch names (git/bzr only)
* Mappings of plugins to $APP_PS1 names
