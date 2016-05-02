import Foundation

enum FontProperties: String {
    case Name = "font"
    case Size = "size"
}

enum LabelProperties: String {
    case FontStyle = "fontStyle"
}

// MARK: Buttons

enum ButtonProperties: String {
    case FontStyle = "fontStyle"
    case BorderWidth = "borderWidth"
    case BorderColor = "borderColor"
    case CornerRadius = "cornerRadius"
    case TitleColor = "titleColor"
}

enum ButtonAllowedStates: String {
    case Normal = "normalState"
    case Highlighted = "highlightedState"
    case Selected = "selectedState"
    case Disabled = "disabledState"
}

// MARK: Text Fields

enum TextFieldProperties: String {
    case FontStyle = "fontStyle"
    case BorderWidth = "borderWidth"
    case BorderColor = "borderColor"
    case CornerRadius = "cornerRadius"
    case TextAlignment = "textAlignment"
    case BorderStyle = "borderStyle"
    case TextColor = "textColor"
}

// MARK: Segmented Controls

enum SegmentedControlProperties: String {
    case FontStyle = "fontStyle"
    case TintColor = "tintColor"
    case TextColor = "textColor"
}

enum SegmentedControlAllowedStates: String {
    case Normal = "normalState"
    case Selected = "selectedState"
}

// MARK: Sliders

enum SliderProperties: String {
    case MinimumTrackTintColor = "minimumTrackTintColor"
    case MaximumTrackTintColor = "maximumTrackTintColor"
    case ThumbImage = "thumbImage"
    case MinimumTrackImage = "minimumTrackImage"
    case MaximumTrackImage = "maximumTrackImage"
}

// MARK: Steppers

enum StepperProperties: String {
    case TintColor = "tintColor"
    case IncrementImage = "incrementImage"
    case DecrementImage = "decrementImage"
    case BackgroundImage = "backgroundImage"
}

enum StepperAllowedStates: String {
    case Normal = "normalState"
    case Highlighted = "highlightedState"
    case Disabled = "disabledState"
}

// MARK: Progress Views

enum ProgressViewProperties: String {
    case Style = "style"
    case ProgressTintColor = "progressTintColor"
    case TrackTintColor = "trackTintColor"
    case ProgressImage = "progressImage"
    case TrackImage = "trackImage"
}

// MARK: Text Views

enum TextViewProperties: String {
    case TextColor = "textColor"
    case FontStyle = "fontStyle"
    case TextAlignment = "textAlignment"
}

// MARK: Miscellaneous

enum ColorProperties: String {
    case Red = "red"
    case Green = "green"
    case Blue = "blue"
    case Alpha = "alpha"
}

enum UIElements: String {
    case SegmentedControls = "SegmentedControls"
    case TextFields = "TextFields"
    case Buttons = "Buttons"
    case Labels = "Labels"
    case Sliders = "Sliders"
    case Steppers = "Steppers"
    case ProgressViews = "ProgressViews"
    case TextViews = "TextViews"
}

enum CommonObjects: String {
    case Fonts = "Fonts"
    case Colors = "Colors"
    case Images = "Images"
}