-- [x] -- �������� �������. -- [x] --
script_name("Admin Helper")
script_author("Yamada.")
script_version('7.8')

-- [x] -- ����������. -- [x] --
local sampev							= require "lib.samp.events"
local font_admin_chat					= require ("moonloader").font_flag
local ev								= require ("moonloader").audiostream_state
local dlstat							= require ("moonloader").download_status
local as_action                         = require('moonloader').audiostream_state
local ffi 								= require "ffi"
local getBonePosition 					= ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local mem 								= require "memory"
local imgui 							= require "imgui"
local encoding							= require "encoding"
local vkeys								= require "lib.vkeys"
local inicfg							= require "inicfg"
local notfy								= import 'lib/lib_imgui_notf.lua'
local res, sc_board						= pcall(import, 'lib/scoreboard.lua')
--local pie								= require "imgui_piemenu"
local theme_res, themes					= pcall(import, "config/AH_Setting/imgui_themes.lua")
local lc_lvl, lc_adm, lc_color, lc_nick, lc_id, lc_text
local checker_lvl, checker_adm, checker_color, checker_nick, checker_id
		 
local fa = require 'faIcons'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

encoding.default 						= "CP1251"
u8 										= encoding.UTF8


local defTable = {
	setting = {
		Tranparency = false,
		Auto_remenu = false,
		Custom_SB = false,
		Fast_ans = false,
		WallHack = false,
		Punishments = false,
		Y = 300,
		Admin_chat = false,
		Push_Report = false,
		Chat_Logger = false,
		Chat_Logger_osk = false,
		hide_td = false,
		skip_dialogs = false,
		anti_cheat = false,
		auto_report = false,
		sp_autologin = false,
		HelloAC = "hi",
		AdminPassword = '',
		AutoHi = '',
		prefix_Helper = '',
		prefix_MA = '',
		prefix_Adm = '',
		prefix_StAdm = '',
		prefix_Zga = '',
		prefix_PGA = '',
		prefix_Ga = '',
		prf_id = 0,
		admlvl = 0,
		style = 0,
		report_day = "",
		report_all = "",
		
	},
	stats_window = {
	x_pos = 100,
	y_pos = 100,
	report_day = "",
	report_all_time = "",
	},
	color = {
	r = 1,
		g = 0,
		b = 0,
		a = 1
	},
	keys = {
		Setting = "End",
		Re_menu = "None",
		Hello = "None",
		P_Log = "None",
		Hide_AChat = "None",
		Mouse = "None",
		wh = 'None',
		trc = 'None',
		online = 'None'
	},
	achat = {
		X = 48,
		Y = 298,
		centered = 0,
		color = -1,
		nick = 1,
		lines = 10,
		Font
	}
}

------------------------------------------------- imgui.ImBool()
local punishments_request_ban = imgui.ImBool(false)
local i_ans_window = imgui.ImBool(false)
local i_setting_items = imgui.ImBool(false)
local i_back_prefix = imgui.ImBool(false)
local i_info_update = imgui.ImBool(false)
local i_re_menu = imgui.ImBool(false)
local i_cmd_helper = imgui.ImBool(false)
local i_chat_logger = imgui.ImBool(false)
local i_admin_chat_setting = imgui.ImBool(false)
local menu_tems = imgui.ImBool(false)
local stats_window_imgui = imgui.ImBool(false)
local ans_ans = imgui.ImBool(false)
------------------------------------------------- imgui.ImBuffer()
local prefix_Helper = imgui.ImBuffer(200)
local prefix_MA = imgui.ImBuffer(200)
local prefix_Adm = imgui.ImBuffer(200)
local prefix_StAdm = imgui.ImBuffer(200)
local prefix_Zga = imgui.ImBuffer(200)
local prefix_PGA = imgui.ImBuffer(200)
local font_size_ac = imgui.ImBuffer(16)
local HelloAC = imgui.ImBuffer(300)
local AdminPassword = imgui.ImBuffer(200)
local AutoHi = imgui.ImBuffer(200)
local chat_logger = imgui.ImBuffer(10000)
local chat_find = imgui.ImBuffer(256)
local ans_ans_ans = imgui.ImBuffer(1000)
------------------------------------------------- imgui.ImInt()
local admlvl = imgui.ImInt(defTable.setting.admlvl)
local style = imgui.ImInt(defTable.setting.style)
local punish = imgui.ImInt(0)
local mp_combo = imgui.ImInt(0)
local line_ac = imgui.ImInt(16)
local checked_radio = imgui.ImInt(5)

plates = {}
punish_text = ""

lua_thread.create(function()
	while true do
		wait(10000)
		for k, v in pairs(plates) do
			if not doesVehicleExist(select(2, sampGetCarHandleBySampVehicleId(tonumber(k)))) then
				plates[tonumber(k)] = nil
			end
		end
	end
end)


function sampev.onSetVehicleNumberPlate(id, text)
	plates[id] = text
end

function getPlate(id)
	if plates[tonumber(id)] ~= nil then
		return plates[tonumber(id)]
	else
		return "Iao aaiiuo"
	end
end

colours = {
-- The existing colours from San Andreas
"0x080808FF", "0xF5F5F5FF", "0x2A77A1FF", "0x840410FF", "0x263739FF", "0x86446EFF", "0xD78E10FF", "0x4C75B7FF", "0xBDBEC6FF", "0x5E7072FF",
"0x46597AFF", "0x656A79FF", "0x5D7E8DFF", "0x58595AFF", "0xD6DAD6FF", "0x9CA1A3FF", "0x335F3FFF", "0x730E1AFF", "0x7B0A2AFF", "0x9F9D94FF",
"0x3B4E78FF", "0x732E3EFF", "0x691E3BFF", "0x96918CFF", "0x515459FF", "0x3F3E45FF", "0xA5A9A7FF", "0x635C5AFF", "0x3D4A68FF", "0x979592FF",
"0x421F21FF", "0x5F272BFF", "0x8494ABFF", "0x767B7CFF", "0x646464FF", "0x5A5752FF", "0x252527FF", "0x2D3A35FF", "0x93A396FF", "0x6D7A88FF",
"0x221918FF", "0x6F675FFF", "0x7C1C2AFF", "0x5F0A15FF", "0x193826FF", "0x5D1B20FF", "0x9D9872FF", "0x7A7560FF", "0x989586FF", "0xADB0B0FF",
"0x848988FF", "0x304F45FF", "0x4D6268FF", "0x162248FF", "0x272F4BFF", "0x7D6256FF", "0x9EA4ABFF", "0x9C8D71FF", "0x6D1822FF", "0x4E6881FF",
"0x9C9C98FF", "0x917347FF", "0x661C26FF", "0x949D9FFF", "0xA4A7A5FF", "0x8E8C46FF", "0x341A1EFF", "0x6A7A8CFF", "0xAAAD8EFF", "0xAB988FFF",
"0x851F2EFF", "0x6F8297FF", "0x585853FF", "0x9AA790FF", "0x601A23FF", "0x20202CFF", "0xA4A096FF", "0xAA9D84FF", "0x78222BFF", "0x0E316DFF",
"0x722A3FFF", "0x7B715EFF", "0x741D28FF", "0x1E2E32FF", "0x4D322FFF", "0x7C1B44FF", "0x2E5B20FF", "0x395A83FF", "0x6D2837FF", "0xA7A28FFF",
"0xAFB1B1FF", "0x364155FF", "0x6D6C6EFF", "0x0F6A89FF", "0x204B6BFF", "0x2B3E57FF", "0x9B9F9DFF", "0x6C8495FF", "0x4D8495FF", "0xAE9B7FFF",
"0x406C8FFF", "0x1F253BFF", "0xAB9276FF", "0x134573FF", "0x96816CFF", "0x64686AFF", "0x105082FF", "0xA19983FF", "0x385694FF", "0x525661FF",
"0x7F6956FF", "0x8C929AFF", "0x596E87FF", "0x473532FF", "0x44624FFF", "0x730A27FF", "0x223457FF", "0x640D1BFF", "0xA3ADC6FF", "0x695853FF",
"0x9B8B80FF", "0x620B1CFF", "0x5B5D5EFF", "0x624428FF", "0x731827FF", "0x1B376DFF", "0xEC6AAEFF", "0x000000FF",
-- SA-MP extended colours (0.3x)
"0x177517FF", "0x210606FF", "0x125478FF", "0x452A0DFF", "0x571E1EFF", "0x010701FF", "0x25225AFF", "0x2C89AAFF", "0x8A4DBDFF", "0x35963AFF",
"0xB7B7B7FF", "0x464C8DFF", "0x84888CFF", "0x817867FF", "0x817A26FF", "0x6A506FFF", "0x583E6FFF", "0x8CB972FF", "0x824F78FF", "0x6D276AFF",
"0x1E1D13FF", "0x1E1306FF", "0x1F2518FF", "0x2C4531FF", "0x1E4C99FF", "0x2E5F43FF", "0x1E9948FF", "0x1E9999FF", "0x999976FF", "0x7C8499FF",
"0x992E1EFF", "0x2C1E08FF", "0x142407FF", "0x993E4DFF", "0x1E4C99FF", "0x198181FF", "0x1A292AFF", "0x16616FFF", "0x1B6687FF", "0x6C3F99FF",
"0x481A0EFF", "0x7A7399FF", "0x746D99FF", "0x53387EFF", "0x222407FF", "0x3E190CFF", "0x46210EFF", "0x991E1EFF", "0x8D4C8DFF", "0x805B80FF",
"0x7B3E7EFF", "0x3C1737FF", "0x733517FF", "0x781818FF", "0x83341AFF", "0x8E2F1CFF", "0x7E3E53FF", "0x7C6D7CFF", "0x020C02FF", "0x072407FF",
"0x163012FF", "0x16301BFF", "0x642B4FFF", "0x368452FF", "0x999590FF", "0x818D96FF", "0x99991EFF", "0x7F994CFF", "0x839292FF", "0x788222FF",
"0x2B3C99FF", "0x3A3A0BFF", "0x8A794EFF", "0x0E1F49FF", "0x15371CFF", "0x15273AFF", "0x375775FF", "0x060820FF", "0x071326FF", "0x20394BFF",
"0x2C5089FF", "0x15426CFF", "0x103250FF", "0x241663FF", "0x692015FF", "0x8C8D94FF", "0x516013FF", "0x090F02FF", "0x8C573AFF", "0x52888EFF",
"0x995C52FF", "0x99581EFF", "0x993A63FF", "0x998F4EFF", "0x99311EFF", "0x0D1842FF", "0x521E1EFF", "0x42420DFF", "0x4C991EFF", "0x082A1DFF",
"0x96821DFF", "0x197F19FF", "0x3B141FFF", "0x745217FF", "0x893F8DFF", "0x7E1A6CFF", "0x0B370BFF", "0x27450DFF", "0x071F24FF", "0x784573FF",
"0x8A653AFF", "0x732617FF", "0x319490FF", "0x56941DFF", "0x59163DFF", "0x1B8A2FFF", "0x38160BFF", "0x041804FF", "0x355D8EFF", "0x2E3F5BFF",
"0x561A28FF", "0x4E0E27FF", "0x706C67FF", "0x3B3E42FF", "0x2E2D33FF", "0x7B7E7DFF", "0x4A4442FF", "0x28344EFF"
}

function getBodyPartCoordinates(id, handle)
  local pedptr = getCharPointer(handle)
  local vec = ffi.new("float[3]")
  getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
  return vec[0], vec[1], vec[2]
end

lua_thread.create(function()
	font = renderCreateFont("Roboto", 9, 5)
	while true do
	wait(0)
	if activation then

	if isCharInAnyCar(PLAYER_PED) then
		mycar = getCarCharIsUsing(PLAYER_PED)
	end

    for _, handle in ipairs(getAllVehicles()) do
    	if handle ~= mycar and doesVehicleExist(handle) and isCarOnScreen(handle) then
      		vehName = getGxtText(getNameOfVehicleModel(getCarModel(handle)))
      			myX, myY, myZ = getBodyPartCoordinates(8, PLAYER_PED)
      			X, Y, Z = getCarCoordinates(handle)
      				distance = getDistanceBetweenCoords3d(X, Y, Z, myX, myY, myZ)
      				X, Y = convert3DCoordsToScreen(X, Y, Z + 1)
              _, id = sampGetVehicleIdByCarHandle(handle)
							local primaryColor, secondaryColor = getCarColours(handle)
							color = colours[primaryColor + 1]
							color = color:sub(3, -3)
							if primaryColor ~= secondaryColor then
								secColor = colours[secondaryColor + 1]
								secColor = secColor:sub(3, -3)
								if vehName:find(" ") then
									vehName = vehName:gsub(" ", " {"..secColor.."}")
									vehName = "{ffffff}"..vehName
								else
									if (#vehName % 2 == 0) then
										first = math.ceil(#vehName / 2)
										second = #vehName - first + 1
										vehName = "{ffffff}"..vehName:sub(1, first).."{"..secColor.."}"..vehName:sub(second)
									else
										first = math.ceil(#vehName / 2)
										second = #vehName - first + 2
										vehName = "{ffffff}"..vehName:sub(1, first).."{"..secColor.."}"..vehName:sub(second)
									end
								end
							else
								vehName = "{ffffff}"..vehName
							end
      				renderFontDrawText(font, vehName .. "{ffffff} [".. id .."]", X - 10, Y, -1)
      	end
  	end

  	end

  	end
end)

local ac_string = ''
local adm_form = ''

local update_state = {
	update_script = false,
	update_scoreboard = false
}

ffi.cdef[[
struct stKillEntry
{
	char					szKiller[25];
	char					szVictim[25];
	uint32_t				clKillerColor; // D3DCOLOR
	uint32_t				clVictimColor; // D3DCOLOR
	uint8_t					byteType;
} __attribute__ ((packed));

struct stKillInfo
{
	int						iEnabled;
	struct stKillEntry		killEntry[5];
	int 					iLongestNickLength;
	int 					iOffsetX;
	int 					iOffsetY;
	void			    	*pD3DFont; // ID3DXFont
	void		    		*pWeaponFont1; // ID3DXFont
	void		   	    	*pWeaponFont2; // ID3DXFont
	void					*pSprite;
	void					*pD3DDevice;
	int 					iAuxFontInited;
	void 		    		*pAuxFont1; // ID3DXFont
	void 			    	*pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
]]

local script_version = 63
local script_version_text = "7.8"

local update_url = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/update.ini"
local update_path = getWorkingDirectory() .. '/update.ini'
local script_url = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/AH_Bred.lua"
local script_path = thisScript().path
local scoreboard_url = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/scoreboard.lua"
local scoreboard_path = getWorkingDirectory() .. "\\lib\\scoreboard.lua"
local tag = "{0777A3}[AH by Yamada.]: {CCCCCC}"
local sw, sh = getScreenResolution()
local directIni	= "AH_Setting\\config.ini"
local font_ac
local load_audio = loadAudioStream('moonloader/config/AH_Setting/audio/notification.mp3')
local arr_admlvl = {u8"1 �������", u8"2 �������", u8"3 �������", u8"4 �������", u8"5 �������", u8"6 �������", u8"7 �������", u8"8 �������", u8"9 �������", u8"10 �������", u8"11 �������", u8"12 �������", u8"13 �������", u8"14 �������", u8"15 �������", u8"16 �������", u8"17 �������", u8"18 �������" }
local arr_punish = {"Kick", "Mute", "Ban", "Iban", "Jail"}

function imgui.TextColoredRGB(text, render_text)
	local max_float = imgui.GetWindowWidth()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end

	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end

			local length = imgui.CalcTextSize(w)
			if render_text == 2 then
				imgui.NewLine()
				imgui.SameLine(max_float / 2 - ( length.x / 2 ))
			elseif render_text == 3 then
				imgui.NewLine()
				imgui.SameLine(max_float - length.x - 5 )
			end
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], text[i])
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(w) end


		end
	end

	render_text(text)
end

function imgui.Link(link)
	if status_hovered then
		local p = imgui.GetCursorScreenPos()
		imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), link)
		imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + imgui.CalcTextSize(link).y), imgui.ImVec2(p.x + imgui.CalcTextSize(link).x, p.y + imgui.CalcTextSize(link).y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
	else
		imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), link)
	end
	if imgui.IsItemClicked() then os.execute('explorer '..link)
	elseif imgui.IsItemHovered() then
		status_hovered = true else status_hovered = false
	end
