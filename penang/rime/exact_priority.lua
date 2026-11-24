-- Prefer genuine full spellings, including single-letter syllables, over
-- generated shortcuts. Provenance comments survive dictionary deduplication.
-- Both translators share the original dictionary/code IDs and user database.
-- Only the original translator learns; its transaction remains undoable.
-- Split-syllable codes v1: dictionary codes are space-separated syllables with
-- tone keys (tsunSQ piJE). Ranking metadata uses toneless joined spellings (tsunpi).
-- POJ presentation/input adapter v1. Dictionary entries and learning IDs stay canonical.
local poj_decompose = {["À"]="À",["Á"]="Á",["Â"]="Â",["È"]="È",["É"]="É",["Ê"]="Ê",["Ì"]="Ì",["Í"]="Í",["Î"]="Î",["Ò"]="Ò",["Ó"]="Ó",["Ô"]="Ô",["Ù"]="Ù",["Ú"]="Ú",["Û"]="Û",["Ý"]="Ý",["à"]="à",["á"]="á",["â"]="â",["è"]="è",["é"]="é",["ê"]="ê",["ì"]="ì",["í"]="í",["î"]="î",["ò"]="ò",["ó"]="ó",["ô"]="ô",["ù"]="ù",["ú"]="ú",["û"]="û",["ý"]="ý",["Ā"]="Ā",["ā"]="ā",["Ă"]="Ă",["ă"]="ă",["Ć"]="Ć",["ć"]="ć",["Ĉ"]="Ĉ",["ĉ"]="ĉ",["Č"]="Č",["č"]="č",["Ď"]="Ď",["ď"]="ď",["Ē"]="Ē",["ē"]="ē",["Ĕ"]="Ĕ",["ĕ"]="ĕ",["Ě"]="Ě",["ě"]="ě",["Ĝ"]="Ĝ",["ĝ"]="ĝ",["Ğ"]="Ğ",["ğ"]="ğ",["Ĥ"]="Ĥ",["ĥ"]="ĥ",["Ī"]="Ī",["ī"]="ī",["Ĭ"]="Ĭ",["ĭ"]="ĭ",["Ĵ"]="Ĵ",["ĵ"]="ĵ",["Ĺ"]="Ĺ",["ĺ"]="ĺ",["Ľ"]="Ľ",["ľ"]="ľ",["Ń"]="Ń",["ń"]="ń",["Ň"]="Ň",["ň"]="ň",["Ō"]="Ō",["ō"]="ō",["Ŏ"]="Ŏ",["ŏ"]="ŏ",["Ő"]="Ő",["ő"]="ő",["Ŕ"]="Ŕ",["ŕ"]="ŕ",["Ř"]="Ř",["ř"]="ř",["Ś"]="Ś",["ś"]="ś",["Ŝ"]="Ŝ",["ŝ"]="ŝ",["Š"]="Š",["š"]="š",["Ť"]="Ť",["ť"]="ť",["Ū"]="Ū",["ū"]="ū",["Ŭ"]="Ŭ",["ŭ"]="ŭ",["Ű"]="Ű",["ű"]="ű",["Ŵ"]="Ŵ",["ŵ"]="ŵ",["Ŷ"]="Ŷ",["ŷ"]="ŷ",["Ź"]="Ź",["ź"]="ź",["Ž"]="Ž",["ž"]="ž",["Ǎ"]="Ǎ",["ǎ"]="ǎ",["Ǐ"]="Ǐ",["ǐ"]="ǐ",["Ǒ"]="Ǒ",["ǒ"]="ǒ",["Ǔ"]="Ǔ",["ǔ"]="ǔ",["Ǧ"]="Ǧ",["ǧ"]="ǧ",["Ǩ"]="Ǩ",["ǩ"]="ǩ",["ǰ"]="ǰ",["Ǵ"]="Ǵ",["ǵ"]="ǵ",["Ǹ"]="Ǹ",["ǹ"]="ǹ",["Ȟ"]="Ȟ",["ȟ"]="ȟ",["Ȳ"]="Ȳ",["ȳ"]="ȳ",["Ḕ"]="Ḕ",["ḕ"]="ḕ",["Ḗ"]="Ḗ",["ḗ"]="ḗ",["Ḡ"]="Ḡ",["ḡ"]="ḡ",["Ḱ"]="Ḱ",["ḱ"]="ḱ",["Ḿ"]="Ḿ",["ḿ"]="ḿ",["Ṑ"]="Ṑ",["ṑ"]="ṑ",["Ṓ"]="Ṓ",["ṓ"]="ṓ",["Ṕ"]="Ṕ",["ṕ"]="ṕ",["Ẁ"]="Ẁ",["ẁ"]="ẁ",["Ẃ"]="Ẃ",["ẃ"]="ẃ",["Ẑ"]="Ẑ",["ẑ"]="ẑ",["Ấ"]="Ấ",["ấ"]="ấ",["Ầ"]="Ầ",["ầ"]="ầ",["Ắ"]="Ắ",["ắ"]="ắ",["Ằ"]="Ằ",["ằ"]="ằ",["Ế"]="Ế",["ế"]="ế",["Ề"]="Ề",["ề"]="ề",["Ố"]="Ố",["ố"]="ố",["Ồ"]="Ồ",["ồ"]="ồ",["Ỳ"]="Ỳ",["ỳ"]="ỳ"}
local poj_compose = {["À"]="À",["Á"]="Á",["Â"]="Â",["È"]="È",["É"]="É",["Ê"]="Ê",["Ì"]="Ì",["Í"]="Í",["Î"]="Î",["Ò"]="Ò",["Ó"]="Ó",["Ô"]="Ô",["Ù"]="Ù",["Ú"]="Ú",["Û"]="Û",["Ý"]="Ý",["à"]="à",["á"]="á",["â"]="â",["è"]="è",["é"]="é",["ê"]="ê",["ì"]="ì",["í"]="í",["î"]="î",["ò"]="ò",["ó"]="ó",["ô"]="ô",["ù"]="ù",["ú"]="ú",["û"]="û",["ý"]="ý",["Ā"]="Ā",["ā"]="ā",["Ă"]="Ă",["ă"]="ă",["Ć"]="Ć",["ć"]="ć",["Ĉ"]="Ĉ",["ĉ"]="ĉ",["Č"]="Č",["č"]="č",["Ď"]="Ď",["ď"]="ď",["Ē"]="Ē",["ē"]="ē",["Ĕ"]="Ĕ",["ĕ"]="ĕ",["Ě"]="Ě",["ě"]="ě",["Ĝ"]="Ĝ",["ĝ"]="ĝ",["Ğ"]="Ğ",["ğ"]="ğ",["Ĥ"]="Ĥ",["ĥ"]="ĥ",["Ī"]="Ī",["ī"]="ī",["Ĭ"]="Ĭ",["ĭ"]="ĭ",["Ĵ"]="Ĵ",["ĵ"]="ĵ",["Ĺ"]="Ĺ",["ĺ"]="ĺ",["Ľ"]="Ľ",["ľ"]="ľ",["Ń"]="Ń",["ń"]="ń",["Ň"]="Ň",["ň"]="ň",["Ō"]="Ō",["ō"]="ō",["Ŏ"]="Ŏ",["ŏ"]="ŏ",["Ő"]="Ő",["ő"]="ő",["Ŕ"]="Ŕ",["ŕ"]="ŕ",["Ř"]="Ř",["ř"]="ř",["Ś"]="Ś",["ś"]="ś",["Ŝ"]="Ŝ",["ŝ"]="ŝ",["Š"]="Š",["š"]="š",["Ť"]="Ť",["ť"]="ť",["Ū"]="Ū",["ū"]="ū",["Ŭ"]="Ŭ",["ŭ"]="ŭ",["Ű"]="Ű",["ű"]="ű",["Ŵ"]="Ŵ",["ŵ"]="ŵ",["Ŷ"]="Ŷ",["ŷ"]="ŷ",["Ź"]="Ź",["ź"]="ź",["Ž"]="Ž",["ž"]="ž",["Ǎ"]="Ǎ",["ǎ"]="ǎ",["Ǐ"]="Ǐ",["ǐ"]="ǐ",["Ǒ"]="Ǒ",["ǒ"]="ǒ",["Ǔ"]="Ǔ",["ǔ"]="ǔ",["Ǧ"]="Ǧ",["ǧ"]="ǧ",["Ǩ"]="Ǩ",["ǩ"]="ǩ",["ǰ"]="ǰ",["Ǵ"]="Ǵ",["ǵ"]="ǵ",["Ǹ"]="Ǹ",["ǹ"]="ǹ",["Ȟ"]="Ȟ",["ȟ"]="ȟ",["Ȳ"]="Ȳ",["ȳ"]="ȳ",["Ḕ"]="Ḕ",["ḕ"]="ḕ",["Ḗ"]="Ḗ",["ḗ"]="ḗ",["Ḡ"]="Ḡ",["ḡ"]="ḡ",["Ḱ"]="Ḱ",["ḱ"]="ḱ",["Ḿ"]="Ḿ",["ḿ"]="ḿ",["Ṑ"]="Ṑ",["ṑ"]="ṑ",["Ṓ"]="Ṓ",["ṓ"]="ṓ",["Ṕ"]="Ṕ",["ṕ"]="ṕ",["Ẁ"]="Ẁ",["ẁ"]="ẁ",["Ẃ"]="Ẃ",["ẃ"]="ẃ",["Ẑ"]="Ẑ",["ẑ"]="ẑ",["Ấ"]="Ấ",["ấ"]="ấ",["Ầ"]="Ầ",["ầ"]="ầ",["Ắ"]="Ắ",["ắ"]="ắ",["Ằ"]="Ằ",["ằ"]="ằ",["Ế"]="Ế",["ế"]="ế",["Ề"]="Ề",["ề"]="ề",["Ố"]="Ố",["ố"]="ố",["Ồ"]="Ồ",["ồ"]="ồ",["Ỳ"]="Ỳ",["ỳ"]="ỳ"}
local poj_tones = {["̀"]=true,["́"]=true,["̂"]=true,["̄"]=true,["̍"]=true,["̆"]=true,["̌"]=true,["̋"]=true}
local function poj_input(s)
  -- All replacements have equal byte lengths, preserving candidate spans.
  return (s:gsub("chh", "tsh"):gsub("ch", "ts"):gsub("oa", "ua"):gsub("oe", "ue"))
