---@param path string
---@return style
function new(path)
    ---@class style
    local this = {}

    ---@class style.label
    local label = {}
    ---@type alignment
    label.alignment = 1
    ---@class style.label.theme
    local normal_label = {
        textColor = colors.black,
        backgroundColor = colors.white
    }
    ---@type style.label.theme
    local disabled_label = {
        textColor = colors.gray,
        backgroundColor = colors.white
    }
    label.normalTheme = normal_label
    label.disabledTheme = disabled_label
    this.label = label

    ---@class style.button
    local button = {}
    ---@type alignment
    button.alignment = 5
    ---@class style.button.theme
    local normal_button = {
        textColor = colors.lightBlue,
        textBackgroundColor = colors.blue,
        borderColor = colors.lightBlue,
        borderBackgroundColor = colors.blue,
        ---@type border
        border = {
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
    ---@class style.button.theme
    local disabled_button = {
        textColor = colors.lightGray,
        textBackgroundColor = colors.gray,
        borderColor = colors.lightGray,
        borderBackgroundColor = colors.gray,
        ---@type border
        border = {
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
    ---@class style.button.theme
    local selected_button = {
        textColor = colors.white,
        textBackgroundColor = colors.blue,
        borderColor = colors.white,
        borderBackgroundColor = colors.blue,
        ---@type border
        border = {
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
    ---@class style.button.theme
    local pressed_button = {
        textColor = colors.white,
        textBackgroundColor = colors.lightBlue,
        borderColor = colors.white,
        borderBackgroundColor = colors.lightBlue,
        ---@type border
        border = {
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
    button.normalTheme = normal_button
    button.disabledTheme = disabled_button
    button.selectedTheme = selected_button
    button.pressedTheme = pressed_button
    this.button = button

    ---@class style.toggleButton
    local toggleButton = {}
    ---@type alignment
    toggleButton.alignment = 1
    ---@class style.toggleButton.theme
    local normal_toggleButton = {
        textColor = colors.black,
        backgroundColor = colors.white,
        uncheckedCheckbox = {" ", "O", " "},
        uncheckedCheckboxTextColor = {colors.white, colors.lightBlue, colors.white},
        uncheckedCheckboxBackgroundColor = {colors.white, colors.blue, colors.white},
        checkedCheckbox = {" ", "X", " "},
        checkedCheckboxTextColor = {colors.white, colors.orange, colors.white},
        checkedCheckboxBackgroundColor = {colors.white, colors.red, colors.white}
    }
    ---@type style.toggleButton.theme
    local disabled_toggleButton = {
        textColor = colors.gray,
        backgroundColor = colors.white,
        uncheckedCheckbox = {"*", "O", "*"},
        uncheckedCheckboxTextColor = {colors.white, colors.gray, colors.white},
        uncheckedCheckboxBackgroundColor = {colors.gray, colors.lightGray, colors.gray},
        checkedCheckbox = {"*", "X", "*"},
        checkedCheckboxTextColor = {colors.white, colors.gray, colors.white},
        checkedCheckboxBackgroundColor = {colors.gray, colors.lightGray, colors.gray}
    }
    ---@type style.toggleButton.theme
    local selected_toggleButton = {
        textColor = colors.orange,
        backgroundColor = colors.white,
        uncheckedCheckbox = {">", "O", "< "},
        uncheckedCheckboxTextColor = {colors.orange, colors.white, colors.orange},
        uncheckedCheckboxBackgroundColor = {colors.white, colors.blue, colors.white},
        checkedCheckbox = {">", "X", "<"},
        checkedCheckboxTextColor = {colors.orange, colors.white, colors.orange},
        checkedCheckboxBackgroundColor = {colors.white, colors.red, colors.white}
    }
    ---@type style.toggleButton.theme
    local pressed_toggleButton = {
        textColor = colors.orange,
        backgroundColor = colors.white,
        uncheckedCheckbox = {">", "X", "<"},
        uncheckedCheckboxTextColor = {colors.orange, colors.white, colors.orange},
        uncheckedCheckboxBackgroundColor = {colors.white, colors.orange, colors.white},
        checkedCheckbox = {">", "O", "<"},
        checkedCheckboxTextColor = {colors.orange, colors.white, colors.orange},
        checkedCheckboxBackgroundColor = {colors.white, colors.lightBlue, colors.white}
    }
    toggleButton.normalTheme = normal_toggleButton
    toggleButton.disabledTheme = disabled_toggleButton
    toggleButton.selectedTheme = selected_toggleButton
    toggleButton.pressedTheme = pressed_toggleButton
    this.toggleButton = toggleButton

    ---@class style.slider
    local slider = {}
    ---@class style.slider.theme
    local normal_slider = {
        slider = {"|", "#", "|"},
        sliderColor = {colors.lightGray, colors.lightGray, colors.lightGray},
        sliderBackgroundColor = {colors.gray, colors.gray, colors.gray},
        handle = {"|", "#", "|"},
        handleColor = {colors.lightGray, colors.gray, colors.lightGray},
        handleBackgroundColor = {colors.lightGray, colors.black, colors.lightGray}
    }
    ---@class style.slider.button
    local normal_slider_buttonPositive = {}
    ---@class style.slider.button.theme
    local normal_slider_normal_buttonPositive = {
        text = {"[", "A", "]"},
        color = {colors.lightBlue, colors.lightBlue, colors.lightBlue},
        backgroundColor = {colors.blue, colors.blue, colors.blue}
    }
    ---@type style.slider.button.theme
    local normal_slider_disabled_buttonPositive = {
        text = {"[", "A", "]"},
        color = {colors.lightGray, colors.lightGray, colors.lightGray},
        backgroundColor = {colors.gray, colors.gray, colors.gray}
    }
    ---@type style.slider.button.theme
    local normal_slider_selected_buttonPositive = {
        text = {"[", "A", "]"},
        color = {colors.white, colors.white, colors.white},
        backgroundColor = {colors.blue, colors.blue, colors.blue}
    }
    normal_slider_buttonPositive.normal = normal_slider_normal_buttonPositive
    normal_slider_buttonPositive.disabled = normal_slider_disabled_buttonPositive
    normal_slider_buttonPositive.selected = normal_slider_selected_buttonPositive
    ---@type style.slider.button
    local normal_slider_buttonNegative = {}
    ---@type style.slider.button.theme
    local normal_slider_normal_buttonNegative = {
        text = {"[", "A", "]"},
        color = {colors.lightBlue, colors.lightBlue, colors.lightBlue},
        backgroundColor = {colors.blue, colors.blue, colors.blue}
    }
    ---@type style.slider.button.theme
    local normal_slider_disabled_buttonNegative = {
        text = {"[", "A", "]"},
        color = {colors.lightGray, colors.lightGray, colors.lightGray},
        backgroundColor = {colors.gray, colors.gray, colors.gray}
    }
    ---@type style.slider.button.theme
    local normal_slider_selected_buttonNegative = {
        text = {"[", "A", "]"},
        color = {colors.white, colors.white, colors.white},
        backgroundColor = {colors.blue, colors.blue, colors.blue}
    }
    normal_slider_buttonNegative.normal = normal_slider_normal_buttonNegative
    normal_slider_buttonNegative.disabled = normal_slider_disabled_buttonNegative
    normal_slider_buttonNegative.selected = normal_slider_selected_buttonNegative
    normal_slider.buttonPositive = normal_slider_buttonPositive
    normal_slider.buttonNegative = normal_slider_buttonNegative
    local disabled_slider = {
        slider = {"|", "#", "|"},
        sliderColor = {colors.lightGray, colors.lightGray, colors.lightGray},
        sliderBackgroundColor = {colors.gray, colors.gray, colors.gray},
        handle = {"|", "#", "|"},
        handleColor = {colors.lightGray, colors.gray, colors.lightGray},
        handleBackgroundColor = {colors.lightGray, colors.black, colors.lightGray}
    }
    ---@type style.style.slider.button
    local disabled_slider_buttonPositive = {}
    ---@type style.style.slider.button
    local disabled_slider_buttonNegative = {}
    disabled_slider_buttonPositive.disabled = normal_slider_disabled_buttonPositive
    disabled_slider_buttonNegative.disabled = normal_slider_disabled_buttonNegative
    disabled_slider.buttonPositive = disabled_slider_buttonPositive
    disabled_slider.buttonNegative = disabled_slider_buttonNegative
    slider.normal = normal_slider
    slider.disabled = disabled_slider
    this.slider = slider

    ---@class style.textBox
    local textBox = {}
    ---@type style.label
    textBox.label = assets.extension.copyTable(this.label)
    ---@type style.slider
    textBox.slider = assets.extension.copyTable(this.slider)
    textBox.slider.normal.buttonPositive.normal.text = {string.char(30)}
    textBox.slider.normal.buttonPositive.normal.color = {colors.white}
    textBox.slider.normal.buttonPositive.normal.backgroundColor = {colors.lime}
    textBox.slider.normal.buttonPositive.selected.text = {string.char(30)}
    textBox.slider.normal.buttonPositive.selected.color = {colors.yellow}
    textBox.slider.normal.buttonPositive.selected.backgroundColor = {colors.lime}
    textBox.slider.normal.buttonPositive.disabled.text = {string.char(30)}
    textBox.slider.normal.buttonPositive.disabled.color = {colors.gray}
    textBox.slider.normal.buttonPositive.disabled.backgroundColor = {colors.lime}
    textBox.slider.normal.buttonNegative.normal.text = {string.char(31)}
    textBox.slider.normal.buttonNegative.normal.color = {colors.white}
    textBox.slider.normal.buttonNegative.normal.backgroundColor = {colors.lime}
    textBox.slider.normal.buttonNegative.selected.text = {string.char(31)}
    textBox.slider.normal.buttonNegative.selected.color = {colors.yellow}
    textBox.slider.normal.buttonNegative.selected.backgroundColor = {colors.lime}
    textBox.slider.normal.buttonNegative.disabled.text = {string.char(31)}
    textBox.slider.normal.buttonNegative.disabled.color = {colors.gray}
    textBox.slider.normal.buttonNegative.disabled.backgroundColor = {colors.lime}
    textBox.slider.normal.slider = {string.char(127)}
    textBox.slider.normal.sliderColor = {colors.lightGray}
    textBox.slider.normal.sliderBackgroundColor = {colors.lime}
    textBox.slider.normal.handle = {"#"}
    textBox.slider.normal.handleColor = {colors.gray}
    textBox.slider.normal.handleBackgroundColor = {colors.green}

    textBox.slider.disabled.buttonPositive.disabled.text = {string.char(30)}
    textBox.slider.disabled.buttonPositive.disabled.color = {colors.lightGray}
    textBox.slider.disabled.buttonPositive.disabled.backgroundColor = {colors.gray}
    textBox.slider.disabled.buttonNegative.disabled.text = {string.char(31)}
    textBox.slider.disabled.buttonNegative.disabled.color = {colors.lightGray}
    textBox.slider.disabled.buttonNegative.disabled.backgroundColor = {colors.gray}
    textBox.slider.disabled.slider = {string.char(127)}
    textBox.slider.disabled.sliderColor = {colors.lightGray}
    textBox.slider.disabled.sliderBackgroundColor = {colors.gray}
    textBox.slider.disabled.handle = {"#"}
    textBox.slider.disabled.handleColor = {colors.gray}
    textBox.slider.disabled.handleBackgroundColor = {colors.gray}

    ---@class style.textBox.theme
    local normal_textBox = {
        textColor = colors.lime,
        textBackgroundColor = colors.green,
        spaceColor = colors.white,
        borderColor = colors.lime,
        borderBackgroundColor = colors.green,
        ---@type border
        border = {
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
    local disabled_textBox = {
        textColor = colors.lightGray,
        textBackgroundColor = colors.gray,
        spaceColor = colors.white,
        borderColor = colors.lightGray,
        borderBackgroundColor = colors.gray,
        ---@type border
        border = {
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
    local selected_textBox = {
        textColor = colors.yellow,
        textBackgroundColor = colors.green,
        spaceColor = colors.white,
        borderColor = colors.lime,
        borderBackgroundColor = colors.green,
        ---@type border
        border = {
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
    textBox.normalTheme = normal_textBox
    textBox.disabledTheme = disabled_textBox
    textBox.selectedTheme = selected_textBox
    this.textBox = textBox

    ---@class style.scrollView
    local scrollView = {}
    ---@type style.label
    scrollView.label = assets.extension.copyTable(this.label)
    ---@type style.slider
    scrollView.sliderVertical = assets.extension.copyTable(this.slider)
    scrollView.sliderVertical.normal.buttonPositive.normal.text = {string.char(30)}
    scrollView.sliderVertical.normal.buttonPositive.normal.color = {colors.white}
    scrollView.sliderVertical.normal.buttonPositive.normal.backgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.buttonPositive.selected.text = {string.char(30)}
    scrollView.sliderVertical.normal.buttonPositive.selected.color = {colors.yellow}
    scrollView.sliderVertical.normal.buttonPositive.selected.backgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.buttonPositive.disabled.text = {string.char(30)}
    scrollView.sliderVertical.normal.buttonPositive.disabled.color = {colors.gray}
    scrollView.sliderVertical.normal.buttonPositive.disabled.backgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.buttonNegative.normal.text = {string.char(31)}
    scrollView.sliderVertical.normal.buttonNegative.normal.color = {colors.white}
    scrollView.sliderVertical.normal.buttonNegative.normal.backgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.buttonNegative.selected.text = {string.char(31)}
    scrollView.sliderVertical.normal.buttonNegative.selected.color = {colors.yellow}
    scrollView.sliderVertical.normal.buttonNegative.selected.backgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.buttonNegative.disabled.text = {string.char(31)}
    scrollView.sliderVertical.normal.buttonNegative.disabled.color = {colors.gray}
    scrollView.sliderVertical.normal.buttonNegative.disabled.backgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.slider = {string.char(127)}
    scrollView.sliderVertical.normal.sliderColor = {colors.lightGray}
    scrollView.sliderVertical.normal.sliderBackgroundColor = {colors.lime}
    scrollView.sliderVertical.normal.handle = {"#"}
    scrollView.sliderVertical.normal.handleColor = {colors.gray}
    scrollView.sliderVertical.normal.handleBackgroundColor = {colors.green}

    scrollView.sliderVertical.disabled.buttonPositive.disabled.text = {string.char(30)}
    scrollView.sliderVertical.disabled.buttonPositive.disabled.color = {colors.lightGray}
    scrollView.sliderVertical.disabled.buttonPositive.disabled.backgroundColor = {colors.gray}
    scrollView.sliderVertical.disabled.buttonNegative.disabled.text = {string.char(31)}
    scrollView.sliderVertical.disabled.buttonNegative.disabled.color = {colors.lightGray}
    scrollView.sliderVertical.disabled.buttonNegative.disabled.backgroundColor = {colors.gray}
    scrollView.sliderVertical.disabled.slider = {string.char(127)}
    scrollView.sliderVertical.disabled.sliderColor = {colors.lightGray}
    scrollView.sliderVertical.disabled.sliderBackgroundColor = {colors.gray}
    scrollView.sliderVertical.disabled.handle = {"#"}
    scrollView.sliderVertical.disabled.handleColor = {colors.gray}
    scrollView.sliderVertical.disabled.handleBackgroundColor = {colors.gray}
    ---@type style.slider
    scrollView.sliderHorizontal = assets.extension.copyTable(this.slider)
    scrollView.sliderHorizontal.normal.buttonPositive.normal.text = {string.char(17)}
    scrollView.sliderHorizontal.normal.buttonPositive.normal.color = {colors.white}
    scrollView.sliderHorizontal.normal.buttonPositive.normal.backgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.buttonPositive.selected.text = {string.char(17)}
    scrollView.sliderHorizontal.normal.buttonPositive.selected.color = {colors.yellow}
    scrollView.sliderHorizontal.normal.buttonPositive.selected.backgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.buttonPositive.disabled.text = {string.char(17)}
    scrollView.sliderHorizontal.normal.buttonPositive.disabled.color = {colors.gray}
    scrollView.sliderHorizontal.normal.buttonPositive.disabled.backgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.buttonNegative.normal.text = {string.char(16)}
    scrollView.sliderHorizontal.normal.buttonNegative.normal.color = {colors.white}
    scrollView.sliderHorizontal.normal.buttonNegative.normal.backgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.buttonNegative.selected.text = {string.char(16)}
    scrollView.sliderHorizontal.normal.buttonNegative.selected.color = {colors.yellow}
    scrollView.sliderHorizontal.normal.buttonNegative.selected.backgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.buttonNegative.disabled.text = {string.char(16)}
    scrollView.sliderHorizontal.normal.buttonNegative.disabled.color = {colors.gray}
    scrollView.sliderHorizontal.normal.buttonNegative.disabled.backgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.slider = {string.char(127)}
    scrollView.sliderHorizontal.normal.sliderColor = {colors.lightGray}
    scrollView.sliderHorizontal.normal.sliderBackgroundColor = {colors.lime}
    scrollView.sliderHorizontal.normal.handle = {"#"}
    scrollView.sliderHorizontal.normal.handleColor = {colors.gray}
    scrollView.sliderHorizontal.normal.handleBackgroundColor = {colors.green}

    scrollView.sliderHorizontal.disabled.buttonPositive.disabled.text = {string.char(17)}
    scrollView.sliderHorizontal.disabled.buttonPositive.disabled.color = {colors.lightGray}
    scrollView.sliderHorizontal.disabled.buttonPositive.disabled.backgroundColor = {colors.gray}
    scrollView.sliderHorizontal.disabled.buttonNegative.disabled.text = {string.char(16)}
    scrollView.sliderHorizontal.disabled.buttonNegative.disabled.color = {colors.lightGray}
    scrollView.sliderHorizontal.disabled.buttonNegative.disabled.backgroundColor = {colors.gray}
    scrollView.sliderHorizontal.disabled.slider = {string.char(127)}
    scrollView.sliderHorizontal.disabled.sliderColor = {colors.lightGray}
    scrollView.sliderHorizontal.disabled.sliderBackgroundColor = {colors.gray}
    scrollView.sliderHorizontal.disabled.handle = {"#"}
    scrollView.sliderHorizontal.disabled.handleColor = {colors.gray}
    scrollView.sliderHorizontal.disabled.handleBackgroundColor = {colors.gray}

    ---@class style.scrollView.theme
    local normal_scrollView = {
        textColor = colors.lime,
        textBackgroundColor = colors.green,
        spaceColor = colors.white,
        borderColor = colors.lime,
        borderBackgroundColor = colors.green,
        ---@type border
        border = {
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
    local disabled_scrollView = {
        textColor = colors.lightGray,
        textBackgroundColor = colors.gray,
        spaceColor = colors.white,
        borderColor = colors.lightGray,
        borderBackgroundColor = colors.gray,
        ---@type border
        border = {
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
    local selected_scrollView = {
        textColor = colors.yellow,
        textBackgroundColor = colors.green,
        spaceColor = colors.white,
        borderColor = colors.lime,
        borderBackgroundColor = colors.green,
        ---@type border
        border = {
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
    scrollView.normalTheme = normal_scrollView
    scrollView.disabledTheme = disabled_scrollView
    scrollView.selectedTheme = selected_scrollView
    this.scrollView = scrollView

    ---@return style.any
    this.getStyle = function(elementType, arguments)
        local copiedStyle = {}
        for k, v in pairs(this[elementType]) do
            copiedStyle[k] = v
        end

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
                return t.getStyle(type, arguments)
            end
        }
    )

    return this
end

---@param topLeft char[]
---@param topMiddle char[]
---@param topRight char[]
---@param middleLeft char[]
---@param middleRight char[]
---@param bottomLeft char[]
---@param bottomMiddle char[]
---@param bottomRight char[]
---@return border
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
