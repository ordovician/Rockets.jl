using Documenter, Rockets

makedocs(
	sitename="Rockets.jl", 
	modules = [Rockets],						# module to look in for functions referenced in doc
	pages = Any[
		"Home" => "index.md",
		"assemble-rocket.md",
		"simulate-launches.md",
		"rocket-equations.md"
	],
	format = Documenter.HTML(prettyurls = false) # prettyurls = false allows us to jump to HTML files locally
)