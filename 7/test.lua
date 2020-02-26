local test = {"was", "kann", "ich", [6] = "was", [5] = "lol"}
test[4] = "na"
for _, value in pairs(test) do
    print(_, value)
end
