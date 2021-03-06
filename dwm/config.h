/* See LICENSE file for copyright and license details. */

/* appearance */
/*static const char font[]            = "-*-fixed-*-r-normal-*-10-*-*-*-*-*-iso10646-1";*/
static const char font[]            = "terminus 8";
static const char normbordercolor[] = "#554444";
static const char normbgcolor[]     = "#151515";
static const char normfgcolor[]     = "#b3b3b3";
static const char selbordercolor[]  = "#87b0ff";
static const char selbgcolor[]      = "#151515";
static const char selfgcolor[]      = "#87b0ff";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            True,        -1 },
	{ "Firefox",    NULL,       NULL,       1 << 1,     True  -1 },
	{ "Chrome",    NULL,       NULL,       1 << 1,     True  -1 },
	{ "Opera",      NULL,       NULL,       1 << 1,     False -1 }	,
	{ "Inkscape",   NULL,       NULL,       1 << 4,     True -1 },
	{ "Pcmanfm",    NULL,       NULL,       1 << 5,     True -1 },
	{ "MPlayer",    NULL,       NULL,       1 << 6,     True -1 }, 
	{ "Sonata",     NULL,       NULL,       1 << 6,     True -1 },
	{ "Skype",      NULL,       NULL,       1 << 2,     True -1 },
	{ "Pidgin",     NULL,       NULL,       1 << 2,     True -1 },
	{ "OpenOffice.org", NULL,     NULL,       1 << 7,     True -1 },
	{ "Thunderbird-bin",     NULL,       NULL,       1 << 3,    True -1 },
	{ "Evince",     NULL,       NULL,       1 << 8,     True -1 },
    { "trayer",         NULL,       NULL,       0,         False },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const float tagmwfact[] = { 0.6, 0.5, 0.7, 0.5, 0.7, 0.5, 0.5, 0.5, 0.5 };
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */
static const int taglayout[] = { 3, 2, 0, 1, 0, 1, 0, 0, 0 };
static const int tagattachmode[] = { AttNormal, AttAsLast, AttNormal, AttNormal, AttNormal, AttNormal, AttNormal, AttNormal, AttNormal };

#include "push.c"
#include "gaplessgrid.c"
static const int nmaster = 2;      /* default number of clients in master area */
#include "nmaster-sym.c"   /* more than one client in the (tiling) master area */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "+++",      gaplessgrid },
	{ "-|=",      ntile },
	{ "-|-",      nbstack },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "urxvtc", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_w,      spawn,           SHCMD("exec opera") },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_g,      setlayout,      {.v = &layouts[3]} },
	/* nmaster */
	{ MODKEY,                       XK_a,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_z,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_x,      setnmaster,     {.i = 2 } },
	{ MODKEY,                       XK_y,      setlayout,      {.v = &layouts[4] } },
	{ MODKEY,                       XK_b,      setlayout,      {.v = &layouts[5] } },
    /* push */
    { MODKEY|ControlMask,           XK_j,           pushdown,       {0} },
    { MODKEY|ControlMask,           XK_k,           pushup,         {0} },
	/* -- */
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,		XK_n,	   setattachmode,  {.i =AttNormal} },
	{ MODKEY|ShiftMask,		XK_b,	   setattachmode,  {.i =AttAbove} },
	{ MODKEY|ShiftMask,		XK_s,	   setattachmode,  {.i =AttAside} },
	{ MODKEY|ShiftMask,		XK_l,	   setattachmode,  {.i =AttAsLast} },
	{ MODKEY,        		XK_Tab,	   focustoggle,    {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

