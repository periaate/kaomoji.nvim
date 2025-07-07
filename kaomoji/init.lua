local M = {
    moji = {
        [[(๑>◡<๑)           :: yay, happy, excited, closed eyes, ><, smiling]],
        [[٩(◕‿◕｡)۶          :: yay, happy, yippee, open eyes, smiling, blush, arms]],
        [[(─‿‿─)            :: comfy, smiling, kitty, ;3, closed eyes]],
        [[<(￣︶￣)>        :: proud, smiling, closed eyes, arms]],
        [[(≧◡≦)             :: yay happy yippee excited smiling closed eyes blush ><]],
        [[(￢‿￢ )          :: smug, suggestive, smirk, smiling, looking sideways]],
        [[(ᗒ⩊ᗕ)             :: smiling ;3 ><]],
        [[(・`ω´・)         :: grr!! >;3 eyebrows]],
        [[( `ε´ )           :: abuu! pouting grr angy]],
        [[(≖､≖╬)            :: are we fr rn? angy frustrated]],
        [[┐(︶▽︶)┌         :: domt car! shrug bird closed eyes arms]],
        [[／(˃ᆺ˂)＼         :: bnuy cute ;3 ><]],
        [[(〜￣▽￣)〜       :: dance this way bird!]],
        [[〜(￣▽￣〜)       :: dance that way bord!]],
        [[♨o(>_<)o♨         :: waa cooked too much!!! >< closed eyes arms cookage dish]],
        [[( ˘▽˘)っ♨         :: ah I done cooked! comfy bord closed eyes arm cookage dish]],
        [[(￣﹃￣)          :: ah I want eated... comfy drool]],
        [[(๑ᵔ⤙ᵔ๑)           :: yay I eatig! comfy eatig face]],
        [[─=≡Σ((( つ＞＜)つ :: aaa i bwoke it!!! quick escape aaa ><]],
        [[ε===(っ≧ω≦)っ     :: teehee i bwoke it!!! quick escape yaay ;3 ><]],
        [[┬┴┬┴┤ω･)          :: the hider look!! ;3]],
        [[┬┴┬┴┤･ω･)ﾉ        :: the hider greet!! ;3]],
        [[(っ╹ᆺ╹)っ         :: bnuy]],
        [[(„¬ᴗ¬„)           :: smug blush looking sideways]],
    },
}


--- Creates a function that clamps a value within a specified range.
--- @param lower number The lower bound of the range.
--- @param upper number The upper bound of the range.
--- @return fun(val:number):number function that takes a value and returns it clamped between the lower and upper bounds.
local function Clamp(lower, upper)
    if lower > upper then lower, upper = upper, lower end

    return function(val)
        if val >= upper     then return upper
        elseif val <= lower then return lower
        else                     return val end
    end
end

local function get_max_col() return #vim.api.nvim_get_current_line() end
local function get_max_row() return vim.api.nvim_buf_line_count(0) end

function M.find_and_paste()
    local actions = require("telescope.actions")

    require("telescope.pickers").new({}, {
        prompt_title = [[( ˘▽˘)っ♨  (๑ᵔ⤙ᵔ๑)]],
        finder = require("telescope.finders").new_table({
            results = M.moji,
        }),
        sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selections = require("telescope.actions.state").get_selected_entry()
                local sel = selections[1]
                sel = sel:gsub([[(.*)%s*::.*]], "%1"):gsub("^%s*(.-)%s*$", "%1")
                vim.api.nvim_paste(sel, false, -1)
                local pos = vim.api.nvim_win_get_cursor(0)
                pos = { row = pos[1], col = pos[2] }
                local new_col = pos.col+#sel
                vim.api.nvim_win_set_cursor(0, {
                    Clamp(1, get_max_row())(pos.row),
                    Clamp(0, get_max_col())(new_col),
                })
            end)
            return true
        end,
    }):find()
end

M.find_and_paste()
