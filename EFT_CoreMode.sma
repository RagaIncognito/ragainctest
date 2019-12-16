/* ---------------------------------------------------------------------------- */
// |-- >>> PLUGIN, VERSION AND AUTHOR <<< --|
/* ---------------------------------------------------------------------------- */

#define PLUGIN "[Untitled] Soon"
#define VERSION "0.1"
#define AUTHOR "Soon"

/* ---------------------------------------------------------------------------- */
// |-- >>> LIB'S <<< --|
/* ---------------------------------------------------------------------------- */

#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>

/* ---------------------------------------------------------------------------- */
// |-- >>> MACROSE'S <<< --|
/* ---------------------------------------------------------------------------- */

// soon

/* ---------------------------------------------------------------------------- */
// |-- >>> COUNTER'S <<< --|
/* ---------------------------------------------------------------------------- */

enum
{
	TYPE_GET = 0,
	TYPE_SET, 
	TYPE_ADD, 
	TYPE_MIN
}

enum _: eData_User
{
	bool: u_Connected
}

/* ---------------------------------------------------------------------------- */
// |-- >>> VAR'S <<< --|
/* ---------------------------------------------------------------------------- */

new g_aUserData[ 33 ][ eData_User ];

new bool: g_bRoundType = false;

/* ---------------------------------------------------------------------------- */
// |-- >>> AMXMODX MAIN <<< --|
/* ---------------------------------------------------------------------------- */

public plugin_init()	{
	
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_clcmd("say /info", "info")
	
	register_event("HLTV", "NewRound", "a", "1=0", "2=0");
	
	RegisterHam(Ham_TraceAttack, "player", "fwd_Ham_BlockDamage");
	RegisterHam(Ham_Killed, "player", "fwd_Ham_Killed");
}

/* ---------------------------------------------------------------------------- */
// |-- >>> AMXMODX <<< --|
/* ---------------------------------------------------------------------------- */

public client_putinserver( pPlayer )	{
	
	RM_UserConnected( pPlayer, TYPE_SET, true );
}

public client_disconnected( pPlayer )	{
	
	RM_UserConnected( pPlayer, TYPE_SET, false );
}

/* ---------------------------------------------------------------------------- */
// |-- >>> GAME EVENT <<< --|
/* ---------------------------------------------------------------------------- */

public NewRound() {
	g_bRoundType = !g_bRoundType;
	
	if(!g_bRoundType)
		server_cmd("mp_roundtime 0.55");
	else
		server_cmd("mp_roundtime 8");
	
	client_print(0, print_chat, "[debug] Режим: %s", g_bRoundType ? "Лобби" : "Игровой раунд");
}

/* ---------------------------------------------------------------------------- */
// |-- >>> HAMSANDWICH <<< --|
/* ---------------------------------------------------------------------------- */

public fwd_Ham_BlockDamage() {
	if(!g_bRoundType)
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

public fwd_Ham_Killed(victim)
{
	client_print(0, print_chat, "[debug] Вы были убиты");
	
	if(g_bRoundType)
		set_task(2.0, "Player_Respawn", victim);
}

/* ---------------------------------------------------------------------------- */
// |-- >>> FUNCTION'S <<< --|
/* ---------------------------------------------------------------------------- */

public Player_Respawn(victim) {
	ExecuteHam(Ham_CS_RoundRespawn, victim);
	client_print(0, print_chat, "[debug] Вы возродились");
}

public info() {
	client_print(0, print_chat, "[debug] Режим: %s", g_bRoundType ? "Лобби" : "Игровой раунд");
}

/* ---------------------------------------------------------------------------- */
// |-- >>> STOCK'S <<< --|
/* ---------------------------------------------------------------------------- */

stock RM_UserConnected( pPlayer, iType = 0, bool: bParam = false )	{
	
	switch( iType )
	{
		case TYPE_GET: return g_aUserData[ pPlayer ][ u_Connected ];
		case TYPE_SET: g_aUserData[ pPlayer ][ u_Connected ] = bParam;
	}
	
	return true;
}

/* ---------------------------------------------------------------------------- */