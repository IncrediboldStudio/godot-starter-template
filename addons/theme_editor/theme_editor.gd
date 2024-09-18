@tool

class_name ThemeEditor
extends Theme

#region Exports
@export var log_debug: bool = true

@export var variants: Dictionary = {
  "Button": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": true},
  "CheckBox": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": false},
  "CheckButton": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": false},
  "HSlider": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": true},
  "LineEdit": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": false},
  "LinkButton": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": false},
  "PanelContainer":
  {
    "variant_name": ["Background", "Surface", "Primary", "Secondary", "Accent"],
    "colored_text": false
  },
  "ProgressBar": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": true},
  "TabBar":
  {
    "variant_name": ["Background", "Surface", "Primary", "Secondary", "Accent"],
    "colored_text": true
  },
  "TabContainer":
  {
    "variant_name": ["Background", "Surface", "Primary", "Secondary", "Accent"],
    "colored_text": true
  },
  "VSlider": {"variant_name": ["Primary", "Secondary", "Accent"], "colored_text": true},
}

@export_group("Colors")
@export var color_primary: Color = Color.WHITE
@export var color_secondary: Color = Color.WHITE
@export var color_accent: Color = Color.WHITE
@export var color_background: Color = Color.WHITE
@export var color_surface: Color = Color.WHITE
@export var color_text: Color = Color.WHITE

@export_group("Typography")
@export var font_body: Font
@export var font_header: Font
@export var typography_types: Dictionary = {
  "TypographyDisplay": {"font_type": "header", "font_size": 57},
  "TypographyHeadline": {"font_type": "header", "font_size": 32},
  "TypographyTitle": {"font_type": "body", "font_size": 22},
  "TypographyBody": {"font_type": "body", "font_size": 16},
  "TypographyLabel": {"font_type": "body", "font_size": 14},
}
#endregion


func set_styles() -> void:
  if font_body:
    default_font = font_body
  default_font_size = 16
  set_typography_styles()

  for theme_type: StringName in get_type_list():
    if !get_type_variation_base(theme_type):
      set_stylebox_style(theme_type, color_background)
      set_color_style(theme_type, color_text)
      set_icon_style(theme_type, color_background)

  set_variants()
  print("Styles applied")


func set_variants() -> void:
  for variant_key: StringName in variants:
    for variant: StringName in variants.get(variant_key)["variant_name"]:
      match variant:
        "Background":
          set_variant(variant, variant_key, color_background, color_background)
        "Surface":
          set_variant(variant, variant_key, color_surface, color_surface)
        "Primary":
          set_variant(variant, variant_key, color_primary, color_primary)
        "Secondary":
          set_variant(variant, variant_key, color_secondary, color_secondary)
        "Accent":
          set_variant(variant, variant_key, color_accent, color_accent)
        "Transparent":
          set_variant(variant, variant_key, Color.TRANSPARENT, color_text)
        _:
          printerr("Unable to create variant %s for base type %s" % [variant, variant_key])


func set_typography_styles() -> void:
  for key: StringName in typography_types:
    add_type(key)
    set_type_variation(key, "Label")
    set_typography_style(key, key)
    set_color_style(key, color_text)


func set_typography_style(theme_type: StringName, typography_name: StringName) -> void:
  var typography_type: Object = typography_types.get(typography_name)

  match typography_type["font_type"]:
    "header":
      set_font("font", theme_type, font_header)
    "body":
      set_font("font", theme_type, font_body)
    _:
      printerr(
        "Error while parsing font for %s, received $s" % [theme_type, typography_type["font_type"]]
      )
      set_font("font", theme_type, default_font)

  set_font_size("font_size", theme_type, typography_type["font_size"])


