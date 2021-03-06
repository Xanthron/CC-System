ui.style = {}
---@return style
local function newStyle()
    ---@class style
    local this = {}
    ---@class style.label
    local label = {}
    label.align = 1
    ---@class style.label.theme
    local label_normal = {prefix = "", suffix = "", tC = colors.black, tBG = colors.white}
    ---@type style.label.theme
    local label_disabled = {prefix = "", suffix = "", tC = colors.gray, tBG = colors.white}
    ---@type style.label.theme
    local label_selected = {prefix = "", suffix = "", tC = colors.black, tBG = colors.orange}
    label.nTheme = label_normal
    label.dTheme = label_disabled
    label.sTheme = label_selected
    this.label = label

    ---@class style.button
    local button = {}
    button.align = 5
    ---@class style.button.theme
    local button_normal = {
        tC = colors.lightBlue,
        tBG = colors.blue,
        bC = colors.lightBlue,
        bBG = colors.blue,
        b = {
            {},
            {},
            {},
            {">", " "},
            {" "},
            {" ", "<"},
            {},
            {},
            {}
        }
    }
    ---@type style.button.theme
    local button_disabled = {
        tC = colors.lightGray,
        tBG = colors.gray,
        bC = colors.lightGray,
        bBG = colors.gray,
        b = {
            {},
            {},
            {},
            {"x", " "},
            {" "},
            {" ", "x"},
            {},
            {},
            {}
        }
    }
    ---@type style.button.theme
    local button_selected = {
        tC = colors.white,
        tBG = colors.blue,
        bC = colors.white,
        bBG = colors.blue,
        b = {
            {},
            {},
            {},
            {"\16", " "},
            {" "},
            {" ", "\17"},
            {},
            {},
            {}
        }
    }
    ---@type style.button.theme
    local button_pressed = {
        tC = colors.white,
        tBG = colors.lightBlue,
        bC = colors.white,
        bBG = colors.lightBlue,
        b = {
            {},
            {},
            {},
            {" ", "\16"},
            {" "},
            {"\17", " "},
            {},
            {},
            {}
        }
    }
    button.nTheme = button_normal
    button.dTheme = button_disabled
    button.sTheme = button_selected
    button.pTheme = button_pressed
    this.button = button

    ---@class style.toggle
    local toggle = {}
    toggle.align = 1
    ---@class style.toggle.theme
    local toggle_normal = {
        tC = colors.black,
        tBG = colors.white,
        uncheckedL = {" ", "O", " "},
        uncheckedLC = {colors.white, colors.lightBlue, colors.white},
        uncheckedLBG = {colors.white, colors.blue, colors.white},
        checkedL = {" ", "X", " "},
        checkedLC = {colors.white, colors.orange, colors.white},
        checkedLBG = {colors.white, colors.red, colors.white}
    }
    ---@type style.toggle.theme
    local toggle_disabled = {
        tC = colors.gray,
        tBG = colors.white,
        uncheckedL = {"*", "O", "*"},
        uncheckedLC = {colors.white, colors.gray, colors.white},
        uncheckedLBG = {colors.gray, colors.lightGray, colors.gray},
        checkedL = {"*", "X", "*"},
        checkedLC = {colors.white, colors.gray, colors.white},
        checkedLBG = {colors.gray, colors.lightGray, colors.gray}
    }
    ---@type style.toggle.theme
    local toggle_selected = {
        tC = colors.orange,
        tBG = colors.white,
        uncheckedL = {">", "O", "< "},
        uncheckedLC = {colors.orange, colors.white, colors.orange},
        uncheckedLBG = {colors.white, colors.blue, colors.white},
        checkedL = {">", "X", "<"},
        checkedLC = {colors.orange, colors.white, colors.orange},
        checkedLBG = {colors.white, colors.red, colors.white}
    }
    ---@type style.toggle.theme
    local toggle_pressed = {
        tC = colors.orange,
        tBG = colors.white,
        uncheckedL = {">", "X", "<"},
        uncheckedLC = {colors.orange, colors.white, colors.orange},
        uncheckedLBG = {colors.white, colors.orange, colors.white},
        checkedL = {">", "O", "<"},
        checkedLC = {colors.orange, colors.white, colors.orange},
        checkedLBG = {colors.white, colors.lightBlue, colors.white}
    }
    toggle.nTheme = toggle_normal
    toggle.dTheme = toggle_disabled
    toggle.sTheme = toggle_selected
    toggle.pTheme = toggle_pressed
    this.toggle = toggle

    ---@class style.slider
    local slider = {}
    ---@class style.slider.theme
    local slider_normal = {
        sliderT = {"|", "#", "|"},
        sliderTC = {colors.lightGray, colors.lightGray, colors.lightGray},
        sliderTBG = {colors.gray, colors.gray, colors.gray},
        handleL = {"|", "#", "|"},
        handleLC = {colors.lightGray, colors.gray, colors.lightGray},
        handleLBG = {colors.lightGray, colors.black, colors.lightGray}
    }
    ---@class style.slider.button
    local slider_normal_buttonPositive = {}
    ---@class style.slider.button.theme
    local slider_normal_buttonPositive_normal = {
        t = {"[", "A", "]"},
        tC = {colors.lightBlue, colors.lightBlue, colors.lightBlue},
        tBG = {colors.blue, colors.blue, colors.blue}
    }
    ---@type style.slider.button.theme
    local slider_normal_buttonPositive_disabled = {
        t = {"[", "A", "]"},
        tC = {colors.lightGray, colors.lightGray, colors.lightGray},
        tBG = {colors.gray, colors.gray, colors.gray}
    }
    ---@type style.slider.button.theme
    local slider_normal_buttonPositive_selected = {
        t = {"[", "A", "]"},
        tC = {colors.white, colors.white, colors.white},
        tBG = {colors.blue, colors.blue, colors.blue}
    }
    slider_normal_buttonPositive.nTheme = slider_normal_buttonPositive_normal
    slider_normal_buttonPositive.dTheme = slider_normal_buttonPositive_disabled
    slider_normal_buttonPositive.sTheme = slider_normal_buttonPositive_selected
    ---@type style.slider.button
    local slider_normal_buttonNegative = {}
    ---@type style.slider.button.theme
    local slider_normal_buttonNegative_normal = {
        t = {"[", "A", "]"},
        tC = {colors.lightBlue, colors.lightBlue, colors.lightBlue},
        tBG = {colors.blue, colors.blue, colors.blue}
    }
    ---@type style.slider.button.theme
    local slider_normal_buttonNegative_disabled = {
        t = {"[", "A", "]"},
        tC = {colors.lightGray, colors.lightGray, colors.lightGray},
        tBG = {colors.gray, colors.gray, colors.gray}
    }
    ---@type style.slider.button.theme
    local slider_normal_buttonNegative_selected = {
        t = {"[", "A", "]"},
        tC = {colors.white, colors.white, colors.white},
        tBG = {colors.blue, colors.blue, colors.blue}
    }
    slider_normal_buttonNegative.nTheme = slider_normal_buttonNegative_normal
    slider_normal_buttonNegative.dTheme = slider_normal_buttonNegative_disabled
    slider_normal_buttonNegative.sTheme = slider_normal_buttonNegative_selected
    slider_normal.buttonP = slider_normal_buttonPositive
    slider_normal.buttonN = slider_normal_buttonNegative
    ---@type style.slider.theme
    local slider_disabled = {
        sliderT = {"|", "#", "|"},
        sliderTC = {colors.lightGray, colors.lightGray, colors.lightGray},
        sliderTBG = {colors.gray, colors.gray, colors.gray},
        handleL = {"|", "#", "|"},
        handleLC = {colors.lightGray, colors.gray, colors.lightGray},
        handleLBG = {colors.lightGray, colors.black, colors.lightGray}
    }
    ---@type style.slider.button
    local slider_disabled_buttonPositive = {}
    ---@type style.slider.button
    local slider_disabled_buttonNegative = {}
    slider_disabled_buttonPositive.dTheme = slider_normal_buttonPositive_disabled
    slider_disabled_buttonNegative.dTheme = slider_normal_buttonNegative_disabled
    slider_disabled.buttonP = slider_disabled_buttonPositive
    slider_disabled.buttonN = slider_disabled_buttonNegative
    slider.nTheme = slider_normal
    slider.dTheme = slider_disabled
    this.slider = slider

    ---@class style.textBox
    local textBox = {}
    ---@type style.label
    textBox.label = table.copy(this.label)
    textBox.label.nTheme.tBG = colors.green
    textBox.label.nTheme.tC = colors.lime
    textBox.label.dTheme.tBG = colors.gray
    textBox.label.dTheme.tC = colors.lightGray
    textBox.label.dTheme.prefix = "*"
    textBox.label.dTheme.suffix = "*"
    textBox.label.sTheme.tBG = colors.green
    textBox.label.sTheme.tC = colors.yellow
    textBox.label.sTheme.prefix = ">"
    textBox.label.sTheme.suffix = "<"
    ---@type style.label
    textBox.text = table.copy(this.label)
    textBox.text.nTheme.tBG = colors.white
    textBox.text.nTheme.tC = colors.black
    textBox.text.dTheme.tBG = colors.white
    textBox.text.dTheme.tC = colors.black
    textBox.text.sTheme.tBG = colors.white
    textBox.text.sTheme.tC = colors.black
    ---@type style.slider
    textBox.slider = table.copy(this.slider)
    textBox.slider.nTheme.buttonP.nTheme.t = {string.char(30)}
    textBox.slider.nTheme.buttonP.nTheme.tC = {colors.white}
    textBox.slider.nTheme.buttonP.nTheme.tBG = {colors.lime}
    textBox.slider.nTheme.buttonP.sTheme.t = {string.char(30)}
    textBox.slider.nTheme.buttonP.sTheme.tC = {colors.yellow}
    textBox.slider.nTheme.buttonP.sTheme.tBG = {colors.lime}
    textBox.slider.nTheme.buttonP.dTheme.t = {string.char(30)}
    textBox.slider.nTheme.buttonP.dTheme.tC = {colors.gray}
    textBox.slider.nTheme.buttonP.dTheme.tBG = {colors.lime}
    textBox.slider.nTheme.buttonN.nTheme.t = {string.char(31)}
    textBox.slider.nTheme.buttonN.nTheme.tC = {colors.white}
    textBox.slider.nTheme.buttonN.nTheme.tBG = {colors.lime}
    textBox.slider.nTheme.buttonN.sTheme.t = {string.char(31)}
    textBox.slider.nTheme.buttonN.sTheme.tC = {colors.yellow}
    textBox.slider.nTheme.buttonN.sTheme.tBG = {colors.lime}
    textBox.slider.nTheme.buttonN.dTheme.t = {string.char(31)}
    textBox.slider.nTheme.buttonN.dTheme.tC = {colors.gray}
    textBox.slider.nTheme.buttonN.dTheme.tBG = {colors.lime}
    textBox.slider.nTheme.sliderT = {string.char(127)}
    textBox.slider.nTheme.sliderTC = {colors.lightGray}
    textBox.slider.nTheme.sliderTBG = {colors.lime}
    textBox.slider.nTheme.handleL = {"#"}
    textBox.slider.nTheme.handleLC = {colors.gray}
    textBox.slider.nTheme.handleLBG = {colors.green}
    textBox.slider.dTheme.buttonP.dTheme.t = {string.char(30)}
    textBox.slider.dTheme.buttonP.dTheme.tC = {colors.lightGray}
    textBox.slider.dTheme.buttonP.dTheme.tBG = {colors.gray}
    textBox.slider.dTheme.buttonN.dTheme.t = {string.char(31)}
    textBox.slider.dTheme.buttonN.dTheme.tC = {colors.lightGray}
    textBox.slider.dTheme.buttonN.dTheme.tBG = {colors.gray}
    textBox.slider.dTheme.sliderT = {string.char(127)}
    textBox.slider.dTheme.sliderTC = {colors.lightGray}
    textBox.slider.dTheme.sliderTBG = {colors.gray}
    textBox.slider.dTheme.handleL = {"#"}
    textBox.slider.dTheme.handleLC = {colors.gray}
    textBox.slider.dTheme.handleLBG = {colors.gray}
    ---@class style.textBox.theme
    local textBox_normal = {
        sTC = colors.white,
        bC = colors.lime,
        bBG = colors.green,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+", "|", "+"},
            {"-", " ", "-"},
            {"+", "|", "+"}
        }
    }
    ---@type style.textBox.theme
    local textBox_disabled = {
        sTC = colors.white,
        bC = colors.lightGray,
        bBG = colors.gray,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+", "|", "+"},
            {"-", " ", "-"},
            {"+", "|", "+"}
        }
    }
    ---@type style.textBox.theme
    local textBox_selected = {
        sTC = colors.white,
        bC = colors.lime,
        bBG = colors.green,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+", "|", "+"},
            {"-", " ", "-"},
            {"+", "|", "+"}
        }
    }
    textBox.nTheme = textBox_normal
    textBox.dTheme = textBox_disabled
    textBox.sTheme = textBox_selected
    this.textBox = textBox

    ---@class style.scrollView
    local scrollView = {}
    ---@type style.label
    scrollView.label = table.copy(this.label)
    ---@type style.slider
    scrollView.sliderV = table.copy(this.slider)
    scrollView.sliderV.nTheme.buttonP.nTheme.t = {string.char(30)}
    scrollView.sliderV.nTheme.buttonP.nTheme.tC = {colors.white}
    scrollView.sliderV.nTheme.buttonP.nTheme.tBG = {colors.lime}
    scrollView.sliderV.nTheme.buttonP.sTheme.t = {string.char(30)}
    scrollView.sliderV.nTheme.buttonP.sTheme.tC = {colors.yellow}
    scrollView.sliderV.nTheme.buttonP.sTheme.tBG = {colors.lime}
    scrollView.sliderV.nTheme.buttonP.dTheme.t = {string.char(30)}
    scrollView.sliderV.nTheme.buttonP.dTheme.tC = {colors.gray}
    scrollView.sliderV.nTheme.buttonP.dTheme.tBG = {colors.lime}
    scrollView.sliderV.nTheme.buttonN.nTheme.t = {string.char(31)}
    scrollView.sliderV.nTheme.buttonN.nTheme.tC = {colors.white}
    scrollView.sliderV.nTheme.buttonN.nTheme.tBG = {colors.lime}
    scrollView.sliderV.nTheme.buttonN.sTheme.t = {string.char(31)}
    scrollView.sliderV.nTheme.buttonN.sTheme.tC = {colors.yellow}
    scrollView.sliderV.nTheme.buttonN.sTheme.tBG = {colors.lime}
    scrollView.sliderV.nTheme.buttonN.dTheme.t = {string.char(31)}
    scrollView.sliderV.nTheme.buttonN.dTheme.tC = {colors.gray}
    scrollView.sliderV.nTheme.buttonN.dTheme.tBG = {colors.lime}
    scrollView.sliderV.nTheme.sliderT = {string.char(127)}
    scrollView.sliderV.nTheme.sliderTC = {colors.lightGray}
    scrollView.sliderV.nTheme.sliderTBG = {colors.lime}
    scrollView.sliderV.nTheme.handleL = {"#"}
    scrollView.sliderV.nTheme.handleLC = {colors.gray}
    scrollView.sliderV.nTheme.handleLBG = {colors.green}
    scrollView.sliderV.dTheme.buttonP.dTheme.t = {string.char(30)}
    scrollView.sliderV.dTheme.buttonP.dTheme.tC = {colors.lightGray}
    scrollView.sliderV.dTheme.buttonP.dTheme.tBG = {colors.gray}
    scrollView.sliderV.dTheme.buttonN.dTheme.t = {string.char(31)}
    scrollView.sliderV.dTheme.buttonN.dTheme.tC = {colors.lightGray}
    scrollView.sliderV.dTheme.buttonN.dTheme.tBG = {colors.gray}
    scrollView.sliderV.dTheme.sliderT = {string.char(127)}
    scrollView.sliderV.dTheme.sliderTC = {colors.lightGray}
    scrollView.sliderV.dTheme.sliderTBG = {colors.gray}
    scrollView.sliderV.dTheme.handleL = {"#"}
    scrollView.sliderV.dTheme.handleLC = {colors.gray}
    scrollView.sliderV.dTheme.handleLBG = {colors.gray}
    ---@type style.slider
    scrollView.sliderH = table.copy(this.slider)
    scrollView.sliderH.nTheme.buttonP.nTheme.t = {string.char(17)}
    scrollView.sliderH.nTheme.buttonP.nTheme.tC = {colors.white}
    scrollView.sliderH.nTheme.buttonP.nTheme.tBG = {colors.lime}
    scrollView.sliderH.nTheme.buttonP.sTheme.t = {string.char(17)}
    scrollView.sliderH.nTheme.buttonP.sTheme.tC = {colors.yellow}
    scrollView.sliderH.nTheme.buttonP.sTheme.tBG = {colors.lime}
    scrollView.sliderH.nTheme.buttonP.dTheme.t = {string.char(17)}
    scrollView.sliderH.nTheme.buttonP.dTheme.tC = {colors.gray}
    scrollView.sliderH.nTheme.buttonP.dTheme.tBG = {colors.lime}
    scrollView.sliderH.nTheme.buttonN.nTheme.t = {string.char(16)}
    scrollView.sliderH.nTheme.buttonN.nTheme.tC = {colors.white}
    scrollView.sliderH.nTheme.buttonN.nTheme.tBG = {colors.lime}
    scrollView.sliderH.nTheme.buttonN.sTheme.t = {string.char(16)}
    scrollView.sliderH.nTheme.buttonN.sTheme.tC = {colors.yellow}
    scrollView.sliderH.nTheme.buttonN.sTheme.tBG = {colors.lime}
    scrollView.sliderH.nTheme.buttonN.dTheme.t = {string.char(16)}
    scrollView.sliderH.nTheme.buttonN.dTheme.tC = {colors.gray}
    scrollView.sliderH.nTheme.buttonN.dTheme.tBG = {colors.lime}
    scrollView.sliderH.nTheme.sliderT = {string.char(127)}
    scrollView.sliderH.nTheme.sliderTC = {colors.lightGray}
    scrollView.sliderH.nTheme.sliderTBG = {colors.lime}
    scrollView.sliderH.nTheme.handleL = {"#"}
    scrollView.sliderH.nTheme.handleLC = {colors.gray}
    scrollView.sliderH.nTheme.handleLBG = {colors.green}
    scrollView.sliderH.dTheme.buttonP.dTheme.t = {string.char(17)}
    scrollView.sliderH.dTheme.buttonP.dTheme.tC = {colors.lightGray}
    scrollView.sliderH.dTheme.buttonP.dTheme.tBG = {colors.gray}
    scrollView.sliderH.dTheme.buttonN.dTheme.t = {string.char(16)}
    scrollView.sliderH.dTheme.buttonN.dTheme.tC = {colors.lightGray}
    scrollView.sliderH.dTheme.buttonN.dTheme.tBG = {colors.gray}
    scrollView.sliderH.dTheme.sliderT = {string.char(127)}
    scrollView.sliderH.dTheme.sliderTC = {colors.lightGray}
    scrollView.sliderH.dTheme.sliderTBG = {colors.gray}
    scrollView.sliderH.dTheme.handleL = {"#"}
    scrollView.sliderH.dTheme.handleLC = {colors.gray}
    scrollView.sliderH.dTheme.handleLBG = {colors.gray}
    ---@class style.scrollView.theme
    local scrollView_normal = {
        tC = colors.lime,
        tBG = colors.green,
        spaceTextColor = colors.white,
        spaceBackgroundColor = colors.white,
        bC = colors.lime,
        bBG = colors.green,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+"},
            {"-"},
            {"+"}
        }
    }
    ---@type style.scrollView.theme
    local scrollView_disabled = {
        tC = colors.lightGray,
        tBG = colors.gray,
        spaceTextColor = colors.white,
        spaceBackgroundColor = colors.white,
        bC = colors.lightGray,
        bBG = colors.gray,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+"},
            {"-"},
            {"+"}
        }
    }
    ---@type style.scrollView.theme
    local scrollView_selected = {
        tC = colors.yellow,
        tBG = colors.green,
        spaceTextColor = colors.white,
        spaceBackgroundColor = colors.white,
        bC = colors.lime,
        bBG = colors.green,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+"},
            {"-"},
            {"+"}
        }
    }
    scrollView.nTheme = scrollView_normal
    scrollView.dTheme = scrollView_disabled
    scrollView.sTheme = scrollView_selected
    this.scrollView = scrollView

    ---@class style.inputField
    local inputField = {}
    inputField.align = 1
    ---@type style.label
    inputField.label = table.copy(this.label)
    inputField.label.nTheme.tC = colors.lime
    inputField.label.nTheme.tBG = colors.green
    inputField.label.sTheme.tC = colors.yellow
    inputField.label.sTheme.tBG = colors.green
    ---@class style.inputField.theme
    local inputField_normal = {
        tC = colors.white,
        tBG = colors.black,
        sTC = colors.white,
        bC = colors.lime,
        bBG = colors.green,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+"},
            {"-"},
            {"+"}
        }
    }
    ---@type style.inputField.theme
    local inputField_disabled = {
        tC = colors.lightGray,
        tBG = colors.gray,
        sTC = colors.white,
        bC = colors.lightGray,
        bBG = colors.gray,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+"},
            {"-"},
            {"+"}
        }
    }
    ---@type style.inputField.theme
    local inputField_selected = {
        tC = colors.yellow,
        tBG = colors.black,
        complC = colors.yellow,
        complBG = colors.gray,
        sTC = colors.white,
        bC = colors.lime,
        bBG = colors.green,
        b = {
            {"+"},
            {"-"},
            {"+"},
            {"|"},
            {" "},
            {"|"},
            {"+"},
            {"-"},
            {"+"}
        }
    }
    inputField.nTheme = inputField_normal
    inputField.dTheme = inputField_disabled
    inputField.sTheme = inputField_selected
    this.inputField = inputField

    function this:getStyle(elementType, arguments)
        local copiedStyle = table.copy(self[elementType], elementType)
        if type(arguments) == "table" then
            for k, v in pairs(arguments) do
                copiedStyle[k] = v
            end
        end
        return copiedStyle
    end
    setmetatable(
        this,
        {
            __call = function(t, type, arguments)
                return t:getStyle(type, arguments)
            end
        }
    )
    return this
