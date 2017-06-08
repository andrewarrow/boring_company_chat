# boring company chat

this is the start of a macOS navtive AppKit cocoa swift3 chat app.

The idea came from https://josephg.com/blog/electron-is-flash-for-the-desktop/

![](screenshot.png)

# require reading

* https://josephg.com/blog/electron-is-flash-for-the-desktop/
* https://slack.com
* https://about.mattermost.com
* https://rocket.chat
* https://ryver.com
* https://www.bitrix24.com
* http://moxtra.com
* https://fleep.io
* https://www.hipchat.com

* https://www.skype.com/
* https://en.wikipedia.org/wiki/AOL_Instant_Messenger
* https://en.wikipedia.org/wiki/ICQ
* https://en.wikipedia.org/wiki/Windows_Live_Messenger
* https://messenger.yahoo.com
* https://www.trillian.im
* https://www.ejabberd.im

# plans

So I want to build an "open source slack replacement" with the following goals:

* Native macOS client first, in swift, with good memory 
* NO WebKit or HTML parsing code, all messages are displayed as text with some cocoa font formating
* Images can be displayed inline, but this will NOT be a mini chrome running.
* Links can be hot, but they will open default browser on the mac
* Offers peer-to-peer no server solution for small teams that can handle that
* Offers slack style company owns the data no peer to peer needed

