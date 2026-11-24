#pragma once
// Penang Hokkien Keyboard: menu options shared by the text service (menu)
// and the server (which applies them). Stored per user in the registry.
#include <windows.h>
#include <string>

namespace penang {

constexpr const wchar_t* kRegKey = L"Software\\Rime\\PenangHokkien\\Penang";

enum : UINT {
  ID_POJ = 40101,
  ID_ALT_CHINESE,
  ID_FULL_MATCH,
  ID_PARTIAL_MATCH,
  ID_VERTICAL,
  ID_FIVE,
  ID_NINE,
  ID_LARGE,
  ID_XLARGE,
  ID_HINTS,
  ID_CONTINUATIONS,
  ID_FIRST = ID_POJ,
  ID_LAST = ID_CONTINUATIONS,
  ID_THEME_AUTO = 40150,
  ID_THEME_FIRST = 40151
};

// Colour themes offered in the menu (ids from weasel.yaml).
struct Theme {
  const wchar_t* id;
  const wchar_t* name;
};
constexpr Theme kThemes[] = {
    {L"aqua", L"Aqua"},
    {L"azure", L"Azure"},
    {L"luna", L"Luna"},
    {L"ink", L"Ink"},
    {L"lost_temple", L"Lost Temple"},
    {L"dark_temple", L"Dark Temple"},
    {L"solarized_rock", L"Solarized Rock"},
    {L"cool_breeze", L"Cool Breeze"},
    {L"brisk", L"Brisk"},
    {L"metroblue", L"Metro Blue"},
    {L"psionics", L"Psionics"},
};
constexpr UINT kThemeCount = sizeof(kThemes) / sizeof(kThemes[0]);
constexpr UINT ID_THEME_LAST = ID_THEME_FIRST + kThemeCount - 1;

struct Settings {
  bool poj = false;
  bool alt_chinese = false;
  bool full_match = false;
  bool partial_match = false;
  bool vertical = false;
  bool hints = true;
  bool continuations = true;
  std::wstring theme;  // empty: automatic (light/dark)
  int page_size = 7;
  int text_size = 0;  // 0 normal, 1 large, 2 extra large
};

inline DWORD ReadDword(const wchar_t* name, DWORD fallback) {
  DWORD value = 0, size = sizeof(value);
  if (RegGetValueW(HKEY_CURRENT_USER, kRegKey, name, RRF_RT_REG_DWORD, NULL,
                   &value, &size) == ERROR_SUCCESS)
    return value;
  return fallback;
}

inline void WriteDword(const wchar_t* name, DWORD value) {
  RegSetKeyValueW(HKEY_CURRENT_USER, kRegKey, name, REG_DWORD, &value,
                  sizeof(value));
}

inline std::wstring ReadString(const wchar_t* name) {
  wchar_t value[64] = {0};
  DWORD size = sizeof(value);
  if (RegGetValueW(HKEY_CURRENT_USER, kRegKey, name, RRF_RT_REG_SZ, NULL, value,
                   &size) == ERROR_SUCCESS)
    return value;
  return std::wstring();
}

inline void WriteString(const wchar_t* name, const std::wstring& value) {
  RegSetKeyValueW(HKEY_CURRENT_USER, kRegKey, name, REG_SZ, value.c_str(),
                  (DWORD)((value.size() + 1) * sizeof(wchar_t)));
}

inline Settings Load() {
  Settings s;
  s.poj = ReadDword(L"UsePOJ", 0) != 0;
  s.alt_chinese = ReadDword(L"AlternativeChinese", 0) != 0;
  s.full_match = ReadDword(L"FullMatchRomanisations", 0) != 0;
  s.partial_match = ReadDword(L"PartialMatchRomanisations", 0) != 0;
  s.vertical = ReadDword(L"VerticalLayout", 0) != 0;
  s.hints = ReadDword(L"RomanisationHints", 1) != 0;
  s.continuations = ReadDword(L"WordContinuations", 1) != 0;
  s.theme = ReadString(L"ColourTheme");
  bool known = false;
  for (const Theme& t : kThemes)
    known = known || s.theme == t.id;
  if (!known)
    s.theme.clear();
  DWORD page = ReadDword(L"PageSize", 7);
  s.page_size = (page == 5 || page == 9) ? (int)page : 7;
  DWORD text = ReadDword(L"TextSize", 0);
  s.text_size = text <= 2 ? (int)text : 0;
  return s;
}

inline bool IsCommand(UINT id) {
  return (id >= ID_FIRST && id <= ID_LAST) ||
         (id >= ID_THEME_AUTO && id <= ID_THEME_LAST);
}

inline void Toggle(UINT id) {
  if (id == ID_THEME_AUTO) {
    WriteString(L"ColourTheme", L"");
    return;
  }
  if (id >= ID_THEME_FIRST && id <= ID_THEME_LAST) {
    WriteString(L"ColourTheme", kThemes[id - ID_THEME_FIRST].id);
    return;
  }
  Settings s = Load();
  switch (id) {
    case ID_POJ:
      WriteDword(L"UsePOJ", !s.poj);
      break;
    case ID_ALT_CHINESE:
      WriteDword(L"AlternativeChinese", !s.alt_chinese);
      break;
    case ID_FULL_MATCH:
      WriteDword(L"FullMatchRomanisations", !s.full_match);
      break;
    case ID_PARTIAL_MATCH:
      WriteDword(L"PartialMatchRomanisations", !s.partial_match);
      break;
    case ID_VERTICAL:
      WriteDword(L"VerticalLayout", !s.vertical);
      break;
    case ID_FIVE:
      WriteDword(L"PageSize", s.page_size == 5 ? 7 : 5);
      break;
    case ID_NINE:
      WriteDword(L"PageSize", s.page_size == 9 ? 7 : 9);
      break;
    case ID_LARGE:
      WriteDword(L"TextSize", s.text_size == 1 ? 0 : 1);
      break;
    case ID_XLARGE:
      WriteDword(L"TextSize", s.text_size == 2 ? 0 : 2);
      break;
    case ID_HINTS:
      WriteDword(L"RomanisationHints", !s.hints);
      break;
    case ID_CONTINUATIONS:
      WriteDword(L"WordContinuations", !s.continuations);
      break;
  }
}

// The menu shown for the input method (same items as macOS).
inline HMENU BuildMenu() {
  Settings s = Load();
  HMENU menu = CreatePopupMenu();
  auto add = [menu](UINT id, const wchar_t* text, bool on) {
    AppendMenuW(menu, MF_STRING | (on ? MF_CHECKED : MF_UNCHECKED), id, text);
  };
  auto separator = [menu]() { AppendMenuW(menu, MF_SEPARATOR, 0, NULL); };
  add(ID_POJ, L"Use POJ Romanisation", s.poj);
  separator();
  add(ID_CONTINUATIONS, L"Word Continuations", s.continuations);
  separator();
  add(ID_ALT_CHINESE, L"Rare Chinese Alternatives", s.alt_chinese);
  separator();
  add(ID_FULL_MATCH, L"Full-Match Romanisations", s.full_match);
  add(ID_PARTIAL_MATCH, L"Partial-Match Romanisations", s.partial_match);
  separator();
  add(ID_VERTICAL, L"Vertical Layout", s.vertical);
  separator();
  add(ID_FIVE, L"Decrease to 5 Candidates", s.page_size == 5);
  add(ID_NINE, L"Increase to 9 Candidates", s.page_size == 9);
  separator();
  add(ID_LARGE, L"Large Text", s.text_size == 1);
  add(ID_XLARGE, L"Extra Large Text", s.text_size == 2);
  separator();
  add(ID_HINTS, L"Romanisation Hints", s.hints);
  separator();
  HMENU themes = CreatePopupMenu();
  AppendMenuW(themes, MF_STRING | (s.theme.empty() ? MF_CHECKED : MF_UNCHECKED),
              ID_THEME_AUTO, L"Automatic (Light / Dark)");
  AppendMenuW(themes, MF_SEPARATOR, 0, NULL);
  for (UINT i = 0; i < kThemeCount; ++i)
    AppendMenuW(themes, MF_STRING | (s.theme == kThemes[i].id ? MF_CHECKED : 0),
                ID_THEME_FIRST + i, kThemes[i].name);
  AppendMenuW(menu, MF_POPUP, (UINT_PTR)themes, L"Colour Theme");
  return menu;
}

}  // namespace penang
