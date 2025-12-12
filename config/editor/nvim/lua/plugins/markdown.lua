return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
	ft = { "markdown" },
	config = function()
		-- Configuration optimisée pour WSL
		vim.g.mkdp_auto_start = 0
		vim.g.mkdp_auto_close = 1
		
		-- Utilise wslview pour ouvrir dans le navigateur Windows (recommandé)
		vim.g.mkdp_browser = 'wslview'
		
		-- Alternatives si wslview ne fonctionne pas :
		-- vim.g.mkdp_browser = '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'
		-- vim.g.mkdp_browser = '/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
		-- vim.g.mkdp_browser = '/mnt/c/Program Files/Mozilla Firefox/firefox.exe'
		
		-- Configuration réseau
		vim.g.mkdp_open_to_the_world = 1
		vim.g.mkdp_open_ip = '127.0.0.1'
		vim.g.mkdp_port = '8080'
		vim.g.mkdp_echo_preview_url = 1 -- Affiche l'URL dans Neovim
		
		-- Options de prévisualisation
		vim.g.mkdp_preview_options = {
			mkit = {},
			katex = {},
			uml = {},
			maid = {},
			disable_sync_scroll = 0,
			sync_scroll_type = 'middle',
			hide_yaml_meta = 1,
			content_editable = false,
			disable_filename = 0
		}
		
		-- Theme CSS personnalisé (optionnel)
		vim.g.mkdp_markdown_css = ''
		vim.g.mkdp_highlight_css = ''
		
		-- Page template personnalisée (optionnel)
		vim.g.mkdp_page_title = '「${name}」'
	end,
}
