class_name ColorExtensions

class OKLABColor:
  var l:float
  var a: float
  var b: float
  var alpha: float

  func _init(_l, _a, _b, _alpha):
    l = _l
    a = _a
    b = _b
    alpha = _alpha
  
  func _to_string():
    return "OKLAB(%f,%f,%f,%f)" % [l, a, b, alpha]


#region OKLAB 
# https://gist.github.com/earthbound19/e7fe15fdf8ca3ef814750a61bc75b5ce

static func gamma_to_linear(gamma: float):
  return pow((gamma + 0.055)/1.055, 2.4) if gamma >= 0.04045 else gamma / 12.92

static func rgb_to_oklab(color: Color):
  var r = gamma_to_linear(color.r)
  var g = gamma_to_linear(color.g)
  var b = gamma_to_linear(color.b)

  var l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
  var m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
  var s = 0.0883024619 * r + 0.2817188376 * b + 0.6299787005 * b;

  l = pow(l, 1.0/3.0)
  m = pow(m, 1.0/3.0)
  s = pow(s, 1.0/3.0)

  return OKLABColor.new(
    l * 0.2104542553 + m * 0.7936177850 + s * -0.0040720468,
    l * 1.9779984951 + m * -2.4285922050 + s * 0.4505937099,
    l * 0.0259040371 + m * 0.7827717662 + s * -0.8086757660,
    color.a
  )

#endregion