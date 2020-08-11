--------------------------------------------------------------
-- ifarm v1
-- by Icewater @ Bronze Dragonflight (EU)
--------------------------------------------------------------
FIRST: To show the iFarm UI, type the following on the console:
	/ifarm show
--------------------------------------------------------------

iFarm is an automatic bag cleaner that cleans your bags of unwanted items automatically, and the items are defined by yourself.

When I go farming in lower level instances I like to auto-loot all items from the mobs instead of picking out the items i need or running out of bagspace and then manually having to delete items to make room.

In order to let me auto-loot and get the unwanted items deleted automatically from my bags I wrote an addon myself called "ifarm". When you load it, it shows a small little window with the text "ifarm" and several function buttons. The "iFarm" text is in red or green, depending wether the auto-delete function is active or not. This window can be hidden if preferred by clicking "close". You can show the window by typing "/ifarm show". You can get a list of commands by typing "/ifarm".

When you first load it, the auto-delete list is empty, but you can add items by dragging them from your bags on the "drag item here" button or you can type: "/ifarm add <item>" or instead of typing the name manually, type "/ifarm add " and then link the item from your bags.

The list gets saved into the localvariables per character so that you don't need to populate the list each time you start the game. When ifarm is enabled (it can be disabled too), and you pick up or move an item in your bags, the auto-delete list will be checked and any item on there will get deleted from your bags. You'd be amazed how long you can keep farming without running out of bagspace in an instance when the unwanted items are being auto-deleted.

When you run an instance 1-2 times, you can get a lot of the grey items or other unwanted items on the list, enabling to really 'farm' the instance without worrying about looting and bagspace, which makes the farming more enjoyable.

To remove items from the list just press the "clear list" button or type '/ifarm clearlist' 
To remove specific items type '/ifarm rem <itemname>' 
You can also list the current items, which will be numbered, allowing you to type '/ifarm rem <itemnumber>

If you farm instances like I like to do from time to time, give it a try and let me know what you think. It's definitely worth it adding the initial 'unwanted' items as you will win your time back very fast.

-------------------------------
-- CHANGELOG
-- V1.0
-------------------------------

* Changed the version compatibility so it does not show up as incompatible for Battle for Azeroth
* Changed to Version 1. This addon has now been working for almost 10 years, I think it's time to call it version 1. :)

-------------------------------
-- CHANGELOG
-- V0.2e
-------------------------------

* Changed the option [SHOW] to false so the window does not come up on cutscenes anymore. Thx for that feedback to EnigmaniteZ!

-------------------------------
-- CHANGELOG
-- V0.2d
-------------------------------

* Small update to be compatible with 4.0.1

-------------------------------
-- CHANGELOG
-- V0.2c

-------------------------------

* Items are now saved with the complete itemString, so no errors after loading a saved list anymore

* Changed the event that triggers a bagCheck to when you finish looting, so there is an accurate count on the number of items auto-deleted 

* Added a line in the interface that shows you how many items have been auto-deleted

-------------------------------
-- CHANGELOG
-- V0.2b

-------------------------------

* Created a UI for easy interaction with iFarm

* Drag & Drop the items to auto-delete now, no more typing like crazy :)

* UI can be scaled through the command line. Press "commands" for a list of supported commands