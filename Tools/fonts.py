import re

class Icon:

    def __init__(self, name, value):
        self.name = name
        self.value = value

        self.reserved_keywords = ["repeat", "try", "subscript"]

    def clean_name(self):
        parts = self.name.split('-')
        name = parts[0]
        for part in parts[1:]:
            name += part.capitalize()

        if name in self.reserved_keywords or name[0].isdigit():
            name = "_" + name

        return name

    def to_swift(self):
        return "case %s = \"\u{0000%s}\"" % (self.clean_name(), self.value)

    def __repr__(self):
        return "%s (%s)" % (self.name, self.value)


class Font:
    name = None
    regex = None
    filepath = None
    icons = []

    def parse(self):
        self.icons = []
        with open(self.filepath, "r") as f:
            data = f.read()
            regex = re.compile(self.regex)
            for (name, value) in regex.findall(data):
                self.icons.append(Icon(name, value))

    def to_swift(self):
        data = "public enum %sEnum: String, FontIcon {\n\n" % self.name

        data += "    public var fontName: String { return \"%s\" }\n" % self.name

        for icon in self.icons:
            data += "    %s\n" % icon.to_swift()
        data += "}"
        return data

    def write_file(self):
        output_path = "swift/%sEnum.swift" % self.name
        with open(output_path, "w") as f:
            f.write(self.to_swift())


class FontAwesome(Font):
    name = "FontAwesome"
    regex = r'.fa-(?P<name>.*?):before \{\n  content: "\\(?P<value>.*?)";'
    filepath = 'css/font-awesome.css'


class IcoFont(Font):
    name = "IcoFont"
    regex = r'.icofont-(?P<name>.*?):before \{\n\tcontent: "\\(?P<value>.*?)";'
    filepath = 'css/icofont.css'


font = FontAwesome()
font.parse()
font.write_file()

font = IcoFont()
font.parse()
font.write_file()