end

local style = newStyle()
local button1 = style("button")
if term.isColor() then
    button1.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button1.pTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button1.sTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button1.dTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    button1.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button1.pTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    button1.sTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    button1.dTheme.b = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
button1.nTheme.tC = colors.white
button1.nTheme.tBG = colors.green
button1.nTheme.bC = colors.white
button1.nTheme.bBG = colors.green
button1.pTheme.tC = colors.orange
button1.pTheme.tBG = colors.green
button1.pTheme.bC = colors.orange
button1.pTheme.bBG = colors.green
button1.sTheme.tC = colors.yellow
button1.sTheme.tBG = colors.green
button1.sTheme.bC = colors.yellow
button1.sTheme.bBG = colors.green
button1.dTheme.tC = colors.gray
button1.dTheme.tBG = colors.green
button1.dTheme.bC = colors.gray
button1.dTheme.bBG = colors.green
local button2 = style("button")
if term.isColor() then
    button2.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button2.pTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button2.sTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button2.dTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    button2.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    button2.pTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    button2.sTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    button2.dTheme.b = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
button2.nTheme.tC = colors.white
button2.nTheme.tBG = colors.red
button2.nTheme.bC = colors.white
button2.nTheme.bBG = colors.red
button2.pTheme.tC = colors.white
button2.pTheme.tBG = colors.orange
button2.pTheme.bC = colors.white
button2.pTheme.bBG = colors.orange
button2.sTheme.tC = colors.orange
button2.sTheme.tBG = colors.red
button2.sTheme.bC = colors.orange
button2.sTheme.bBG = colors.red
button2.dTheme.tC = colors.lightGray
button2.dTheme.tBG = colors.gray
button2.dTheme.bC = colors.lightGray
button2.dTheme.bBG = colors.gray
local button3 = style("button")
if term.isColor() then
    button3.nTheme.b = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
    button3.pTheme.b = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    button3.sTheme.b = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    button3.dTheme.b = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
