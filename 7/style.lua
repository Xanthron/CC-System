return {
    toggleButton = {
        disabledTheme = {
            uncheckedCheckboxBackgroundColor = {128, 256, 128},
            checkedCheckbox = {"*", "X", "*"},
            uncheckedCheckbox = {"*", "O", "*"},
            uncheckedCheckboxTextColor = {1, 128, 1},
            checkedCheckboxBackgroundColor = {128, 256, 128},
            checkedCheckboxTextColor = {1, 128, 1},
            backgroundColor = 1,
            textColor = 128
        },
        alignment = 1,
        pressedTheme = {
            uncheckedCheckboxBackgroundColor = {1, 2, 1},
            checkedCheckbox = {">", "O", "<"},
            uncheckedCheckbox = {">", "X", "<"},
            uncheckedCheckboxTextColor = {2, 1, 2},
            checkedCheckboxBackgroundColor = {1, 8, 1},
            checkedCheckboxTextColor = {2, 1, 2},
            backgroundColor = 1,
            textColor = 2
        },
        selectedTheme = {
            uncheckedCheckboxBackgroundColor = {1, 2048, 1},
            checkedCheckbox = {">", "X", "<"},
            uncheckedCheckbox = {">", "O", "< "},
            uncheckedCheckboxTextColor = {2, 1, 2},
            checkedCheckboxBackgroundColor = {1, 16384, 1},
            checkedCheckboxTextColor = {2, 1, 2},
            backgroundColor = 1,
            textColor = 2
        },
        normalTheme = {
            uncheckedCheckboxBackgroundColor = {1, 2048, 1},
            checkedCheckbox = {" ", "X", " "},
            uncheckedCheckbox = {" ", "O", " "},
            uncheckedCheckboxTextColor = {1, 8, 1},
            checkedCheckboxBackgroundColor = {1, 16384, 1},
            checkedCheckboxTextColor = {1, 2, 1},
            backgroundColor = 1,
            textColor = 32768
        }
    },
    getStyle = nil,
    label = {
        disabledTheme = {backgroundColor = 1, textColor = 128},
        normalTheme = {backgroundColor = 1, textColor = 32768},
        alignment = 1
    },
    button = {
        disabledTheme = {
            borderColor = 256,
            borderBackgroundColor = 128,
            border = {{}, {}, {}, {"x", " "}, {" ", "x"}, {}, {}, {}},
            textBackgroundColor = 128,
            textColor = 256
        },
        alignment = 5,
        pressedTheme = {
            borderColor = 1,
            borderBackgroundColor = 8,
            border = {{}, {}, {}, {" ", ""}, {"", " "}, {}, {}, {}},
            textBackgroundColor = 8,
            textColor = 1
        },
        selectedTheme = {
            borderColor = 1,
            borderBackgroundColor = 2048,
            border = {{}, {}, {}, {"", " "}, {" ", ""}, {}, {}, {}},
            textBackgroundColor = 2048,
            textColor = 1
        },
        normalTheme = {
            borderColor = 8,
            borderBackgroundColor = 2048,
            border = {{}, {}, {}, {">", " "}, {" ", "<"}, {}, {}, {}},
            textBackgroundColor = 2048,
            textColor = 8
        }
    },
    scrollView = {
        disabledTheme = {
            spaceColor = 1,
            borderColor = 256,
            borderBackgroundColor = 128,
            border = {{"+"}, {"-"}, {"+"}, {"|"}, {"|"}, {"+", "|", "+"}, {"-", " ", "-"}, {"+", "|", "+"}},
            textBackgroundColor = 128,
            textColor = 256
        },
        sliderVertical = {
            normal = {
                buttonPositive = {
                    normal = {color = {1}, text = {""}, backgroundColor = {32}},
                    selected = {color = {16}, text = {""}, backgroundColor = {32}},
                    disabled = {color = {128}, text = {""}, backgroundColor = {32}}
                },
                handleColor = {128},
                slider = {""},
                sliderBackgroundColor = {32},
                sliderColor = {256},
                handleBackgroundColor = {8192},
                handle = {"#"},
                buttonNegative = {
                    normal = {color = {1}, text = {""}, backgroundColor = {32}},
                    selected = {color = {16}, text = {""}, backgroundColor = {32}},
                    disabled = {color = {128}, text = {""}, backgroundColor = {32}}
                }
            },
            disabled = {
                buttonPositive = {disabled = {color = {256}, text = {""}, backgroundColor = {128}}},
                handleColor = {128},
                slider = {""},
                sliderBackgroundColor = {128},
                sliderColor = {256},
                handleBackgroundColor = {128},
                handle = {"#"},
                buttonNegative = {disabled = {color = {256}, text = {""}, backgroundColor = {128}}}
            }
        },
        label = {
            disabledTheme = {backgroundColor = 1, textColor = 128},
            normalTheme = {backgroundColor = 1, textColor = 32768},
            alignment = 1
        },
        sliderHorizontal = {
            normal = {
                buttonPositive = {
                    normal = {color = {1}, text = {""}, backgroundColor = {32}},
                    selected = {color = {16}, text = {""}, backgroundColor = {32}},
                    disabled = {color = {128}, text = {""}, backgroundColor = {32}}
                },
                handleColor = {128},
                slider = {""},
                sliderBackgroundColor = {32},
                sliderColor = {256},
                handleBackgroundColor = {8192},
                handle = {"#"},
                buttonNegative = {
                    normal = {color = {1}, text = {""}, backgroundColor = {32}},
                    selected = {color = {16}, text = {""}, backgroundColor = {32}},
                    disabled = {color = {128}, text = {""}, backgroundColor = {32}}
                }
            },
            disabled = {
                buttonPositive = {disabled = {color = {256}, text = {""}, backgroundColor = {128}}},
                handleColor = {128},
                slider = {""},
                sliderBackgroundColor = {128},
                sliderColor = {256},
                handleBackgroundColor = {128},
                handle = {"#"},
                buttonNegative = {disabled = {color = {256}, text = {""}, backgroundColor = {128}}}
            }
        },
        selectedTheme = {
            spaceColor = 1,
            borderColor = 32,
            borderBackgroundColor = 8192,
            border = {{"+"}, {"-"}, {"+"}, {"|"}, {"|"}, {"+", "|", "+"}, {"-", " ", "-"}, {"+", "|", "+"}},
            textBackgroundColor = 8192,
            textColor = 16
        },
        normalTheme = {
            spaceColor = 1,
            borderColor = 32,
            borderBackgroundColor = 8192,
            border = {{"+"}, {"-"}, {"+"}, {"|"}, {"|"}, {"+", "|", "+"}, {"-", " ", "-"}, {"+", "|", "+"}},
            textBackgroundColor = 8192,
            textColor = 32
        }
    },
    textBox = {
        disabledTheme = {
            spaceColor = 1,
            borderColor = 256,
            borderBackgroundColor = 128,
            border = {{"+"}, {"-"}, {"+"}, {"|"}, {"|"}, {"+", "|", "+"}, {"-", " ", "-"}, {"+", "|", "+"}},
            textBackgroundColor = 128,
            textColor = 256
        },
        normalTheme = {
            spaceColor = 1,
            borderColor = 32,
            borderBackgroundColor = 8192,
            border = {{"+"}, {"-"}, {"+"}, {"|"}, {"|"}, {"+", "|", "+"}, {"-", " ", "-"}, {"+", "|", "+"}},
            textBackgroundColor = 8192,
            textColor = 32
        },
        label = {
            disabledTheme = {backgroundColor = 1, textColor = 128},
            normalTheme = {backgroundColor = 1, textColor = 32768},
            alignment = 1
        },
        selectedTheme = {
            spaceColor = 1,
            borderColor = 32,
            borderBackgroundColor = 8192,
            border = {{"+"}, {"-"}, {"+"}, {"|"}, {"|"}, {"+", "|", "+"}, {"-", " ", "-"}, {"+", "|", "+"}},
            textBackgroundColor = 8192,
            textColor = 16
        },
        slider = {
            normal = {
                buttonPositive = {
                    normal = {color = {1}, text = {""}, backgroundColor = {32}},
                    selected = {color = {16}, text = {""}, backgroundColor = {32}},
                    disabled = {color = {128}, text = {""}, backgroundColor = {32}}
                },
                handleColor = {128},
                slider = {""},
                sliderBackgroundColor = {32},
                sliderColor = {256},
                handleBackgroundColor = {8192},
                handle = {"#"},
                buttonNegative = {
                    normal = {color = {1}, text = {""}, backgroundColor = {32}},
                    selected = {color = {16}, text = {""}, backgroundColor = {32}},
                    disabled = {color = {128}, text = {""}, backgroundColor = {32}}
                }
            },
            disabled = {
                buttonPositive = {disabled = {color = {256}, text = {""}, backgroundColor = {128}}},
                handleColor = {128},
                slider = {""},
                sliderBackgroundColor = {128},
                sliderColor = {256},
                handleBackgroundColor = {128},
                handle = {"#"},
                buttonNegative = {disabled = {color = {256}, text = {""}, backgroundColor = {128}}}
            }
        }
    },
    slider = {
        normal = {
            buttonPositive = {
                normal = {color = {8, 8, 8}, text = {"[", "A", "]"}, backgroundColor = {2048, 2048, 2048}},
                selected = {color = {1, 1, 1}, text = {"[", "A", "]"}, backgroundColor = {2048, 2048, 2048}},
                disabled = {color = {256, 256, 256}, text = {"[", "A", "]"}, backgroundColor = {128, 128, 128}}
            },
            handleColor = {256, 128, 256},
            buttonNegative = {
                normal = {color = {8, 8, 8}, text = {"[", "A", "]"}, backgroundColor = {2048, 2048, 2048}},
                selected = {color = {1, 1, 1}, text = {"[", "A", "]"}, backgroundColor = {2048, 2048, 2048}},
                disabled = {color = {256, 256, 256}, text = {"[", "A", "]"}, backgroundColor = {128, 128, 128}}
            },
            sliderBackgroundColor = {128, 128, 128},
            sliderColor = {256, 256, 256},
            handleBackgroundColor = {256, 32768, 256},
            handle = {"|", "#", "|"},
            slider = {"|", "#", "|"}
        },
        disabled = {
            buttonPositive = {
                disabled = {color = {256, 256, 256}, text = {"[", "A", "]"}, backgroundColor = {128, 128, 128}}
            },
            handleColor = {256, 128, 256},
            buttonNegative = {
                disabled = {color = {256, 256, 256}, text = {"[", "A", "]"}, backgroundColor = {128, 128, 128}}
            },
            sliderBackgroundColor = {128, 128, 128},
            sliderColor = {256, 256, 256},
            handleBackgroundColor = {256, 32768, 256},
            handle = {"|", "#", "|"},
            slider = {"|", "#", "|"}
        }
    }
}