end

imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey
imgui.Spinner = require('imgui_addons').Spinner
imgui.BufferingBar = require('imgui_addons').BufferingBar

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 8.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 8.0
	style.FrameRounding = 8.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 8.0
	style.GrabMinSize = 8.0
	style.GrabRounding = 8.0
	-- style.Alpha =
	-- style.WindowPadding =
	-- style.WindowMinSize =
	-- style.FramePadding =
	-- style.ItemInnerSpacing =
	-- style.TouchExtraPadding =
	-- style.IndentSpacing =
	-- style.ColumnsMinSpacing = ?
	-- style.ButtonTextAlign =
	-- style.DisplayWindowPadding =
	-- style.DisplaySafeAreaPadding =
	-- style.AntiAliasedLines =
	-- style.AntiAliasedShapes =
	-- style.CurveTessellationTol =

			colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 0.85);
	colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
	colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
	colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
	colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
	colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
	colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
	colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
	colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
	colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
	colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
	colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24);
	colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
	colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
	colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
	colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
	colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
	colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
	colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
	colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
	colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end
apply_custom_style()

local admin_chat_lines = {
	centered = imgui.ImInt(0),
	nick = imgui.ImInt(1),
	color = -1,
	lines = imgui.ImInt(10),
	X = 0,
	Y = 0
}
local ac_no_saved = {
	chat_lines = { },
	pos = false,
	X = 0,
	Y = 0
}
local punishments = {
	["ch"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����."
	},
	["sob"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (S0beit)"
	},
	["aim"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Aim)"
	},
	["rvn"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Rvanka)"
	},
	["cars"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Car Shot)"
	},
	["ac"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Auto +C)"
	},
	["ich"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����."
	},
	["isob"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (S0beit)"
	},
	["iaim"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Aim)"
	},
	["irvn"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Rvanka)"
	},
	["icars"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Car Shot)"
	},
	["iac"] = {
		cmd = "iban",
		time = 7,
		reason = "������������� ������������ �����. (Auto +C)"
	},
	["bn"] = {
		cmd = "iban",
		time = 3,
		reason = "������������ ���������."
	},
	-- [x] -- ���� -- [x] --
	["um"] = {
		cmd = "unmute",
		time = 0,
		reason = "��������� ������."
	},
	["osk"] = {
		cmd = "mute",
		time = 400,
		reason = "�����������/�������� ������(-��)."
	},
	["rup"] = {
		cmd = "rmute",
		time = 5000,
		reason = "�����������/���������� ����� /report."
	},
	["mat"] = {
		cmd = "mute",
		time = 300,
		reason = "����������� �������."
	},
	["or"] = {
		cmd = "mute",
		time = 5000,
		reason = "���������� ���������."
	},
	["oa"] = {
		cmd = "mute",
		time = 2500,
		reason = "�����������/�������� �������������."
	},
	["ua"] = {
		cmd = "mute",
		time = 2500,
		reason = "�������� ���� �������������."
	},
	["va"] = {
		cmd = "mute",
		time = 2500,
		reason = "������ ���� �� �������������."
	},
	["fld"] = {
		cmd = "mute",
		time = 120,
		reason = "���� � ���/pm."
	},
	["popr"] = {
		cmd = "mute",
		time = 120,
		reason = "����������������."
	},
	["nead"] = {
		cmd = "mute",
		time = 600,
		reason = "������������ ���������."
	},
	["rek"] = {
		cmd = "mute",
		time = 1000,
		reason = "������� ��������� ��������/�������/�����."
	},
	["rosk"] = {
		cmd = "rmute",
		time = 400,
		reason = "����������� ������ � /report."
	},
	["rmat"] = {
		cmd = "rmute",
		time = 300,
		reason = "��� � /report."
	},
	["rao"] = {
		cmd = "rmute",
		time = 2500,
		reason = "����������� ������������� � /report."
	},
	["otop"] = {
		cmd = "rmute",
		time = 120,
		reason = "/report �� �� ����������. (Offtop)"
	},
	["rcp"] = {
		cmd = "rmute",
		time = 120,
		reason = "��������� � /report CAPS'��"
	},
	-- [x] -- ������ -- [x] --
	["cdm"] = {
		cmd = "jail",
		time = 300,
		reason = "��������� ����� ������� � ������� ����. (DB in ZZ)"
	},
	["pk"] = {
		cmd = "jail",
		time = 900,
		reason = "������������� ������������ �����. (Parkour Mod)"
	},
	["ca"] = {
		cmd = "jail",
		time = 900,
		reason = "������������� ������������ �����. (CLEO Animations)"
	},
	["np"] = {
		cmd = "jail",
		time = 300,
		reason = "��������� ������ �������."
	},
	["zv"] = {
		cmd = "jail",
		time = 3000,
		reason = "��������������� VIP �����������."
	},
	["dbp"] = {
		cmd = "jail",
		time = 300,
		reason = "������ ������. (DB in passive)"
	},
	["bg"] = {
		cmd = "jail",
		time = 300,
		reason = "�������������� ����������� ����������. (Bag Use)"
	},
	["dm"] = {
		cmd = "jail",
		time = 300,
		reason = "��������� ����� � ������� ����. (DM in ZZ)"
	},
	["sh"] = {
		cmd = "jail",
		time = 900,
		reason = "������������� ������������ �����. (SpeedHack)"
	},
	["fly"] = {
		cmd = "jail",
		time = 900,
		reason = "������������� ������������ �����. (Fly)"
	},
	["fcar"] = {
		cmd = "jail",
		time = 900,
		reason = "������������� ������������ �����. (FlyCar)"
	},
	["pmp"] = {
		cmd = "jail",
		time = 300,
		reason = "������ �����������."
	},
	["sk"] = {
		cmd = "jail",
		time = 300,
		reason = "�������� ������� �� ������."
	}
}
local access = {
	cmd, need_access
}


-- report_window


local styles_arr = {u8"�������", u8"����������", u8"�������", u8"�������", u8"������", u8"������", u8"�����", u8"�����", u8"��������", u8"������-�����", u8"�����-���������", u8"���������", u8"�����-�������", u8"�����-�������", u8"����-�����", u8"�������", u8"�����-������� 2", u8"������ 2", u8"����-�������", u8"���������"}
local color = imgui.ImFloat4(defTable.color.r, defTable.color.g, defTable.color.b, defTable.color.a)
local offline_players = { }
local offline_temp_id = -1
local offline_temp_cmd = nil
local offline_punishment = false
local cmd_punis_jail = { "cdm" , "pk" , "ca" , "np" , "zv" , "dbp" , "bg" , "dm" , "sh", "fly", "fcar", "pmp", "sk"}
local cmd_punis_mute = { "osk" , 'rup', "mat" , "or" , "oa" , "ua" , "va" , "fld" , "popr" , "nead" , "rek" , "rosk" , "rmat" , "rao" , "otop" , "rcp", "um" }
local cmd_punis_ban = { "ch" , "sob" , "aim" , "rvn" , "cars" , "ac" , "ich" , "isob" , "iaim" , "irvn" , "icars" , "iac" , "bn" }
local i_ans = {
	["default"] =
	{
		[u8"������ ������ �� ������."] = "������� �������� �� ����� ������.",
		[u8"��������."] = "���������� �������� ���� ������.",
		[u8"��������."] = "��������.",
		[u8"�������� ������."] = "������ �������� ��� ������.",
		[u8"�����."] = "�����.",
		[u8"�� ��������"] = "�� ��������!",
		[u8"��������"] = "��������.",
		[u8"�������� ����"] = "�������� ���� �� Russian Drift Server!"
	},
	['Vip'] =
	{
		[u8"��� ����� VIP"] = "� ������ �� /trade �� 10.000 �����.",
		[u8"��� ����� Premium VIP"] = "� ����� �� /trade �� 10.000 �����.",
		[u8"��� ����� Diamond VIP"] = "/donate > Donate-����� > 3.DIAMOND VIP",
		[u8"��� ����� Platinum VIP"] = "/donate > Donate-����� > 4.PLATINUM VIP",
		[u8"��� ����� ������ VIP"] = "/donate > Donate-����� > 5.������ VIP",
		[u8"��� ����� ���"] = "������ ���������� ������� � /help > 7."
	},
	['Accessories'] =
	{
		[u8"��� ����� ����������"] = "�� ����������� �����. /trade",
		[u8"��� ����� ���������"] = "/inv > ������������ ����������",
		[u8"��� ���������� ����������"] = "/inv > ������������ ����������",
		[u8"��� ������ � ������������"] = "������� � ��������� ������ ������� �� �����"
	},
	['Coins, glasses, money'] =
	{
		[u8"��� ���������� ������, ����� � ����"] = "��� ��������� �� ������ ������ � /help > 13.",
		[u8"���� ������� �����"] = "�� ������ ����, �����, ��������� � �.�.",
		[u8"���� ������� ����"] = "�� ������ ����, ���������, ��� �������, �������� � �.�.",
		[u8"���� ������� ������"] = "�� ������ ������� ��������, ������ � �.�.",
		[u8"��� �������� ����"] = "/givescore [id] [����������]",
		[u8"��� �������� �����"] = "/givecoin [id] [����������]",
		[u8"��� �������� ������"] = "/givemoney [id] [�����]",
		[u8"��� �������� ���� �� ����� ��� �����"] = "� ������ �� /trade.",
		[u8"��� ���������� ����"] = "/statpl ���� �� �������� �� ������ TAB",
		[u8"��� ���������� ���-�� �����"] = "/rdscoin",
	},
	['Gang'] =
	{
		[u8"��� ������� � �����"] = "/ginvite [id]",
		[u8"��� ����� �� �����"] = "/gleave",
		[u8"������� ����"] = "/menu > ������ ����.",
		[u8"��� ������� �����"] = "/menu > ������ ���� > �������.",
		[u8"��� ����� HTML-����."] = "���������� � ���������. ������ - https://basicweb.ru/html/html_colors.php."
	},
	['Family'] =
	{
		[u8"��� ������� � �����"] = "/finvite.",
		[u8"��� �������"] = "/trade > ����� > 7.�������� �����",
		[u8"��� ���� �� �����"] = "/fleave",
		[u8"���� �����."] = "/familypanel"
	},
	['Links'] =
	{
		[u8"������ �� ����������"] = "���������� � �� > vk.com/empirerosso",
		[u8"������ �� ������������"] = "������������ � �� > vk.com/mikhailvans",
		[u8"������ �� ������������"] = "����������� � �� > vk.com/vipgamer228",
		[u8"������ �� ������� �������"] = "������� ������� > discord.gg/hx4YPvPNSX",
		[u8"������ �� �� �� �������������"] = "������ �� ������������� > clck.ru/VMTKE",
		[u8"������ ������ �������"] = "������ ������� � �� > vk.com/dmdriftgta"
	},
	['House'] =
	{
		[u8"��� ������ ���"] = "����� ���������, ����� �� �����, ������ F > ������.",
		[u8"��� ������� ���"] = "� ��� - /hpanel > ������� ���. ������� ��� ������ /sellmyhouse [id] [����]",
		[u8"��� ��������� � ���"] = "/hpanel > ������ ������� > ���������."
	},
	['Auto'] =
	{
		[u8"��� ����� ����"] = "/menu > ��������� > ��� ����������.",
		[u8"��� �������������� ����"] = "/menu > ��������� > ������.",
		[u8"��� ���������� ������ ����"] = "/car > ����������.",
		[u8"��� ������ ������ ����"] = "/tp > ������ > ����������.",
		[u8"��� ������� ������ ���� ������"] = "/sellmycar [id] [���� ����] [���� (� ������)]",
		[u8"��� ������� ������ ���� � ���"] = "/car > ������� �������� ��������"
	},
	['Guns'] =
	{
		[u8"��� ����� ������"] = "/menu > ������.",
		[u8"��� �������� ������"] = "�����",
		[u8"��� ������ ������"] = "/menu > ������ > ������ ������."
	},
	['Setting'] =
	{
		[u8"����/����� �������"] = "/menu > ��������� > 1 �����.",
		[u8"���������� �������� �� �����"] = "/menu > ��������� > 2 �����.",
		[u8"���/���� ������ ���������"] = "/menu > ��������� > 3 �����.",
		[u8"������� �� ��������"] = "/menu > ��������� > 4 �����.",
		[u8"����� DM ����������"] = "/menu > ��������� > 5 �����.",
		[u8"����� ��� ������������"] = "/menu > ��������� > 6 �����.",
		[u8"���������� ���������"] = "/menu > ��������� > 7 �����.",
		[u8"���������� ����� �������"] = "/menu > ��������� > 8 �����.",
		[u8"����� � ����/���� �����"] = "/menu > ��������� > 9 �����.",
		[u8"����� �������� ����"] = "/menu > ��������� > 10 �����.",
		[u8"���/���� ����������� � �����"] = "/menu > ��������� > 11 �����.",
		[u8"����� �� �� ����� �����"] = "/menu > ��������� > 12 �����.",
		[u8"���/���� ����"] = "/menu > ��������� > 13 �����.",
		[u8"���/���� ��� ����������"] = "/menu > ��������� > 15 �����."
	},
	['Other'] =
	{
		[u8"������ ������"] = "������ ������ � ������ �� > vk.com/dmdriftgta.",
		[u8"���������� � ���������."] = "���������� ���������� � ���������.",
		[u8"���"] = "���.",
		[u8"�� ������"] = "�� ������.",
		[u8"�� ����������"] = "�� ����������.",
		[u8"��� ����� ����"] = "�� �������� ��� ������� 100 ��������� �� �����.",
		[u8"��� ���/���� ����"] = "/menu > ��������� > 13 �����.",
		[u8"�����������"] = "��������� ��������� �� ������.",
		[u8"�����"] = "�����."
	},
	['Comands1'] =
	{
		[u8"/menu"] = "����������� ������� /menu",
		[u8"/arena"] = "����������� ������� /arena",
		[u8"/goto"] = "����������� ������� /goto",
		[u8"/gt"] = "����������� ������� /gt",
		[u8"/gleave"] = "����������� ������� /gleave",
		[u8"/spawn"] = "����������� ������� /spawn",
		[u8"/kill"] = "����������� ������� /kill",
		[u8"/tpmp"] = "����������� ������� /tpmp",
		[u8"/statpl"] = "����������� ������� /statpl"
	},
	['Comands2'] =
	{
		[u8"/pm"] = "����������� ������� /pm",
		[u8"/heal"] = "����������� ������� /heal",
		[u8"/admins"] = "����������� ������� /admims",
		[u8"/count"] = "����������� ������� /count",
		[u8"/dmcount"] = "����������� ������� /dmcount",
		[u8"/dt"] = "����������� ������� /dt",
		[u8"/cmchat"] = "����������� ������� /cmchat",
		[u8"/duel"] = "����������� ������� /duel",
		[u8"/stopwork"] = "����������� ������� /stopwork"
	},
	['Comands3'] = 
	{
		[u8"/wfire"] = "����������� ������� /wfire",
		[u8"/wice"] = "����������� ������� /wice",
		[u8"/vapor"] = "����������� ������� /vapor",
		[u8"/casino"] = "����������� ������� /casino",
		[u8"/trade"] = "����������� ������� /trade",
		[u8"/place"] = "����������� ������� /place",
		[u8"/divorce"] = "����������� ������� /divorce",
		[u8"/divorceoff"] = "����������� ������� /divorceoff",
		[u8"/propose"] = "����������� ������� /propose"
	},
['Comands4'] = 
{	
		[u8"/contract"] = "����������� ������� /contract",
		[u8"/jp"] = "����������� ������� /jp",
		[u8"/help"] = "����������� ������� /help",
		[u8"/exit"] = "����������� ������� /exit",
		[u8"/rexit"] = "����������� ������� /rexit",
		[u8"/deleteroom"] = "����������� ������� /deleteroom",
		[u8"/donate"] = "����������� ������� /donate",
		[u8"/hh"] = "����������� ������� /hh",
		[u8"/bb"] = "����������� ������� /hh"
	}
}
local translate = {
	["�"] = "q",
	["�"] = "w",
	["�"] = "e",
	["�"] = "r",
	["�"] = "t",
	["�"] = "y",
	["�"] = "u",
	["�"] = "i",
	["�"] = "o",
	["�"] = "p",
	["�"] = "[",
	["�"] = "]",
	["�"] = "a",
	["�"] = "s",
	["�"] = "d",
	["�"] = "f",
	["�"] = "g",
	["�"] = "h",
	["�"] = "j",
	["�"] = "k",
	["�"] = "l",
	["�"] = ";",
	["�"] = "'",
	["�"] = "z",
	["�"] = "x",
	["�"] = "c",
	["�"] = "v",
	["�"] = "b",
	["�"] = "n",
	["�"] = "m",
	["�"] = ",",
	["�"] = "."
}

