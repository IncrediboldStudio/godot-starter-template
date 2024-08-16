# Style Guide

This style guide is heavily inspired from the [Gamemakin Style Guide](https://github.com/Allar/ue5-style-guide/tree/v2). 
## 1. General Rules  

As a rule of thumb, all names should avoid using characters outside `a-z`, `A-Z`, and `0-9` such as `@`,`.`, `,`, `*`, `#`, diacritics (`é`,`ï`,`ç`) and **spaces** as it can lead to unexpected behavior on other platforms or with source control.  

### 1.1 Casing Conventions
Here are the ways used in this style guide to `CaseWordsWhenNaming` :

> #### PascalCase
> #### PascalCase
> Capitalize every word and remove all spaces, e.g. `StyleGuide`, `ASeriesOfWords`.
> 
> #### camelCase
> The first letter is always lowercase but every following word starts with uppercase, e.g. `styleGuide`, > `aSeriesOfWords`.
> 
> #### snake_case
> Words must be lowercase and are separated by an underscore, e.g. `style_guide`, `a_series_of_words`.
> 
> #### CONSTANT_CASE
> Words must be uppercase and are separated by an underscore, e.g. `STYLE_GUIDE`, `A_SERIES_OF_WORDS`.
  

## 2. Naming Conventions

These naming conventions follow the [Godot Engine style](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html). Breaking these will make your code clash with the built-in naming conventions, leading to inconsistent code.


| Type         | Casing        | Notes                                                |
| ------------ | ------------- | ---------------------------------------------------- |
| File Name    | snake_case    |                                                      |
| Class Name   | snake_case    |                                                      |
| Node Name    | PascalCase    |                                                      |
| Functions    | snake_case    |                                                      |
| Variables    | snake_case    |                                                      |
| Signals      | snake_case    | Should always be in past tense eg. `signal_detected` |
| Constants    | CONSTANT_CASE |                                                      |
| Enums Names  | PascalCase    |                                                      |
| Enum Members | CONSTANT_CASE |                                                      |



### 2.1 Asset Naming Conventions

All assets should have a *Base Asset name*. A base asset name represents a logical grouping of related assets. Any asset that is part of this logical group should follow the standard of `prefix_base_asset_name_variant`.  
Most things are prefixed with prefixes being generally an acronym of the asset type followed by an underscore `_`.

#### 2.1.1 Most Common

| Asset Type   | Prefix | Notes                               |
| ------------ | ------ | ----------------------------------- |
| Scene        | scn_   | Should be in the `scenes` directory |
| UI Control   | ui_    |                                     |
| Material     | mat_   |                                     |
| Texture      | t_     |                                     |
| Mesh         | m_     |                                     |
| Shader       | sh_    |                                     |
| Audio Stream | as_    |                                     |
| Sprite       | spr_   |                                     |
| Sprite Atlas | spra_  |                                     |
| Tile Map     | tm_    |                                     |
| Tile Set     | ts_    |                                     |
| Theme        | th_    | Also for ThemeEditor resources      |

## 3. Direcory Structure

Since we are using the prefix and variant [naming convention](#asset-naming-conventions) explained above, using folders that contains assets of a similar type like `/models` and `/textures` becomes redundant. Instead, creating folders containing assets related under a similar use-case becomes more relevant.

All project-specific assets should exist in the `src` directory to avoid conflicts with migration with third-party addons. Therefore, all third-party addons should be placed in the `addons` directory.

**Here is an example of what your project structure should look like:**

```
|-- art
|   |-- environment
|   |   |-- nature
|   |   |-- building
|   |-- vfx
|   |   |-- post_processing
|   |   |   |-- bloom
|   |   |-- effect
|   |   |   |-- dissolve
|-- audio
|   |-- music
|   |-- sfx
|-- gameplay
|   |-- character
|   |   |-- enemy
|   |   |-- player
|   |-- weapon
|   |   |-- bow
|   |   |-- sword
|-- scenes
|   |-- main_menu
|   |-- loading_screen
|   |-- level_1
|-- system
|   |-- game_settings
|   |   |-- audio
|   |   |-- graphics
|   |-- save
|   |   |-- achievement
|   |   |-- progress
|-- ui
|   |-- theme
|   |   |-- colors
|   |   |-- fonts
|   |-- components
|   |   |-- button
|   |   |-- progress_bar
|-- utils
|   |-- extensions
|   |-- helper
```

### 3.1 Project Folders

Here is an explanation of the top-level folders present in the `src` directory.

#### 3.1.1 Art
In this folder, you should place all assets related to the visual of your game. This include assets like materials, textures and sprites as well as shaders for vfx and post-processing.

#### 3.1.2 Audio
In this folder, you should place all assets related to the audio of your game such as sound effects and bgm.

#### 3.1.3 Gameplay
In this folder, you should place all assets related to components directly impacting the gameplay loop of your game.
Features like the characters, movement, AI and interactables are such examples.

#### 3.1.4 Scenes

#### 3.1.5 System
In this folder, you should place all assets related to components related to the general logic of the program. Such examples include save system, object pools, scene loading etc.

#### 3.1.6 UI
In this folder, you should place all assets related to the user interface, such as Control Nodes, themes and fonts.

#### 3.1.7 Utils
In this folder, you should place all assets related to more generic logic like serialization.

## 4. Code Structure

Every scripts in your project should be organized the following way:

```
01. tool
02. class_name
03. extends
04. # docstring

05. signals
06. enums
07. constants
08. exported variables
09. public variables
10. private variables
11. onready variables

12. optional built-in virtual _init method
13. built-in virtual _ready method
14. remaining built-in virtual methods
15. public methods
16. private methods
```