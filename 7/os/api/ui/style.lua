---@return style
function new(path)
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

    ---@class style.toggleButton
    local toggleButton = {}
    toggleButton.align = 1
    ---@class style.toggleButton.theme
    local toggleButton_normal = {
        tC = colors.black,
        tBG = colors.white,
        uncheckedL = {" ", "O", " "},
        uncheckedLC = {colors.white, colors.lightBlue, colors.white},
        uncheckedLBG = {colors.white, colors.blue, colors.white},
        checkedL = {" ", "X", " "},
        checkedLC = {colors.white, colors.orange, colors.white},
        checkedLBG = {colors.white, colors.red, colors.white}
    }
    ---@type style.toggleButton.theme
    local toggleButton_disabled = {
        tC = colors.gray,
        tBG = colors.white,
        uncheckedL = {"*", "O", "*"},
        uncheckedLC = {colors.white, colors.gray, colors.white},
        uncheckedLBG = {colors.gray, colors.lightGray, colors.gray},
        checkedL = {"*", "X", "*"},
        checkedLC = {colors.white, colors.gray, colors.white},
        checkedLBG = {colors.gray, colors.lightGray, colors.gray}
    }
    ---@type style.toggleButton.theme
    local toggleButton_selected = {
        tC = colors.orange,
        tBG = colors.white,
        uncheckedL = {">", "O", "< "},
        uncheckedLC = {colors.orange, colors.white, colors.orange},
        uncheckedLBG = {colors.white, colors.blue, colors.white},
        checkedL = {">", "X", "<"},
        checkedLC = {colors.orange, colors.white, colors.orange},
        checkedLBG = {colors.white, colors.red, colors.white}
    }
    ---@type style.toggleButton.theme
    local toggleButton_pressed = {
        tC = colors.orange,
        tBG = colors.white,
        uncheckedL = {">", "X", "<"},
        uncheckedLC = {colors.orange, colors.white, colors.orange},
        uncheckedLBG = {colors.white, colors.orange, colors.white},
        checkedL = {">", "O", "<"},
        checkedLC = {colors.orange, colors.white, colors.orange},
        checkedLBG = {colors.white, colors.lightBlue, colors.white}
    }
    toggleButton.nTheme = toggleButton_normal
    toggleButton.dTheme = toggleButton_disabled
    toggleButton.sTheme = toggleButton_selected
    toggleButton.pTheme = toggleButton_pressed
    this.toggleButton = toggleButton

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
function border(topLeft, topMiddle, topRight, middleLeft, middleRight, bottomLeft, bottomMiddle, bottomRight)
    ---@class border
    return {
        topLeft or {},
        topMiddle or {},
        topRight or {},
        middleLeft or {},
        middleRight or {},
        bottomLeft or {},
        bottomMiddle or {},
        bottomRight or {}
    }
end