else
    button3.nTheme.b = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
    button3.pTheme.b = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    button3.sTheme.b = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    button3.dTheme.b = {{}, {}, {}, {"*"}, {" "}, {}, {}, {}, {}}
end
button3.align = 1
button3.nTheme.tC = colors.black
button3.nTheme.tBG = colors.white
button3.nTheme.bC = colors.black
button3.nTheme.bBG = colors.white
button3.pTheme.tC = colors.orange
button3.pTheme.tBG = colors.white
button3.pTheme.bC = colors.orange
button3.pTheme.bBG = colors.white
button3.sTheme.tC = colors.orange
button3.sTheme.tBG = colors.white
button3.sTheme.bC = colors.orange
button3.sTheme.bBG = colors.white
button3.dTheme.tC = colors.lightGray
button3.dTheme.tBG = colors.white
button3.dTheme.bC = colors.lightGray
button3.dTheme.bBG = colors.white
local button4 = style("button")
if term.isColor() then
    button4.nTheme.b = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
    button4.pTheme.b = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    button4.sTheme.b = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    button4.dTheme.b = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
else
    button4.nTheme.b = {{}, {}, {}, {" ", "\7"}, {" "}, {}, {}, {}, {}}
    button4.pTheme.b = {{}, {}, {}, {"\16", "\7"}, {" "}, {}, {}, {}, {}}
    button4.sTheme.b = {{}, {}, {}, {">", "\7"}, {" "}, {}, {}, {}, {}}
    button4.dTheme.b = {{}, {}, {}, {"*", "\7"}, {" "}, {}, {}, {}, {}}
