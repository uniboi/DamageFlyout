globalize_all_functions

void function ElaborateDamageFlyoutAddModSettings()
{
	AddConVarSetting("elab_title_macro", "Flyout Title Macro", "Odd.ElaborateDamageFlyout", "string")
	AddConVarSetting("elab_desc_macro", "Flyout Description Macro", "Odd.ElaborateDamageFlyout", "string")
	// AddConVarSettingEnum("elab_recompile", "Recompile", "Odd.ElaborateDamageFlyout", ["No (Efficient)", "Yes (Storage?)"])
	AddConVarSettingEnum("elab_use_compact", "Type", "Odd.ElaborateDamageFlyout", ["Fancy", "Compact"])
	AddConVarSetting("elab_compact_pos", "Compact Position", "Odd.ElaborateDamageFlyout", "vector")
	AddConVarSetting("elab_compact_color", "Compact Color", "Odd.ElaborateDamageFlyout", "vector")
	AddConVarSetting("elab_compact_size", "Compact Size", "Odd.ElaborateDamageFlyout", "int")
}