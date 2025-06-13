MiniDeps.add {
  source = 'williamboman/mason.nvim',
}

local PACKAGES= {
  -- LSP
  'bash-language-server',
  'css-lsp',
  'cssmodules-language-server',
  'css-variables-language-server',
  'dockerfile-language-server',
  'html-lsp',
  'json-lsp',
  'lua-language-server',
  'rust-analyzer',
  'typescript-language-server',
  'gopls',
  'zls',
  'clangd',
  -- DAP
  'codelldb',
  'delve',
  -- Format
  'black',
  'stylua',
  'gofmt',
  'gofumpt',
  'clang-format',
  'goimports',
  'golines',
  -- Lint
  'eslint_d',
  'editorconfig-checker',
  'golangci-lint',
  'pylint',
}

local function install(pack, version)
	local notifyOpts = { title = "Mason", icon = "", id = "mason.install" }

	local msg = version and ("[%s] updating to %s…"):format(pack.name, version)
		or ("[%s] installing…"):format(pack.name)
	vim.defer_fn(function()
		vim.notify(msg, nil, notifyOpts)
	end, 0)

	pack:once("install:success", function()
		local msg2 = ("[%s] %s"):format(pack.name, version and "updated." or "installed.")
		notifyOpts.icon = " "
		vim.defer_fn(function()
			vim.notify(msg2, nil, notifyOpts)
		end, 0)
	end)

	pack:once("install:failed", function()
		local error = "Failed to install [" .. pack.name .. "]"
		vim.defer_fn(function()
			vim.notify(error, vim.log.levels.ERROR, notifyOpts)
		end, 0)
	end)

	pack:install({ version = version })
end

local function syncPackages(ensurePacks)
	local masonReg = require("mason-registry")

	local function refreshCallback()
		-- Auto-install missing packages & auto-update installed ones
		vim.iter(ensurePacks):each(function(packName)
			-- Extract package name and pinned version if specified
			local name, pinnedVersion = packName:match("([^@]+)@?(.*)")
			if not masonReg.has_package(name) then
				return
			end
			local pack = masonReg.get_package(name)
			if pack:is_installed() then
				-- Only check for updates if no version was pinned
				if pinnedVersion == "" then
					pack:check_new_version(function(hasNewVersion, version)
						if not hasNewVersion then
							return
						end
						install(pack, version.latest_version)
					end)
				end
			else
				-- Install with pinned version if specified
				install(pack, pinnedVersion ~= "" and pinnedVersion or nil)
			end
		end)

		-- Auto-clean unused packages
		local installedPackages = masonReg.get_installed_package_names()
		vim.iter(installedPackages):each(function(packName)
			-- Check if installed package is in our ensure list (without version suffix)
			local isEnsured = vim.iter(ensurePacks):any(function(ensurePack)
				local name = ensurePack:match("([^@]+)")
				return name == packName
			end)

			if not isEnsured then
				masonReg.get_package(packName):uninstall()
				local msg = ("[%s] uninstalled."):format(packName)
				vim.defer_fn(function()
					vim.notify(msg, nil, { title = "Mason", icon = "󰅗" })
				end, 0)
			end
		end)
	end

	masonReg.refresh(refreshCallback)
end

---@diagnostic disable-next-line: missing-fields
require('mason').setup {
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
}

syncPackages(PACKAGES)
