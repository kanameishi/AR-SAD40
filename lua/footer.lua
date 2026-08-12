-- footer.lua
-- Builds revealjs footer from YAML metadata: meta.title and meta.subtitle.
-- If meta.footer is already set to a non-empty value, leave it untouched.
-- Format: "<title> · <subtitle>" (or just "<title>" if no subtitle).

function Meta(meta)
  -- Skip if user explicitly set a non-empty footer
  if meta.footer ~= nil then
    local current = pandoc.utils.stringify(meta.footer)
    if current ~= "" then
      return nil
    end
  end

  local title    = meta.title    and pandoc.utils.stringify(meta.title)    or ""
  local subtitle = meta.subtitle and pandoc.utils.stringify(meta.subtitle) or ""

  if title == "" and subtitle == "" then
    return nil
  end

  local footer = title
  if subtitle ~= "" then
    if title ~= "" then
      footer = title .. " · " .. subtitle
    else
      footer = subtitle
    end
  end

  meta.footer = pandoc.MetaString(footer)
  return meta
end
