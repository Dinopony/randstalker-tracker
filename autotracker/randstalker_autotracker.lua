ICON_SIZE_WITHOUT_MARGINS = 56
ICON_MARGIN = 4
ICON_SIZE = ICON_SIZE_WITHOUT_MARGINS + (ICON_MARGIN * 2)
WINDOW_WIDTH = 400
WINDOW_HEIGHT = 554

MEMORY_MAPPINGS = {
    sword_1          = { addr = 0xFF1040, msb = true  },
    sword_2          = { addr = 0xFF1041, msb = true },
    sword_3          = { addr = 0xFF1041, msb = false  },
    sword_4          = { addr = 0xFF1042, msb = false },
    armor_1          = { addr = 0xFF1044, msb = true  },
    armor_2          = { addr = 0xFF1045, msb = false },
    armor_3          = { addr = 0xFF1045, msb = true  },
    armor_4          = { addr = 0xFF1046, msb = false },
    boots_1          = { addr = 0xFF1043, msb = true  },
    boots_2          = { addr = 0xFF1042, msb = true },
    boots_3          = { addr = 0xFF1043, msb = false  },
    boots_4          = { addr = 0xFF1044, msb = false },
    ring_1           = { addr = 0xFF1046, msb = true  },
    ring_2           = { addr = 0xFF1047, msb = true },
    ring_3           = { addr = 0xFF1047, msb = false  },
    ring_4           = { addr = 0xFF1048, msb = false },
    lithograph       = { addr = 0xFF1053, msb = true  },
    oracle_stone     = { addr = 0xFF1058, msb = false },
    bell             = { addr = 0xFF105A, msb = true  },
    statue_jypta     = { addr = 0xFF104E, msb = true  },
    idol_stone       = { addr = 0xFF1058, msb = true  },
    safety_pass      = { addr = 0xFF1059, msb = true  },
    armlet           = { addr = 0xFF104F, msb = true  },
    garlic           = { addr = 0xFF104D, msb = true  },
    key              = { addr = 0xFF1059, msb = false },
    lantern          = { addr = 0xFF104D, msb = false },
    einstein_whistle = { addr = 0xFF1050, msb = false },
    sun_stone        = { addr = 0xFF104F, msb = false },
    axe_magic        = { addr = 0xFF104B, msb = true  },
    logs             = { addr = 0xFF1057, msb = true  },
    buyer_card       = { addr = 0xFF104C, msb = true  },
    casino_ticket    = { addr = 0xFF104B, msb = false },
    gola_eye         = { addr = 0xFF1055, msb = true  },
    red_jewel        = { addr = 0xFF1054, msb = false },
    purple_jewel     = { addr = 0xFF1055, msb = false },
    green_jewel      = { addr = 0xFF105A, msb = false },
    blue_jewel       = { addr = 0xFF1050, msb = true  },
    yellow_jewel     = { addr = 0xFF1051, msb = false },
    gola_nail        = { addr = 0xFF105B, msb = true  },
    gola_fang        = { addr = 0xFF105C, msb = true  },
    gola_horn        = { addr = 0xFF105C, msb = false }
}

ITEM_LAYOUT = {
    'sword_1', 'sword_2', 'sword_3', 'sword_4', '', 'lithograph',
    'armor_1', 'armor_2', 'armor_3', 'armor_4', '', 'oracle_stone',
    'boots_1', 'boots_2', 'boots_3', 'boots_4', '', 'bell',
    'ring_1', 'ring_2', 'ring_3', 'ring_4', '', 'statue_jypta',
    
    'idol_stone', 'safety_pass', 'armlet', 'garlic', 'key', 'lantern', 
    'einstein_whistle', 'sun_stone', 'axe_magic', 'logs', 'buyer_card', 'casino_ticket', 

    'gola_eye', 'red_jewel', 'purple_jewel', 'green_jewel', 'blue_jewel', 'yellow_jewel', 
    '', '', '', 'gola_nail', 'gola_fang', 'gola_horn'
}

function get_item_quantity(addr, msb)
    value = memory.read_u8(addr - 0xFF0000, "68K RAM")
    msh = math.floor(value / 16)
    lsh = value - (msh * 16)
    if msb then
        return msh
    else
        return lsh
    end
end

function draw_inventory()
    x = 0
    y = 0
    forms.clear(canvas_handle, 0xFF666666)
    for index, name in pairs(ITEM_LAYOUT) do
        if (x + ICON_SIZE) > WINDOW_WIDTH then
            x = 0
            y = y + ICON_SIZE
        end

        if name ~= '' then
            string.format("%s => %d", name, inventory[name])
            if inventory[name] > 0 then
                image_path = string.format("./ls_assets/%s.gif", name)
            else
                image_path = string.format("./ls_assets/%s_off.gif", name)
            end
            forms.drawImage(canvas_handle, image_path, x + ICON_MARGIN, y + ICON_MARGIN)
        end

        x = x + ICON_SIZE
    end

    forms.refresh(canvas_handle)
end

inventory = {}
console.log("Starting autotracker...")
form_handle = forms.newform(WINDOW_WIDTH, WINDOW_HEIGHT, "Randstalker Tracker")
canvas_handle = forms.pictureBox(form_handle, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

frame_count = 0
while true do
    frame_count = frame_count + 1
    if frame_count % 20 == 0 then
        frame_count = 0
        updated = false
        for name, mem in pairs(MEMORY_MAPPINGS) do
            new_value = get_item_quantity(mem["addr"], mem["msb"])
            if new_value ~= inventory[name] then
                inventory[name] = new_value
                updated = true
            end
        end

        if updated == true then
            draw_inventory()
        end
    end
	emu.frameadvance()
end

forms.destroyall()