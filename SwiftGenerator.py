from __future__ import division
import sys, string, UIObjects, datetime, time


class SwiftGenerator:

    def __init__(self):
        self.code = []
        self.tab = "    "
        self.indentLevel = 0
        self.iboutlet = "@IBOutlet var "
        self.labelArray = "[UILabel]! "
        self.textViewArray = "[UITextView]! "
        self.viewArray = "[UIView]! "
        self.buttonArray = "[UIButton]! "
        self.textFieldArray = "[UITextField]! "
        self.segmentedControlArray = "[UISegmentedControl]! "
        self.ui = UIObjects
        self.clearBackground = "object.backgroundColor = UIColor.clearColor()"
        self.attributeDictionary = " Dictionary<String, AnyObject>"
        self.seperator = ","

    def end(self):
        return string.join(self.code, "")
        
    def newline(self):
        self.write("\n")

    def enter(self):
        self.indent()
        self.newline()

    def buildFontConstants(self, fontDefinitions = {}):
        for key, value in fontDefinitions.iteritems():
            self.write("let %s: String = \"%s\"" % (key, value))
            self.newline()
        self.newline()

    def buildColorConstants(self, colorDefinitions = {}):
        for key, value in colorDefinitions.iteritems():
            if 'alpha' in value:
                alpha = value['alpha']
            else:
                alpha = 1.0
            if 'hex' in value:
                color = self.ui.HexColor(value['hex'], alpha)
            else:
                color = self.ui.RGBColor(value['red'], value['green'], value['blue'], alpha)

            self.write("let %s = %s" % (key, color.toSwiftRGBA()))
            self.newline()
        self.newline()

    def buildImageConstants(self, imageDefinitions = {}):
        for key, value in imageDefinitions.iteritems():
            image = self.write("let %s = UIImage(named: \"%s\")" % (key, value))
            self.newline()
        self.newline()

    def labelOutletCollections(self, labels = []):
        for label in labels:
            self.write(self.iboutlet + label.name + ": "+ self.labelArray + "{" )
            self.enter()
            self.didSet(label.name)
            self.closeCollection()

    def textViewOutletCollections(self, textViews = []):
        for textView in textViews:
            self.write(self.iboutlet + textView.name + ": "+ self.textViewArray + "{" )
            self.enter()
            self.didSet(textView.name)
            self.closeCollection()

    def viewOutletCollections(self, views = []):
        for view in views:
            self.write(self.iboutlet + view.name + ": "+ self.viewArray + "{" )
            self.enter()
            self.didSet(view.name)
            self.closeCollection()

    def buttonOutletCollections(self, buttons = []):
        for button in buttons:
            self.write(self.iboutlet + button.name + ": "+ self.buttonArray + "{" )
            self.enter()
            self.didSet(button.name)
            self.closeCollection()

    def textFieldOutletCollection(self, textfields = []):
        for textfield in textfields:
            self.write(self.iboutlet + textfield.name + ": "+ self.textFieldArray + "{" )
            self.enter()
            self.didSet(textfield.name)
            self.closeCollection()

    def segmentedControlOutletCollection(self, segmentedControls = []):
        for segmentedControl in segmentedControls:
            self.write(self.iboutlet + segmentedControl.name + ": "+ self.segmentedControlArray + "{" )
            self.enter()
            self.didSet(segmentedControl.name)
            self.closeCollection()
        
    def didSet(self, name):
        self.write("didSet {")
        self.enter()
        self.write("style" + name + "("+ name +")")
        self.newline()
        self.outdent()
        self.write("}")

    def buildStyleFunctions(self, objects = []):
        for object in objects:
            self.write("func style" + object.name + "(objects: [" + object.type + "]) {")
            self.enter()
            self.write("for object in objects {")
            self.newline()
            self.indent()
            if isinstance(object, UIObjects.View):
                if object.backgroundColor: set([self.write("object.backgroundColor = " + object.backgroundColor)]), self.newline()
                if object.cornerRadius: set([self.write("object.layer.cornerRadius = " + str(object.cornerRadius))]), self.newline()
                if object.borderColor: set([self.write("object.layer.borderColor = " + object.borderColor + ".CGColor")]), self.newline()
                if object.borderWidth: set([self.write("object.layer.borderWidth = " + str(object.borderWidth))]), self.newline()
            
            if isinstance(object, UIObjects.Label):
                if object.textColor: set([self.write("object.textColor = " + object.textColor)]), self.newline()
                if object.attributes: set([self.write("object.attributedText = NSAttributedString(string: object.text!, attributes:attributesFor" + object.name + "())")]), self.newline()

            if isinstance(object, UIObjects.TextView):
                if object.attributes: set([self.write("object.attributedText = NSAttributedString(string: object.text!, attributes:attributesFor" + object.name + "())")]), self.newline()
                if object.textColor: set([self.write("object.textColor = " + object.textColor)]), self.newline()
            
            if isinstance(object, UIObjects.Button):
                set([self.write("object.layer.masksToBounds = true")]), self.newline()
                if object.fontStyle: set([self.write("object.titleLabel?.font = " + object.fontStyle.toSwift())]), self.newline()
                if object.cornerRadius: set([self.write("object.layer.cornerRadius = " + str(object.cornerRadius))]), self.newline()
                if object.borderColor: set([self.write("object.layer.borderColor = " + object.borderColor + ".CGColor")]), self.newline()
                if object.borderWidth: set([self.write("object.layer.borderWidth = " + str(object.borderWidth))]), self.newline()
                if object.normalState:
                    if object.normalState.textColor: set([self.write("object.setTitleColor(" + object.normalState.textColor + ", forState: .Normal)")]), self.newline()
                    if object.normalState.titleShadowColor: set([self.write("object.setTitleShadowColor(" + object.normalState.titleShadowColor + ", forState: .Normal)")]),self.newline()
                    if object.normalState.backgroundColor: set([self.write("object.setBackgroundImage(UIImage.imageWithColor(" + object.normalState.backgroundColor + "), forState: .Normal)",)]),self.newline()
                if object.highlightedState:
                    if object.highlightedState.textColor: set([self.write("object.setTitleColor(" + object.highlightedState.textColor + ", forState: .Highlighted)")]), self.newline()
                    if object.highlightedState.titleShadowColor: set([self.write("object.setTitleShadowColor(" + object.highlightedState.titleShadowColor + ", forState: .Highlighted)")]),self.newline()
                    if object.highlightedState.backgroundColor: set([self.write("object.setBackgroundImage(UIImage.imageWithColor(" + object.highlightedState.backgroundColor + "), forState: .Highlighted)",)]),self.newline()
                if object.selectedState:
                    if object.selectedState.textColor: set([self.write("object.setTitleColor(" + object.selectedState.textColor + ", forState: .Selected)")]), self.newline()
                    if object.selectedState.titleShadowColor: set([self.write("object.setTitleShadowColor(" + object.selectedState.titleShadowColor + ", forState: .Selected)")]),self.newline()
                    if object.selectedState.backgroundColor: set([self.write("object.setBackgroundImage(UIImage.imageWithColor(" + object.selectedState.backgroundColor + "), forState: .Selected)",)]),self.newline()

            if isinstance(object, UIObjects.TextField):
                if object.textColor: set([self.write("object.textColor = " + object.textColor)]), self.newline()
                if object.backgroundColor: set([self.write("object.backgroundColor = " + object.backgroundColor)]), self.newline()
                if object.fontStyle: set([self.write("object.font = " + object.fontStyle.toSwift())]),  self.newline()
                if object.textAlignment: set([self.write("object.textAlignment = NSTextAlignment." + object.textAlignment)]), self.newline()
                if object.borderStyle: set([self.write("object.borderStyle = UITextBorderStyle." + object.borderStyle)]), self.newline()
                if object.cornerRadius: set([self.write("object.layer.cornerRadius = " + str(object.cornerRadius))]), self.newline()
                if object.borderColor: set([self.write("object.layer.borderColor = " + object.borderColor + ".CGColor")]), self.newline()
                if object.borderWidth: set([self.write("object.layer.borderWidth = " + str(object.borderWidth))]), self.newline()

            if isinstance(object, UIObjects.SegmentedControl):
                if object.dividerColor: set([self.write("object.setDividerImage(UIImage.imageWithColor(" + object.dividerColor + "), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)")]), self.newline()
                if object.normalState:
                    if object.normalState.backgroundColor: set([self.write("object.setBackgroundImage(UIImage.imageWithColor(" + object.normalState.backgroundColor + "), forState: .Normal, barMetrics: .Default)")]), self.newline()
                    if object.normalState.textColor: set([self.write("object.setTitleTextAttributes([NSFontAttributeName: " + object.fontStyle.toSwift() + "!, NSForegroundColorAttributeName: " + object.normalState.textColor + "], forState: .Normal)")]),self.newline()
                if object.highlightedState:
                    if object.highlightedState.backgroundColor: set([self.write("object.setBackgroundImage(UIImage.imageWithColor(" + object.highlightedState.backgroundColor + "), forState: .Highlighted, barMetrics: .Default)")]), self.newline()
                    if object.highlightedState.textColor: set([self.write("object.setTitleTextAttributes([NSFontAttributeName: " + object.fontStyle.toSwift() + "!, NSForegroundColorAttributeName: " + object.highlightedState.textColor + "], forState: .Highlighted)")]),self.newline()
                if object.selectedState:
                    if object.selectedState.backgroundColor: set([self.write("object.setBackgroundImage(UIImage.imageWithColor(" + object.selectedState.backgroundColor + "), forState: .Selected, barMetrics: .Default)")]), self.newline()
                    if object.selectedState.textColor: set([self.write("object.setTitleTextAttributes([NSFontAttributeName: " + object.fontStyle.toSwift() + "!, NSForegroundColorAttributeName: " + object.selectedState.textColor + "], forState: .Selected)")]),self.newline()
            self.outdent()
            self.write("}")
            self.closeFunction()
            self.nextFunction()

    def buildAttributesForObjects(self, objects = []):
        for object in objects:
            attributes = object.attributes
            self.write("func attributesFor" + object.name + "() -> " + self.attributeDictionary + " { ")
            self.enter()
            if object.textAlignment or attributes.lineSpacing:
                set([self.write("let style = NSMutableParagraphStyle()")]),self.newline()
                if object.textAlignment:
                    set([self.write("style.alignment = NSTextAlignment." + object.textAlignment)]),self.newline()
                if attributes.lineSpacing:
                    set([self.write("style.lineSpacing = " + str(attributes.lineSpacing))]),self.newline()
            self.write("let attributes = [ ")
            self.indent(),self.newline()
            if isinstance(attributes, UIObjects.TextAttributes):
                attributes.seperatorCount = len(attributes.properties) - 1
                if attributes.fontStyle: set([self.write("NSFontAttributeName: " + attributes.fontStyle.toSwift() + "!")]),self.addSeperator(attributes),self.newline()
                if attributes.tracking:
                    characterSpacing = attributes.fontStyle.size * attributes.tracking / 1000
                    set([self.write("NSKernAttributeName: " + str(characterSpacing))]),self.addSeperator(attributes),self.newline()
                if object.textAlignment or attributes.lineSpacing:
                    set([self.write("NSParagraphStyleAttributeName: style")]),self.addSeperator(attributes),self.newline()
                if attributes.ligature: set([self.write("NSLigatureAttributeName: " + str(attributes.ligature))]),self.addSeperator(attributes),self.newline()
            self.outdent()
            self.write(" ]")
            self.newline()
            self.write("return attributes")
            self.closeFunction()
            self.nextFunction()

    def addSeperator(self, object):
        count = object.seperatorCount
        if count > 0:
            self.append(self.seperator)
            count = count - 1
            object.seperatorCount = count

    def append(self, string):
        self.code.append(string)

    def write(self, string):
        self.code.append(self.tab * self.indentLevel + string)
        
    def indent(self):
        self.indentLevel = self.indentLevel + 1

    def outdent(self):
        if self.indentLevel == 0:
            raise SyntaxError, "internal error in code generator"
        self.indentLevel = self.indentLevel - 1

    def nextFunction(self):
        self.indentLevel = 0
        self.enter()
        self.newline()

    def closeFunction(self):
        self.newline()
        self.outdent()
        self.write("}")

    def openClass(self):
        self.write("import UIKit\n")
        self.newline()
        self.write("class StyleKit: NSObject {\n")
        self.newline()
        self.indent()
        self.write("static let sharedInstance = StyleKit()")
        self.newline()
        self.newline()

    def closeCollection(self):
        self.newline()
        self.outdent()
        self.write("}")
        self.newline()
        self.newline()

    def closeClass(self):
        self.indentLevel = 0
        self.write("}")
