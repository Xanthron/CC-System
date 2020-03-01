local text = "Was..auch.immer"

for word in text:gmatch("[^%.]*") do
    print(word)
end
