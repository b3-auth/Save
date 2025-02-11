--!native
--!optimize 2
--!divine-intellect

-- Script chỉnh sửa để sao chép toàn bộ game trên Roblox
-- Bao gồm tất cả Instances, Scripts, Plugins, Assets

local function saveGame()
    local HttpService = game:GetService("HttpService")
    local DataModel = game:GetService("DataModel")

    -- Hàm lưu toàn bộ game
    local function saveInstance(instance)
        local success, result = pcall(function()
            return HttpService:JSONEncode(instance)
        end)

        if success then
            return result
        else
            warn("Lỗi khi lưu instance:", instance, result)
            return nil
        end
    end

    -- Tạo bảng chứa tất cả dữ liệu game
    local gameData = {
        Instances = {},
        Scripts = {},
        Plugins = {},
        Assets = {}
    }

    -- Lưu tất cả các Instances
    for _, instance in ipairs(DataModel:GetDescendants()) do
        table.insert(gameData.Instances, saveInstance(instance))
    end

    -- Lưu tất cả Scripts
    for _, script in ipairs(DataModel:GetDescendants()) do
        if script:IsA("LocalScript") or script:IsA("ModuleScript") or script:IsA("Script") then
            table.insert(gameData.Scripts, {
                Name = script.Name,
                Source = script.Source
            })
        end
    end

    -- Lưu tất cả Plugins
    local PluginService = game:GetService("PluginService")
    for _, plugin in ipairs(PluginService:GetChildren()) do
        table.insert(gameData.Plugins, saveInstance(plugin))
    end

    -- Lưu tất cả Assets (Models, Sounds, Textures...)
    local AssetService = game:GetService("InsertService")
    for _, asset in ipairs(AssetService:GetChildren()) do
        table.insert(gameData.Assets, saveInstance(asset))
    end

    -- Xuất dữ liệu ra file JSON
    local gameDataJSON = HttpService:JSONEncode(gameData)
    writefile("GameCopy.rbxl", gameDataJSON)

    print("Game đã được sao chép thành công!")
end

saveGame()
