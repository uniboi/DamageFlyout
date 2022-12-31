untyped

global function InitElaborateDamageFlyout
global function AddElaborateDamageFlyout

global struct flyoutPackage {
	var rui
	entity victim
	float damage
	float damageTime
}

global flyoutPackage& lastFlyout

/*
struct tokenRecompileData {
	string key
	int index
	string raw_token
}
*/

struct {
	flyoutPackage& last
	table macro_tokens = {
		elab_title_macro_tokens = null
		elab_desc_macro_tokens = null
	}
	string current_title_macro
	string current_desc_macro
	float summedDamage
	// array<tokenRecompileData&> recompileData
} file

void function InitElaborateDamageFlyout()
{
	thread RefreshTokensThread()
}

void function RefreshTokensThread()
{
	while (true) {
		string new_title_macro = GetConVarString("elab_title_macro")
		if( file.current_title_macro != new_title_macro )
			file.macro_tokens.elab_title_macro_tokens = GetTokensFromString(new_title_macro, "elab_title_macro_tokens")
		string new_desc_macro = GetConVarString("elab_desc_macro")
		if( file.current_desc_macro != new_desc_macro )
			file.macro_tokens.elab_desc_macro_tokens = GetTokensFromString(new_desc_macro, "elab_desc_macro_tokens")
		wait 5
	}
}

array<var> function GetTokensFromString( string tokenStr, string recompile_key )
{
	array<var> result_tokens
	array<string> tokens = split(tokenStr, "$")

	foreach( string token in tokens ) {
		int[2] par
		var t = token.find("{")
		par[0] = type(t) == "int" ? expect int( t ) : -1
		// t = token.find("}")
		t = FindLastIndex(token, '}')
		par[1] = type(t) == "int" ? expect int( t ) : -1
		if(par[0] == 0 && par[1] > 0)
		{
			string[2] subtokens
			subtokens[0] = token.slice( par[0] + 1, par[1] )
			subtokens[1] = par[1] + 1 > token.len() ? "" : token.slice( par[1] + 1)
			if( subtokens[0].len() )
			{
				result_tokens.append(compilestring(subtokens[0]))

				/*
				tokenRecompileData newData
				newData.key = recompile_key
				newData.index = result_tokens.len() - 1
				newData.raw_token = subtokens[0]
				file.recompileData.append( newData )
				*/
			}
			result_tokens.append(subtokens[1])
		}
		else
		{
			result_tokens.append(token)
		}
	}
	return result_tokens
}

void function AddElaborateDamageFlyout( float damage, vector damagePosition, entity victim, bool isCrit, bool isIneffective )
{
	/*
	if( GetConVarBool( "elab_recompile" ) )
		RecompileTokens()
	*/
	if( lastFlyout.victim == victim )
		file.summedDamage += damage
	else
		file.summedDamage = 0

	// printt("KILLME", file.killme)
	// printt("ADDING", lastFlyout.summedDamage)

	if( lastFlyout.rui )
		RuiDestroyIfAlive( lastFlyout.rui )

	var flyoutRUI

	if( GetConVarBool( "elab_use_compact" ) )
		flyoutRUI = CreateCompactRui( damage, damagePosition, victim, isCrit, isIneffective, file.summedDamage )
	else
		flyoutRUI = CreateDetailedRui( damage, damagePosition, victim, isCrit, isIneffective, file.summedDamage )

	flyoutPackage current
	current.rui = flyoutRUI
	current.victim = victim
	current.damage = damage
	current.damageTime = Time()

	lastFlyout = current
}

/*
void function RecompileTokens()
{
	foreach( data in file.recompileData )
	{
		file.macro_tokens[data.key][data.index] = compilestring(data.raw_token)
	}
}
*/

var function CreateCompactRui( float damage, vector damagePosition, entity victim, bool isCrit, bool isIneffective, float summedDamage )
{
    var rui = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0)
    RuiSetString(rui, "msgText", StitchContent( file.macro_tokens.elab_title_macro_tokens ) + "\n" + StitchContent( file.macro_tokens.elab_desc_macro_tokens ) )
    RuiSetInt(rui, "lineNum", 1)
    RuiSetFloat(rui, "msgFontSize", GetConVarFloat("elab_compact_size"))
    RuiSetFloat(rui, "msgAlpha", 1)
    RuiSetFloat(rui, "thicken", 0)
    RuiSetFloat3(rui, "msgColor", GetConVarFloat3("elab_compact_color"))
	RuiSetFloat2(rui, "msgPos", GetConVarFloat3("elab_compact_pos") )

	thread DestroyDelayedThread( rui )

    return rui
}

var function CreateDetailedRui( float damage, vector damagePosition, entity victim, bool isCrit, bool isIneffective, float summedDamage )
{
	var flyoutRUI = RuiCreate( $"ui/weapon_flyout.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	RuiSetGameTime( flyoutRUI, "startTime", Time() - 0.5 )
	RuiTrackFloat3( flyoutRUI, "pos", victim, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetString( flyoutRUI, "titleText", StitchContent( file.macro_tokens.elab_title_macro_tokens ) )
	RuiSetString( flyoutRUI, "descriptionText", StitchContent( file.macro_tokens.elab_desc_macro_tokens ) )
	RuiSetResolutionToScreenSize( flyoutRUI )

	return flyoutRUI
}

string function StitchContent( var tokens ) {
	string s = ""
	foreach( token in tokens ) {
		if( type( token ) == "string" )
			s += expect string( token )
		else
			s += expect string( token() )
	}
	return s
}

void function DestroyDelayedThread( var rui)
{
	wait 3
	RuiDestroyIfAlive( rui )
}

vector function GetConVarFloat3(string convar){
    array<string> value = split(GetConVarString(convar), " ")
    try{
        return Vector(value[0].tofloat(), value[1].tofloat(), value[2].tofloat())
    }
    catch(ex){
        throw "Invalid convar " + convar + "! make sure it is a float3 and formatted as \"X Y Z\""
    }
    unreachable
}

int function FindLastIndex( string str, int char)
{
	int index = -1
	for( int i = 0; i < str.len(); i++ )
	{
		if( str[i] == char )
			index = i
	}
	return index
}