end
local function poj_syllable(word)
  local units = {}
  for _, cp in utf8.codes(word) do
    local c = utf8.char(cp)
    for _, dcp in utf8.codes(poj_decompose[c] or c) do
      local d = utf8.char(dcp)
      if d:match("^[A-Za-z]$") then units[#units+1] = {b=d, mark="", dot=""}
      elseif #units > 0 and poj_tones[d] then units[#units].mark = units[#units].mark .. d
      elseif #units > 0 then units[#units].dot = units[#units].dot .. d end
    end
  end
  local out, i = {}, 1
  local function casing(c, original) return original:match("%u") and c:upper() or c end
  while i <= #units do
    local a,b,c = units[i], units[i+1], units[i+2]
    local pair = a.b:lower() .. (b and b.b:lower() or "")
    if pair == "ts" then
      out[#out+1]={b=casing("c",a.b),mark=a.mark,dot=a.dot}
      out[#out+1]={b=casing("h",b.b),mark=b.mark,dot=b.dot}
      i=i+2 -- an existing third h remains h: tsh -> chh
    elseif pair == "ua" or pair == "ue" then
      out[#out+1]={b=casing("o",a.b),mark=a.mark,dot=a.dot};out[#out+1]=b;i=i+2
    elseif pair == "oo" or pair == "ee" then
      out[#out+1]={b=a.b,mark=a.mark..b.mark,dot="͘"};i=i+2
    elseif pair == "nn" then
      out[#out+1]={b="ⁿ",mark=a.mark..b.mark,dot=""};i=i+2
    else out[#out+1]=a;i=i+1 end
  end
  -- Only the agreed POJ tone-placement differences are moved.
  local plain=""; local tone="";local tone_index=nil
  for j,u in ipairs(out) do
    plain=plain..u.b:lower()
    if u.mark~="" then tone=tone..u.mark;tone_index=j end
  end
  if tone_index then
    local target=nil
    for j=1,#out-1 do
      local pair=out[j].b:lower()..out[j+1].b:lower()
      if pair=="oa" or pair=="oe" then
        local following=""
        for k=j+2,#out do following=following..out[k].b:lower() end
        -- Nasalisation alone is not a consonant ending: uann2 -> óaⁿ.
        target=(following=="" or following=="ⁿ") and j or j+1
      elseif pair=="ui" then target=j end
    end
    if target then
      for _,u in ipairs(out) do u.mark="" end
      out[target].mark=tone
    end
  end
  local result={}
  for _,u in ipairs(out) do
    result[#result+1]=(poj_compose[u.b..u.mark] or (u.b..u.mark))..u.dot
  end
  return table.concat(result)
end
local function poj_output(text)
  local result, word={},{}
  local function flush()
    if #word>0 then result[#result+1]=poj_syllable(table.concat(word));word={} end
  end
  for _,cp in utf8.codes(text) do
    local c=utf8.char(cp)
    if c:match("^[A-Za-z]$") or poj_decompose[c] or (cp>=0x300 and cp<=0x36f) then
      word[#word+1]=c
    else flush();result[#result+1]=c end
  end
  flush();return table.concat(result)
end

local function plain(stored) return (stored:gsub("[A-Z ]", "")) end
-- Exact typable forms of a stored code: each syllable bare, with its 9-tone key
-- or with its 4-group key (tsunSQ -> tsun, tsunS, tsunQ).
local function typable_forms(stored)
  local forms = {""}
  for syllable in stored:gmatch("%S+") do
    local base, nine, four = syllable:match("^([a-z]+)([ASDFGHJKL])([QWER])$")
    local choices = base and {base, base .. nine, base .. four} or {syllable}
    local next_forms = {}
    for _, f in ipairs(forms) do
      for _, c in ipairs(choices) do next_forms[#next_forms+1] = f .. c end
    end
    forms = next_forms
    if #forms > 729 then break end
  end
  return forms
end

local M = {}
function M.init(env)
  env.exact = Component.ScriptTranslator(env.engine, Schema("penang_hokkien_exact"), "translator", "script_translator")
  assert(env.exact:set_memorize_callback(function() return true end))
  env.fuzzy = Component.Translator(env.engine, "translator", "script_translator")
  -- Built-in neighbouring-key correction runs in its own lane, so corrected
  -- guesses can be placed after genuine, abbreviation and fuzzy matches.
  if env.engine.schema.config:get_bool("corrector/enable_correction") then
    env.correct = Component.Translator(env.engine, "corrector", "script_translator")
  end
  -- Alternative Chinese visibility metadata, generated from Raw 2-5 provenance.
  -- All original dictionary mappings remain available when the option is on.
  env.alternative_chinese = {}
  local metadata_count, expected_count, metadata_present = 0, nil, false
  local metadata = io.open(rime_api.get_shared_data_dir() .. "/penang_hokkien_full.dict.yaml", "r")
  if metadata then
    for line in metadata:lines() do
      if line == "# alternative-chinese-v1" then metadata_present = true end
      local text, code = line:match("^# alternative%-chinese\t([^\t]+)\t([^\t]+)$")
      if text then
        env.alternative_chinese[text] = env.alternative_chinese[text] or {}
        env.alternative_chinese[text][code] = true
        metadata_count = metadata_count + 1
      end
      expected_count = tonumber(line:match("^# alternative%-chinese%-end\t(%d+)$")) or expected_count
    end
    metadata:close()
  end
  assert(metadata_present and expected_count == metadata_count,
    "Alternative Chinese metadata missing or incomplete; run rebuild then prepare")
  local legacy, recorded, has_metadata = {}, {}, false
  local function add(target, text, code)
    target[code] = target[code] or {}
    target[code][text] = true
  end
  -- Dictionary line order breaks exact ties between readings that now sit in
  -- different tone syllables (formerly one shared code kept file order).
  env.rank, env.line, env.letter_weight, env.letter_order = {}, 0, {}, {}
  for _, name in ipairs({"penang_hokkien_full.dict.yaml", "penang_hokkien_single.dict.yaml", "penang_hokkien_variant.dict.yaml"}) do
    local file = io.open(rime_api.get_shared_data_dir() .. "/" .. name, "r")
    if file then
    for line in file:lines() do
      if line == "# exact-spellings-v1" then has_metadata = true end
      local text, code = line:match("^# exact%-spelling\t([^\t]+)\t([a-z]+)$")
      if text then add(recorded, text, code) end
      local weight
      text, code, weight = line:match("^([^#\t][^\t]*)\t([^\t]+)\t(%d+)")
      if text then
        code = plain(code)
        env.line = env.line + 1
        local k = text .. "\t" .. code
        if not env.rank[k] then env.rank[k] = env.line end
        if #code == 1 then
          local w = env.letter_weight[code] or {}
          local o = env.letter_order[code] or {}
          env.letter_weight[code], env.letter_order[code] = w, o
          if not w[text] or w[text] < tonumber(weight) then w[text] = tonumber(weight); o[text] = env.line end
        end
        add(legacy, text, code)
        -- The variant module contains deliberate complete spellings, not shortcuts.
        if name == "penang_hokkien_variant.dict.yaml" then add(recorded, text, code) end
      end
    end
    file:close()
    elseif name ~= "penang_hokkien_variant.dict.yaml" then
      error("Missing spelling metadata: " .. name)
    end
  end
  -- Older generated dictionaries remain usable until the next rebuild.
  env.spellings = has_metadata and recorded or legacy
  -- Sorted references avoid building a large index for every possible prefix.
  env.prefix_spellings = {}
  for code in pairs(env.spellings) do
    env.prefix_spellings[#env.prefix_spellings+1] = code
  end
  table.sort(env.prefix_spellings)
  -- Emoji matching uses the same schema transformations, excluding abbreviations.
  env.emoji_rules, env.emoji_cache, env.emoji_cache_order = {}, {}, {}
  local algebra = env.engine.schema.config:get_list("speller/algebra")
  if algebra then
    for i = 0, algebra.size - 1 do
      local rule = algebra:get_value_at(i).value
      local op = rule:match("^(%w+)")
      if op == "fuzz" or op == "derive" or op == "xform" or op == "xlit" or op == "erase" then
        local projection = Projection()
        local transform = rule:gsub("^fuzz", "xform"):gsub("^derive", "xform")
        assert(projection:load({transform}))
        env.emoji_rules[#env.emoji_rules+1] = {projection=projection, retain=op=="fuzz" or op=="derive"}
      end
    end
  end
  env.emoji_codes, env.emoji_stored, env.emoji_outputs = {}, {}, {}
  local emoji_file = io.open(rime_api.get_shared_data_dir() .. "/penang_hokkien_emoji.dict.yaml", "r")
  if emoji_file then
    for line in emoji_file:lines() do
      local text, code = line:match("^([^#\t][^\t]*)\t([^\t]+)\t")
      if text then
        add(env.emoji_stored, text, code)
        for _, form in ipairs(typable_forms(code)) do add(env.emoji_codes, text, form) end
        env.emoji_outputs[text] = true
      end
    end
    emoji_file:close()
  end
  -- Neighbouring-syllable alternatives (pat lang -> pa lang) count as fuzzy spellings.
  env.aliases = {}
  env.redirects = {}
  local alias = io.open(rime_api.get_shared_data_dir() .. "/penang_hokkien_alias.dict.yaml", "r")
  if alias then
    for line in alias:lines() do
      local text, code = line:match("^([^#\t][^\t]*)\t([^\t]+)\t")
      if text then add(env.aliases, text, plain(code)) end
      -- Spelling redirects (word_alternatives.txt): ma-tsai is looked up as mia-tsai.
      local rkey, rtargets = line:match("^# redirect\t([^\t]+)\t(.+)$")
      if rkey then
        env.redirects[rkey] = {}
        for t in rtargets:gmatch("[^\t]+") do table.insert(env.redirects[rkey], t) end
      end
    end
    alias:close()
  end
  -- One-letter ordering (formerly penang_hokkien_initials entries): weight, then
  -- dictionary order; full/single readings precede the initials list on ties.
  local initials = io.open(rime_api.get_shared_data_dir() .. "/penang_hokkien_initials.dict.yaml", "r")
  local position = 0
  if initials then
    for line in initials:lines() do
      local text, code, weight = line:match("^([^#\t][^\t]*)\t([a-z])\t(%d+)")
      if text then
        position = position + 1
        -- A pair lives where its weight is highest; equal weights keep the
        -- earlier dictionary (full/single before the former initials list).
        local w = env.letter_weight[code] or {}
        local o = env.letter_order[code] or {}
        env.letter_weight[code], env.letter_order[code] = w, o
        if not w[text] or w[text] < tonumber(weight) then
          w[text] = tonumber(weight); o[text] = 10000000 + position
        end
      end
    end
    initials:close()
  end
  -- Only explicit abbreviation entries qualify; fuzzy/partial shortcuts do not.
  env.abbreviations = {}
  local abbr = io.open(rime_api.get_shared_data_dir() .. "/penang_hokkien_abbr.dict.yaml", "r")
  if abbr then
    for line in abbr:lines() do
      local text, code = line:match("^([^#\t][^\t]*)\t([a-z]+)\t")
      if text then add(env.abbreviations, text, code) end
    end
    abbr:close()
  end
end

-- Decode a candidate's dictionary entries: {text=..., stored="tsunSQ piJE"}.
local entries_of_uncached
local function entries_of(cand, env)
  local cache = env.entries_cache
  if cache and cache[cand] ~= nil then return cache[cand] or nil end
  local list = entries_of_uncached(cand, env)
  if cache then cache[cand] = list or false end
  return list
end
function entries_of_uncached(cand, env)
  local genuine = cand:get_genuine()
  local list = {}
  local sentence = genuine:to_sentence()
  if sentence then
    for _, entry in ipairs(sentence.entrys) do
      list[#list+1] = {text=entry.text, stored=table.concat(env.exact.dict:decode(entry.code), " ")}
    end
    return list
  end
  local phrase = genuine:to_phrase()
  if not phrase then return nil end
  list[1] = {text=phrase.text, stored=table.concat(env.exact.dict:decode(phrase.code), " ")}
  return list
end

-- A recorded pair, or a learned phrase made of recorded words (好 + 放屎):
-- split its syllables into consecutive recorded words, one Han character each.
local kind
local syllable_variants
local function recorded(text, stored, table_)
  local p = plain(stored)
  if table_[p] and table_[p][text] then return true end
  local syllables, chars = {}, {}
  for syllable in stored:gmatch("%S+") do syllables[#syllables+1] = syllable:gsub("[A-Z]", "") end
  for _, c in utf8.codes(text) do chars[#chars+1] = utf8.char(c) end
  if #syllables < 2 or #syllables ~= #chars or kind(text) ~= "compound" then return false end
  local memo = {}
  local function from(i)
    if i > #syllables then return true end
    if memo[i] ~= nil then return memo[i] end
    local code, out = "", ""
    for j = i, #syllables do
      code, out = code .. syllables[j], out .. chars[j]
      if not (i == 1 and j == #syllables) and table_[code] and table_[code][out] and from(j + 1) then
        memo[i] = true
        return true
      end
    end
    memo[i] = false
    return false
  end
  return from(1)
end

-- Genuine full spelling: every entry is a recorded spelling/output pair and the
-- typed letters are exactly those spellings (m/毋 is a spelling, m/免 a shortcut).
local function full_spelling(cand, input, env)
  local list = entries_of(cand, env)
  if not list or #list == 0 then return false end
  local joined = {}
  for i, e in ipairs(list) do
    if not recorded(e.text, e.stored, env.spellings) then return false end
    joined[i] = plain(e.stored)
  end
  return table.concat(joined) == input, #list
end

-- How the typed letters spell the stored syllables. Each syllable is typed in
-- full (any fuzzy/tone variant) or abbreviated (first one to three letters of
-- a variant; f for ph, q for kh). Returns: spelt at all, spelt in full, and
-- whether every abbreviated reading needs t for a ts/tsh syllable.
local function abbreviations(syllable, env)
  local cache = env.abbreviation_cache[syllable]
  if cache then return cache end
  cache = {}
  for v in pairs(syllable_variants(syllable, env)) do
    for n = 1, 3 do if #v > n then cache[v:sub(1, n)] = true end end
  end
  local base = syllable:gsub("[A-Z]", "")
  if base:match("^ph.") then cache.f = true end
  if base:match("^kh.") then cache.q = true end
  env.abbreviation_cache[syllable] = cache
  return cache
end

local spelling_uncached
local function spelling(input, list, env)
  local key = input .. "\t"
  for _, e in ipairs(list) do key = key .. e.stored .. "|" end
  local cache = env.spelling_cache
  local hit = cache and cache[key]
  if hit then return hit[1], hit[2], hit[3] end
  local a, b, c = spelling_uncached(input, list, env)
  if cache then cache[key] = {a, b, c} end
  return a, b, c
end
function spelling_uncached(input, list, env)
  local syllables = {}
  for _, e in ipairs(list) do
    for syllable in e.stored:gmatch("%S+") do syllables[#syllables+1] = syllable end
  end
  -- best[i..pos] = {abbreviated count, t-for-ts count}; minimise both.
  local memo = {}
  local function from(i, pos)
    if i > #syllables then return pos == #input + 1 and {0, 0} or nil end
    local k = i .. ":" .. pos
    if memo[k] ~= nil then return memo[k] or nil end
    local best
    local function consider(v, abbreviated, t_for_ts)
      if #v > 0 and input:sub(pos, pos + #v - 1) == v then
        local rest = from(i + 1, pos + #v)
        if rest then
          local c = {rest[1] + (abbreviated and 1 or 0), rest[2] + (t_for_ts and 1 or 0)}
          if not best or c[1] < best[1] or (c[1] == best[1] and c[2] < best[2]) then best = c end
        end
      end
    end
    for v in pairs(syllable_variants(syllables[i], env)) do consider(v, false, false) end
    local ts = syllables[i]:match("^ts") ~= nil
    for v in pairs(abbreviations(syllables[i], env)) do consider(v, true, ts and v == "t") end
    memo[k] = best or false
    return best
  end
  local r = from(1, 1)
  if not r then return false, false, false end
  return true, r[1] == 0, r[2] > 0
end

-- Recorded pair typed in full by fuzzy spelling, or a neighbouring-syllable
-- alternative. Abbreviated readings are shortcuts, as formerly.
local function known_pairs(cand, input, env)
  local list = entries_of(cand, env)
  if not list or #list == 0 then return false end
  for _, e in ipairs(list) do
    local p = plain(e.stored)
    if not (recorded(e.text, e.stored, env.spellings) or (env.aliases[p] and env.aliases[p][e.text])) then
      return false
    end
  end
  local _, full = spelling(input, list, env)
  return full
end

-- c is the preferred shortcut for ts/tsh; t still reaches them, but later.
local function ts_by_t(cand, input, env)
  local list = entries_of(cand, env)
  if not list or #list == 0 then return false end
  local _, _, t_for_ts = spelling(input, list, env)
  return t_for_ts
end

-- Unicode classification includes supplementary Han and ignores variation selectors.
function kind(text)
  local han, latin = 0, false
  for _, c in utf8.codes(text) do
    if (c >= 0x3400 and c <= 0x4DBF) or (c >= 0x4E00 and c <= 0x9FFF)
      or (c >= 0xF900 and c <= 0xFAFF) or (c >= 0x20000 and c <= 0x323AF) or c == 0x3007 then
      han = han + 1
    elseif (c >= 65 and c <= 90) or (c >= 97 and c <= 122) or (c >= 0xC0 and c <= 0x2AF) then
      latin = true
    end
  end
  if han > 0 then return han == 1 and "single" or "compound" end
  return latin and "romanisation" or "other"
end

-- Visibility-only detection also covers precomposed Tailo letters such as ḿ.
-- Keep the existing ranking classifier untouched.
local function is_romanisation(text)
  local category = kind(text)
  if category == "romanisation" then return true end
  if category ~= "other" then return false end
  for _, c in utf8.codes(text) do
    if c >= 0x1E00 and c <= 0x1EFF then return true end
  end
  return false
end

-- Verify a complete fuzzy spelling; a completion or automatic initial is not enough.
function syllable_variants(syllable, env)
  local variants = env.emoji_cache[syllable]
  if variants then return variants end
  variants = {[syllable]=true}
  for _, rule in ipairs(env.emoji_rules) do
    local next_variants = {}
    for spelling in pairs(variants) do
      if rule.retain then next_variants[spelling] = true end
      local result = rule.projection:apply(spelling, true)
      if result ~= "" then next_variants[result] = true end
    end
    variants = next_variants
  end
  -- About four thousand stored syllables exist, so the cache stays small.
  env.emoji_cache[syllable] = variants
  return variants
end

local function emoji_spelling(input, stored, env)
  local syllables = {}
  for syllable in stored:gmatch("%S+") do syllables[#syllables+1] = syllable end
  local memo = {}
  local function from(i, pos)
    if i > #syllables then return pos == #input + 1 end
    local k = i .. ":" .. pos
    if memo[k] ~= nil then return memo[k] end
    local found = false
    for v in pairs(syllable_variants(syllables[i], env)) do
      if #v > 0 and input:sub(pos, pos + #v - 1) == v and from(i + 1, pos + #v) then found = true; break end
    end
    memo[k] = found
    return found
  end
  return from(1, 1)
end

-- Use the decoded dictionary code, not the typed fuzzy spelling or weight.
-- Returning the original candidate preserves its span, quality and learning identity.
local function alternative_chinese(cand, env)
  if cand.type == "user_phrase" then return false end
  local genuine = cand:get_genuine()
  if genuine.type == "user_phrase" then return false end
  local function restricted(text, code)
    local codes = env.alternative_chinese[text]
    if not codes then return false end
    local spellings = env.exact.dict:decode(code)
    return codes[table.concat(spellings, " ")] == true
  end
  local sentence = genuine:to_sentence()
  if sentence then
    for _, entry in ipairs(sentence.entrys) do
      -- A learned component retains its existing participation in sentences.
      if (entry.commit_count or 0) <= 0 and restricted(entry.text, entry.code) then return true end
    end
    return false
  end
  local phrase = genuine:to_phrase()
  return phrase and restricted(phrase.text, phrase.code) or false
end

-- Penang literal-prefix completion ranking v1.
-- Look up original spellings, including candidates reached via generated shortcuts.
local function literal_prefix_outputs(input, env)
  local codes, outputs = env.prefix_spellings, {}
  local low, high = 1, #codes + 1
  while low < high do
    local mid = math.floor((low + high) / 2)
    if codes[mid] < input then low = mid + 1 else high = mid end
  end
  for i = low, #codes do
    local code = codes[i]
    if code:sub(1, #input) ~= input then break end
    if #code > #input then
      for text in pairs(env.spellings[code]) do outputs[text] = true end
    end
  end
  return outputs
end

function M.func(input, seg, env)
  env.entries_cache = {}
  env.spelling_cache = {}
  local use_poj = env.engine.context:get_option("use_poj_romanisation")
  local original_input = input
  if use_poj then input = poj_input(input) end
  local function emit_candidate(cand)
    if use_poj then
      local genuine = cand:get_genuine()
      -- Lookup normalises POJ internally, but inline text follows the typed letters.
      -- Equal-length input mappings preserve the original candidate span.
      genuine.preedit = original_input:sub(1, cand._end - seg.start)
      local text, comment = poj_output(cand.text), poj_output(cand.comment or "")
      if text ~= cand.text or comment ~= (cand.comment or "") then
        -- Shadow retains the genuine native phrase for learning and deletion.
        yield(ShadowCandidate(cand, cand.type, text, comment, false))
        return
      end
    end
    yield(cand)
  end
  local show_alternatives = env.engine.context:get_option("show_alternative_chinese")
  local show_matching = env.engine.context:get_option("show_matching_romanisations")
  local emoji_codes = env.emoji_codes[input]
  local function matching_emoji(cand)
    if cand._end ~= seg._end or not env.emoji_outputs[cand.text] then return false end
    -- A dictionary shortcut is not a full spelling merely because its code is exact.
    local input_spelling = input:gsub("[ASDFGHJKLQWER]", "")
    if emoji_codes and emoji_codes[cand.text] and env.spellings[input_spelling] then return true end
    if cand.type == "completion" then return false end
    local list = entries_of(cand, env)
    if not list or #list ~= 1 then return false end
    local stored = list[1].stored
    -- Generated abbreviations are explicit shortcuts, not full fuzzy spellings.
    if not env.spellings[plain(stored)] then return false end
    return env.emoji_stored[stored] and env.emoji_stored[stored][cand.text]
      and emoji_spelling(input, stored, env)
  end
  -- Short abbreviations can match thousands of words; Rime yields the longest
  -- and best matches first, so only the leading ones are ranked and shown.
  local limit = 2500
  local function each_fuzzy(accept)
    local translated = env.fuzzy:query(input, seg)
    local n = 0
    if translated then for cand in translated:iter() do
      n = n + 1
      if n > limit then break end
      accept(cand)
    end end
    -- Retain existing fuzzy/loanword spellings alongside the canonical POJ lookup.
    if use_poj and original_input ~= input then
      local original = env.fuzzy:query(original_input, seg)
      n = 0
      if original then for cand in original:iter() do
        n = n + 1
        if n > limit then break end
        accept(cand)
      end end
    end
  end
  local learned_scores = {}
  local function key(cand) return cand.text .. "\t" .. cand._end end
  local function remember_score(cand)
    -- Only learning that consumes this entire input may displace its emojis.
    -- Partial-word learning remains active in Rime's ordinary candidate ordering.
    if cand.type == "user_phrase" and cand.start == seg.start and cand._end == seg._end then
      learned_scores[key(cand)] = math.max(learned_scores[key(cand)] or 0, cand.quality)
    end
  end
  -- Stable insertion: all non-emoji candidates keep their relative order.
  -- Native learned scores can move the emoji block down, or back up to slot four.
  local function emit(ordered)
    local promoted, rest = {}, {}
    for _, cand in ipairs(ordered) do
      if matching_emoji(cand) then promoted[#promoted+1] = cand else rest[#rest+1] = cand end
    end
    local protected, count = #rest, 0
    for i, cand in ipairs(rest) do
      if not env.emoji_outputs[cand.text] then count = count + 1 end
      if count == 3 then protected = i; break end
    end
    local insertions = {}
    for _, cand in ipairs(promoted) do
      local score, after = learned_scores[key(cand)] or 0, protected
      for i = protected + 1, #rest do
        if not env.emoji_outputs[rest[i].text] and (learned_scores[key(rest[i])] or 0) > score then after = i end
      end
      insertions[after] = insertions[after] or {}
      insertions[after][#insertions[after]+1] = cand
    end
    local function emit_at(i)
      for _, cand in ipairs(insertions[i] or {}) do emit_candidate(cand) end
    end
    emit_at(0)
    for i, cand in ipairs(rest) do emit_candidate(cand); emit_at(i) end
  end
  if not input:match("^[a-z]+$") then
    local ordered, fallback_emoji, emitted = {}, {}, {}
    each_fuzzy(function(cand)
      local identity = cand.text .. "\t" .. cand._end
      if use_poj then
        if emitted[identity] then return end
        emitted[identity] = true
      end
      if show_alternatives or not alternative_chinese(cand, env) then
      remember_score(cand)
      if env.emoji_outputs[cand.text] and not matching_emoji(cand) then
        fallback_emoji[#fallback_emoji+1] = cand
      elseif show_matching or not is_romanisation(cand.text) then ordered[#ordered+1] = cand end
      end
    end)
    for _, cand in ipairs(fallback_emoji) do ordered[#ordered+1] = cand end
    emit(ordered)
    return
  end
  local matches, groups, seen = {}, {{}, {}, {}, {}}, {}
  local late_compounds = {}
  local prefix_completions = {}
  local prefix_outputs = literal_prefix_outputs(input, env)
  local show_partial = env.engine.context:get_option("show_partial_romanisations")
  local redirected = false
  local function add(cand, exact_lane)
    if not show_alternatives and alternative_chinese(cand, env) then return end
    if not exact_lane then remember_score(cand) end
    local genuine, genuine_parts = full_spelling(cand, input:sub(1, cand._end - seg.start), env)
    local abbreviation = cand._end == seg._end
      and (cand.preedit or ""):gsub(" ", "") == input
      and env.abbreviations[input] and env.abbreviations[input][cand.text]
    local emoji = matching_emoji(cand)
    if exact_lane and not genuine and not abbreviation then return end
    -- Native user phrases are validated by Rime against the current input.
    -- Their output need not exist in Excel: retaining Rime's candidate preserves
    -- its learned spelling sequence, consumed span and future learning updates.
    local learned = cand.type == "user_phrase"
    local typed = input:sub(cand.start - seg.start + 1, cand._end - seg.start)
    local fuzzy = not exact_lane and (learned or redirected or known_pairs(cand, typed, env))
    local category = kind(cand.text)
    if not genuine and not fuzzy and not abbreviation and category == "romanisation" and not show_partial then return end
    local key = cand.text .. "\t" .. cand._end
    if seen[key] then return end
    seen[key] = true
    -- Retain native learning, but never promote a learned emoji abbreviation.
    if env.emoji_outputs[cand.text] and not emoji then
      groups[3][#groups[3]+1] = cand
    elseif prefix_outputs[cand.text] and not is_romanisation(cand.text)
      and cand.start == seg.start and cand._end == seg._end
      and not genuine and not cand:get_genuine():to_sentence() then
      prefix_completions[#prefix_completions+1] = cand
    -- Genuine sentences of up to two words keep exact priority (汝講); longer
    -- assemblies of single syllables do not outrank dictionary words.
    elseif emoji or genuine or fuzzy or abbreviation then
      matches[#matches+1] = {cand=cand, exact=genuine, roman=category=="romanisation", sentence=cand:get_genuine():to_sentence() ~= nil, order=#matches+1, tier=emoji and 0 or (genuine and cand._end == seg._end and (genuine_parts or 1) <= 2) and 1 or abbreviation and 2 or (not genuine and ts_by_t(cand, typed, env)) and 4 or 3}
    else
      local group = category=="single" and 1 or category=="compound" and 2 or category=="romanisation" and 4 or 3
      if group == 2 and ts_by_t(cand, typed, env) then late_compounds[#late_compounds+1] = cand
      else groups[group][#groups[group]+1] = cand end
    end
  end
  env.abbreviation_cache = env.abbreviation_cache or {}
  local exact = env.exact:query(input, seg)
  if exact then for cand in exact:iter() do add(cand, true) end end
  each_fuzzy(function(cand) add(cand, false) end)
  -- A listed distortion shows the whole-word results of its proper spelling(s).
  local targets = env.redirects[input]
    or env.redirects[(input:gsub("z", "ts"):gsub("c", "ts"))]
    or env.redirects[(input:gsub("ch", "ts"):gsub("z", "ts"):gsub("c", "ts"))]
  if targets then
    for _, target in ipairs(targets) do
      for _, lane in ipairs({env.exact, env.fuzzy}) do
      local r = lane:query(target, seg)
      local n = 0
      if r then for cand in r:iter() do
        n = n + 1
        if n > 300 then break end
        if cand._end == seg.start + #target then
          cand._end = seg._end
          local list = entries_of(cand, env)
          local hint = (list and #list == 1) and plain(list[1].stored) or target
          redirected = true
          add(ShadowCandidate(cand, cand.type, cand.text, hint, false), false)
          redirected = false
        end
      end end
      end
    end
  end
  -- Neighbouring-key corrections of the whole input (like the former g/h typo
  -- list: inputs of five or more letters), after every intended match.
  local corrections = {}
  -- Only when nothing matches the whole input (as with the former typo list).
  local whole = #prefix_completions > 0
  for _, item in ipairs(matches) do
    if item.cand._end == seg._end and not item.cand:get_genuine():to_sentence() then whole = true; break end
  end
  if env.correct and #input >= 5 and not whole then
    local translated = env.correct:query(input, seg)
    if translated then
      local scanned = 0
      for cand in translated:iter() do
        scanned = scanned + 1
        if scanned > 200 then break end
        local k = cand.text .. "\t" .. cand._end
        if not seen[k] and cand._end == seg._end and not is_romanisation(cand.text)
          and not env.emoji_outputs[cand.text] and not cand:get_genuine():to_sentence()
          and (show_alternatives or not alternative_chinese(cand, env)) then
          seen[k] = true
          corrections[#corrections+1] = cand
        end
      end
    end
  end
  -- One stray letter at the end (a slip such as bengpekl for bengpek): when nothing
  -- matches the whole input but it matches without its last letter, offer those words
  -- first. Choosing one finishes the input and drops the stray letter.
  local strays = {}
  local stray_letters = {b=true, c=true, d=true, f=true, j=true, l=true, q=true,
                         s=true, v=true, w=true, x=true, z=true}
  if not whole and #input >= 3 and stray_letters[input:sub(-1)] then
    local short = input:sub(1, -2)
    local short_end = seg.start + #short
    local taken = {}
    local function take(translation, most)
      if not translation then return end
      local n = 0
      for cand in translation:iter() do
        n = n + 1
        if n > most then break end
        if cand._end == short_end and not taken[cand.text] and not is_romanisation(cand.text)
          and not env.emoji_outputs[cand.text]
          and (show_alternatives or not alternative_chinese(cand, env))
          and (full_spelling(cand, short, env) or known_pairs(cand, short, env)) then
          taken[cand.text] = true
          strays[#strays + 1] = Candidate("stray", seg.start, seg._end, cand.text, cand.comment or "")
        end
      end
    end
    take(env.exact:query(short, seg), 60)
    take(env.fuzzy:query(short, seg), 300)
  end
  -- A fuzzy spelling may swallow a letter of the next word: se typed seh before
  -- hang, or wae typed waeh before hpi (好朋友). When the same word also has a
  -- genuine reading one or two letters shorter, keep the genuine reading if the
  -- letters left over begin a syllable (h + vowel, as before) or make up a
  -- whole word on their own. Otherwise the fuzzy spelling stands (bohpai).
  do
    local genuine_ends = {}
    for _, item in ipairs(matches) do
      if item.exact and item.cand._end ~= seg._end then
        local ends = genuine_ends[item.cand.text] or {}
        ends[item.cand._end] = true
        genuine_ends[item.cand.text] = ends
      end
    end
    local whole_word = {}
    local function is_whole_word(rest)
      if whole_word[rest] == nil then
        whole_word[rest] = false
        local r = env.exact:query(rest, seg)
        local n = 0
        if r then for c in r:iter() do
          n = n + 1
          if n > 60 then break end
          if c._end == seg.start + #rest and not c:get_genuine():to_sentence()
            and ((env.abbreviations[rest] and env.abbreviations[rest][c.text])
              or full_spelling(c, rest, env)) then
            whole_word[rest] = true
            break
          end
        end end
      end
      return whole_word[rest]
    end
    local kept = {}
    for _, item in ipairs(matches) do
      local e = item.cand._end
      local ends = genuine_ends[item.cand.text]
      local drop = false
      if not item.exact and ends and e < seg._end then
        for back = 1, 2 do
          if ends[e - back] then
            local from = e - back - seg.start + 1
            local rest = input:sub(from)
            if (back == 1 and input:sub(from, from) == "h"
                and input:sub(from + 1, from + 1):match("^[aeioumn]$"))
              or is_whole_word(rest) then
              drop = true
            end
            break
          end
        end
      end
      if not drop then kept[#kept + 1] = item end
    end
    matches = kept
  end
  table.sort(matches, function(a,b)
    if a.tier ~= b.tier then return a.tier < b.tier end
    if a.cand._end ~= b.cand._end then return a.cand._end > b.cand._end end
    -- Dictionary words before sentences assembled from single syllables.
    if a.sentence ~= b.sentence then return not a.sentence end
    if a.exact ~= b.exact then return a.exact end
    if a.roman ~= b.roman then return not a.roman end
    return a.order < b.order
  end)
  -- Equal-quality neighbours keep dictionary line order (stable within the run).
  local function rank_of(cand)
    local list = entries_of(cand, env)
    if not list or #list ~= 1 then return nil end
    return env.rank[list[1].text .. "\t" .. plain(list[1].stored)]
  end
  local i = 1
  while i <= #matches do
    local j = i
    local a = matches[i]
    while j + 1 <= #matches do
      local b = matches[j + 1]
      if b.tier ~= a.tier or b.cand._end ~= a.cand._end or b.exact ~= a.exact or b.roman ~= a.roman
        or b.sentence ~= a.sentence
        or math.abs(b.cand.quality - a.cand.quality) > 1e-9 then break end
      j = j + 1
    end
    if j > i then
      local run = {}
      for k = i, j do run[#run+1] = {item=matches[k], rank=rank_of(matches[k].cand) or math.huge, pos=k} end
      table.sort(run, function(x, y)
        if x.rank ~= y.rank then return x.rank < y.rank end
        return x.pos < y.pos
      end)
      for k = i, j do matches[k] = run[k - i + 1].item end
    end
    i = j + 1
  end
  local ordered = {}
  local prefixes_emitted = false
  local function emit_prefixes()
    if prefixes_emitted then return end
    for _, cand in ipairs(prefix_completions) do ordered[#ordered+1] = cand end
    prefixes_emitted = true
  end
  local corrections_emitted = false
  local function emit_corrections()
    if corrections_emitted then return end
    emit_prefixes()
    for _, cand in ipairs(corrections) do ordered[#ordered+1] = cand end
    corrections_emitted = true
  end
  for _, cand in ipairs(strays) do ordered[#ordered+1] = cand end
  for _, item in ipairs(matches) do
    -- Complete literal spellings remain first; prefix completions precede
    -- abbreviations, fuzzy spellings and matches consuming only part of input.
    if item.tier > 1 then emit_prefixes() end
    -- Whole-input corrections follow every whole-input match.
    if item.cand._end ~= seg._end then emit_corrections() end
    if show_matching or not is_romanisation(item.cand.text) then ordered[#ordered+1] = item.cand end
  end
  emit_corrections()
  for _, cand in ipairs(late_compounds) do groups[2][#groups[2]+1] = cand end
  -- One-letter characters for the first letter, as the former initials list
  -- did, when Rime offered none (whole-input codes such as ckt hide them).
  local first = input:sub(1, 1)
  if #input > 1 and env.letter_weight[first] then
    local have = false
    for _, cand in ipairs(groups[1]) do if cand._end == seg.start + 1 then have = true; break end end
    if not have then
      local weights, order, list = env.letter_weight[first], env.letter_order[first] or {}, {}
      for text, w in pairs(weights) do list[#list+1] = {text=text, w=w, o=order[text] or math.huge} end
      table.sort(list, function(x, y) if x.w ~= y.w then return x.w > y.w end return x.o < y.o end)
      for _, x in ipairs(list) do
        local k = x.text .. "\t" .. (seg.start + 1)
        if not seen[k] then
          seen[k] = true
          groups[1][#groups[1]+1] = Candidate("initial", seg.start, seg.start + 1, x.text, "")
        end
      end
    end
  end
  for _, group in ipairs(groups) do for _, cand in ipairs(group) do
    if show_partial or not is_romanisation(cand.text) then ordered[#ordered+1] = cand end
  end end
  -- One letter: own readings first, then other characters, each by the former
  -- one-letter list order (weight, then position); everything else follows.
  if #input == 1 and env.letter_weight[input] then
    local weights, order = env.letter_weight[input], env.letter_order[input] or {}
    local own, other, rest = {}, {}, {}
    for pos, cand in ipairs(ordered) do
      local w = weights[cand.text]
      if w and kind(cand.text) == "single" and cand._end == seg._end then
        local list = entries_of(cand, env)
        local reading = list and #list == 1 and plain(list[1].stored) == input
        local target = reading and own or other
        target[#target+1] = {cand=cand, w=w, o=order[cand.text] or math.huge, pos=pos}
      else
        rest[#rest+1] = cand
      end
    end
    local function by_letter(x, y)
      -- Learned choices keep Rime's learned order ahead of static list order.
      local lx, ly = x.cand.type == "user_phrase", y.cand.type == "user_phrase"
      if lx ~= ly then return lx end
      if lx then return x.pos < y.pos end
      if x.w ~= y.w then return x.w > y.w end
      if x.o ~= y.o then return x.o < y.o end
      return x.pos < y.pos
    end
    -- Characters reached by a letter-syllable (a, e, i, m, o, u) cannot also be
    -- abbreviated by Rime; offer the remaining one-letter list entries directly.
    local present = {}
    for _, x in ipairs(own) do present[x.cand.text] = true end
    for _, x in ipairs(other) do present[x.cand.text] = true end
    for _, cand in ipairs(rest) do present[cand.text] = true end
    for text, w in pairs(weights) do
      if not present[text] and (order[text] or 0) >= 10000000 then
        other[#other+1] = {cand=Candidate("initial", seg.start, seg._end, text, ""), w=w, o=order[text], pos=math.huge}
      end
    end
    table.sort(own, by_letter)
    table.sort(other, by_letter)
    ordered = {}
    for _, x in ipairs(own) do ordered[#ordered+1] = x.cand end
    for _, x in ipairs(other) do ordered[#ordered+1] = x.cand end
    for _, cand in ipairs(rest) do ordered[#ordered+1] = cand end
  end
  emit(ordered)
end
return M
