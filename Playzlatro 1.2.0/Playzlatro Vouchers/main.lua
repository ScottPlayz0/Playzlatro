SMODS.Atlas({
    key = "modicon",
    path = "ModIcon.png",
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

local voucherAtlasPath = "CustomVouchers.png"  
local atlas_px = 71
local atlas_py = 95

SMODS.Atlas({
    key = "CustomVouchers",
    path = voucherAtlasPath,
    px = atlas_px,
    py = atlas_py,
    atlas_table = "ASSET_ATLAS"
})

local atlasAliases = {
    "Voucher",
    "CustomVoucher",
    "customvoucher",
    "playzlat_Voucher",
    "playzlat_voucher",
    "playzlat_CustomVoucher",
    "playzlat_customvoucher"
}

for _, key in ipairs(atlasAliases) do
    pcall(function()
        SMODS.Atlas({
            key = key,
            path = voucherAtlasPath,
            px = atlas_px,
            py = atlas_py,
            atlas_table = "ASSET_ATLAS"
        })
    end)
end

local NFS = require("nativefs")
to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end
local voucherIndexList = {1,2,3,4,5,6,7,8}
local function load_vouchers_folder()
    local mod_path = SMODS.current_mod.path
    local vouchers_path = mod_path .. "/vouchers"
    local files = NFS.getDirectoryItemsInfo(vouchers_path)
    for i = 1, #voucherIndexList do
        local file = files[voucherIndexList[i]]
        if file and file.name:sub(-4) == ".lua" then
            assert(SMODS.load_file("vouchers/" .. file.name))()
        end
    end
end

load_vouchers_folder()

SMODS.current_mod.optional_features = function()
    return {
        cardareas = {}
    }
end

local create_card_ref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == "Joker" and G.GAME and G.GAME.playz_legendary_in_shop and not legendary then
        if pseudorandom("playz_legendary_roll") < (G.GAME.playz_legendary_rate or 0) then
            legendary = true
            _rarity = 4
        end
    end
    return create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end

local create_card_ref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == 'Joker' and G.GAME then
        if G.GAME.playz_true_equal and not forced_key then
            local keys = {}
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and not v.no_pool_flag and not v.demo then
                    table.insert(keys, k)
                end
            end
            if #keys > 0 then
                forced_key = pseudorandom_element(keys, pseudoseed('true_equal'))
            end
        end
        if not forced_key and G.GAME.playz_legendary_in_shop and not legendary then
            if pseudorandom('playz_legendary_roll') < (G.GAME.playz_legendary_rate or 0) then
                legendary = true
                _rarity = 4
            end
        end
    end
    return create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end