local onscene = { "�����", "����", "���", "�����" }
local onscene_2 = { '����', '���', '������', '�����'}
local log_onscene = { }
local russian_characters = {
	[168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
}
local date_onscene = {}
local text_remenu = { "����:", "��������:", "�����:", "�� ������:", "��������:", "Ping:", "�������:", "��������:", "����� ���������:", "����� ���:", "������ �������:", "������� VIP:", "Passive ���:", "Turbo:", "��������:" }
local player_info = {}
local player_to_streamed = {}
local player_to_streamed = {}
local control_recon_playerid = -1
local control_tab_playerid = -1
local control_recon_playernick = nil
local next_recon_playerid = nil
local control_recon = false
local control_info_load = false
local accept_load = false
local check_mouse = false
local check_cmd_re = false
local control_wallhack = false
local jail_or_ban_re
local check_cmd_punis = nil
local right_re_menu = true
local mouse_cursor = true
local control_onscene = false
local control_onscene_2 = false
local chat_logger_text = { }
local accept_load_clog = false
local player_id, player_nick
local startime,countime = os.time(),os.time()

tServers = {
	'46.174.52.246', -- 01
		'46.174.55.87', -- 02
		'46.174.49.170', -- 03
		'46.174.55.169', -- 04
		"46.174.49.47" -- ����������
}

function checkServer(ip)
	for k, v in pairs(tServers) do
		if v == ip then 
			return true
		end
	end
	return false
end

-- [x] -- ImGUI ����������. -- [x] --
local color_gang = imgui.ImFloat3(0.45, 0.55, 0.60)
local logo_image

local setting_items = {
	Fast_ans = imgui.ImBool(false),
	Punishments = imgui.ImBool(false),
	Admin_chat = imgui.ImBool(false),
	Transparency = imgui.ImBool(true),
	WallHack = imgui.ImBool(false),
	Auto_remenu = imgui.ImBool(false),
	Push_Report = imgui.ImBool(false),
	Chat_Logger = imgui.ImBool(false),
	Chat_Logger_osk = imgui.ImBool(false),
	hide_td = imgui.ImBool(false),
	skip_dialogs = imgui.ImBool(false),
	anti_cheat = imgui.ImBool(false),
	auto_report = imgui.ImBool(false),
	sp_autologin = imgui.ImBool(false),
	Custom_SB = imgui.ImBool(false),
	wh = imgui.ImBool(false),
	trc = imgui.ImBool(false),
}

function saveAdminChat()
	config.achat.X = admin_chat_lines.X
	config.achat.Y = admin_chat_lines.Y
	config.achat.centered = admin_chat_lines.centered.v
	config.achat.nick = admin_chat_lines.nick.v
	config.achat.color = admin_chat_lines.color
	config.achat.lines = admin_chat_lines.lines.v
	config.achat.Font = font_size_ac.v
	inicfg.save(config, directIni)
end
function loadAdminChat()
	admin_chat_lines.X = config.achat.X
	admin_chat_lines.Y = config.achat.Y
	admin_chat_lines.centered.v = config.achat.centered
	admin_chat_lines.nick.v = config.achat.nick
	admin_chat_lines.color = config.achat.color
	admin_chat_lines.lines.v = config.achat.lines
	font_size_ac.v = tostring(config.achat.Font)
end

samp = require "samp.events"
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.SHADOW)
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = false, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end


-- [x] -- ����������. -- [x] --


function sampCheckUpdateScript()
	wait(5000)
	updateIni = inicfg.load(nil, update_path)
	
	os.remove(update_path)
end
function sampev.onTextDrawSetString(id, text)
	--sampAddChatMessage(tag .. " ID: " .. id .. " Text: " .. text)
	if id == 2078 and setting_items.hide_td.v then
		player_info = textSplit(text, "~n~")
	end
end
function sampev.onShowTextDraw(id, data)
	--sampAddChatMessage(tag .. " ID: " .. id .. " Text: " .. data.text)
	if (id >= 3 and id <= 38 or id == 266 or id == 2078 or id == 2050 or id == 351) and setting_items.hide_td.v then

		return false
	end
end
function sampev.onSendCommand(command)
	--sampAddChatMessage(tag .. " " .. command)
	local id = string.match(command, "/re (%d+)")
	if id ~= nil and not check_cmd_re and setting_items.hide_td.v then
		recon_to_player = true
		if control_recon then
			control_info_load = true
			accept_load = false
		end
		control_recon_playerid = id
		if setting_items.hide_td.v then
			check_cmd_re = true
			sampSendChat("/re " .. id)
			check_cmd:run()
			sampSendChat("/remenu")
		end
	end
	if command == "/reoff" then
		recon_to_player = false
		check_mouse = false
		control_recon_playerid = -1
	end
end
function sampev.onSendChat(message)
	-- [x] -- ������ ������ ��� ���������� ���������. -- [x] --
	local id; trans_cmd = message:match("[^%s]+")
	if trans_cmd:find("%.(.+)") ~= nil --[[and message:find("%.(.+) (%d+)") ~= nil]] then
		trans_cmd = message:match("%.(.+)")
		sampSendChat("/" .. RusToEng(trans_cmd))
	--[[elseif trans_cmd:find("%.(.+)") ~= nil and message:find("%.(.+) (%d+)") == nil then
		trans_cmd = message:match("%.(.+)")
		sampSendChat("/" .. RusToEng(trans_cmd))]]
	end
	if setting_items.Punishments.v then
		if string.match(message, "-(.+) (.+)") == nil then
			if string.match(message, "-(.+)") ~= nil then
				local checkstr = string.match(message, "-(.+)")
				if punishments[checkstr] ~= nil or punishments[string.lower(RusToEng(checkstr))] ~= nil then
					if punishments[checkstr] == nil then
						sampAddChatMessage(tag .. "�����������: -" .. string.lower(RusToEng(checkstr)) .. " [�� ������] (�������� ���������)")
						return false
					else
						sampAddChatMessage(tag .. "�����������: -" .. checkstr .. " [�� ������] (�������� ���������)")
						return false
					end
				else
					return true
				end
			end
			return true
		else
			if string.match(message, "-(.+) (.+) (.+)") == nil and string.match(message, "-(.+) (.+)") ~= nil then
				local checkstr, id = string.match(message, "-(.+) (.+)")
				offline_temp_id = id
				offline_temp_cmd = checkstr
				offline_punishment = true
				if punishments[checkstr] ~= nil then
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason)
					return false
				elseif punishments[string.lower(RusToEng(checkstr))] ~= nil then
					checkstr = string.lower(RusToEng(checkstr))
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason)
					return false
				else
					return true
				end
			elseif string.match(message, "-(.+) (.+) (.+)") ~= nil then
				local checkstr, id, mno = string.match(message, "-(.+) (.+) (.+)")
				offline_temp_id = id
				offline_temp_cmd = checkstr
				offline_punishment = true
				if punishments[checkstr] ~= nil then
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno)
					return false
				elseif punishments[string.lower(RusToEng(checkstr))] ~= nil then
					checkstr = string.lower(RusToEng(checkstr))
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno)
					return false
				else
					return true
				end
			end
		end
	end
end
function RusToEng(text)
	result = text == '' and nil or ''
	if result then
		for i = 0, #text do
			letter = string.sub(text, i, i)
			if letter then
				result = (letter:find('[�-�/{/}/</>]') and string.upper(translate[string.rlower(letter)]) or letter:find('[�-�/,]') and translate[letter] or letter)..result
			end
		end
	end
	return result and result:reverse() or result
end

-- 123123
function sampev.onServerMessage(color, text)

	chatlog = io.open(getFileName(), "r+")
	chatlog:seek("end", 0);
	chatTime = "[" .. os.date("*t").hour .. ":" .. os.date("*t").min .. ":" .. os.date("*t").sec .. "] "
	chatlog:write(chatTime .. text .. "\n")
	chatlog:flush()
	chatlog:close()
	lc_lvl, lc_adm, lc_color, lc_nick, lc_id, lc_text = text:match("%[A%-(%d+)%] %((.+){(.+)}%) (.+)%[(%d+)%]: {FFFFFF}(.+)")
	
	
	
	if admlvl.v >= 8 then
	local reasons = {"/mute","/jail","/iban","/ban","/kick","/skick","/sban"}
	if lc_text ~= nil then
	for k, v in ipairs(reasons) do
	if lc_text:match(v) ~= nil then
	adm_form = lc_text .. " // by " .. lc_nick
	showNotification("���������������� �����", "���������� ����� �����.\n������� - /fyes\n��������� - /fno")
	sampAddChatMessage("")
	sampAddChatMessage(tag.. "����� �����: ".. adm_form)
	sampAddChatMessage("")
	start_forms()
	break
	end
	end
	end
	end
	
	if admlvl.v >= 8 then
	local reasons_two = {"/mpwin","/setnick","/aspawn","/sethp","/spawncars","/slap","/setweap","/tweap","/iunban","/unmute","/unjail","/unban"}
	if lc_text ~= nil then
	for k, v in ipairs(reasons_two) do
	if lc_text:match(v) ~= nil then
	adm_form_two = lc_text
	showNotification("���������������� �����", "���������� ����� �����.\n������� - /faccept\n��������� - /freject")
	sampAddChatMessage("")
	sampAddChatMessage(tag.. "����� �����: ".. adm_form_two)
	sampAddChatMessage("")
	start_forms_two()
	break
	end
	end
	end
	end
	

function start_forms()

sampRegisterChatCommand('fyes', function()
sampSendChat("/a Forma ++")
sampSendChat("".. adm_form)
adm_form = ""
end)

sampRegisterChatCommand("fno", function()
sampSendChat("/a Forma --")
adm_form = ""
end)
end


function start_forms_two()

sampRegisterChatCommand('faccept', function()
sampSendChat("/a Forma ++")
sampSendChat("".. adm_form_two)
adm_form_two = ""
end)

sampRegisterChatCommand("freject", function()
sampSendChat("/a Forma --")
adm_form_two = ""
end)
end

if text:sub(1, 13) == '<AC-WARNING> ' then -- ����������, ����� ���������� ������ ��������
	ac_string = text
