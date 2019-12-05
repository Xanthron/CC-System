local test = "Was ein schöner\n\nTesttext"
for line in test:gmatch(".+[^\n\r]") do
    print(line)
end
