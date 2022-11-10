# platformer-toolkit
A Godot Project you can use to create your own 2d platformer

## Youtube
### Update
[![Youtube Video](https://img.youtube.com/vi/cnJaiOHai6Q/0.jpg)](https://www.youtube.com/watch?v=cnJaiOHai6Q)

### Original Video + Tutorial (I will update it in a few weeks/months)
[![Youtube Video](https://img.youtube.com/vi/wXCLaRMhl9c/0.jpg)](https://www.youtube.com/watch?v=wXCLaRMhl9c)

## Player:
Control the player with WASD or the Arrow Keys. Jump with Space, W or Up.
You can edit player properties by selecting the node and changing the script variables in the inspector tab

### Double Jump
Activate "Can Double Jump" and you can define the number of jumps the player has

### Gravity
Activate "Can Gravity" and the player reacts to the gravity areas.

If "Can Gravity" isn't activated, the player won't be affected by different gravitys

### Climb
Activite "Can Climb" and you can climb on walls by jumping or falling against them.

While climbing press up or down to climb.

You can stop climbing by walking in the opposite direction of the wall.

Climbing refills your double jump.

You can change the climb speed

### Glide
Activite "Can Glide" and hold up/jump while in air to glide.

If you're gliding in the wind, you'll be carried by it.

You can't climb while gliding. If you're at a wall and want to climb let go of the up/jump button.

## Objects:

### Wind
Place a wind and you can glide in it.

You can scale and rotate to set the size and direction.
The particles will adjust automatically in-game.

You can change the wind speed

### Gravity Area
If "Can Gravity" is activated in the player propertys, the player will be affected be these gravity areas.
Similar to Mario Galaxy.

You can set the gravity direction as a vector or rotate the gravity are. Don't use both, they'll add together.

If "Parent Rotation" is activated, the rotation of the parent node will affect the gravity direction as well.
Turn it off if you want to rotate the parent without affecting the gravity direction.

You shouldn't rely too much on the gravity feature. It's not very refined and doesn't work well together with all other features

### Blockswitch:
Switch the red and blue blocks by walking over this switch

### Cloud:
Semi-solid platform you can jump through from below

### Trampoline/Pink Cloud:
Bouncy Cloud

### Swing
Moving swing.
Set the length, starting side and speed in the propertys.

### Booster
Touch the booster and you'll dash in the direction of your movement.
You can't dash down, you'll make a smaller dash upwards.

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

### Teleporter Area:
Can teleport the player while they are inside.
Under Script Variables, if Required Jump is activated, the player has to jump to be teleported. If not the Player gets teleported directly after entering the area.
In the Destination property you can set the destination. Click on assign and choose a Node. It can be every object, but most of the times you want the destination to be at another door.
If you want the player to be teleported to a specific location, create a Node2D or Position2D Node, place it where you want the player to be teleported to and set this Node as the destination

## Fonts used:
[ codeman38 | cody@zone38.net | http://www.zone38.net/ ]

Copyright 2011, The VT323 Project Authors (peter.hull@oikoi.com)
