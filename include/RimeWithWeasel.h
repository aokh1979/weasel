#pragma once
#include <WeaselIPC.h>
#include <WeaselUI.h>
#include <map>
#include <string>
#include <mutex>
#include <atomic>
#include <vector>
#include <PenangSettings.h>

#include <rime_api.h>

struct CaseInsensitiveCompare {
  bool operator()(const std::string& str1, const std::string& str2) const {
    std::string str1Lower, str2Lower;
    std::transform(str1.begin(), str1.end(), std::back_inserter(str1Lower),
                   [](char c) { return std::tolower(c); });
    std::transform(str2.begin(), str2.end(), std::back_inserter(str2Lower),
                   [](char c) { return std::tolower(c); });
    return str1Lower < str2Lower;
  }
};

typedef std::map<std::string, bool> AppOptions;
typedef std::map<std::string, AppOptions, CaseInsensitiveCompare>
    AppOptionsByAppName;

struct SessionStatus {
  SessionStatus() : style(weasel::UIStyle()), __synced(false), session_id(0) {
    RIME_STRUCT(RimeStatus, status);
  }
  weasel::UIStyle style;
  RimeStatus status;
  bool __synced;
  RimeSessionId session_id;
};
typedef std::map<DWORD, SessionStatus> SessionStatusMap;
typedef DWORD WeaselSessionId;

void LoadWeaselUIStyle(RimeConfig* config,
                       weasel::UIStyle& style,
                       bool initialize = true,
                       const std::string& color_scheme = std::string());

class RimeWithWeaselHandler : public weasel::RequestHandler {
 public:
  RimeWithWeaselHandler(weasel::UI* ui);
  virtual ~RimeWithWeaselHandler();
  virtual void Initialize();
  virtual void Finalize();
  virtual DWORD FindSession(WeaselSessionId ipc_id);
  virtual DWORD AddSession(LPWSTR buffer, EatLine eat = 0);
  virtual DWORD RemoveSession(WeaselSessionId ipc_id);
  virtual BOOL ProcessKeyEvent(weasel::KeyEvent keyEvent,
                               WeaselSessionId ipc_id,
                               EatLine eat);
  virtual void CommitComposition(WeaselSessionId ipc_id);
  virtual void ClearComposition(WeaselSessionId ipc_id);
  virtual void SelectCandidateOnCurrentPage(size_t index,
                                            WeaselSessionId ipc_id);
  virtual bool HighlightCandidateOnCurrentPage(size_t index,
                                               WeaselSessionId ipc_id,
                                               EatLine eat);
  virtual bool ChangePage(bool backward, WeaselSessionId ipc_id, EatLine eat);
  virtual void FocusIn(DWORD param, WeaselSessionId ipc_id);
  virtual void FocusOut(DWORD param, WeaselSessionId ipc_id);
  virtual void UpdateInputPosition(RECT const& rc, WeaselSessionId ipc_id);
  virtual void StartMaintenance();
  virtual void EndMaintenance();
  void PenangSettingsChanged() { m_penang_dirty = true; }
  virtual void SetOption(WeaselSessionId ipc_id,
                         const std::string& opt,
                         bool val);
  virtual void UpdateColorTheme(BOOL darkMode);

  void OnUpdateUI(std::function<void()> const& cb);

 private:
  void _Setup();
  bool _IsDeployerRunning();
  void _UpdateUI(WeaselSessionId ipc_id);
  void _LoadSchemaSpecificSettings(WeaselSessionId ipc_id,
                                   const std::string& schema_id);
  void _LoadAppInlinePreeditSet(WeaselSessionId ipc_id,
                                bool ignore_app_name = false);
  bool _ShowMessage(weasel::Context& ctx, weasel::Status& status);
  bool _Respond(WeaselSessionId ipc_id, EatLine eat);
  void _ReadClientInfo(WeaselSessionId ipc_id, LPWSTR buffer);
  void _GetCandidateInfo(weasel::CandidateInfo& cinfo, RimeContext& ctx);
  void _GetStatus(weasel::Status& stat,
                  WeaselSessionId ipc_id,
                  weasel::Context& ctx);
  void _GetContext(weasel::Context& ctx, RimeSessionId session_id);
  void _UpdateShowNotifications(RimeConfig* config, bool initialize = false);

  void _UpdateInlinePreeditStatus(WeaselSessionId ipc_id);

  RimeSessionId to_session_id(WeaselSessionId ipc_id) {
    return m_session_status_map[ipc_id].session_id;
  }
  SessionStatus& get_session_status(WeaselSessionId ipc_id) {
    return m_session_status_map[ipc_id];
  }
  SessionStatus& new_session_status(WeaselSessionId ipc_id) {
    return m_session_status_map[ipc_id] = SessionStatus();
  }

  AppOptionsByAppName m_app_options;
  weasel::UI* m_ui;  // reference
  DWORD m_active_session;
  bool m_disabled;
  std::string m_last_schema_id;
  std::string m_last_app_name;
  weasel::UIStyle m_base_style;
  // Penang Hokkien Keyboard menu options.
  void _PenangSync(RimeSessionId session_id);
  void _PenangPageSize(RimeSessionId session_id);
  void _PenangApplyStyle(weasel::UIStyle& style);
  void _PenangInitStyle();
  std::atomic<bool> m_penang_dirty{true};
  penang::Settings m_penang;
  int m_penang_base_font = 0;
  std::map<RimeSessionId, int> m_penang_page;
  // Penang typing features: tone marks, double space, word continuations.
  struct PenangOverlay {
    RimeSessionId session = 0;
    int kind = 0;  // 0 none, 1 tone marks, 2 word continuations
    std::vector<std::wstring> items;
    int page = 0;
    int index = 0;
    int page_size = 8;
    UINT keycode = 0;
    std::wstring prefix;
  };
  bool _PenangHandleKey(const weasel::KeyEvent& ke, RimeSessionId session_id);
  void _PenangAfterKey(const weasel::KeyEvent& ke,
                       RimeSessionId session_id,
                       bool handled,
                       bool was_empty);
  bool _PenangChineseMode(RimeSessionId session_id);
  std::string _PenangInput(RimeSessionId session_id);
  void _PenangOfferContinuations(RimeSessionId session_id,
                                 const std::wstring& prefix);
  bool _PenangSelect(int index);
  void _PenangMove(int step);
  void _PenangLoadContinuations();
  void _PenangRecord(const std::wstring& prefix, const std::wstring& suffix);
  PenangOverlay m_penang_ov;
  std::wstring m_penang_commit;
  std::wstring m_penang_last_commit;
  UINT m_penang_down = 0;
  ULONGLONG m_penang_space_time = 0;
  bool m_penang_text_before = false;
  bool m_penang_committed = false;
  bool m_penang_cont_loaded = false;
  std::map<std::wstring, std::vector<std::wstring>> m_penang_cont;
  std::map<std::wstring, int> m_penang_learn;
  std::map<std::string, bool> m_show_notifications;
  std::map<std::string, bool> m_show_notifications_base;
  std::function<void()> _UpdateUICallback;

  static void OnNotify(void* context_object,
                       uintptr_t session_id,
                       const char* message_type,
                       const char* message_value);
  static std::string m_message_type;
  static std::string m_message_value;
  static std::string m_message_label;
  static std::string m_option_name;
  static std::mutex m_notifier_mutex;
  SessionStatusMap m_session_status_map;
  bool m_current_dark_mode;
  bool m_global_ascii_mode;
  int m_show_notifications_time;
  DWORD m_pid;
};
