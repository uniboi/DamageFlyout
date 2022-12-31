globalize_all_functions

void function ElaborateDamageFlyoutAddModSettings()
{
	AddModTitle( "DamageFlyout" )

	AddModCategory( "General" )
	AddConVarSetting("elab_title_macro", "Flyout Title Macro", "string")
	AddConVarSetting("elab_desc_macro", "Flyout Description Macro", "string")
	// AddConVarSettingEnum("elab_recompile", "Recompile", "Odd.ElaborateDamageFlyout", ["No (Efficient)", "Yes (Storage?)"])
	AddConVarSettingEnum("elab_use_compact", "Type", ["Fancy", "Compact"])

	AddModCategory( "Compact Mode Settings" )
	AddConVarSetting("elab_compact_pos", "Compact Position", "vector")
	AddConVarSetting("elab_compact_color", "Compact Color", "vector")
	AddConVarSetting("elab_compact_size", "Compact Size", "int")
}