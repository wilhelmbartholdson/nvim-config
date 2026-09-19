return {
	cmd = { "/opt/homebrew/bin/R", "--vanilla", "--no-echo", "-e", "languageserver::run()" },
	filetypes = { "r", "rmd" },
	root_markers = {
		"DESCRIPTION",
		"NAMESPACE",
		".Rbuildignore",
		".Rproj",
		".Rprofile",
		".Rhistory"
	},
	settings = { filetypes = { "r", "rmd" } }
}
