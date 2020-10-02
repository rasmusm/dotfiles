
local browserCMD = "firefox --new-window"

local browserScr = ioncore.find_screen_id(0)

wsrun = {}
appws = {}

function wsrun.goto_or_create_ws(name, ongoto, oncreate)
  local ws=ioncore.lookup_region(name)
  if ws then
    ws:goto_focus()
    if ongoto and type(ongoto) == "function" then
      return ongoto(name)
    end
  else
    if oncreate and type(oncreate) == "function" then
      return oncreate(name)
    else
      print("worning: no 'create(name) :: string -> bool'")
    end
  end
  return false
end

function wsrun.mkws(name, layout, scr)
  local tmpl={name=name, switchto=true}
  if not ioncore.create_ws(scr, tmpl, layout) then
    error(TR("Unknown error"))
  end
end

function wsrun.start_if(test, func, name)
  if test then
    return func(name)
  else
    return false
  end
end

function wsrun.start_first_browser_on (name)
  return wsrun.start_if( not wsrun.find_browser_in(name),
    wsrun.start_browser_on, name )
end

function wsrun.start_browser_on(name)
  defwinprop { rule = "browser",
    target=name,
    oneshot=true,
    jumpto=true,
  }
  return exec (browserCMD)
end

function wsrun.create_browser_ws_and_start (name)
  wsrun.mkws (name,"full", browserScr)

  return wsrun.start_browser_on(name)
end

function wsrun.find_browser_in(name)
  local result = nil

  if not name then
    name = "www"
  end

  local www = ioncore.lookup_region(name)
  if not www then
    error(TR("No " .. name .. " region"))
  end
  ws = ioncore.find_manager(www, "WGroupWS")

  ioncore.clientwin_i (
    function (win)
      if ioncore.find_manager(win, "WGroupWS") == ws then
        local wi = win:get_ident()
        if wi.role and wi.role == "browser" then
          result = win
          return false
        end
      end
      return true
    end
  )
  return result
end

function appws.create_or_goto_browser_or_prev (curws)
  if curws and curws:name() == "www" then
    return ioncore.goto_previous_workspace()
  else
    return wsrun.goto_or_create_ws(
      "www",
      wsrun.start_first_browser_on,
      wsrun.create_browser_ws_and_start
    )
  end
end

defbindings("WScreen", {
  bdoc("Goto or create 'www' ws and make sure a browser are started", "www"),
  kpress(META.."B", "appws.create_or_goto_browser_or_prev(_sub)"),
})
