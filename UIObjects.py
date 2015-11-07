class uiObject:
    def __init__(self, name, type):
        self.name = name
        self.type = type
        self.textColor = None
        self.font = None
        self.backgroundColor = None
        self.titleColor = None
        self.titleLabel = None
        self.cornerRadius = None
        self.borderColor = None
        self.borderWidth = None
        self.titleShadowColor = None
        self.backgroundImage = None
        self.attributes = []
        #
        self.attributedFont = None
        self.attributedBackgroundColor = None
        self.attributedForegroundColor = None
        self.attributedKerning = None
        self.attributedLigature = None
        self.attributedParagraphStyle = None
        self.attributedSuperScript = None
        self.attributedUnderlineStylenderlineStyle = None

class View:
    @property
    def backgroundColor(self):
        if "backgroundColor" in self.properties:
            return (self.properties['backgroundColor'])
    @property
    def borderColor(self):
        if "borderColor" in self.properties:
            return (self.properties['borderColor'])

    @property
    def borderWidth(self):
        if "borderWidth" in self.properties:
            return (self.properties['borderWidth'])

    @property
    def cornerRadius(self):
        if "cornerRadius" in self.properties:
            return (self.properties['cornerRadius'])

    @property
    def type(self):
        return "UIView"

class Normal:
    def __init__(self, name, properties = {}):
        self.name = name
        self.properties = properties

    @property
    def titleColor(self):
        if "titleColor" in self.properties:
            return (self.properties['titleColor'])

    @property
    def state(self):
        return ".Normal"


class Attributes:
    def __init__(self, name, properties = {}):
        self.name = name
        self.properties = properties
        self.seperatorCount = None

    @property
    def font(self):
        if "font" in self.properties:
            return Font(self.properties['font'], self.properties['size'])

    @property
    def foregroundColor(self):
        if "foregroundColor" in self.properties:
            return self.properties['foregroundColor']

    @property
    def backgroundColor(self):
        if "backgroundColor" in self.properties:
            return self.properties['backgroundColor']

    @property
    def kerning(self):
         if "kerning" in self.properties:
            return self.properties['kerning']

    @property
    def ligature(self):
         if "ligature" in self.properties:
            return self.properties['ligature']

class Button(View, Attributes, Normal):
    def __init__(self, name, properties = {}):
        self.name = name
        self.properties = properties

    @property
    def normal(self):
        if "normal" in self.properties:
            return Normal(self.name, self.properties['normal'])

    @property
    def attributes(self):
        if "attributes" in self.properties:
            return Attributes(self.name, self.properties['attributes'])

    @property
    def titleShadowColor(self):
        if "titleShadowColor" in self.properties:
            return (self.properties['titleShadowColor'])

    @property
    def backgroundImage(self):
        if "backgroundImage" in self.properties:
            return (self.properties['backgroundImage'])

    @property
    def titleLabelFont(self):
        if "titleLabelFont" in self.properties:
            return Font(self.properties['titleLabelFont'], self.properties['size'])

    @property
    def type(self):
        return "UIButton"


class Label(View, Attributes):
    def __init__(self, name, properties = {}):
        self.name = name
        self.properties = properties

    @property
    def attributes(self):
        if "attributes" in self.properties:
            return Attributes(self.name, self.properties['attributes'])

    @property
    def textColor(self):
        if "textColor" in self.properties:
            return (self.properties['textColor'])

    @property
    def type(self):
        return "UILabel"

    @property
    def font(self):
        if "font" in self.properties:
            return Font(self.properties['font'], self.properties['size'])

class TextField(View, Attributes):
    def __init__(self, name, properties = {}):
        self.name = name
        self.properties = properties

    @property
    def attributes(self):
        if "attributes" in self.properties:
            return Attributes(self.name, self.properties['attributes'])

    @property
    def textColor(self):
        if "textColor" in self.properties:
            return (self.properties['textColor'])

    @property
    def type(self):
        return "UITextField"



class Font:
    def __init__(self, name, size):
        self.name = name
        self.size = size

    def toSwift(self):
        return "UIFont (name: %s, size: %s)" % (self.name, self.size)

class Color:
    def __init__(self, red, green, blue, alpha):
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha

    def toSwiftRGBA(self):
        return "UIColor(red: %.1f/255.0, green: %.1f/255.0, blue: %.1f/255.0, alpha: %.1f)" % (self.red, self.green, self.blue, self.alpha)

    def rgb_to_hex(self, r,g,b):
        return "#%02X%02X%02X" % (r,g,b)

    def hex_to_rgb(value):
        value = value.lstrip('#')
        lv = len(value)
        return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))