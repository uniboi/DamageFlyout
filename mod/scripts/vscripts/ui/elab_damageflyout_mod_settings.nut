globalize_all_functions

void function ElaborateDamageFlyoutAddModSettings()
{
	ModSettings_AddModTitle( "DamageFlyout" )

	ModSettings_AddModCategory( "General" )
	ModSettings_AddSetting("elab_title_macro", "Flyout Title Macro", "string")
	ModSettings_AddSetting("elab_desc_macro", "Flyout Description Macro", "string")
	// AddConVarSettingEnum("elab_recompile", "Recompile", "Odd.ElaborateDamageFlyout", ["No (Efficient)", "Yes (Storage?)"])
	ModSettings_AddEnumSetting("elab_use_compact", "Type", ["Fancy", "Compact"])

	ModSettings_AddModCategory( "Compact Mode Settings" )
	ModSettings_AddSetting("elab_compact_pos", "Compact Position", "vector")
	ModSettings_AddSetting("elab_compact_color", "Compact Color", "vector")
	ModSettings_AddSetting("elab_compact_size", "Compact Size", "int")
}