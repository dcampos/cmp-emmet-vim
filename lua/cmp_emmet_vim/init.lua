local cmp = require('cmp')
local fn = vim.fn

local source = {}

local function get_file_type()
    local ok, parser = pcall(vim.treesitter.get_parser)
    if not ok then
        return fn['emmet#getFileType']()
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    local range_parser = parser:language_for_range({ cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] })
    local lang = range_parser:lang()
    if lang == 'html' then
        local ts_utils = require('nvim-treesitter.ts_utils')
        local node = ts_utils.get_node_at_cursor()
        if node and node:type() == 'style_element' then
            return 'css'
        end
    end
    return lang
end

local function get_last_word()
    local current_word = fn.matchstr(fn.getline('.'), '\\S\\+\\%.c')
    return current_word
end

local function emmet_complete()
    local last_word = get_last_word()
    local type = get_file_type()
    local ok1, tree = pcall(fn['emmet#parseIntoTree'], last_word, type)
    if not ok1 then
        return
    end
    local tree_view = tree.child[1]
    local indentation = fn['emmet#getIndentation'](type)
    local ok2, string_view = pcall(fn['emmet#toString'], tree_view, type, 0, { type }, 0, indentation)
    return ok2 and string_view or nil
end

local function build_snippet(text)
    local n = 0
    local snippet = text:gsub('%$%{([^}]+)%}', function(placeholder)
        n = n + 1
        if placeholder == 'cursor' then
            return '$' .. n
        elseif vim.startswith(placeholder, 'lorem') then
            local lorem = fn['emmet#lorem#en#expand'](placeholder)
            return string.format('${%d:%s}', n, lorem)
        else
            return string.format('${%d:%s}', n, placeholder)
        end
    end)
    -- Remove trailing empty line
    snippet = snippet:gsub('\n+$', '')
    return snippet
end

source.new = function()
    return setmetatable({}, { __index = source })
end

function source:is_available()
    return vim.tbl_contains(
        { 'html', 'xml', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
        get_file_type()
    )
end

source.get_keyword_pattern = function()
    return '.'
end

function source:get_debug_name()
    return 'emmet-vim'
end

function source:complete(request, callback)
    local word = get_last_word()

    if not word or word == '' then
        return
    end

    local text = emmet_complete()

    if not text then
        return
    end

    local results = {}

    local cursor = request.context.cursor

    local range = {
        ['start'] = { line = cursor.line, character = cursor.col - #word - 1 },
        ['end'] = { line = cursor.line, character = cursor.col + #word - 1 },
    }

    local cmp_item = {
        word = word,
        label = word,
        kind = cmp.lsp.CompletionItemKind.Snippet,
        insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
        textEdit = {
            newText = build_snippet(text),
            insert = range,
            replace = range,
        },
    }
    table.insert(results, cmp_item)

    callback(results)
end

function source:resolve(completion_item, callback)
    local documentation = {}
    local repr = completion_item.textEdit.newText
    local lines = vim.split(repr, '\n', true)

    table.insert(documentation, '```' .. vim.bo.ft)
    for _, line in ipairs(lines) do
        table.insert(documentation, line)
    end
    table.insert(documentation, '```')

    completion_item.documentation = {
        kind = cmp.lsp.MarkupKind.Markdown,
        value = table.concat(documentation, '\n'),
    }

    callback(completion_item)
end

return source