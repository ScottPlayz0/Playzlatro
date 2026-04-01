SMODS.Atlas({
    key = "modicon",
    path = "ModIcon.png",
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "playz_jokers",
    path = "playz_jokers.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
})

local NFS = require("nativefs")

to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end

local jokerIndexList = { 1, 2 }

local function load_jokers_folder()
    local mod_path = SMODS.current_mod.path
    local jokers_path = mod_path .. "/jokers"

    local ok, files = pcall(NFS.getDirectoryItemsInfo, jokers_path)
    if not ok or not files then return end

    for i = 1, #jokerIndexList do
        local idx = jokerIndexList[i]
        local file = files[idx]
        if file and file.name and file.name:sub(-4) == ".lua" then
            pcall(function()
                assert(SMODS.load_file("jokers/" .. file.name))()
            end)
        end
    end

    for _, file in ipairs(files) do
        if file.name:sub(-4) == ".lua" then
            pcall(function()
                assert(SMODS.load_file("jokers/" .. file.name))()
            end)
        end
    end
end

load_jokers_folder()


SMODS.ObjectType({
    key = "chipsnan_food",
    cards = {
        j_gros_michel = true,
        j_egg = true,
        j_ice_cream = true,
        j_cavendish = true,
        j_turtle_bean = true,
        j_diet_cola = true,
        j_popcorn = true,
        j_ramen = true,
        j_selzer = true
    },
})
