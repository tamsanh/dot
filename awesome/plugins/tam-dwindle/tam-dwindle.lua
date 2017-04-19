---------------------------------------------------------------------------
-- @author Uli Schlachter &lt;psychon@znc.in&gt;
-- @copyright 2009 Uli Schlachter
-- @copyright 2008 Julien Danjou
-- @release v3.5.4
---------------------------------------------------------------------------

-- Grab environment we need
local ipairs = ipairs
local math = math

-- tam_dwindle
local tam_dwindle = {}

local function do_spiral(p)
    local wa = p.workarea
    local cls = p.clients
    local n = #cls
    local old_width, old_height = wa.width, 2 * wa.height

    -- We want to do the bigger width thing just for the first one.

    for k, c in ipairs(cls) do
        -- For every even one
        -- Make the new width one half
        local border_width_offset = old_width - math.ceil(old_width / 1.65)
        if k == 1 then
          wa.width, old_width = math.ceil(old_width / 1.65), wa.width
        elseif k % 2 == 0 then
            if k == 2 then
              wa.width, old_width = old_width - math.ceil(old_width / 1.65), wa.width
            else
              wa.width, old_width = math.ceil(old_width / 2), wa.width
            end
            if k ~= n then
                wa.height, old_height = math.floor(wa.height / 2), wa.height
            end
        else
            wa.height, old_height = math.ceil(old_height / 2), wa.height
            if k ~= n then
                wa.width, old_width = math.floor(wa.width / 2), wa.width
            end
        end

        if k % 2 == 0 then
            wa.x = wa.x + old_width
        end

        if k % 2 == 1 and k ~= 1 then
            wa.y = wa.y + old_height
        end

        local g = {
            x = wa.x,
            y = wa.y,
            width = wa.width - 2 * c.border_width,
            height = wa.height - 2 * c.border_width
        }
        c:geometry(g)
    end
end

--- Spiral layout
--- Icon is determined by the name.
tam_dwindle.name = "spiral"
function tam_dwindle.arrange(p)
    return do_spiral(p)
end

return tam_dwindle

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