end
button4.align = 1
button4.nTheme.tC = colors.blue
button4.nTheme.tBG = colors.white
button4.nTheme.bC = colors.blue
button4.nTheme.bBG = colors.white
button4.pTheme.tC = colors.red
button4.pTheme.tBG = colors.white
button4.pTheme.bC = colors.red
button4.pTheme.bBG = colors.white
button4.sTheme.tC = colors.red
button4.sTheme.tBG = colors.white
button4.sTheme.bC = colors.red
button4.sTheme.bBG = colors.white
button4.dTheme.tC = colors.lightGray
button4.dTheme.tBG = colors.white
button4.dTheme.bC = colors.lightGray
button4.dTheme.bBG = colors.white
local deactivatedButton = style("button")
if term.isColor() then
    deactivatedButton.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.pTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.sTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.dTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    deactivatedButton.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.pTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    deactivatedButton.sTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    deactivatedButton.dTheme.b = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
deactivatedButton.nTheme.tC = colors.white
deactivatedButton.nTheme.tBG = colors.lime
deactivatedButton.nTheme.bC = colors.white
deactivatedButton.nTheme.bBG = colors.lime
deactivatedButton.pTheme.tC = colors.orange
deactivatedButton.pTheme.tBG = colors.lime
deactivatedButton.pTheme.bC = colors.orange
deactivatedButton.pTheme.bBG = colors.lime
deactivatedButton.sTheme.tC = colors.yellow
deactivatedButton.sTheme.tBG = colors.lime
deactivatedButton.sTheme.bC = colors.yellow
deactivatedButton.sTheme.bBG = colors.lime
deactivatedButton.dTheme.tC = colors.lightGray
deactivatedButton.dTheme.tBG = colors.gray
deactivatedButton.dTheme.bC = colors.lightGray
deactivatedButton.dTheme.bBG = colors.gray
local activatedButton = style("button")
if term.isColor() then
    activatedButton.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.pTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.sTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.dTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    activatedButton.nTheme.b = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.pTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    activatedButton.sTheme.b = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    activatedButton.dTheme.b = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
