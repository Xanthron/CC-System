www = {}
function www._getFileName(url)
    url = url:gsub("[#?].*", ""):gsub("/+$", "")
    return url:match("/([^/]+)$")
end

---@param url string
function www.get(url)
    local ok, err = http.checkURL(url)

    if not ok then
        return false, err or "Invalid URL."
    end

    local response = http.get(url, nil, true)
    if not response then
        return false, "Failed."
    end
    local content = response.readAll()
    response.close()

    return true, content
end

function www._run(content, name, ...)
    local func, err = load(content, name, "t", _ENV)
    if not func then
        return false, err
    end

    local ok, err = pcall(func, ...)
    if not ok then
        return false, err
    end
    return true
end

function www.run(url, ...)
    local success, content = get(url)
    if success then
        return www._run(content, www._getFileName(url), ...)
    else
        return false, content
    end
end

function www._save(content, path, override)
    local name = fs.getName(path)
    local path = path:match("^.*/?")
    if fs.exists(path) and not override then
        return false, "File already exists."
    end

    local file = fs.open(path, "wb")
    file.write(content)
    file.close()
    return true
end

function www.save(url, path, override)
    local success, content = www.get(url)
    if not success then
        return false, content
    end
    return www._save(content, path, override)
end

function www.pasteBinGet(url)
    local patterns = {
        "^([%a%d]+)$",
        "^https?://pastebin.com/([%a%d]+)$",
        "^pastebin.com/([%a%d]+)$",
        "^https?://pastebin.com/raw/([%a%d]+)$",
        "^pastebin.com/raw/([%a%d]+)$"
    }

    local code
    for i = 1, #patterns do
        code = url:match(patterns[i])
        if code then
            break
        end
    end

    if not code then
        return false, "No code found."
    end

    local response, err = http.get(("https://pastebin.com/raw/%s?cb=%x"):format(textutils.urlEncode(code), math.random(0, 2 ^ 30)))
    if not response then
        return false, err or "Failed."
    end

    local headers = response.getResponseHeaders()
    if not headers["Content-Type"] or not headers["Content-Type"]:find("^text/plain") then
        return false, "Pastebin block"
    end
    local content = response.readAll()
    response.close()

    return true, content
end

function www.pasteBinRun(url)
    local success, content = www.pasteBinGet(url)
    if success then
        return www._run(content, www._getFileName(url))
    else
        return false, content
    end
end

function www.pasteBinSave(url, path, override)
    local success, content = www.pasteBinGet(url)
    if success then
        return www._save(content, path, override)
    else
        return false, content
    end
end

---@param text string
function www.pasteBinPut(text)
    local key = "0ec2eb25b6166c0c27a394ae118ad829"
    local response = http.post("https://pastebin.com/api/api_post.php", "api_option=paste&" .. "api_dev_key=" .. key .. "&" .. "api_paste_format=lua&" .. "api_paste_name=" .. textutils.urlEncode("file") .. "&" .. "api_paste_code=" .. textutils.urlEncode(text))
    if response then
        local responseText = response.readAll()
        response.close()
        local code = string.match(responseText, "[^/]+$")
        return true, code
    else
        return false, "Failed."
    end
end
