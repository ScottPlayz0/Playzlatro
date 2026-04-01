SMODS.Atlas({
    key = "modicon",
    path = "ModIcon.png",
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomConsumables",
    path = "CustomConsumables.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
})

local NFS = require("nativefs")
to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end
local function load_consumables_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/consumables"
    local ok, files = pcall(NFS.getDirectoryItemsInfo, consumables_path)
    if not ok or not files then return end
    for _, file in ipairs(files) do
        if file and file.name == "sets.lua" then
            pcall(function() assert(SMODS.load_file("consumables/sets.lua"))() end)
            break
        end
    end
    for _, file in ipairs(files) do
        if file and file.name and file.name:sub(-4) == ".lua" and file.name ~= "sets.lua" then
            pcall(function()
                assert(SMODS.load_file("consumables/" .. file.name))()
            end)
        end
    end
end
load_consumables_folder()
SMODS.current_mod.optional_features = function()
    return {
        cardareas = {}
    }
end