activatedButton.nTheme.tC = colors.white
activatedButton.nTheme.tBG = colors.orange
activatedButton.nTheme.bC = colors.white
activatedButton.nTheme.bBG = colors.orange
activatedButton.pTheme.tC = colors.red
activatedButton.pTheme.tBG = colors.orange
activatedButton.pTheme.bC = colors.red
activatedButton.pTheme.bBG = colors.orange
activatedButton.sTheme.tC = colors.yellow
activatedButton.sTheme.tBG = colors.orange
activatedButton.sTheme.bC = colors.yellow
activatedButton.sTheme.bBG = colors.orange
activatedButton.dTheme.tC = colors.lightGray
activatedButton.dTheme.tBG = colors.gray
activatedButton.dTheme.bC = colors.lightGray
activatedButton.dTheme.bBG = colors.gray
---@type style.toggle
local toggle1 = style("toggle")
if term.isColor() then
    toggle1.dTheme.checkedL = {" ", "X", " "}
    toggle1.dTheme.checkedLC = {colors.white, colors.white, colors.white}
    toggle1.dTheme.checkedLBG = {colors.white, colors.gray, colors.white}
    toggle1.dTheme.uncheckedL = {" ", "O", " "}
    toggle1.dTheme.uncheckedLC = {colors.white, colors.white, colors.white}
    toggle1.dTheme.uncheckedLBG = {colors.white, colors.gray, colors.white}