func set_variant(variant_name: String, base_type: String, bg_color: Color, color: Color) -> void:
  variant_name = base_type + variant_name
  add_type(variant_name)
  set_type_variation(variant_name, base_type)

  if !get_stylebox_list(base_type).is_empty():
    set_stylebox_style(variant_name, bg_color)

  color = get_text_color(base_type, color, variants[base_type]["colored_text"])
  if !get_color_list(base_type).is_empty():
    set_color_style(variant_name, color)

  if !get_icon_list(base_type).is_empty():
    set_icon_style(variant_name, bg_color)


func set_color_style(theme_type: String, color: Color) -> void:
  var variant_base: StringName = get_type_variation_base(theme_type)
  var colors: PackedStringArray = get_color_list(theme_type)

  if variant_base:
    colors = get_color_list(variant_base)

  for color_name: StringName in colors:
    if color_name.contains("outline") || color_name.contains("shadow"):
      pass

    elif color_name.contains("uneditable"):
      set_color(color_name, theme_type, get_disabled_color(color))

    elif theme_type.contains("LinkButton"):
      if color_name.contains("hover"):
        set_color(color_name, theme_type, get_hover_color(color))

      elif color_name.contains("pressed"):
        set_color(color_name, theme_type, get_pressed_color(color))

      else:
        set_color(color_name, theme_type, color)

    else:
      set_color(color_name, theme_type, color)

    if log_debug:
      print("Applied %s color type to %s/%s" % [color, theme_type, color_name])


func set_stylebox_style(theme_type: String, color: Color) -> void:
  var variant_base: StringName = get_type_variation_base(theme_type)
  var styleboxes: PackedStringArray = get_stylebox_list(theme_type)

  if variant_base:
    styleboxes = get_stylebox_list(variant_base)

  for stylebox_name: StringName in styleboxes:
    var stylebox: StyleBox = get_stylebox(stylebox_name, theme_type)
    if variant_base:
      stylebox = get_stylebox(stylebox_name, variant_base).duplicate()

    if theme_type.contains("LineEdit"):
      var line_edit_color: Color = Color.TRANSPARENT
      set_stylebox_color(stylebox_name, theme_type, stylebox, line_edit_color)
      if stylebox_name.contains("read_only"):
        (stylebox as StyleBoxFlat).border_color = get_disabled_color(color)
      else:
        (stylebox as StyleBoxFlat).border_color = color

    elif theme_type.contains("Tab"):
      set_stylebox_color(stylebox_name, theme_type, stylebox, color)
      if stylebox_name.contains("tab_selected"):
        (stylebox as StyleBoxFlat).border_color = get_pressed_color(color)
      if stylebox_name.contains("tab_unselected"):
        set_stylebox_color(stylebox_name, theme_type, stylebox, color.darkened(0.24))

    elif theme_type.contains("ScrollBar"):
      if stylebox_name.contains("grabber"):
        set_stylebox_color(
          stylebox_name, theme_type, stylebox, get_color_alpha_variant(Color.WHITE, 0.5)
        )
      else:
        set_stylebox_color(
          stylebox_name, theme_type, stylebox, get_color_alpha_variant(Color.WHITE, 0.87)
        )

    elif stylebox_name.contains("disabled"):
      set_stylebox_color(stylebox_name, theme_type, stylebox, get_disabled_color(color))

    elif stylebox_name.contains("focus"):
      set_stylebox_color(stylebox_name, theme_type, stylebox, get_hover_color(color))

    elif stylebox_name.contains("hover"):
      set_stylebox_color(stylebox_name, theme_type, stylebox, get_hover_color(color))

    elif stylebox_name.contains("pressed"):
      set_stylebox_color(stylebox_name, theme_type, stylebox, get_pressed_color(color))

    elif stylebox_name.contains("slider") || stylebox_name.contains("background"):
      var slider_color: Color = get_color_alpha_variant(color.lightened(0.67), 0.24)
      set_stylebox_color(stylebox_name, theme_type, stylebox, slider_color)

    elif stylebox_name.contains("area_highlight"):
      var area_highlight_color: Color = get_hover_color(color)
      set_stylebox_color(stylebox_name, theme_type, stylebox, area_highlight_color)

    else:
      set_stylebox_color(stylebox_name, theme_type, stylebox, color)

    if log_debug:
      print("Applied %s to stylebox type %s/%s" % [color, theme_type, stylebox_name])


