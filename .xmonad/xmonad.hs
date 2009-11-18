
--necessary
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import IO (Handle, hPutStrLn) 

--utilities
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.NoBorders
import XMonad.Prompt
import XMonad.Prompt.Shell


--hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.XPropManage
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.UrgencyHook (withUrgencyHook, NoUrgencyHook(..))


--MO' HOOKS
import Graphics.X11.Xlib.Extras
import Foreign.C.Types (CLong)
import XMonad.Hooks.SetWMName

--layouts
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LayoutHints
import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Named
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid
import XMonad.Layout.SimplestFloat
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import Data.Ratio((%))


-------------------- main --------------------

main = do 
	h <- spawnPipe "xmobar ~/.xmobarrc"
	xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
		{ workspaces = ["term", "web", "irc", "mail", "code", "graph", "oo", "media", "pdf"] 
--		{ workspaces = ["irc", "web", "media"] ++ map show [4..7] ++ ["network", "torrent"]
		, modMask = mod4Mask
		, startupHook = setWMName "LG3D"
		, borderWidth = 1
		, normalBorderColor = "#554444"
		, focusedBorderColor = "#87b0ff"
		, terminal = "urxvtc"
		, logHook =  logHook' h >> (fadeLogHook)
		, manageHook = manageHook'
		, layoutHook = layoutHook'
		, keys = keys'
		}
-------------------- loghooks --------------------

logHook' ::  Handle -> X ()
logHook' h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }

customPP :: PP
customPP = defaultPP { ppCurrent = xmobarColor "#87b0ff" ""
		     , ppTitle = shorten 75
		     , ppSep = "<fc=#87b0ff> | </fc>"
		     , ppUrgent = xmobarColor "#FF0000" "" . wrap "*" "*"
	             , ppHiddenNoWindows = xmobarColor "#554444" ""
                     }
fadeLogHook :: X ()
fadeLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.7 
-------------------- layouthooks --------------------

layoutHook' = customLayout
--customLayout = onWorkspace "web" simpleTabbed $ avoidStrutsOn [U] (spiral (6/7) ||| spaced |||  float ||| Grid  ||| smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full)
customLayout = onWorkspace "irc" (avoidStruts $ (Mirror tiled) ) $ onWorkspace "term" termL $ onWorkspace "web" webL $ onWorkspace "graph" graphL $ onWorkspace "mail" (avoidStruts $ (Mirror mailL) ) $ defLayout
	where
	 defLayout = avoidStruts $ (spiral (6/7) ||| spaced |||  float     ||| Grid  ||| smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full)
	 spaced = named "Spacing" $ spacing 6 $ Tall 1 (3/100) (1/2)
	 tiled = named "Tiled" $ ResizableTall 1 (2/100) (1/2) []
         float = simplestFloat
	 webL = avoidStruts $ simpleTabbed 
	 graphL =  avoidStruts $ smartBorders $ withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.15) (Role "gimp-dock") Full
	 mailL = named "Mail" $ Tall 1 (2/100) (1/2)
--	 mailL = named "Mail" $ avoidStruts $ smartBorders (Mirror tiled) 
	 termL = avoidStruts $ spacing 6 $ Tall 1 (3/100) (1/2)
--	 tiled1  = Tall 1 (3/100) (1/2)
-------------------- menuhook --------------------

getProp :: Atom -> Window -> X (Maybe [CLong])
getProp a w = withDisplay $ \dpy -> io $ getWindowProperty32 dpy a w

checkAtom name value = ask >>= \w -> liftX $ do
                a <- getAtom name
                val <- getAtom value
                mbr <- getProp a w
                case mbr of
                  Just [r] -> return $ elem (fromIntegral r) [val]
                  _ -> return False 

checkDialog = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG"
checkMenu = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_MENU"

manageMenus = checkMenu --> doFloat
manageDialogs = checkDialog --> doFloat

-------------------- managehook --------------------

manageHook' :: ManageHook
manageHook' = manageHook defaultConfig <+> manageDocks <+> manageMenus <+> manageDialogs <+> myManageHook

myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ [className =? c      --> doFloat | c <- myFloats]
    , [title =? t          --> doFloat | t <- myOtherFloats]
    , [className =? r      --> doIgnore | r <- myIgnores]

    , [className =? im     --> doF (W.shift "irc") | im <- imMessenger]
    , [className =? bw     --> doF (W.shift "web") | bw <- browsers]
    , [className =? e      --> doF (W.shift "graph") | e <- graphApps]
    , [className =? b	   --> doF (W.shift "oo") | b <- office]
    , [className =? p      --> doF (W.shift "pdf") | p <- pdf]
    , [className =? m      --> doF (W.shift "media") | m <- media]	
    ]
    where
      myFloats = ["Gimp", "vlc", "Mirage", "Pcmanfm", "Leafpad", "Smplayer", "Picasa"]
      myOtherFloats = ["Downloads", "Firefox Preferences", "Save As...", "Send file", "Open", "File Transfers"]
      myIgnores = ["trayer", "stalonetray"]

      imMessenger = ["Pidgin", "Psi", "EKG2"]
      browsers = ["Firefox", "Chrome"]
      graphApps = ["Mirage", "Gimp", "Inkscape", "Picasa"]
      office = ["OpenOffice.org 3.1"]
      pdf = ["Evince"]
      media = ["ncmpc++ ver. 0.4.2_pre", "Smplayer"]	
-------------------- keybinds --------------------

keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

      --launching/killing
    --  [ ((modMask,               xK_p     ), spawn "dmenu_run -fn \"-*-fixed-*-*-*-*-10-*-*-*-*-*-iso10646-1\" -nb \"#1C1C1C\" -nf \"#4d4d4d\" -sb \"#2A2A2A\" -sf \"#D81860\"")
      [ ((modMask, 		xK_p	), shellPrompt prompt')
      , ((modMask .|. shiftMask, xK_Return   ), spawn $ XMonad.terminal conf)
      , ((modMask,               xK_f     ), spawn "firefox")
      , ((modMask .|. shiftMask, xK_m     ), spawn "urxvt -e ncmpcpp")
      , ((modMask .|. shiftMask, xK_c     ), kill)
      
      --layouts
      , ((modMask,               xK_space ), sendMessage NextLayout)
      , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
      , ((modMask,               xK_b     ), sendMessage ToggleStruts)

      -- refresh
      , ((modMask,               xK_n     ), refresh)
      , ((modMask .|. shiftMask, xK_w     ), withFocused toggleBorder)
 
      -- focus
      , ((modMask,               xK_Tab   ), windows W.focusDown)
      , ((modMask,               xK_j     ), windows W.focusDown)
      , ((modMask,               xK_k     ), windows W.focusUp)
      , ((modMask,               xK_m     ), windows W.focusMaster)
 
      -- swapping
      , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
      , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
 
      -- increase or decrease number of windows in the master area
      , ((modMask .|. controlMask, xK_h     ), sendMessage (IncMasterN 1))
      , ((modMask .|. controlMask, xK_l     ), sendMessage (IncMasterN (-1)))
 
      -- resizing
      , ((modMask,               xK_h     ), sendMessage Shrink)
      , ((modMask,               xK_l     ), sendMessage Expand)
      , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
      , ((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand)
 
      -- quit, or restart
      , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
      , ((modMask              , xK_q     ), restart "xmonad" True)
      ]
      ++
      -- mod-[1..9] %! Switch to workspace N
      -- mod-shift-[1..9] %! Move client to workspace N
      [((m .|. modMask, k), windows $ f i)
          | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


--prompt
prompt' = defaultXPConfig {
      font              = "xft:terminus-7"
    , bgColor           = "#151515"
    , defaultText       = ""
    , fgColor           = "#b3b3b3"
    , fgHLight          = "#87b0ff"
    , bgHLight          = "#151515"
    , borderColor       = "#FFFFFF"
    , promptBorderWidth = 0
    , position          = Bottom
    , height		= 20
--    , height            = (read dzen_size :: Dimension)
    , historySize       = 128
    }



