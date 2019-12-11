--[[
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();
local thisUtilVer = 1;
if(thisUtilVer <= (g0.UtilVer or 0)) then
	return;
end
g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Quest";

local gQst = g0.Quest;

function TPUTIL_QUEST_UPDATE(frame, msg, argStr, questID)
	g0.PCL(gQst.GetQuest);
end
function gQst.GetQuest()
	local clsList, cnt = GetClassList("QuestProgressCheck");
	gQst.LstWarp ={};
	local i = 0;
	for i = 0, cnt -1 do
		local questIES = GetClassByIndexFromList(clsList, i);
		local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
		if questIES.ClassName ~= "None" then
			local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
			if ((result == 'POSSIBLE' and questIES.POSSI_WARP == 'YES') or (result == 'PROGRESS' and questIES.PROG_WARP == 'YES') or (result == 'SUCCESS' and questIES.SUCC_WARP == 'YES')) then
				local questnpc_state = GET_QUEST_NPC_STATE(questIES, result);
				local mapProp	= geMapTable.GetMapProp(questIES[questnpc_state..'Map']);
				local npcProp	= mapProp:GetNPCPropByDialog(questIES[questnpc_state..'NPC']);
				if (npcProp ~= nil) then
					local qData ={};
					qData.mCName	= mapProp:GetClassName();
					local mClass	= GetClass("Map", qData.mCName);
					qData.mLv		= mClass.QuestLevel or 0;
					qData.mLv2		= (qData.mCName == "c_Klaipe" and 1) or (qData.mCName == "c_orsha" and 2) or (qData.mCName == "c_fedimian" and 3) or (qData.mCName == "c_nunnery" and 4) or 999;
					local mName		= mapProp:GetName();
					qData.mName		= dictionary.ReplaceDicIDInCompStr(mName);
					local nName		= npcProp:GetName();
					qData.nName		= dictionary.ReplaceDicIDInCompStr(nName);
					qData.nName		= qData.nName:gsub("{nl} *","");
					qData.qName		= questIES.Name;
					qData.qCName	= questIES.ClassName;
					qData.qCId		= questIES.ClassID;
					qData.qMode		= questIES.QuestMode;
					gQst.LstWarp[#gQst.LstWarp+1] = qData;
				end
			end
		end
	end
	table.sort(gQst.LstWarp,
		function(a,b)
			if (a==nil) then return true end
			if (b==nil) then return false end
			if (a.mLv<b.mLv) then return true end
			if (a.mLv>b.mLv) then return false end
			if (a.mLv2<b.mLv2) then return true end
			if (a.mLv2>b.mLv2) then return false end
			return (a.qCId<b.qCId);
		end
	);
	g0.Event("TPUTIL_QSTUPD");
end