func set_icon_style(theme_type: String, color: Color) -> void:
  var variant_base: StringName = get_type_variation_base(theme_type)
  var icons: PackedStringArray = get_icon_list(theme_type)

  if variant_base:
    icons = get_icon_list(variant_base)

  if theme_type.contains("Slider"):
    color = color.lightened(0.67)

  for icon_name: StringName in icons:
    var icon_texture: ImageTexture = set_icon_color(icon_name, theme_type, color)

    if icon_name.contains("disabled"):
      var disabled_color: Color = get_disabled_color(color)
      icon_texture = set_icon_color(icon_name, theme_type, disabled_color)

    set_icon(icon_name, theme_type, icon_texture)

    if log_debug:
      print("Applied %s to icon %s/%s" % [color, theme_type, icon_name])


func get_color_alpha_variant(color: Color, value: float) -> Color:
  color.a = value
  return color


func get_text_color(theme_type: String, base_color: Color, colored_text: bool) -> Color:
  if theme_type.contains("LinkButton"):
    return base_color
  if !colored_text:
    return color_text
  if ColorExtensions.rgb_to_oklab(base_color).l > 0.6:
    return base_color.darkened(0.87)
  return base_color.lightened(0.87)


func set_stylebox_color(
  stylebox_name: String, theme_type: String, stylebox: StyleBox, color: Color
) -> void:
  if stylebox is StyleBoxFlat:
    stylebox.bg_color = color
    if stylebox.get_border_width_min() > 0:
      var border_radius: int = (
        (get_stylebox("normal", theme_type) as StyleBoxFlat).corner_radius_bottom_left
      )
      stylebox.set_corner_radius_all(border_radius)
      stylebox.border_color = color.lightened(0.5)

  elif stylebox is StyleBoxLine:
    stylebox.color = color

  set_stylebox(stylebox_name, theme_type, stylebox)


func set_icon_color(icon_name: String, theme_type: String, color: Color) -> ImageTexture:
  var icon_dir_base: StringName = "res://src/ui/theme/icons"
  var icon_dir: StringName = "%s/%s" % [icon_dir_base, theme_type]
  var variant_base: StringName = get_type_variation_base(theme_type)

  if variant_base:
    icon_dir = "%s/%s" % [icon_dir_base, variant_base]
  if !DirAccess.dir_exists_absolute(icon_dir):
    DirAccess.make_dir_recursive_absolute(icon_dir)

  var image: Image = Image.new()
  var icon_path: StringName = "%s/%s.png" % [icon_dir, icon_name]
  if FileAccess.file_exists(icon_path):
    image = Image.load_from_file(icon_path)
  else:
    var texture: Texture2D = get_icon(icon_name, theme_type)
    image = texture.get_image()
    image.save_png(icon_path)

    if log_debug:
      print("Saved new icon %s" % [icon_path])

  for x: int in image.get_width():
    for y: int in image.get_height():
      var base_color: Color = image.get_pixel(x, y)
      var icon_color: Color = color
      if ColorExtensions.rgb_to_oklab(base_color).l < 0.5:
        icon_color = color.lightened(0.67)
      icon_color.a = base_color.a
      image.set_pixel(x, y, icon_color)

  var icon_texture: ImageTexture = ImageTexture.create_from_image(image)
  ResourceSaver.save(icon_texture, "%s/%s_%s.png" % [icon_dir, theme_type, icon_name])
  return load("%s/%s_%s.png" % [icon_dir, theme_type, icon_name])


func get_hover_color(color: Color) -> Color:
  return color.lightened(0.24)


func get_pressed_color(color: Color) -> Color:
  return color.lightened(0.5)


func get_disabled_color(color: Color) -> Color:
  return get_color_alpha_variant(color.lightened(0.5), 0.67)
