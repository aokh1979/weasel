-- tone_filter.lua
-- When input ends with a tone letter (ASDFGHJKLQWER),
-- only show candidates whose input key ends with the same tone letter.
-- Otherwise show all candidates normally.

local tone_letters = {
    A=true, S=true, D=true, F=true, G=true, H=true,
    J=true, K=true, L=true, Q=true, W=true, E=true, R=true
}

local function get_last_tone_letter(input)
    if not input or #input == 0 then return nil end
    local last = input:sub(-1)
    if tone_letters[last] then
        return last
    end
    return nil
end

local function filter(input, env)
    local context = env.engine.context
    local raw_input = context.input

    local tone = get_last_tone_letter(raw_input)

    if not tone then
        -- No tone letter at end — pass all candidates through
        for cand in input:iter() do
            yield(cand)
        end
        return
    end

    -- Tone letter detected — only yield candidates ending with same letter
    for cand in input:iter() do
        local code = cand.preedit or ''
        -- Also check comment which may contain the romanisation
        local comment = cand.comment or ''
        -- Get the last character of the candidate's input code
        local last_char = code:sub(-1)
        if last_char == tone then
            yield(cand)
        end
    end
end

return { func = filter }
