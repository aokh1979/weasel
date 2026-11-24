#pragma once
// Penang Hokkien Keyboard: menu options shared by the text service (menu)
// and the server (which applies them). Stored per user in the registry.
#include <windows.h>

namespace penang {

constexpr const wchar_t* kRegKey = L"Software\\Rime\\Weasel\\Penang";

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
  ID_FIRST = ID_POJ,
  ID_LAST = ID_HINTS
};

struct Settings {
  bool poj = false;
  bool alt_chinese = false;
  bool full_match = false;
  bool partial_match = false;
  bool vertical = false;
  bool hints = true;
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

inline Settings Load() {
  Settings s;
  s.poj = ReadDword(L"UsePOJ", 0) != 0;
  s.alt_chinese = ReadDword(L"AlternativeChinese", 0) != 0;
  s.full_match = ReadDword(L"FullMatchRomanisations", 0) != 0;
  s.partial_match = ReadDword(L"PartialMatchRomanisations", 0) != 0;
  s.vertical = ReadDword(L"VerticalLayout", 0) != 0;
  s.hints = ReadDword(L"RomanisationHints", 1) != 0;
  DWORD page = ReadDword(L"PageSize", 7);
  s.page_size = (page == 5 || page == 9) ? (int)page : 7;
  DWORD text = ReadDword(L"TextSize", 0);
  s.text_size = text <= 2 ? (int)text : 0;
  return s;
}

inline bool IsCommand(UINT id) {
  return id >= ID_FIRST && id <= ID_LAST;
}

inline void Toggle(UINT id) {
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
  add(ID_ALT_CHINESE, L"Rare Chinese Alternatives", s.alt_chinese);
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
  return menu;
}

}  // namespace penang
