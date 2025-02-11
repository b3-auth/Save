local HttpService = game:GetService("HttpService")
local scriptUrl = "https://raw.githubusercontent.com/b3-auth/Save/main/x3.lua"

local function downloadAndRunScript(url)
    print("🔄 Đang tải script từ GitHub...")

    local startTime = tick() -- Bắt đầu đo thời gian tải
    local response = game:HttpGet(url, true) -- Tải script
    local totalSize = #response
    local chunkSize = totalSize / 10 -- Chia thành 10 phần
    local downloaded = 0

    -- Hiển thị tiến trình tải
    for i = 1, 10 do
        task.wait(0.2) -- Giả lập tải (có thể bỏ)
        downloaded = downloaded + chunkSize
        print(string.format("📥 Đang tải... %.0f%%", (downloaded / totalSize) * 100))
    end

    local elapsedTime = tick() - startTime -- Tính thời gian tải
    print("✅ Tải xong! Thời gian tải: " .. string.format("%.2f", elapsedTime) .. " giây")

    -- Chạy script đã tải về
    return response
end

local function copyGame()
    print("🔄 Đang sao chép toàn bộ game...")

    local startCopyTime = tick()
    local gameData = { Instances = {}, Scripts = {}, Assets = {} }

    -- Lưu tất cả Instances
    for _, instance in ipairs(game:GetDescendants()) do
        table.insert(gameData.Instances, {
            Name = instance.Name,
            ClassName = instance.ClassName,
            Properties = instance:GetAttributes(),
        })
    end

    -- Lưu tất cả Scripts
    for _, script in ipairs(game:GetDescendants()) do
        if script:IsA("LocalScript") or script:IsA("ModuleScript") or script:IsA("Script") then
            table.insert(gameData.Scripts, {
                Name = script.Name,
                Source = script.Source
            })
        end
    end

    -- Lưu toàn bộ Assets
    local AssetService = game:GetService("InsertService")
    for _, asset in ipairs(AssetService:GetChildren()) do
        table.insert(gameData.Assets, {
            Name = asset.Name,
            ClassName = asset.ClassName
        })
    end

    local elapsedCopyTime = tick() - startCopyTime
    print("✅ Sao chép xong! Thời gian sao chép: " .. string.format("%.2f", elapsedCopyTime) .. " giây")

    return gameData, elapsedCopyTime
end

local function saveGameData(gameData, copyTime)
    print("💾 Đang lưu file...")

    local startSaveTime = tick()
    local jsonData = HttpService:JSONEncode(gameData)
    writefile("GameCopy.rbxl", jsonData)

    local elapsedSaveTime = tick() - startSaveTime
    print("✅ Lưu xong! Thời gian lưu: " .. string.format("%.2f", elapsedSaveTime) .. " giây")

    -- Tổng thời gian
    print("⏳ Tổng thời gian: " .. string.format("%.2f", copyTime + elapsedSaveTime) .. " giây")
end

-- Chạy toàn bộ quá trình
local scriptContent = downloadAndRunScript(scriptUrl)
local gameData, copyTime = copyGame()
saveGameData(gameData, copyTime)

-- Chạy script tải từ GitHub
loadstring(scriptContent)()