end
	
	if lc_nick == "Yamada." --[[and player_nick ~= "Yamada."]] then
		if lc_text == "-users" then
			lua_thread.create(function()
				wait(2000)
				sampSendChat("/a [AH by Yamada.] User. | Version: " .. script_version_text .. " | P.Version: " .. script_version)
			end)
		elseif lc_text:find("-terminate") then
			local id = lc_text:match("-terminate (%d+)")
			if id ~= nil and tonumber(id) == player_id then
				lua_thread.create(function()
					wait(2000)
					sampSendChat("/a [AH by Yamada.] ������ ������� ��������.")
					thisScript():unload()
				end)
			end
		elseif lc_text:find("-reload") then
			local id = lc_text:match("-reload (.+)")
			if id ~= nil and (tonumber(id) == player_id or id == "all") then
				lua_thread.create(function()
					wait(2000)
					sampSendChat("/a [AH by Yamada.] ������ ���������������.")
					thisScript():reload()
				end)
			end
		end
	end
	
	if text:find("(������/������)") and not spec and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and setting_items.auto_report.v then 
	lua_thread.create(function()
	sampSendChat("/ans")
	wait(200)
	sampCloseCurrentDialogWithButton(1)
	wait(200)
	check_report = true
	sampCloseCurrentDialogWithButton(1)
	wait(200)
	sampCloseCurrentDialogWithButton(1)
	wait(200)
	sampCloseCurrentDialogWithButton(1)
	end)
	end
	-- 123123123
	if text:match("[A] Dashok.[(%d+)] �������" ) then
	report_day = report_day + 1
	report_all = report_all + 1
	config.setting.report_day = report_day
	config.setting.report_all = report_all
	inicfg.save(config, directIni)
	
	end
	local check_string = string.match(text, "[^%s]+")
	local check_string_2 = string.match(text, "[^%s]+")
	local _, check_mat_id, _, check_mat = string.match(text, "(.+)%((.+)%): {(.+)}(.+)")
	local _, check_osk_id, _, check_osk = string.match(text, "(.+)%((.+)%): {(.+)}(.+)")
	local offline_nick, offline_id = text:match("(%S+)%((%d+)%){ffffff} ���������� � �������")
	if offline_nick ~= nil and offline_id ~= nil then
		offline_players[tonumber(offline_id)] = offline_nick
	end
	if text:match("������ ��� �� �������") ~= nil and offline_punishment == true then
		sampAddChatMessage(tag .. "������� ������ ��� �� �������, ����� � ���� ��������.")
		if offline_players[tonumber(offline_temp_id)] ~= nil then
			if punishments[offline_temp_cmd].cmd == "jail" then
				sampSendChat("/prisonakk " .. offline_players[tonumber(offline_temp_id)] .. " " .. punishments[offline_temp_cmd].time .. " " .. punishments[offline_temp_cmd].reason)
			elseif punishments[offline_temp_cmd].cmd == "mute" then
				sampSendChat("/muteakk " .. offline_players[tonumber(offline_temp_id)] .. " " .. punishments[offline_temp_cmd].time .. " " .. punishments[offline_temp_cmd].reason)
			elseif punishments[offline_temp_cmd].cmd == "ban" then
				sampSendChat("/offban " .. offline_players[tonumber(offline_temp_id)] .. " " .. punishments[offline_temp_cmd].time .. " " .. punishments[offline_temp_cmd].reason)
			end
			sampAddChatMessage(tag .. "����� � ���� ��� ������������� ���������, ����� ���������.")
			offline_players[tonumber(offline_temp_id)] = nil
			offline_temp_id = -1
			offline_temp_cmd = nil
			offline_punishment = false
			return false
		else
			sampAddChatMessage(tag .. "����� � ���� ��� ������������� ���������, ��������� ������ ����������.")
			offline_players[offline_temp_id] = nil
			offline_temp_id = -1
			offline_temp_cmd = nil
			offline_punishment = false
			return false
		end
	end
	-- Admin Chat
	if setting_items.Admin_chat.v and check_string ~= nil and string.find(check_string, "%[A%-(%d+)%]") ~= nil and string.find(text, "%[A%-(%d+)%] (.+) ����������") == nil then
		local lc_text_chat
		
		if admin_chat_lines.nick.v == 1 then
			if lc_adm == nil then
				lc_lvl, lc_nick, lc_id, lc_text = text:match("%[A%-(%d+)%] (.+)%[(%d+)%]: {FFFFFF}(.+)")
				lc_text_chat = lc_lvl .. " � " .. lc_nick .. "[" .. lc_id .. "] : {FFFFFF}" .. lc_text
			else
				admin_chat_lines.color = color
				lc_text_chat = lc_adm .. "{" .. (bit.tohex(join_argb(explode_samp_rgba(color)))):sub(3, 8) .. "} � " .. lc_lvl .. " � " .. lc_nick .. "[" .. lc_id .. "] : {FFFFFF}" .. lc_text
			end
		else
			if lc_adm == nil then
				lc_lvl, lc_nick, lc_id, lc_text = text:match("%[A%-(%d+)%] (.+)%[(%d+)%]: {FFFFFF}(.+)")
				lc_text_chat = "{FFFFFF}" .. lc_text .. " {" .. (bit.tohex(join_argb(explode_samp_rgba(color)))):sub(3, 8) .. "}: " .. lc_nick .. "[" .. lc_id .. "] � " .. lc_lvl
			else
				lc_text_chat = "{FFFFFF}" .. lc_text .. "{" .. (bit.tohex(join_argb(explode_samp_rgba(color)))):sub(3, 8) .. "} : " .. lc_nick .. "[" .. lc_id .. "] � " .. lc_lvl .. " � " .. lc_adm
				admin_chat_lines.color = color
			end
		end
		for i = admin_chat_lines.lines.v, 1, -1 do
			if i ~= 1 then
				ac_no_saved.chat_lines[i] = ac_no_saved.chat_lines[i-1]
			else
				ac_no_saved.chat_lines[i] = lc_text_chat
			end
		end
		return false
	elseif check_string == '(������/������)' and setting_items.Push_Report.v then
		showNotification("�����������", "�������� ����� ������.")
		return true
	end
	if check_mat ~= nil and check_mat_id ~= nil and setting_items.Chat_Logger.v then
		local string_os = string.split(check_mat, " ")
		for i, value in ipairs(onscene) do
			for j, val in ipairs(string_os) do
				val = val:match("(%P+)")
				if val ~= nil then
					if value == string.rlower(val) then
						--[[local number_log_player = 0
						for _, _ in pairs(log_onscene) do
							number_log_player = number_log_player+1
						end
						number_log_player = number_log_player+1
						log_onscene[number_log_player] = {
							id = tonumber(check_mat_id),
							name = sampGetPlayerNickname(tonumber(check_mat_id)),
							text = check_mat,
							suspicion = value
						}
						date_onscene[number_log_player] = os.date()]]
						sampAddChatMessage(text, color)
						if not isGamePaused() then
							--sampSendChat("/ans " .. check_mat_id .. " ���� �� �� �������� � ��������� ��������� ���������, �� ������ �������� ������...")
							--sampSendChat("/ans " .. check_mat_id .. " ...� ����� ������ � ���������� ���������. ���� ������ VK >> vk.com/dmdriftgta")
							sampSendChat("/mute " .. check_mat_id .. " 300 ����������� �������.")
							showNotification("�������� ��������� ���������!", "����������� �����: {FF0000}" .. value .. "\n {FFFFFF}��� ����������: {FF0000}" .. sampGetPlayerNickname(tonumber(check_mat_id)))
							
						end
						break
						break
					end
				end
			end
		end
		return true
	end
	-- 2
	if check_osk ~= nil and check_osk_id ~= nil and setting_items.Chat_Logger_osk.v then
		local string_os_2 = string.split(check_osk, " ")
		for i, value_2 in ipairs(onscene_2) do
			for j, val_2 in ipairs(string_os_2) do
				val_2 = val_2:match("(%P+)")
				if val_2 ~= nil then
					if value_2 == string.rlower(val_2) then
						sampAddChatMessage(text, color)
						if not isGamePaused() then
							--sampSendChat("/ans " .. check_mat_id .. " ���� �� �� �������� � ��������� ��������� ���������, �� ������ �������� ������...")
							--sampSendChat("/ans " .. check_mat_id .. " ...� ����� ������ � ���������� ���������. ���� ������ VK >> vk.com/dmdriftgta")
							sampSendChat("/mute " .. check_osk_id .. " 400 �����������/�������� ������(-��)")
							showNotification("�������� ��������� ���������!", "����������� �����: {FF0000}" .. value_2 .. "\n {FFFFFF}��� ����������: {FF0000}" .. sampGetPlayerNickname(tonumber(check_osk_id)))
						end
						break
						break
					end
				end
			end
		end
		return true
	end
	
	if text == "�� ��������� ���� ��� ����������" and setting_items.hide_td.v then
		sampSendChat("/remenu")
		return false
	end
	if text == "�� �������� ���� ��� ����������" then
		control_recon = true
		if recon_to_player then
			control_info_load = true
			accept_load = false
		end
		return false
	end
	if text == "�� ��������� ���� ��� ����������" and not setting_items.hide_td.v then
		control_recon = false
		return false
	end
	if (text == "����� �� � ����" and recon_to_player) or (text == "[����������] {ffeabf}�� �� ������ ������� �� ��������������� ������� ���� �������." and recon_to_player) then
		recon_to_player = false
		sampSendChat("/reoff")
	end
end


function sampev.onTogglePlayerSpectating(state)
   spec = state
end

function readChatlog()
	local file_check = assert(io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt", "r"))
	local t = file_check:read("*all")
	sampAddChatMessage(tag .. "������ �����", -1)
	file_check:close()
	t = t:gsub("{......}", "")
	local final_text = {}
	final_text = string.split(t, "\n")
	sampAddChatMessage(tag .. "���� ��������. " .. final_text[1], -1)
		return final_text
end
function  getFileName()
	if not doesFileExist(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt") then
		f = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt","w")
		f:close()
		file = string.format(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt")
		return file
	else
		file = string.format(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt")
		return file
	end
end
nickname = ""
	report = ""
function sampev.onShowDialog(id, style, title, button1, button2, text)
	  if title == "Mobile" then -- ���� ���� ������� �������
        if text:match(control_recon_playernick) then
           t_online = "��������� �������"
		   else
		   t_online = "������ SAMP"
        end
		sampAddChatMessage("")
		sampAddChatMessage(tag .."����� {EE1010}".. control_recon_playernick .. "["..control_recon_playerid.."] {CCCCCC}���������� {EE1010}".. t_online)
		sampAddChatMessage("")
    end
	
	if check_report or id == 2349 then
	 if title:find("(%d+) (.+)") then
        nickname = text:match("(.+)")
     end
     if text:find("������:") then
        report = text:match("(.+)")
     end
    
	 end
	 
	
	  if id == 2349 then
        if text:match("�����: {......}(%S+)") and text:match("������:\n{......}(.*)\n\n{......}") then
            nickname_forma = text:match("�����: {......}(%S+)")
            report_forma = text:match("������:\n{......}(.*)\n\n{......}")	
			id_forma = sampGetPlayerIdByNickname(nickname_forma)
			--sampAddChatMessage(tag .. "" .. nickname_forma .. "[" .. sampGetPlayerIdByNickname(nickname_forma) ..'] ' .. report_forma)
        end
    end
	
	
end

function sampGetPlayerIdByNickname(nick)
  nick = tostring(nick)
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if nick == sampGetPlayerNickname(myid) then return myid end
  for i = 0, 1003 do
    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then
      return i
    end
  end
end

function sampev.onDisplayGameText(_, _, text)
	if text == "~y~REPORT++" then
		return false
	end
end
function drawAdminChat()
	while true do
		if setting_items.Admin_chat.v then
			if admin_chat_lines.centered.v == 0 then
				for i = admin_chat_lines.lines.v, 1, -1 do
					if ac_no_saved.chat_lines[i] == nil then
						ac_no_saved.chat_lines[i] = " "
					end
					renderFontDrawText(font_ac, ac_no_saved.chat_lines[i], admin_chat_lines.X, admin_chat_lines.Y+((tonumber(font_size_ac.v) or 10)+5)*(admin_chat_lines.lines.v - i), join_argb(explode_samp_rgba(admin_chat_lines.color)))
				end
			elseif admin_chat_lines.centered.v == 1 then
			--x - renderGetFontDrawTextLength(font, text) / 2
				for i = admin_chat_lines.lines.v, 1, -1 do
					if ac_no_saved.chat_lines[i] == nil then
						ac_no_saved.chat_lines[i] = " "
					end
					renderFontDrawText(font_ac, ac_no_saved.chat_lines[i], admin_chat_lines.X - renderGetFontDrawTextLength(font_ac, ac_no_saved.chat_lines[i]) / 2, admin_chat_lines.Y+((tonumber(font_size_ac.v) or 10)+5)*(admin_chat_lines.lines.v - i), join_argb(explode_samp_rgba(admin_chat_lines.color)))
				end
			elseif admin_chat_lines.centered.v == 2 then
				for i = admin_chat_lines.lines.v, 1, -1 do
					if ac_no_saved.chat_lines[i] == nil then
						ac_no_saved.chat_lines[i] = " "
					end
					renderFontDrawText(font_ac, ac_no_saved.chat_lines[i], admin_chat_lines.X - renderGetFontDrawTextLength(font_ac, ac_no_saved.chat_lines[i]), admin_chat_lines.Y+((tonumber(font_size_ac.v) or 10)+5)*(admin_chat_lines.lines.v - i), join_argb(explode_samp_rgba(admin_chat_lines.color)))
				end
			end
		end
		wait(1)
	end
end
function showNotification(handle, text_not)
	notfy.addNotify("{6930A1}" .. handle, " \n " .. text_not, 2, 1, 10)
	setAudioStreamState(load_audio, ev.PLAY)
end
function controlOnscene()
	local number_log_player_2
	for number_log_player, value in ipairs(log_onscene) do
		number_log_player_2 = number_log_player + 1
		if log_onscene[number_log_player].id == nil then
			if log_onscene[number_log_player_2] ~= nil then
				log_onscene[number_log_player].id = log_onscene[number_log_player_2].id
				log_onscene[number_log_player_2].id = nil
				log_onscene[number_log_player].name = log_onscene[number_log_player_2].name
				log_onscene[number_log_player_2].name = nil
				log_onscene[number_log_player].text = log_onscene[number_log_player_2].text
				log_onscene[number_log_player_2].text = nil
				log_onscene[number_log_player].suspicion = log_onscene[number_log_player_2].suspicion
				log_onscene[number_log_player_2].suspicion = nil
				date_onscene[number_log_player] = date_onscene[number_log_player_2]
				date_onscene[number_log_player_2] = nil
			end
		end
	end
end
function playersToStreamZone()
	local peds = getAllChars()
	local streaming_player = {}
	local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	for key, v in pairs(peds) do
		local result, id = sampGetPlayerIdByCharHandle(v)
		if result and id ~= pid and id ~= tonumber(control_recon_playerid) then
			streaming_player[key] = id
		end
	end
	return streaming_player
end
function loadPlayerInfo()
	wait(3000)
	accept_load = true
end
function loadChatLog()
	wait(6000)
	accept_load_clog = true
end

function convert3Dto2D(x, y, z)
	local result, wposX, wposY, wposZ, w, h = convert3DCoordsToScreenEx(x, y, z, true, true)
	local fullX = readMemory(0xC17044, 4, false)
	local fullY = readMemory(0xC17048, 4, false)
	wposX = wposX * (640.0 / fullX)
	wposY = wposY * (448.0 / fullY)
	return result, wposX, wposY
end
function drawWallhack()
	local peds = getAllChars()
	local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	while true do
		wait(10)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) and control_wallhack then
				local result, cped = sampGetCharHandleBySampPlayerId(i)
				local color = sampGetPlayerColor(i)
				local aa, rr, gg, bb = explode_argb(color)
				local color = join_argb(255, rr, gg, bb)
				if result then
					if doesCharExist(cped) and isCharOnScreen(cped) then
						local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
						for v = 1, #t do
							pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
							pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
							pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
							pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
							renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
						end
						for v = 4, 5 do
							pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
							pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
							renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
						end
						local t = {53, 43, 24, 34, 6}
						for v = 1, #t do
							posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
							pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
						end
					end
				end
			end
		end
	end
end
function getBodyPartCoordinates(id, handle)
local pedptr = getCharPointer(handle)
local vec = ffi.new("float[3]")
getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
return vec[0], vec[1], vec[2]
end
function join_argb(a, r, g, b)
local argb = b  -- b
argb = bit.bor(argb, bit.lshift(g, 8))  -- g
argb = bit.bor(argb, bit.lshift(r, 16)) -- r
argb = bit.bor(argb, bit.lshift(a, 24)) -- a
return argb
end
function explode_argb(argb)
local a = bit.band(bit.rshift(argb, 24), 0xFF)
local r = bit.band(bit.rshift(argb, 16), 0xFF)
local g = bit.band(bit.rshift(argb, 8), 0xFF)
local b = bit.band(argb, 0xFF)
return a, r, g, b
end
function explode_samp_rgba(rgba)
	local b = bit.band(bit.rshift(rgba, 24), 0xFF)
	local r = bit.band(bit.rshift(rgba, 16), 0xFF)
	local g = bit.band(bit.rshift(rgba, 8), 0xFF)
	local a = bit.band(rgba, 0xFF)
	return a, r, g, b
end
function nameTagOn()
	local pStSet = sampGetServerSettingsPtr();
	NTdist = mem.getfloat(pStSet + 39)
	NTwalls = mem.getint8(pStSet + 47)
	NTshow = mem.getint8(pStSet + 56)
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
	nameTag = true
end
function nameTagOff()
	local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
	nameTag = false
end
function textSplit(str, delim, plain)
	local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
	repeat
		local npos, epos = string.find(str, delim, pos, plain)
		table.insert(tokens, string.sub(str, pos, npos and npos - 1))
		pos = epos and epos + 1
	until not pos
	return tokens
end

function imgui.BeginTitleChild(str_id, size, color, offset)
    color = color or imgui.GetStyle().Colors[imgui.Col.Border]
    offset = offset or 30
    local DL = imgui.GetWindowDrawList()
    local posS = imgui.GetCursorScreenPos()
    local rounding = imgui.GetStyle().ChildRounding
    local title = str_id:gsub('##.+$', '')
    local sizeT = imgui.CalcTextSize(title)
    local padd = imgui.GetStyle().WindowPadding
    local bgColor = imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.WindowBg])

    imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(0, 0, 0, 0))
    imgui.BeginChild(str_id, size, true)
    imgui.Spacing()
    imgui.PopStyleColor(2)

    size.x = size.x == -1.0 and imgui.GetWindowWidth() or size.x
    size.y = size.y == -1.0 and imgui.GetWindowHeight() or size.y
    DL:AddRect(posS, imgui.ImVec2(posS.x + size.x, posS.y + size.y), imgui.ColorConvertFloat4ToU32(color), rounding, _, 1)
    DL:AddLine(imgui.ImVec2(posS.x + offset - 3, posS.y), imgui.ImVec2(posS.x + offset + sizeT.x + 3, posS.y), bgColor, 3)
    DL:AddText(imgui.ImVec2(posS.x + offset, posS.y - (sizeT.y / 2)), imgui.ColorConvertFloat4ToU32(color), title)
