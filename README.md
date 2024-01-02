# InfiniteFusion-IronmonExtension
Fuse two Pokémon together from the Pokémon Infinite Fusion game.

List of currently available fusions: [infinitefusion.fandom.com](https://infinitefusion.fandom.com/wiki/Pok%C3%A9dex)

## Requirements
- Offline image resources for the fusions (about 350 MB), see [here](#step-1-install-the-fusion-image-resource-files) for details
   - Currently the online Infinite Fusion Calculator is disabled. Until this is fixed, **you must download and install the offline images.**
- [Ironmon-Tracker v8.1.0](https://github.com/besteon/Ironmon-Tracker) or higher

## Install

### Step 1: Install the Fusion Image Resource Files
If you've already downloaded and installed these files, you can skip this entire section.

1) Download from the [Pokémon Infinite Fusion discord](https://discord.gg/infinitefusion) or directly from [Google Drive (November 2023 update)](https://drive.google.com/file/d/1i0_o8xLYO52c-O4OknAcyChxRH-MkWJY/view?usp=drive_link)
2) If you downloaded a `.zip` file, first extract the contents of the `.zip` file into a new folder
3) From inside the extracted folder, look for the **"CustomBattlers"** folder. This is the only folder you'll need, ignore the others.
   - ![image](https://github.com/UTDZac/InfiniteFusion-IronmonExtension/assets/4258818/76c68a85-a688-4286-83aa-5ea9ae4365a8)
4) Move the entire **"CustomBattlers"** folder to your Tracker's extension folder.
   - The folder should appear as: `[YOUR_TRACKER_FOLDER]/extensions/CustomBattlers/`

### Step 2: Install the Tracker Extension
1) Download the [latest release](https://github.com/UTDZac/InfiniteFusion-IronmonExtension/releases/latest) of this extension from the GitHub's Releases page
2) If you downloaded a `.zip` file, first extract the contents of the `.zip` file into a new folder
3) Put the extension file(s) in the existing "**extensions**" folder found inside your Tracker folder
   - The file(s) should appear as: `[YOUR_TRACKER_FOLDER]/extensions/InfiniteFusion.lua`

### Step 3: Enable the Extension
1) On the Tracker settings menu (click the gear icon on the Tracker window), click the "**Extensions**" button
2) In the Extensions menu, enable "**Allow custom code to run**" (if it is currently disabled)
3) Click the "**Install New**" button at the bottom to check for newly installed extensions
   - If you don't see anything in the extensions list, double-check the extension files are installed in the right location. Refer to the Tracker wiki documentation (at the bottom) if you need additional help
4) Click on the "**Infinite Fusion Calculator**" extension button to view the extension
5) From here, you can turn it on or off, as well as check for updates

## How to use
![image](https://github.com/UTDZac/InfiniteFusion-IronmonExtension/assets/4258818/3cdd21d6-edaa-4ca7-b1c1-8a69ddf165c2)

On the main Tracker screen, simply click the Pokémon's name to open the fusion tool. You can also click on the Pokémon icon on the Game Over screen.

![image](https://github.com/UTDZac/InfiniteFusion-IronmonExtension/assets/4258818/7813c329-b57b-44bd-b6c1-069ab8fbae77)

With the fusion overlay open, there are several things you can do:
- Select the 2 Pokémon you want to fuse by clicking on the left & right buttons near the bottom
   - You can randomly select one or both Pokémon using the dice buttons
- Click on the fusion image to see the other fusion, if there is one
- Click on the hamburger menu in the upper-left corner for more options
- Click the X button in the upper-right corner to close the fusion overlay
