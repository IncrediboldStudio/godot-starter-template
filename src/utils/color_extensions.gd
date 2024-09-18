class_name ColorExtensions


class OKLABColor:
  ## range [0,1]
  var l: float

  ## range [-0.4,0.4]
  var a: float

  ## range [-0.4,0.4]
  var b: float

  ## range [0,1]
  var alpha: float

  func _init(_l: float, _a: float, _b: float, _alpha: float) -> void:
    l = _l
    a = _a
    b = _b
    alpha = _alpha

  func _to_string() -> String:
    return "OKLAB(%f,%f,%f,%f)" % [l, a, b, alpha]


#see https://github.com/Evercoder/culori
static func _lrgb_to_oklab(color: Color) -> OKLABColor:
  var l: float = pow(
    0.41222147079999993 * color.r + 0.5363325363 * color.g + 0.0514459929 * color.b, 1.0 / 2.0
  )
  var m: float = pow(
    0.2119034981999999 * color.r + 0.6806995450999999 * color.g + 0.1073969566 * color.b, 1.0 / 2.0
  )
  var s: float = pow(
    0.08830246189999998 * color.r + 0.2817188376 * color.g + 0.6299787005000002 * color.b, 1.0 / 2.0
  )

  return OKLABColor.new(
    0.2104542553 * l + 0.793617785 * m - 0.0040720468 * s,
    1.9779984951 * l - 2.428592205 * m + 0.4505937099 * s,
    0.0259040371 * l + 0.7827717662 * m - 0.808675766 * s,
    color.a
  )


static func rgb_to_oklab(color: Color) -> OKLABColor:
  var oklab: OKLABColor = _lrgb_to_oklab(color)
  if color.r == color.b && color.b == color.g:
    oklab.a = 0
    oklab.b = 0
  return oklab


static func oklab_to_rgb(color: OKLABColor) -> Color:
  var l: float = pow(
    (
      color.l * 0.99999999845051981432
      + 0.39633779217376785678 * color.a
      + 0.21580375806075880339 * color.b
    ),
    3
  )
  var m: float = pow(
    (
      color.l * 1.0000000088817607767
      - 0.1055613423236563494 * color.a
      - 0.063854174771705903402 * color.b
    ),
    3
  )
  var s: float = pow(
    (
      color.l * 1.0000000546724109177
      - 0.089484182094965759684 * color.a
      - 1.2914855378640917399 * color.b
    ),
    3
  )

  return Color(
    4.076741661347994 * l - 3.307711590408193 * m + 0.230969928729428 * s,
    -1.2684380040921763 * l + 2.6097574006633715 * m - 0.3413193963102197 * s,
    -0.004196086541837188 * l - 0.7034186144594493 * m + 1.7076147009309444 * s,
    color.a
  )