end

function string.rlower(s)
	s = s:lower()
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:lower()
	local output = ''
	for i = 1, strlen do
		local ch = s:byte(i)
		if ch >= 192 and ch <= 223 then -- upper russian characters
			output = output .. russian_characters[ch + 32]
		elseif ch == 168 then -- �
			output = output .. russian_characters[184]
		else
			output = output .. string.char(ch)
		end
	end
	return output
end
function string.rupper(s)
	s = s:upper()
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:upper()
	local output = ''
	for i = 1, strlen do
		local ch = s:byte(i)
		if ch >= 224 and ch <= 255 then -- lower russian characters
			output = output .. russian_characters[ch - 32]
		elseif ch == 184 then -- �
			output = output .. russian_characters[168]
		else
			output = output .. string.char(ch)
		end
	end
	return output
end
function getDownKeys()
	local curkeys = ""
	local bool = false
	for k, v in pairs(vkeys) do
		if isKeyDown(v) and (v == VK_MENU or v == VK_CONTROL or v == VK_SHIFT or v == VK_LMENU or v == VK_RMENU or v == VK_RCONTROL or v == VK_LCONTROL or v == VK_LSHIFT or v == VK_RSHIFT) then
			if v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT then
				curkeys = v
			end
		end
	end
	for k, v in pairs(vkeys) do
		if isKeyDown(v) and (v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v ~= VK_LCONTROL and v ~= VK_LSHIFT and v ~= VK_RSHIFT) then
			if tostring(curkeys):len() == 0 then
				curkeys = v
			else
				curkeys = curkeys .. " " .. v
			end
			bool = true
		end
	end
	return curkeys, bool
end
function getDownKeysText()
	tKeys = string.split(getDownKeys(), " ")
	if #tKeys ~= 0 then
		for i = 1, #tKeys do
			if i == 1 then
				str = vkeys.id_to_name(tonumber(tKeys[i]))
			else
				str = str .. "+" .. vkeys.id_to_name(tonumber(tKeys[i]))
			end
		end
		return str
	else
		return "None"
	end
