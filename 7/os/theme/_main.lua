local style = ui.style.new()
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
    button4.nTheme.b = {{}, {}, {}, {"x"}, {" "}, {}, {}, {}, {}}
    button4.pTheme.b = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    button4.sTheme.b = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    button4.dTheme.b = {{}, {}, {}, {"*"}, {" "}, {}, {}, {}, {}}
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
---@type style.toggleButton
local toggle1 = style("toggleButton")
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
local iField1 = style("inputField")
iField1.nTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
iField1.dTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
iField1.sTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
local iField2 = style("inputField")
iField2.align = 3
iField2.nTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
iField2.nTheme.sTC = colors.lime
iField2.nTheme.tC = colors.black
iField2.nTheme.tBG = colors.lime
iField2.dTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
iField2.sTheme.b = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
local label1 = style("label")
label1.align = 1
label1.nTheme.tBG = colors.green
label1.nTheme.tC = colors.black
local label2 = style("label")
assets.variables.save("os/theme/main.lua", {button1 = button1, button2 = button2, button3 = button3, button4 = button4, toggle1 = toggle1, activatedButton = activatedButton, deactivatedButton = deactivatedButton, sView1 = sView1, sView2 = sView2, tBox1 = tBox1, tBox2 = tBox2, iField2 = iField2, iField1 = iField1, label1 = label1, label2 = label2})