end
local sView1 = style("scrollView")
sView1.nTheme.b = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
sView1.sTheme.b = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
sView1.dTheme.b = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
local sView2 = style("scrollView")
sView2.label.align = 1
sView2.label.nTheme.tC = colors.black
sView2.label.sTheme.tC = colors.black
sView2.label.dTheme.tC = colors.black
sView2.nTheme.spaceTextColor = colors.black
sView2.nTheme.bC = colors.black
sView2.nTheme.spaceBackgroundColor = colors.white
sView2.nTheme.bBG = colors.white
sView2.sTheme.spaceTextColor = colors.black
sView2.sTheme.spaceTextColor = colors.black
sView2.sTheme.bC = colors.black
sView2.sTheme.bC = colors.black
sView2.dTheme.spaceBackgroundColor = colors.white
sView2.dTheme.spaceBackgroundColor = colors.white
sView2.dTheme.bBG = colors.white
sView2.dTheme.bBG = colors.white
sView2.sliderH.nTheme.buttonN.nTheme.tBG = {colors.white}
sView2.sliderH.nTheme.buttonN.nTheme.tC = {colors.black}
sView2.sliderH.nTheme.buttonN.dTheme.tBG = {colors.white}
sView2.sliderH.nTheme.buttonN.dTheme.tC = {colors.gray}
sView2.sliderH.nTheme.buttonN.sTheme.tBG = {colors.white}
sView2.sliderH.nTheme.buttonN.sTheme.tC = {colors.orange}
sView2.sliderH.dTheme.buttonN.dTheme.tBG = {colors.white}
sView2.sliderH.dTheme.buttonN.dTheme.tC = {colors.gray}
sView2.sliderH.nTheme.buttonP.nTheme.tBG = {colors.white}
sView2.sliderH.nTheme.buttonP.nTheme.tC = {colors.black}
sView2.sliderH.nTheme.buttonP.dTheme.tBG = {colors.white}
sView2.sliderH.nTheme.buttonP.dTheme.tC = {colors.gray}
sView2.sliderH.nTheme.buttonP.sTheme.tBG = {colors.white}
sView2.sliderH.nTheme.buttonP.sTheme.tC = {colors.orange}
sView2.sliderH.dTheme.buttonP.dTheme.tBG = {colors.white}
sView2.sliderH.dTheme.buttonP.dTheme.tC = {colors.gray}
sView2.sliderV.nTheme.buttonN.nTheme.tBG = {colors.white}
sView2.sliderV.nTheme.buttonN.nTheme.tC = {colors.black}
sView2.sliderV.nTheme.buttonN.dTheme.tBG = {colors.white}
sView2.sliderV.nTheme.buttonN.dTheme.tC = {colors.gray}
sView2.sliderV.nTheme.buttonN.sTheme.tBG = {colors.white}
sView2.sliderV.nTheme.buttonN.sTheme.tC = {colors.orange}
sView2.sliderV.dTheme.buttonN.dTheme.tBG = {colors.white}
sView2.sliderV.dTheme.buttonN.dTheme.tC = {colors.gray}
sView2.sliderV.nTheme.buttonP.nTheme.tBG = {colors.white}
sView2.sliderV.nTheme.buttonP.nTheme.tC = {colors.black}
sView2.sliderV.nTheme.buttonP.dTheme.tBG = {colors.white}
sView2.sliderV.nTheme.buttonP.dTheme.tC = {colors.gray}
sView2.sliderV.nTheme.buttonP.sTheme.tBG = {colors.white}
sView2.sliderV.nTheme.buttonP.sTheme.tC = {colors.orange}
sView2.sliderV.dTheme.buttonP.dTheme.tBG = {colors.white}
sView2.sliderV.dTheme.buttonP.dTheme.tC = {colors.gray}
sView2.sliderH.nTheme.handleLBG = {colors.white}
sView2.sliderH.nTheme.handleLC = {colors.gray}
sView2.sliderH.nTheme.sliderTBG = {colors.white}
sView2.sliderH.nTheme.sliderTC = {colors.black}
sView2.sliderV.nTheme.handleLBG = {colors.white}
sView2.sliderV.nTheme.handleLC = {colors.gray}
sView2.sliderV.nTheme.sliderTBG = {colors.white}
sView2.sliderV.nTheme.sliderTC = {colors.black}
local tBox1 = style("textBox")
local tBox2 = style("textBox")
tBox2.label.align = 1
tBox2.label.nTheme.tC = colors.black
tBox2.label.nTheme.tBG = colors.white
tBox2.label.nTheme.prefix = " "
tBox2.label.nTheme.suffix = " "
tBox2.label.sTheme.prefix = ">"
tBox2.label.sTheme.suffix = "<"
tBox2.label.dTheme.prefix = "*"
tBox2.label.dTheme.suffix = "*"
tBox2.label.sTheme.tC = colors.orange
tBox2.label.sTheme.tBG = colors.white
tBox2.label.dTheme.tC = colors.gray
tBox2.label.dTheme.tBG = colors.white
tBox2.nTheme.b = {{}, {"-"}, {"-"}, {}, {" "}, {" "}, {}, {"-"}, {"-"}}
tBox2.nTheme.bC = colors.black
tBox2.nTheme.bBG = colors.white
tBox2.sTheme.b = {{}, {"-"}, {"-"}, {}, {" "}, {" "}, {}, {"-"}, {"-"}}
tBox2.sTheme.bC = colors.orange
tBox2.sTheme.bBG = colors.white
tBox2.dTheme.b = {{}, {"-"}, {"-"}, {}, {" "}, {" "}, {}, {"-"}, {"-"}}
tBox2.dTheme.bC = colors.gray
tBox2.dTheme.bBG = colors.white
tBox2.slider.nTheme.buttonN.nTheme.tBG = {colors.white}
tBox2.slider.nTheme.buttonN.nTheme.tC = {colors.black}
tBox2.slider.nTheme.buttonN.dTheme.tBG = {colors.white}
tBox2.slider.nTheme.buttonN.dTheme.tC = {colors.gray}
tBox2.slider.nTheme.buttonN.sTheme.tBG = {colors.white}
tBox2.slider.nTheme.buttonN.sTheme.tC = {colors.orange}
tBox2.slider.dTheme.buttonN.dTheme.tBG = {colors.white}
tBox2.slider.dTheme.buttonN.dTheme.tC = {colors.gray}
tBox2.slider.nTheme.buttonP.nTheme.tBG = {colors.white}
tBox2.slider.nTheme.buttonP.nTheme.tC = {colors.black}
tBox2.slider.nTheme.buttonP.dTheme.tBG = {colors.white}
tBox2.slider.nTheme.buttonP.dTheme.tC = {colors.gray}
tBox2.slider.nTheme.buttonP.sTheme.tBG = {colors.white}
tBox2.slider.nTheme.buttonP.sTheme.tC = {colors.orange}
tBox2.slider.dTheme.buttonP.dTheme.tBG = {colors.white}
tBox2.slider.dTheme.buttonP.dTheme.tC = {colors.gray}
tBox2.slider.nTheme.handleLBG = {colors.white}
tBox2.slider.nTheme.handleLC = {colors.gray}
tBox2.slider.nTheme.sliderTBG = {colors.white}
tBox2.slider.nTheme.sliderTC = {colors.black}
---@type style.inputField
local iField1 = style("inputField")
iField1.align = 3
iField1.nTheme.tC = colors.black
iField1.nTheme.sTC = colors.black
iField1.nTheme.tBG = colors.white
iField1.nTheme.b = {{"+"}, {"-"}, {"+"}, {"|"}, {" "}, {"|"}, {"+"}, {"-"}, {"+"}}
iField1.nTheme.bC = colors.black
iField1.nTheme.bBG = colors.white