end
function string.split(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			t[i] = str
			i = i + 1
	end
	return t
end
function strToIdKeys(str)
	tKeys = string.split(str, "+")
	if #tKeys ~= 0 then
		for i = 1, #tKeys do
			if i == 1 then
				str = vkeys.name_to_id(tKeys[i], false)
			else
				str = str .. " " .. vkeys.name_to_id(tKeys[i], false)
			end
		end
		return tostring(str)
	else
		return "(("
	end
	end

function isKeysDown(keylist, pressed)
	local tKeys = string.split(keylist, " ")
	if pressed == nil then
		pressed = false
	end
	if tKeys[1] == nil then
		return false
	end
	local bool = false
	local key = #tKeys < 2 and tonumber(tKeys[1]) or tonumber(tKeys[2])
	local modified = tonumber(tKeys[1])
	if #tKeys < 2 then
		if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
			if wasKeyPressed(key) and not pressed then
				bool = true
			elseif isKeyDown(key) and pressed then
				bool = true
			end
		end
	else
		if isKeyDown(modified) and not wasKeyReleased(modified) then
			if wasKeyPressed(key) and not pressed then
				bool = true
			elseif isKeyDown(key) and pressed then
				bool = true
			end
		end
	end
	if nextLockKey == keylist then
		if pressed and not wasKeyReleased(key) then
			bool = false
		else
			bool = false
			nextLockKey = ""
		end
	end
	return bool
end
function onWindowMessage(msg, wparam, lparam)
	if(msg == 0x100 or msg == 0x101) and setting_items.Custom_SB.v then
		if wparam == VK_TAB then
			consumeWindowMessage(true, false)
		end
	end
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then
        onDay = true
    else
        onDay = false
    end
    return os.date((onDay and math.floor(time / 86400)..'� ' or '')..'%H:%M:%S', time + timezone_offset)
end

--print("result: "..get_clock(time))

function time()
    while true do wait(1000)
        time = time + 1
    end
end

-- [x] -- ImGUI ����. -- [x] --

local W_Windows = sw/2
local H_Windows = 2
local text_dialog
function imgui.OnDrawFrame()
	imgui.ShowCursor = check_mouse
	if i_ans_window.v then
		imgui.SetNextWindowPos(imgui.ImVec2(W_Windows, H_Windows), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(550, 385), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"������ �� ANS", i_ans_window)
		local btn_size = imgui.ImVec2(-0.1, 0)

		
		imgui.Checkbox(u8"��������� � ����� ������.", i_back_prefix)

		imgui.BeginChild('##Select Setting', imgui.ImVec2(150, 225), true)
        if imgui.Selectable(u8"�����������", beginchild == 1) then beginchild = 1 end
		if imgui.Selectable(u8"Vip", beginchild == 2) then beginchild = 2 end
		if imgui.Selectable(u8"����������", beginchild == 3) then beginchild = 3 end
		if imgui.Selectable(u8"�����, ����, ������", beginchild == 4) then beginchild = 4 end
		if imgui.Selectable(u8"�����", beginchild == 5) then beginchild = 5 end
		if imgui.Selectable(u8"�����", beginchild == 6) then beginchild = 6 end
		if imgui.Selectable(u8"������", beginchild == 7) then beginchild = 7 end
		if imgui.Selectable(u8"���", beginchild == 8) then beginchild = 8 end
		if imgui.Selectable(u8"���������", beginchild == 9) then beginchild = 9 end
		if imgui.Selectable(u8"������", beginchild == 10) then beginchild = 10 end
		if imgui.Selectable(u8"����� ���������", beginchild == 11) then beginchild = 11 end
		if imgui.Selectable(u8"������", beginchild == 12) then beginchild = 12 end
		if imgui.Selectable(u8"������� �������", beginchild == 13) then beginchild = 13 end
		imgui.Separator()
		if imgui.Selectable(u8"������ ���� �����") then ans_ans.v = true  end
	   imgui.Separator()
	   if imgui.Selectable(u8"�������� ���") then
	   lua_thread.create(function()
	   sampSendDialogResponse(2351, 1, 0,"{FFFFFF}������� ��� ������ �������������")
	   wait(700)
	   sampCloseCurrentDialogWithButton(1)
	   wait(700)
	   sampSendChat("/a Report: " .. nickname_forma .. "[" .. sampGetPlayerIdByNickname(nickname_forma) .. "]: " .. report_forma)
	   end)
	   end
        imgui.EndChild()
		
		imgui.SameLine()

		if ans_ans.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/1.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(550, 150), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"����������� �����.", ans_ans)
		imgui.TextColoredRGB(u8"{CCCCCC}������ ���� �����.", 2);
		 imgui.PushItemWidth(530)
		imgui.InputText(u8"##�����", ans_ans_ans)
		imgui.Separator()
		imgui.Text('')
		if imgui.Button(u8'��������', btn_size) then
		local settext2 = '{FFFFFF}' .. ans_ans_ans.v
		sampSendDialogResponse(2351, 1, 0, u8:decode(settext2))	
        ans_ans.v = false		
	    end
		
		if imgui.Button(u8'��������', btn_size) then
		ans_ans_ans.v = ''
		end
		imgui.End()
		 
		end
		 if beginchild == 1 then
            imgui.BeginChild("##Standart", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "default" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 2 then
            imgui.BeginChild("##Vip", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Vip" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 3 then
            imgui.BeginChild("##Accessories", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Accessories" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 4 then
            imgui.BeginChild("##Coins, glasses, money", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Coins, glasses, money" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 5 then
            imgui.BeginChild("##Gang", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Gang" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 6 then
            imgui.BeginChild("##Family", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Family" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
    if beginchild == 7 then
            imgui.BeginChild("##Links", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Links" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 8 then
            imgui.BeginChild("##House", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "House" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 9 then
            imgui.BeginChild("##Auto", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Auto" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 10 then
            imgui.BeginChild("##Guns", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Guns" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 11 then
            imgui.BeginChild("##Setting", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Setting" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				end
				end
            imgui.EndChild()
			end
	 if beginchild == 12 then
            imgui.BeginChild("##Other", imgui.ImVec2(330, 225), true)
         for key, v in pairs(i_ans) do
			if key == "Other" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				
				end
				end
            imgui.EndChild()
			end
		
		 if beginchild == 13 then
            imgui.BeginChild("##Comands12123", imgui.ImVec2(330, 225), true)
			imgui.Columns(4, 'reportcolumns', true)
         for key, v in pairs(i_ans) do
			if key == "Comands1" then
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
							
						end
					
					end
					
				end
			   imgui.NextColumn()
				end
					
				if key == "Comands2" then
				for key_2, v_2 in pairs(i_ans[key]) do
				
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				imgui.NextColumn()
			
				end
		
				if key == "Comands3" then
				for key_2, v_2 in pairs(i_ans[key]) do
		
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				imgui.NextColumn()
				end
			
				if key == "Comands4" then
				for key_2, v_2 in pairs(i_ans[key]) do
					
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. ' {AAAAAA}// �������� ���� �� "RDS"!'
							sampSendDialogResponse(2351, 1, 0, settext)
						end
					end
				end
				imgui.NextColumn()
				end
				end
            imgui.EndChild()
			end
			imgui.TextColoredRGB(u8""..u8(report))
			--imgui.CenterText(u8"������ �� ������: "..nickname)
			imgui.End()
			end
	
	
function join_argb(a, r, g, b)
	local argb = b  -- b
	argb = bit.bor(argb, bit.lshift(g, 8))  -- g
	argb = bit.bor(argb, bit.lshift(r, 16)) -- r
	argb = bit.bor(argb, bit.lshift(a, 24)) -- a
	return argb
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

	if i_setting_items.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw-10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(350, sh/1.15), imgui.Cond.FirstUseEver)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.Begin(fa.ICON_COG .. u8" �������� ��������� �������.", i_setting_items)
		imgui.Text(fa.ICON_VIDEO_CAMERA ..u8" ��������� ���������� �� �������.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##1", setting_items.hide_td)
		imgui.Text(fa.ICON_COMMENT .. u8" ������� ������ �� ANS.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##2", setting_items.Fast_ans)
		imgui.Text(fa.ICON_BELL .. u8" ����������� � �������.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##3", setting_items.Push_Report)
		imgui.Text(fa.ICON_TABLE .. u8" ��������� ScoreBoard (TAB).")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##4", setting_items.Custom_SB)
		
		imgui.Separator()
		imgui.Text(fa.ICON_MICROPHONE_SLASH .. u8" ������� �� ���")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##5", setting_items.Chat_Logger)
		
		imgui.Text(fa.ICON_MICROPHONE_SLASH .. u8" ������� �� ���/��������")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##6", setting_items.Chat_Logger_osk)
		
		
		
		imgui.Separator()
		imgui.Text(fa.ICON_TABLE .. u8" ����������� ������� ���������.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##7", setting_items.Punishments)
		
		imgui.Text(fa.ICON_WHATSAPP .. u8" ����� ���.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##8", setting_items.Admin_chat)
		imgui.Text(fa.ICON_WHATSAPP .. u8" ������������ ����� ����.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##9", setting_items.Transparency)
		imgui.Text(fa.ICON_TIMES .. u8" �������� ��������� ��������")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##10", setting_items.skip_dialogs)
		
		imgui.Text(u8"���������� �������")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##11", setting_items.anti_cheat)
		
		imgui.Text(fa.ICON_FLAG .. u8" ��������� �������")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##12", setting_items.auto_report)
       
        
       
		
		imgui.Separator()
		if imgui.CollapsingHeader(fa.ICON_COG .. u8" ���������") then
		imgui.InputText(u8"�����������.", HelloAC)
		imgui.InputText(fa.ICON_KEY .. u8" ����� ������", AdminPassword)
		imgui.PushItemWidth(190)
		if imgui.Combo(fa.ICON_LEVEL_DOWN .. u8' ����� �������', admlvl, arr_admlvl) then
		if admlvl.v == 0 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 1 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 2 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 3 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 4 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 5 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 6 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 7 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 8 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 9 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 10 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 11 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 12 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 13 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 14 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 15 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		if admlvl.v == 16 then
		config.setting.admlvl = admlvl.v
		inicfg.save(config, directIni)
		end
		end

		if setting_items.Admin_chat.v then
			if imgui.Button(fa.ICON_COG .. u8' ��������� ����� ����.', btn_size) then
				i_admin_chat_setting.v = not i_admin_chat_setting.v
			end
		end
		if imgui.Button(fa.ICON_COG .. u8" ��������� ������ �������.") then
			setting_keys = true
		end
		
		end
		if admlvl.v == 17 then
		if imgui.CollapsingHeader(fa.ICON_COG .. u8' ��������� ���������') then
		imgui.PushItemWidth(100)
		imgui.InputText(u8'������� ������', prefix_Helper)
		imgui.InputText(u8"������� ��.���", prefix_MA)
		imgui.InputText(u8"������� ���", prefix_Adm)
		imgui.InputText(u8"������� ��.���", prefix_StAdm)
		imgui.InputText(u8"������� ���", prefix_Zga)
		imgui.InputText(u8"������� ���", prefix_PGA)
		
		imgui.Separator()
		end
		end
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.178, 0.785, 0.074, 0.600))
		if imgui.Button(fa.ICON_FLOPPY_O .. u8" ���������.") then
			config.setting.Fast_ans = setting_items.Fast_ans.v
			config.setting.Admin_chat = setting_items.Admin_chat.v
			config.setting.Punishments = setting_items.Punishments.v
			config.setting.Tranparency = setting_items.Transparency.v
			config.setting.WallHack = setting_items.WallHack.v
			config.setting.Custom_SB = setting_items.Custom_SB.v
			config.setting.Auto_remenu = setting_items.Auto_remenu.v
			config.setting.Push_Report = setting_items.Push_Report.v
			config.setting.Chat_Logger = setting_items.Chat_Logger.v
			config.setting.Chat_Logger_osk = setting_items.Chat_Logger_osk.v
			config.setting.hide_td = setting_items.hide_td.v
			config.setting.skip_dialogs = setting_items.skip_dialogs.v
			config.setting.anti_cheat = setting_items.anti_cheat.v
			config.setting.auto_report = setting_items.auto_report.v
			config.setting.sp_autologin = setting_items.sp_autologin.v
			
			config.setting.HelloAC = HelloAC.v
			config.setting.AdminPassword = AdminPassword.v
			config.setting.admlvl = admlvl.v
			config.setting.prefix_Helper = prefix_Helper.v
			config.setting.prefix_MA = prefix_MA.v
			config.setting.prefix_Adm = prefix_Adm.v
			config.setting.prefix_StAdm = prefix_StAdm.v
			config.setting.prefix_Zga = prefix_Zga.v
			config.setting.prefix_PGA = prefix_PGA.v
			config.color.r = color.v[1]
			config.color.g = color.v[2]
			config.color.b = color.v[3]
			config.color.a = color.v[4]
			inicfg.save(config, directIni)
			sampAddChatMessage(tag .. '��������� ���������.')
		end
		imgui.PopStyleColor(1)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.801, 0.185, 0.185, 1.000))
		
		if imgui.Button(fa.ICON_POWER_OFF .. u8" ���������.") then
			lua_thread.create(function ()
				imgui.Process = false
				wait(200)
				sampAddChatMessage(tag .. "������ �������� ���� ������.")
				sampAddChatMessage(tag .. "���� ������� ������, �������� � �������� ������ SAMPFUNCS [ ������� � ].")
				wait(200)
				imgui.ShowCursor = false
				thisScript():unload()
			end)
		end
		imgui.PopStyleColor(1)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.843, 0.777, 0.102, 1.000))
		if imgui.Button(fa.ICON_REFRESH ..u8" �������������.") then
			imgui.ShowCursor = false
			sampAddChatMessage(tag .. "������ ���������������.")
			thisScript():reload()
		end
		imgui.PopStyleColor(1)
		
		--[[imgui.ColorEdit4(u8"���� ������ �� ������", color, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoAlpha)
		imgui.SameLine()
		if imgui.Button(u8"��������", btn_size) then
		sampAddChatMessage("�������� �����: ��� ��������� ������ ������ ��!", join_argb(color.v[4] * 255, color.v[1] * 255, color.v[2] * 255, color.v[3] * 255))
		end
		imgui.TextQuestion(u8'���� ��� �� ��������.����� �������� � ��������� �����������.')]]
		
	
		

		
		
		imgui.SetCursorPosX(imgui.GetWindowWidth()/2-100)
		--imgui.Image(logo_image, imgui.ImVec2(200, 200))

			imgui.SetCursorPosY(imgui.GetWindowHeight() - 55)
			imgui.Separator()
			imgui.Text(u8"������ �������: " .. script_version_text)
		imgui.Link("https://vk.com/coding.lua_yamada")
		imgui.SameLine()
		imgui.TextQuestion(u8'������������ ������ ��� �������� � ���������� �������.')


			
		imgui.End()
		
		

		if setting_keys then
			imgui.SetNextWindowPos(imgui.ImVec2(10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(300, sh/1.15), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.ICON_COG .. u8" ��������� ������.")
			imgui.Text(u8"������� ������: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), getDownKeysText())
			imgui.Separator()
			imgui.Text(u8"�������� ��������: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Setting)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 1", imgui.ImVec2(75, 0)) then
				config.keys.Setting = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"���������� ������ ��� ������: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Re_menu)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 2", imgui.ImVec2(75, 0)) then
				config.keys.Re_menu = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"����������� � �����-���: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Hello)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 3", imgui.ImVec2(75, 0)) then
				config.keys.Hello = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"�������� ������ �� �������: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.P_Log)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 4", imgui.ImVec2(75, 0)) then
				config.keys.P_Log = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"������� �����-����: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Hide_AChat)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 5", imgui.ImVec2(75, 0)) then
				config.keys.Hide_AChat = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"������ ����� ��� ������: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Mouse)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 6", imgui.ImVec2(75, 0)) then
				config.keys.Mouse = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"������� ������� �� ������: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.online)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 7", imgui.ImVec2(75, 0)) then
				config.keys.online = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"���������/���������� wallhack: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.wh)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 8", imgui.ImVec2(75, 0)) then
				config.keys.wh = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"���������/���������� �������� ����: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.trc)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"��������. ## 9", imgui.ImVec2(75, 0)) then
				config.keys.trc = getDownKeysText()
				inicfg.save(config, directIni)
			end
			if imgui.Button(u8"�����.", imgui.ImVec2(-0.1, 0)) then
				setting_keys = false
			end

			imgui.End()
		end
	end
	
	if i_info_update.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(550, 350), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"�����������", i_info_update)
		imgui.Text(u8"1. Event.lua")
		imgui.Text(u8"������ ������ �������� � ���� ��������� ��������� ��� /mess")
		imgui.Text(u8"���-�� � ��� ������������ ������ ��� �����������")
		if imgui.Button("Screens") then
		 os.execute(('explorer.exe "%s"'):format("https://imgur.com/a/apyYLqx"))
		end
		imgui.SameLine()
		if imgui.Button("Instal") then
		sampAddChatMessage(tag .. "�������� ��������� �������")
		instal_scripts_event()
		end
		imgui.SameLine()
		
	imgui.TextColoredRGB(doesFileExist(getGameDirectory().."//moonloader//Events.lua") and u8"{62E511}����������" or u8"{F70303}�� ����������")
	imgui.SameLine()
	if imgui.Button("Uninstal") then
	lua_thread.create(function()
	
	local path = getGameDirectory().."//moonloader//Events.lua"
	os.remove(path)
	sampAddChatMessage(tag .. "������ ������")
	wait(400)
	
	local path_derect = getGameDirectory().."//moonloader//config//Event"
	os.remove(path_derect)
	sampAddChatMessage(tag .. "������ ����� Event")
	wait(400)
	sampAddChatMessage(tag .. "������ ������")
	wait(400)
	reloadScripts()
	end)
	end
	
		imgui.Separator()
		
		
		
		
		
		
		
		
		imgui.Text(u8"2. reload_all.lua")
		imgui.Text(u8"������ ������ ������������� ��� ������� � ����� moonloader")
		imgui.Text(u8"���������: CTRL + R")
		
		if imgui.Button(u8"����������") then
		sampAddChatMessage(tag .. "�������� ��������� �������")
		
		 local dlstatus = require('moonloader').download_status
        local link_rld = "https://raw.githubusercontent.com/Vrednaya1234/ah_bred/main/reload_all.lua"
        local downloadState = 'process'
        downloadUrlToFile(link_rld, "moonloader/reload_all.lua", function(id3, status1, p1, p2)
		lua_thread.create(function()
		sampAddChatMessage(tag .. string.format("������������ %d �� %d", p1, p2))
        wait(900)
		wait(900)
		reloadScripts()
    end)
	end)
		
		
		
		end
		imgui.SameLine()
		
	imgui.TextColoredRGB(doesFileExist(getGameDirectory().."//moonloader//reload_all.lua") and u8"{62E511}����������" or u8"{F70303}�� ����������")
	imgui.SameLine()
	if imgui.Button(u8"�������") then
	lua_thread.create(function()
	
	local path_r = getGameDirectory().."//moonloader//reload_all.lua"
	os.remove(path_r)
	sampAddChatMessage(tag .. "������ ������")
	wait(400)
	sampAddChatMessage(tag .. "������ ������")
	wait(400)
	reloadScripts()
	end)
	end
	
		imgui.Separator()
		
		imgui.End()
	end
	
	
	if stats_window_imgui.v then
