# Godot Starter Template

**General-purpose Godot Engine 4.x template for game development.**  
*[4.3-stable](https://godotengine.org/download/archive/4.3-stable/)*

Here is a [style guide](docs/style_guide.md) that goes more in detail on the project structure.

## Getting Started

Clone the project:
```

git clone https://github.com/IncrediboldStudio/godot-starter-template.git

```

# Features

This template project comes with these features out of the box:

## Theme Editor
The Theme Editor plugin allows you to generate theme variations in the editor from the provided colors and fonts.
Uses the [theme_editor.gd](addons\theme_editor\theme_editor.gd) as the new Theme ressource.

## CI/CD

This templates allows you to build your project for both Windows desktop and Web.  

The web version is deployed on [Github Pages](https://pages.github.com/) and is available [here](https://incrediboldstudio.github.io/godot-starter-template/).

*Please note that if you use this template, your deployment URL will look something like ```USERNAME.github.io/REPOSITORY_NAME```*

### Changing the Godot version

You can change the Godot engine version used for the build and deploy workflow by changing the environment variables in the [build-deploy.yaml](.github/workflows/build-deploy.yaml) file.

## Acknowledgments

 - [Panku Console](https://github.com/Ark2000/PankuConsole)