iField1.dTheme.tC = colors.gray
iField1.dTheme.sTC = colors.gray
iField1.dTheme.tBG = colors.white
iField1.dTheme.b = {{"+"}, {"-"}, {"+"}, {"|"}, {" "}, {"|"}, {"+"}, {"-"}, {"+"}}
iField1.dTheme.bC = colors.gray
iField1.dTheme.bBG = colors.white

iField1.sTheme.tC = colors.black
iField1.sTheme.sTC = colors.orange
iField1.sTheme.tBG = colors.white
iField1.sTheme.b = {{"+"}, {"-"}, {"+"}, {"|"}, {" "}, {"|"}, {"+"}, {"-"}, {"+"}}
iField1.sTheme.bC = colors.orange
iField1.sTheme.bBG = colors.white

iField1.label = style("label")
iField1.label.nTheme.prefix = "-"
iField1.label.nTheme.suffix = "-"
iField1.label.nTheme.tBG = colors.white
iField1.label.nTheme.tC = colors.black
iField1.label.dTheme.prefix = "*"
iField1.label.dTheme.suffix = "*"
iField1.label.dTheme.tBG = colors.white
iField1.label.dTheme.tC = colors.gray
iField1.label.sTheme.prefix = ">"
iField1.label.sTheme.suffix = "<"
iField1.label.sTheme.tBG = colors.white
iField1.label.sTheme.tC = colors.orange

---@type style.inputField
local iField2 = style("inputField")
iField2.nTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
iField2.nTheme.tC = colors.white
iField2.nTheme.sTC = colors.white
iField2.nTheme.tBG = colors.black
iField2.dTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
iField2.sTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}

local label1 = style("label")
label1.align = 1
label1.nTheme.tBG = colors.green
label1.nTheme.tC = colors.black
local label2 = style("label")
table.save({button1 = button1, button2 = button2, button3 = button3, button4 = button4, toggle1 = toggle1, activatedButton = activatedButton, deactivatedButton = deactivatedButton, sView1 = sView1, sView2 = sView2, tBox1 = tBox1, tBox2 = tBox2, iField1 = iField1, iField2 = iField2, label1 = label1, label2 = label2}, "os/theme/main.lua")