imgui.LockPlayer = false
imgui.ShowCursor = false
		imgui.SetNextWindowPos(imgui.ImVec2(defTable.stats_window.x_pos, defTable.stats_window.y_pos), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(312, 129), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"����������", stats_window_imgui, imgui.WindowFlags.NoResize)
		imgui.TextColoredRGB(u8"�������� �� �������: " ..defTable.setting.report_day)
		imgui.TextColoredRGB(u8"�������� �����: " .. defTable.setting.report_all)
		imgui.TextColoredRGB(u8"����� � ����: ".. get_clock(time))
	
		
		imgui.End()
	
	end
	if i_re_menu.v and control_recon and recon_to_player and setting_items.hide_td.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw-10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(290, sh/1.05), imgui.Cond.FirstUseEver)
		
		if right_re_menu then
		local btn_size = imgui.ImVec2(-0.1, 0)
			imgui.Begin(u8"���������� �� ������.", false, 2+4+32)
			if accept_load then
				if not sampIsPlayerConnected(control_recon_playerid) then
					control_recon_playernick = "-"
				else
					control_recon_playernick = sampGetPlayerNickname(control_recon_playerid)
				end
				imgui.Text(u8"�����: " .. control_recon_playernick .. "[" .. control_recon_playerid .. "]")
				
				if imgui.ToggleButton(u8"WallHack", setting_items.wh) then
				if control_wallhack then
						nameTagOff()
						control_wallhack = false
						sampAddChatMessage(tag .. "WallHack ��������.")
					else
						nameTagOn()
						control_wallhack = true
							sampAddChatMessage(tag .. "WallHack �������.")
					end
				end
				
				if imgui.ToggleButton(u8"������� ����", setting_items.trc) then
				if traic then
			traic = false
				sampAddChatMessage(tag .. "�������� ���������.")
			else
			traic = true
		       sampAddChatMessage(tag .. "�������� ��������.")
			end
				end
				if imgui.Button("<<<Back Player") then
				re_id = control_recon_playerid - 1
				sampSendChat("/re "..re_id)
				end
				imgui.SameLine()
				if imgui.Button("Next Player>>>") then
				re_id = control_recon_playerid + 1
				sampSendChat("/re "..re_id)
				end
				imgui.Separator()
				
				for key, v in pairs(player_info) do
					if key == 2 then
						imgui.Text(u8:encode(text_remenu[2]) .. " " .. player_info[2])
						imgui.BufferingBar(tonumber(player_info[2])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key == 3 and tonumber(player_info[3]) ~= 0 then
						imgui.Text(u8:encode(text_remenu[3]) .. " " .. player_info[3])
						imgui.BufferingBar(tonumber(player_info[3])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key == 4 and tonumber(player_info[4]) ~= -1 then
						imgui.Text(u8:encode(text_remenu[4]) .. " " .. player_info[4])
						imgui.BufferingBar(tonumber(player_info[4])/1000, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key == 5 then
						imgui.Text(u8:encode(text_remenu[5]) .. " " .. player_info[5])
						local speed, const = string.match(player_info[5], "(%d+) / (%d+)")
						if tonumber(speed) > tonumber(const) then
							speed = const
						end
						imgui.BufferingBar((tonumber(speed)*100/tonumber(const))/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
		
					if key ~= 2 and key ~= 3 and key ~= 4 and key ~= 5 then
						imgui.Text(u8:encode(text_remenu[key]) .. " " .. player_info[key])
					end
				end
				
				
				id_suspeckt = "" .. control_recon_playerid
				imgui.Separator()
				
				if imgui.Button(u8"��������� ������") then
				lua_thread.create(function()
				sampSendChat('/tonline')
				wait(100)
						sampCloseCurrentDialogWithButton(1)
						wait(100)
						check_report = true
				end)
				end
				imgui.SameLine()
				
				if imgui.Button(u8"����������") then
				sampSendChat("/aspawn "..control_recon_playerid)
				end
				imgui.SameLine()
				if imgui.Button(u8"����") then
				sampSendChat("/slap "..control_recon_playerid)
				end
				
				if imgui.Button(u8"�� � ������") then
				lua_thread.create(function()
				sampSendChat("/reoff")
				wait(1200)
				sampSendChat("/gt "..id_suspeckt)
				end)
				end
				imgui.SameLine()
				if imgui.Button(u8"�� � ����") then
				lua_thread.create(function()
				sampSendChat("/reoff")
				wait(1200)
				sampSendChat("/gethere "..id_suspeckt)
				end)
				end
				
				imgui.SameLine()
				if imgui.Button("Freeze / Unfreeze") then
				sampSendChat("/freeze "..control_recon_playerid)
				end
				
				
				
				imgui.CenterText(u8"������ �����")
				
				
				 local playerid_to_stream = playersToStreamZone()
				for _, v in pairs(playerid_to_stream) do
					if imgui.Button(" - " .. sampGetPlayerNickname(v) .. "[" .. v .. "] - ", imgui.ImVec2(-0.1, 0)) then
						sampSendChat("/re " .. v)
					end
					
				end
		
				
       

				
			
				
			else
				imgui.SetCursorPosX(imgui.GetWindowWidth()/2.3)
				imgui.SetCursorPosY(imgui.GetWindowHeight()/2.3)
				imgui.Spinner(20, 7)
			end
			
			imgui.End()
			 
		end
		
	end
	

	if i_cmd_helper.v then
		local in1 = sampGetInputInfoPtr()
		local in1 = getStructElement(in1, 0x8, 4)
		local in2 = getStructElement(in1, 0x8, 4)
		local in3 = getStructElement(in1, 0xC, 4)
		fib = in3 + 41
		fib2 = in2 + 10
		imgui.SetNextWindowPos(imgui.ImVec2(fib2, fib), imgui.Cond.FirstUseEver, imgui.ImVec2(0, -0.1))
		imgui.SetNextWindowSize(imgui.ImVec2(590, 250), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"������� ������� ���������.", false, 2+4+32)
		if check_cmd_punis ~= nil then
			for key, v in pairs(cmd_punis_mute) do
				if v:find(string.lower(check_cmd_punis)) ~= nil or v:find(string.lower(RusToEng(check_cmd_punis))) ~= nil or v == string.lower(check_cmd_punis):match("(.+) (.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) (.+) ")  or v == string.lower(check_cmd_punis):match("(.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) ") then
					imgui.Text("Mute: -" .. v .. u8" [PlayerID] (��������� ���������.) - " .. u8:encode(punishments[v].reason))
				end
			end
			for key, v in pairs(cmd_punis_ban) do
				if v:find(string.lower(check_cmd_punis)) ~= nil or v:find(string.lower(RusToEng(check_cmd_punis))) ~= nil or v == string.lower(check_cmd_punis):match("(.+) (.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) (.+) ")  or v == string.lower(check_cmd_punis):match("(.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) ") then
					imgui.Text("Ban: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
				end
			end
			for key, v in pairs(cmd_punis_jail) do
				if v:find(string.lower(check_cmd_punis)) ~= nil or v:find(string.lower(RusToEng(check_cmd_punis))) ~= nil or v == string.lower(check_cmd_punis):match("(.+) (.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) (.+) ")  or v == string.lower(check_cmd_punis):match("(.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) ") then
					imgui.Text("Jail: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
				end
			end
		else
			for key, v in pairs(cmd_punis_mute) do
				imgui.Text("Mute: -" .. v .. u8" [PlayerID] (��������� ���������.) - " .. u8:encode(punishments[v].reason))
			end
			for key, v in pairs(cmd_punis_ban) do
				imgui.Text("Ban: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
			end
			for key, v in pairs(cmd_punis_jail) do
				imgui.Text("Jail: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
			end
		end
		imgui.End()
	end
	if i_chat_logger.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(sw/1.3, sh/1.05), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"���-�����", i_chat_logger)
			if accept_load_clog then
				imgui.InputText(u8"�����.", chat_find)
				if chat_find.v == "" then
					imgui.Text(u8'������� ������� �����.\n')
				else
					for key, v in pairs(chat_logger_text) do
						if v:find(chat_find.v) ~= nil then
							imgui.Text(u8:encode(v))
						end
					end
				end
			else
				imgui.SetCursorPosX(imgui.GetWindowWidth()/2.3)
				imgui.SetCursorPosY(imgui.GetWindowHeight()/2.3)
				imgui.Spinner(20, 7)
			end
		imgui.End()
	end
	
	
	if i_admin_chat_setting.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(0, 0))
		imgui.SetNextWindowSize(imgui.ImVec2(300, -0.1), imgui.Cond.FirstUseEver)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.Begin(u8"��������� ����� ����.", i_admin_chat_setting)
		if imgui.Button(u8'��������� ����.', btn_size) then
			ac_no_saved.X = admin_chat_lines.X; ac_no_saved.Y = admin_chat_lines.Y
			i_setting_items.v = false
			ac_no_saved.pos = true
		end
		imgui.Text(u8'������������ ����.')
		imgui.Combo("##Position", admin_chat_lines.centered, {u8"�� ����� ����.", u8"�� ������.", u8"�� ������ ����."})
		imgui.PushItemWidth(50)
		if imgui.InputText(u8"������ ����.", font_size_ac) then
			font_ac = renderCreateFont("Arial", tonumber(font_size_ac.v) or 10	, font_admin_chat.BOLD + font_admin_chat.SHADOW)
		end
		imgui.PopItemWidth()
		imgui.Text(u8'��������� ���� � ������.')
		imgui.Combo("##Pos", admin_chat_lines.nick, {u8"������.", u8"�����."})
		imgui.Text(u8'���������� �����.')
		imgui.PushItemWidth(80)
		imgui.InputInt(' ', admin_chat_lines.lines)
		imgui.PopItemWidth()
		if imgui.Button(u8'���������.', btn_size) then
			saveAdminChat()
		end
		imgui.End()
	end
end


function instal_scripts_event()
  
        local dlstatus = require('moonloader').download_status
        local link_event = "https://raw.githubusercontent.com/Vrednaya1234/Scripts-SAMP/main/Events.lua"
        local downloadState = 'process'
        downloadUrlToFile(link_event, "moonloader/Events.lua", function(id3, status1, p13, p23)
		lua_thread.create(function()
		sampAddChatMessage(tag .. string.format("������������ %d �� %d", p13, p23))
        wait(900)
		wait(900)
		reloadScripts()
    end)
	end)
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function samp.onBulletSync(playerid, data)
	if traic then
		if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
			return true
		end
		BulletSync.lastId = BulletSync.lastId + 1
		if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
			BulletSync.lastId = 1
		end
		local id = BulletSync.lastId
		BulletSync[id].enable = true
		BulletSync[id].tType = data.targetType
		BulletSync[id].time = os.time() + 15
		BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
		BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
	end
end


-- [x] -- ���� �������. -- [x] --
function main()

if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end 
	
	showNotification("��������","���� �������� �������")
	wait(1000)
		if not checkServer(select(1, sampGetCurrentServerAddress())) then
		showNotification('������','������ �������� ������ �� ��������\nRussian Drift Server!')
		wait(3000)
		thisScript():unload()
	end
	wait(1000)
	showNotification("�����������","�������� ������ �������.\n������ ������� ��������.")
	_, player_id = sampGetPlayerIdByCharHandle(playerPed)
	player_nick = sampGetPlayerNickname(player_id)
	
	report_answer = "[A]" .. player_nick .. "[" .. player_id .. "] �������"

	kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr()) -- Kill List
	
	chatlogDirectory = getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog"
	if not doesDirectoryExist(chatlogDirectory) then
		createDirectory(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog")
	end
	
	if not doesDirectoryExist(getWorkingDirectory() .. "/config/AH_Setting") then
		createDirectory(getWorkingDirectory() .. "/config/AH_Setting")
	end
	if not doesDirectoryExist(getWorkingDirectory() .. "/config/AH_Setting/audio") then
		createDirectory(getWorkingDirectory() .. "/config/AH_Setting/audio")
	end
	
	sampRegisterChatCommand('ah_setting', function()
		i_setting_items.v = not i_setting_items.v
		imgui.Process = i_setting_items.v
	end)
	
sampRegisterChatCommand("ah_forma", function()
local fileForms = io.open(getGameDirectory().."//moonloader//config//AH_Setting//forms.txt","r+")
local delay = 500
lua_thread.create(function()
sampAddChatMessage(tag .. "�������� ����� �� ����� forms.txt")
wait(1000)
if fileForms then
    for line in fileForms:lines() do
        sampAddChatMessage(line, -1)
		wait(delay)
    end
	sampAddChatMessage(tag .. "������ ���� ���������")
end
end)
end)


fileForms = io.open(getGameDirectory().."//moonloader//config//AH_Setting//forms.txt","r+");
if fileForms == nil then 
      -- ������� ���� � ������ "������"
      fileForms = io.open(getGameDirectory().."//moonloader//config//AH_Setting//forms.txt","w"); 
	  sampAddChatMessage(tag .. "����������� ���� forms.txt, ������ ����.")
      -- ��������� ����
      fileForms:close();
   end;
   
	sampRegisterChatCommand("repository", function()
	i_info_update.v = not i_info_update.v
	imgui.Process = i_info_update.v
	end)
	
sampRegisterChatCommand("ah_stat", function()
stats_window_imgui.v = not stats_window_imgui.v
imgui.Process = stats_window_imgui.v
startime = os.time()
end)
showNotification("�������� ����������.", "���� ������� ����������!")
update()


	sampRegisterChatCommand('spplayers', function()
	lua_thread.create(function()
	sampAddChatMessage(tag .. '��������! �� ������������� ������ ���������� ' ..(sampGetPlayerCount(true) - 1).. ' ������(-��)?')
	sampAddChatMessage(tag .. '�������� ������ �������� � �������.')
	wait(700)
	sampShowDialog(1999, "{FFFFFF}�������� ��������.", string.format("{FFFFFF}1 - ���������� ������\n2 - �������� ��������"), "�������", "������", 2)
	end)
	end)
	
	sampRegisterChatCommand('ah_online', function()
	lua_thread.create(function()
	sampSendChat("/online")
		wait(200)
		local c = math.floor(sampGetPlayerCount(false) / 10)
		sampSendDialogResponse(1098, 1, c - 1)
		sampCloseCurrentDialogWithButton(0)
		wait(300)
		end)
	end)
	
	local file_read, c_line = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\Auto Mute\\mat.txt", "r"), 1
	local file_read_2, c_line_2 = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\Auto Mute\\osk.txt", "r"), 1
	if file_read ~= nil then
		file_read:seek("set", 0)
		for line in file_read:lines() do
			onscene[c_line] = line
			c_line = c_line + 1
		end
		file_read:close()
	end
	-- 2
	if file_read_2 ~= nil then
		file_read_2:seek("set", 0)
		for line_2 in file_read_2:lines() do
			onscene_2[c_line_2] = line_2
			c_line_2 = c_line_2 + 1
		end
		file_read_2:close()
	end
	
	sampRegisterChatCommand('save_mat', function(param)
		if param == nil then
			return false
		end
		for _, val in ipairs(onscene) do
			if string.rlower(param) == val then
				sampAddChatMessage(tag .. "����� \"" .. val .. "\" ��� ������������ � ������.")
				return false
			end
		end
		local file_write, c_line = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\Auto Mute\\mat.txt", "w"), 1
		onscene[#onscene + 1] = string.rlower(param)
		for _, val in ipairs(onscene) do
			file_write:write(val .. "\n")
		end
		file_write:close()
		sampAddChatMessage(tag .. "����� \"" .. string.rlower(param) .. "\" ������� ���������� � ������.")
	end)
	-- 2

	sampRegisterChatCommand('save_osk', function(param_2)
		if param_2 == nil then
			return false
		end
		for _, val_2 in ipairs(onscene_2) do
			if string.rlower(param_2) == val_2 then
				sampAddChatMessage(tag .. "����� \"" .. val_2 .. "\" ��� ������������ � ������.")
				return false
			end
		end
		
		local file_write_2, c_line_2 = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\Auto Mute\\osk.txt", "w"), 1
		onscene_2[#onscene_2 + 1] = string.rlower(param_2)
		for _, val_2 in ipairs(onscene_2) do
			file_write_2:write(val_2 .. "\n")
		end
		file_write_2:close()
		sampAddChatMessage(tag .. "����� \"" .. string.rlower(param_2) .. "\" ������� ���������� � ������.")
	end)

	

	sampRegisterChatCommand('del_mat', function(param)
		if param == nil then
			return false
		end
		local file_write, c_line = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\Auto Mute\\mat.txt", "w"), 1
		for i, val in ipairs(onscene) do
			if val == string.rlower(param) then
				onscene[i] = nil
				control_onscene = true
			else
				file_write:write(val .. "\n")
			end
		end
		file_write:close()
		if control_onscene then
			sampAddChatMessage(tag .. "����� \"" .. string.rlower(param) .. "\" ���� ������� ������� �� ������� ����.")
			control_onscene = false
		else
			sampAddChatMessage(tag .. "����� \"" .. string.rlower(param) .. "\" ��� � ������ ����.")
		end
	end)
	-- 2
	
	sampRegisterChatCommand('minigun', function(param_minigun)
	sampSendChat('/setweap ' .. param_minigun .. ' 38 5000')
	sampSendChat('/setweap ' .. param_minigun .. ' 38 5000')
	end)
	

	sampRegisterChatCommand('fld_report', function()
	lua_thread.create(function()
	for i=1, 3 do
	sampSendChat('/a �������� �� ������! /ans')
	wait(3000)
	end
	end)
	end)
	
	act = 0

	sampRegisterChatCommand('del_osk', function(param_2)
		if param_2 == nil then
			return false
		end
		local file_write_2, c_line_2 = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\Auto Mute\\osk.txt", "w"), 1
		for i_2, val_2 in ipairs(onscene_2) do
			if val_2 == string.rlower(param_2) then
				onscene_2[j_2] = nil
				control_onscene_2 = true
			else
				file_write_2:write(val_2 .. "\n")
			end
		end
		file_write_2:close()
		if control_onscene_2 then
			sampAddChatMessage(tag .. "����� \"" .. string.rlower(param_2) .. "\" ���� ������� ������� �� ������� ����.")
			control_onscene_2 = false
		else
			sampAddChatMessage(tag .. "����� \"" .. string.rlower(param_2) .. "\" ��� � ������ ����.")
		end
	end)

	sampRegisterChatCommand('cfind', function(param)
		if param == nil then
			i_chat_logger.v = not i_chat_logger.v
			imgui.Process = true
			chat_logger_text = readChatlog()
		else
			i_chat_logger.v = not i_chat_logger.v
			imgui.Process = true
			chat_find.v = param
			chat_logger_text = readChatlog()
		end
		load_chat_log:run()
	end)

	sampRegisterChatCommand("plate", function(x)
			local id = string.match(x, '(%d+)')
			if id ~= nil then
				sampAddChatMessage(getPlate(id), -1)
			else
				sampAddChatMessage("Invalid id", -1)
			end
		end)
		
	local color_prefix_button = "{AFEEEE}"
	sampRegisterChatCommand('aprefix', function(prf_id)
	prefix_id = prf_id
	sampShowDialog(9999, "{FFFFFF}�������� �������.", string.format(color_prefix_button ..'������\n' .. color_prefix_button .. '��.�������������\n '  .. color_prefix_button .. '�������������\n '  .. color_prefix_button ..  '��.�������������\n '  .. color_prefix_button .. '���\n '  .. color_prefix_button .. '���'), "�������", "������", 2)

	end)
	

	config = inicfg.load(defTable, directIni)
	setting_items.Fast_ans.v = config.setting.Fast_ans
	setting_items.Punishments.v = config.setting.Punishments
	setting_items.Admin_chat.v = config.setting.Admin_chat
	setting_items.Custom_SB.v = config.setting.Custom_SB
	setting_items.Transparency.v = config.setting.Tranparency
	setting_items.WallHack.v = config.setting.WallHack
	setting_items.Auto_remenu.v = config.setting.Auto_remenu
	setting_items.Push_Report.v = config.setting.Push_Report
	setting_items.Chat_Logger.v = config.setting.Chat_Logger
	setting_items.Chat_Logger_osk.v = config.setting.Chat_Logger_osk
	setting_items.hide_td.v = config.setting.hide_td
	setting_items.skip_dialogs.v = config.setting.skip_dialogs
	setting_items.anti_cheat.v = config.setting.anti_cheat
	setting_items.auto_report.v = config.setting.auto_report
	setting_items.sp_autologin.v = config.setting.sp_autologin
	
	HelloAC.v = config.setting.HelloAC
	AdminPassword.v = config.setting.AdminPassword
	admlvl.v = config.setting.admlvl
    report_all = config.setting.report_all
	report_day = config.setting.report_day
	
	prefix_Helper.v = config.setting.prefix_Helper
	prefix_Adm.v = config.setting.prefix_Adm
	prefix_MA.v = config.setting.prefix_MA
	prefix_StAdm.v = config.setting.prefix_StAdm
	prefix_Zga.v = config.setting.prefix_Zga
	prefix_PGA.v = config.setting.prefix_PGA


	color.v[1] = config.color.r
	color.v[2] = config.color.g
	color.v[3] = config.color.b
	color.v[4] = config.color.a
	index_text_pos = config.setting.Y

	font_ac = renderCreateFont("Arial", config.setting.Font, font_admin_chat.BOLD + font_admin_chat.SHADOW)
	font_watermark = renderCreateFont("Arial", 10, font_admin_chat.BOLD)
	admin_chat = lua_thread.create_suspended(drawAdminChat)
	check_dialog_active = lua_thread.create_suspended(checkIsDialogActive)
	draw_re_menu = lua_thread.create_suspended(drawRePlayerInfo)
	check_updates = lua_thread.create_suspended(sampCheckUpdateScript)
	load_chat_log = lua_thread.create_suspended(loadChatLog)
	load_info_player = lua_thread.create_suspended(loadPlayerInfo)
	wallhack = lua_thread.create(drawWallhack)
	lua_thread.create(time)
    time = 0
	wait_reload = lua_thread.create_suspended(function()
		wait(3000)
		showNotification("����������!", "���������� ������� ���������!")
		thisScript():reload()
	end)
	
	check_cmd = lua_thread.create_suspended(function()
		wait(1000)
		check_cmd_re = false
	end)
	local an_tag = '{EAC60D}�������:'
	local wont_tag = "{0777A3}[AH by Yamada.]: {FFFFFF}"


	lua_thread.create(function()
		while true do
			renderFontDrawText(font_watermark, wont_tag .. "{FFFFFF}v." .. script_version_text .. " {FFFFFF}| " .. player_nick .. "[" .. player_id .. "] | �����: " ..os.date("%H:%M:%S"), 20, sh-20, 0xCCFFFFFF)
			
			if setting_items.anti_cheat.v then 
			renderFontDrawText(font_watermark, an_tag.. '\n' ..ac_string, 20, sh-350, 0xCCFFFFFF)
			end
			
				if wasKeyPressed(88) and not sampIsChatInputActive() and not sampIsDialogActive() then
	   		activation = not activation
			end
		
			wait(1)
		end
	end)



	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstat.STATUS_ENDDOWNLOADDATA then
			check_updates:run()
			--showNotification("�������� ����������.", "���� ������� ����������!")
			
		end
	end)
	
	


	loadAdminChat()
	admin_chat:run()

	logo_image = imgui.CreateTextureFromFile(getWorkingDirectory() .. "\\config\\AH_Setting\\1.png")
	
	while true do
	local oTime = os.time()
		if traic then
			for i = 1, BulletSync.maxLines do
				if BulletSync[i].enable == true and oTime <= BulletSync[i].time then
					local o, t = BulletSync[i].o, BulletSync[i].t
					if isPointOnScreen(o.x, o.y, o.z) and
						isPointOnScreen(t.x, t.y, t.z) then
						local sx, sy = convert3DCoordsToScreen(o.x, o.y, o.z)
						local fx, fy = convert3DCoordsToScreen(t.x, t.y, t.z)
						renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFF0000)
						renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
					end
				end
			end
		end


		local result, button, list, input = sampHasDialogRespond(1999)
		if result then
				if button == 1 then
				if list == 0 then
				sampAddChatMessage(tag .. '�������� ����� ������.')
				local playerid_to_stream = playersToStreamZone()
				lua_thread.create(function()
				wait(500)        
				for _, v in pairs(playerid_to_stream) do
				sampSendChat('/aspawn ' .. v)
				end
				end)
				end
				if list == 1 then
				sampAddChatMessage(tag .. '�� �������� ��������.')
				
				end
		
				end
				end
				-- test
		local result, button, list, input = sampHasDialogRespond(9999)
		if result then
		if button == 1 then
		local test = "{"
		local test2 = "}"
		if list == 0 then
		sampSendChat('/prefix ' .. prefix_id .. ' ������ ' .. prefix_Helper.v .. '')
		showNotification('�����������', '�� ������� ������\n �������������� �������' .. test ..''..prefix_Helper.v ..''.. test2 .. " ������.")
		end
			if list == 1 then
		sampSendChat('/prefix ' .. prefix_id .. ' ��.�������������. ' .. prefix_MA.v .. '')
		showNotification('�����������', '�� ������� ������\n �������������� �������\n' .. test ..''..prefix_MA.v ..''.. test2 ..  "��.�������������.")
		end
			if list == 2 then
		sampSendChat('/prefix ' .. prefix_id .. ' �������������. ' .. prefix_Adm.v .. '')
			showNotification('�����������', '�� ������� ������\n �������������� �������\n' .. test ..''..prefix_Adm.v ..''.. test2 ..  "�������������.")
		end
			if list == 3 then
		sampSendChat('/prefix ' .. prefix_id .. ' ��.�������������. ' .. prefix_StAdm.v .. '')
			showNotification('�����������', '�� ������� ������\n �������������� �������\n' .. test ..''..prefix_StAdm.v ..''.. test2 ..  "��.�������������.")
		end
			if list == 4 then
		sampSendChat('/prefix ' .. prefix_id .. ' ���.����.��������������. ' .. prefix_Zga.v .. '')
			showNotification('�����������', '�� ������� ������\n �������������� �������\n' .. test ..''..prefix_Zga.v ..''.. test2 .. "���.����.��������������.")
		end
			if list == 5 then
		sampSendChat('/prefix ' .. prefix_id .. ' ��������.����.��������������. ' .. prefix_PGA.v .. '')
			showNotification('�����������', '�� ������� ������\n �������������� �������\n' .. test ..''..prefix_PGA.v ..''.. test2 ..  "��������.����.��������������.")
		end
		
		end
		end

		if isKeysDown(strToIdKeys(config.keys.Setting)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			i_setting_items.v = not i_setting_items.v
			imgui.Process = true
		end
		
		-- online
		if isKeysDown(strToIdKeys(config.keys.online)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			sampSendChat("/online")
		wait(100)
		local c = math.floor(sampGetPlayerCount(false) / 10)
		sampSendDialogResponse(1098, 1, c - 1)
		sampCloseCurrentDialogWithButton(0)
		wait(650)
		end
		-- wh
		if isKeysDown(strToIdKeys(config.keys.wh)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
		local test1 = '{'
		local test2 = "}"
		local wh_text_color_on = '37FF00'
		local wh_text_color_off = 'FF0000'
			if control_wallhack then
						nameTagOff()
						control_wallhack = false
						showNotification('�����������', 'WallHack ������� ' .. test1 .. '' .. wh_text_color_off .. '' .. test2 .. '��������.')
					else
						nameTagOn()
						control_wallhack = true
						showNotification('�����������', 'WallHack ������� ' .. test1 .. '' .. wh_text_color_on .. '' .. test2 .. '�������.')
					end
		end
		-- tracer
		if isKeysDown(strToIdKeys(config.keys.trc)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
		local test1 = '{'
		local test2 = "}"
		local trc_text_color_on = '37FF00'
		local trc_text_color_off = 'FF0000'
			if traic then
			traic = false
			showNotification('�����������', 'Tracers ������� ' .. test1 .. '' .. trc_text_color_off .. '' .. test2 .. '���������.')
			else
			traic = true
		showNotification('�����������', 'Tracers ������� ' .. test1 .. '' .. trc_text_color_on .. '' .. test2 .. '��������.')
			end
		end
		if isKeyDown(VK_Q)  and setting_items.hide_td.v and not sampIsChatInputActive() and not sampIsDialogActive() then
		sampSendChat('/reoff')
		end
		
		if isKeyDown(VK_R)  and setting_items.hide_td.v and not sampIsChatInputActive() and not sampIsDialogActive() then
		sampSendClickTextdraw(48)
		end
		
		if control_recon and recon_to_player then
			if control_info_load then
				control_info_load = false
				load_info_player:run()
				i_re_menu.v = true
				imgui.Process = true
				jail_or_ban_re = 0
			end
		else
			i_re_menu.v = false
		end
		if isKeyJustPressed(0x09) and setting_items.Custom_SB.v then
			sc_board.ActivetedScoreboard()
		end
		if isKeysDown(strToIdKeys(config.keys.Hide_AChat)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			setting_items.Admin_chat.v = not setting_items.Admin_chat.v
		end
		if not i_admin_chat_setting.v and
		not i_setting_items.v and
		not i_ans_window.v and
		not i_info_update.v and
		not i_re_menu.v and
		not i_cmd_helper.v and
		not stats_window_imgui.v and
		not i_chat_logger.v then
			imgui.Process = false
			imgui.LockPlayer = false
		end

		if sampGetCurrentDialogId() == 2351 and setting_items.Fast_ans.v and sampIsDialogActive() then
			i_ans_window.v = true
			imgui.Process = true
		else
			i_ans_window.v = false
		end
		
		if sampGetCurrentDialogId() == 657 and setting_items.skip_dialogs.v and sampIsDialogActive() then
				sampSendDialogResponse(657, 1, 2)
		sampCloseCurrentDialogWithButton(1)
		end
		
		if sampGetCurrentDialogId() == 658 and setting_items.skip_dialogs.v and sampIsDialogActive() then
				sampSendDialogResponse(658, 1)
		sampCloseCurrentDialogWithButton(1)
		end
		
			if sampGetCurrentDialogId() == 1227 and AdminPassword.v and sampIsDialogActive() then
			sampSendDialogResponse(1227, 1, _, AdminPassword.v)
			sampCloseCurrentDialogWithButton(1227, 1)
		end
		
		
		if not i_re_menu.v then
			check_mouse = true
		end
		if isKeysDown(strToIdKeys(config.keys.P_Log)) and setting_items.Chat_Logger.v and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			i_info_update.v = not i_info_update.v
			imgui.Process = true
		end
		if isKeyJustPressed(VK_RBUTTON) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) and control_recon and recon_to_player then
			check_mouse = not check_mouse
		end
		if isKeysDown(strToIdKeys(config.keys.Re_menu)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) and control_recon and recon_to_player then
			right_re_menu = not right_re_menu
		end
		if isKeysDown(strToIdKeys(config.keys.Hello)) and (sampIsDialogActive() == false) then
			sampSendChat("/a " .. u8:decode(HelloAC.v))
		end
		if not sampIsPlayerConnected(control_recon_playerid) then
			i_re_menu.v = false
			control_recon_playerid = -1
		end
		if sampIsChatInputActive() then
			if sampGetChatInputText():find("-") == 1 then
				i_cmd_helper.v = true
				imgui.Process = true
				if sampGetChatInputText():match("-(.+)") ~= nil then
					check_cmd_punis = sampGetChatInputText():match("-(.+)")
				else
					check_cmd_punis = nil
				end
			else
				i_cmd_helper.v = false
			end
		else
			i_cmd_helper.v = false
		end

		if ac_no_saved.pos then
			if isKeyJustPressed(VK_RBUTTON) then
				admin_chat_lines.X = ac_no_saved.X
				admin_chat_lines.Y = ac_no_saved.Y
				ac_no_saved.pos = false
				i_setting_items.v = true
			elseif isKeyJustPressed(VK_LBUTTON) then
				ac_no_saved.pos = false
				i_setting_items.v = true
			else
				admin_chat_lines.X, admin_chat_lines.Y = getCursorPos()
			end
		end
		wait(0)
	end

end

function samp.onPlayerDeathNotification(killerId, killedId, reason)
	local kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)

	local n_killer = ( sampIsPlayerConnected(killerId) or killerId == myid ) and sampGetPlayerNickname(killerId) or nil
	local n_killed = ( sampIsPlayerConnected(killedId) or killedId == myid ) and sampGetPlayerNickname(killedId) or nil
	lua_thread.create(function()
		wait(0)
		if n_killer then kill.killEntry[4].szKiller = ffi.new('char[25]', ( n_killer .. '[' .. killerId .. ']' ):sub(1, 24) ) end
		if n_killed then kill.killEntry[4].szVictim = ffi.new('char[25]', ( n_killed .. '[' .. killedId .. ']' ):sub(1, 24) ) end
	end)
end

function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end


local dlstatus = require('moonloader').download_status
function update()

  local fpath = os.getenv('TEMP') .. '\\testing_version.json' 
  downloadUrlToFile('https://raw.githubusercontent.com/Vrednaya1234/ah_bred/main/update.json', fpath, function(id, status, p1, p2) 
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') 
    if f then
      local info = decodeJson(f:read('*a')) 
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) 
        if version > tonumber(thisScript().version) then 
          lua_thread.create(goupdate) 
        else 
          update = false 
          sampAddChatMessage(tag ..'� ��� � ��� ��������� ������ �������! ������� ����������.')
        end
      end
    end
  end
end)
end

function goupdate()
sampAddChatMessage(tag ..'���������� ����� ����������')
sampAddChatMessage(tag ..'������� ������: '..thisScript().version.." ����� ������: "..version)
wait(3000)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  wait(3000)
  sampAddChatMessage(tag ..'���������� ���������!')
  sampAddChatMessage(tag ..'����������� � ��� ����� � ������ �������')
  wait(4000)
  thisScript():reload()
end
end)
end

