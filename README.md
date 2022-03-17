# platformer-toolkit
A Godot Project you can use to create your own 2d platformer

Youtube:

[![Youtube Video](https://img.youtube.com/vi/wXCLaRMhl9c/0.jpg)](https://www.youtube.com/watch?v=wXCLaRMhl9c)

## Objects:

### Blockswitch:
Switch the red and blue blocks by walking over this switch

### Cloud:
Semi-solid platform you can jump through from below

### Trampoline/Pink Cloud:
Bouncy Cloud

### Coin:
Coin the player can collect. Collect all coins to win the game.
The coin counter adjusts automatically

### Death Trigger:
Area that kills the player when they enter it.
Can be used for the death trigger at the bottom of the level or for things like spikes, enemies etc.

### Dialog Area:
Area that displays text while the player is inside.
Write the text in the „text“ property under Script Variables
Can be used for signs or NPCs.
(It’s used for the credits in the menu scene)

### Player:
Control the player with WASD or the Arrow Keys. Jump with Space, W or Up. Smash down with S or Down.
Under Script Variables you can adjust the Move Speed, Jump Height, Jump Time to Peak, Jump Time to Descent and the Extra Jump Count (0 would be a normal jump, 1 a double jump)

### Teleporter Area:
Can teleport the player while they are inside.
Under Script Variables, if Required Jump is activated, the player has to jump to be teleported. If not the Player gets teleported directly after entering the area.
In the Destination property you can set the destination. Click on assign and choose a Node. It can be every object, but most of the times you want the destination to be at another door.
If you want the player to be teleported to a specific location, create a Node2D or Position2D Node, place it where you want the player to be teleported to and set this Node as the destination

## Fonts used:
[ codeman38 | cody@zone38.net | http://www.zone38.net/ ]

Copyright 2011, The VT323 Project Authors (peter.hull@oikoi.com)
