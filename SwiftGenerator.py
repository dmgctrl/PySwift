import sys, string, UIObjects, datetime, time

class SwiftGenerator:

    def __init__(self):
        self.code = []
        self.tab = "    "
        self.indentLevel = 0
        self.iboutlet = "@IBOutlet var "
        self.labelArray = "[UILabel]! "
        self.buttonArray = "[UIButton]! "
        self.textFieldArray = "[UITextField]! "
        self.ui = UIObjects
        self.clearBackground = "object.backgroundColor = UIColor.clearColor()"
        self.attributeDictionary = " Dictionary<String, AnyObject>"
        self.seperator = ","
        self.unwrap = "!"

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
            color = self.ui.Color(value['red'], value['green'],value['blue'],value['alpha'])
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
            if object.font: set([self.write("object.font = " + object.font.toSwift())]),  self.newline()
            if object.textColor: set([self.write("object.textColor = " + object.textColor)]), self.newline()
            if object.backgroundColor: set([self.write("object.backgroundColor = " + object.backgroundColor)]), self.newline()
            if object.titleColor: set([self.write("object.setTitleColor(" + object.titleColor + ", forState: .Normal)")]), self.newline()
            if object.titleLabel: set([self.write("object.titleLabel?.font = " + object.titleLabel.toSwift())]), self.newline()
            if object.cornerRadius: set([self.write("object.layer.cornerRadius = " + str(object.cornerRadius))]), self.newline()
            if object.borderColor: set([self.write("object.layer.borderColor = " + object.borderColor + ".CGColor")]), self.newline()
            if object.borderWidth: set([self.write("object.layer.borderWidth = " + str(object.borderWidth))]), self.newline()
            if object.titleShadowColor: set([self.write("object.setTitleShadowColor(" + object.titleShadowColor + ", forState: .Normal)")]),self.newline()
            if object.backgroundImage: set([self.write("object.setBackgroundImage(" + object.backgroundImage + ", forState: .Normal)",)]),self.newline(), self.write(self.clearBackground),self.newline()
            self.write("}")
            self.closeFunction()
            self.nextFunction()

    def buildAttributesForObjects(self, objects = []):
        for object in objects:
            self.write("func attributesFor" + object.name + "() -> " + self.attributeDictionary + " { ")
            self.enter()
            self.write("let attributes = [ ")
            self.indent(),self.newline()
            if object.attributedFont: set([self.write("NSFontAttributeName: " + object.attributedFont.toSwift() + self.unwrap)]),self.addSeperator(object),self.newline()
            if object.attributedForegroundColor: set([self.write("NSForegroundColorAttributeName: " + object.attributedForegroundColor)]),self.addSeperator(object),self.newline()
            if object.attributedBackgroundColor: set([self.write("NSBackgroundColorAttributeName: " + object.attributedBackgroundColor)]),self.addSeperator(object),self.newline()
            if object.attributedKerning: set([self.write("NSKernAttributeName: " + str(object.attributedKerning))]),self.addSeperator(object),self.newline()
            if object.attributedLigature: set([self.write("NSLigatureAttributeName: " + str(object.attributedLigature))]),self.addSeperator(object),self.newline()
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
        self.write("class Style: NSObject {\n")
        self.newline()
        self.indent()
        self.write("static let sharedInstance = Style()")
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
