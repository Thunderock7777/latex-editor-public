-- ==========================================
-- PASS 1: FRESH NOTEBOOKLM TEXT PRE-PROCESSOR
-- ==========================================
local function PreProcessor(doc)
    local input_filename = PANDOC_STATE.input_files[1] 
    if not input_filename then return nil end
    
    local ext = input_filename:match("^.+(%..+)$")
    if ext ~= ".txt" and ext ~= ".md" then return nil end
    
    local file = io.open(input_filename, "r")
    if not file then return nil end
    local raw_text = file:read("*a")
    file:close()
    
    local changed = false
    
    -- Detect NotebookLM's specific math formatting
    if raw_text:match("\\%(") or raw_text:match("\\%[") or raw_text:match("\\%$") then
        -- 1. Fix NotebookLM's web-math brackets
        raw_text = raw_text:gsub("\\%(", "$")
        raw_text = raw_text:gsub("\\%)", "$")
        raw_text = raw_text:gsub("\\%[", "$$")
        raw_text = raw_text:gsub("\\%]", "$$")
        
        -- 2. Fix NotebookLM's escaped dollar signs (e.g., \$2a\$)
        raw_text = raw_text:gsub("\\%$", "$")
        
        changed = true
    end
    
    if changed then
        local out_file = io.open(input_filename, "w")
        out_file:write(raw_text)
        out_file:close()
        
        print("\n[AI Pre-Processor] Fresh NotebookLM math formatted! Rebuilding AST...\n")
        return pandoc.read(raw_text, "markdown")
    end
    
    return nil
end

-- ==========================================
-- PASS 2: THE MAIN PIPELINE
-- ==========================================

-- 1. Vaporize stray URLs and group tags
function Str(el)
    local text = el.text or ""
    if text:match("\\begingroup") or text:match("\\endgroup") or text:match("^http") then return {} end
    return el
end

function Math(el)
    local text = el.text or ""
    if text:match("begingroup") or text:match("endgroup") then return {} end
    return el
end

function Image(el) return {} end
function Figure(el) return {} end

function Link(el) return el.content end

-- 2. Handle both HTML extraction blocks and Python execution blocks
local plot_counter = 0

function CodeBlock(el)
    if el.classes:includes("htmlcode") then
        local doc = pandoc.read(el.text, "html")
        
        local math_cleaner = {
            Span = function(span)
                if span.classes:includes("mwe-math-mathml-inline") or span.classes:includes("mwe-math-mathml-a11y") then return {} end
                if span.classes:includes("mwe-math-element") then
                    local tex = nil
                    for _, inline in ipairs(span.content) do
                        if inline.t == "Image" then tex = pandoc.utils.stringify(inline.caption)
                        elseif inline.t == "Math" and not tex then tex = inline.text end
                    end
                    if tex then
                        tex = tex:gsub("^%s*\\%(", ""):gsub("\\%)%s*$", "")
                        return pandoc.Math("InlineMath", tex)
                    end
                    return {}
                end
                return span
            end,
            RawInline = function(raw)
                if raw.format == "html" then
                    local tex = raw.text:match('math/tex[^>]*>([^<]+)<')
                    if not tex then tex = raw.text:match('application/x%-tex">([^<]+)<') end
                    if tex then return pandoc.Math("InlineMath", tex) end
                    return {}
                end
                return raw
            end
        }
        return pandoc.walk_block(pandoc.Div(doc.blocks), math_cleaner).content
    end

    if el.classes:includes("python-run") then
        plot_counter = plot_counter + 1
        local py_file = "auto_plot_" .. plot_counter .. ".py"
        local pdf_file = "auto_plot_" .. plot_counter .. ".pdf"

        local safe_code = el.text:gsub("plt%.show%s*%(%s*%)", "")

        local file = io.open(py_file, "w")
        file:write(safe_code)
        file:write("\n\nimport matplotlib.pyplot as plt\n")
        file:write("plt.savefig('" .. pdf_file .. "', format='pdf', bbox_inches='tight')\n")
        file:close()

        local handle = io.popen("python " .. py_file .. " 2>&1")
        local print_output = handle:read("*a")
        handle:close()

        for i = 1, 2 do 
            local missing_module = print_output:match("ModuleNotFoundError: No module named '([^']+)'")
            if missing_module then
                print("\n[Auto-Installer] Missing module detected: " .. missing_module)
                os.execute("pip install " .. missing_module)
                handle = io.popen("python " .. py_file .. " 2>&1")
                print_output = handle:read("*a")
                handle:close()
            else break end
        end

        local output_blocks = { el } 
        local generated_stuff = {}   
        
        if print_output and print_output:match("%S") then
            print_output = print_output:gsub("%s+$", "") 
            table.insert(generated_stuff, pandoc.CodeBlock(print_output))
        end

        local check_pdf = io.open(pdf_file, "r")
        if check_pdf then
            check_pdf:close()
            local tex_injection = '\n\\begin{figure}[H]\n\\centering\n\\realincludegraphics[width=0.85\\textwidth]{' .. pdf_file .. '}\n\\end{figure}\n'
            table.insert(generated_stuff, pandoc.RawBlock('tex', tex_injection))
        else
            local error_msg = '\n\\textbf{\\color{red}Warning: Graph could not be generated. See traceback.}\n'
            table.insert(generated_stuff, pandoc.RawBlock('tex', error_msg))
        end

        local output_div = pandoc.Div(generated_stuff, pandoc.Attr("", {"py-auto-generated"}))
        table.insert(output_blocks, output_div)

        return output_blocks
    end
    
    return el
end

function RawBlock(el)
    if (el.format == "tex" or el.format == "latex") and el.text:match("python%-run") then
        local safe_text = el.text:gsub("\\begin{document}", ""):gsub("\\end{document}", "")
        local rescued_doc = pandoc.read(safe_text, "markdown")
        return pandoc.walk_block(pandoc.Div(rescued_doc.blocks), { CodeBlock = CodeBlock }).content
    end
    return el
end

-- 3. Output the perfectly clean Text file (SAFELY)
function Pandoc(doc)
    local text_doc = pandoc.walk_block(pandoc.Div(doc.blocks), {
        Div = function(div)
            if div.classes:includes("py-auto-generated") then
                return {} 
            end
            return div
        end
    })

    local clean_text = pandoc.write(pandoc.Pandoc(text_doc.content, doc.meta), "markdown")
    
    -- THE PANDOC SHIELD: Forbids Pandoc from vandalizing your fresh NotebookLM math
    clean_text = clean_text:gsub("```%s+python%-run", "```python-run")
    clean_text = clean_text:gsub("```%s+{%s*%.python%-run%s*}", "```python-run")
    clean_text = clean_text:gsub("`([^`]+)`{=tex}", "%1") -- Prevents {=tex} corruption
    clean_text = clean_text:gsub("\\%$", "$")             -- Stops Pandoc from escaping dollars
    clean_text = clean_text:gsub("\\%^", "^")             -- Stops Pandoc from escaping powers
    clean_text = clean_text:gsub("\\%|", "|")             -- Stops Pandoc from escaping bra-kets

    local input_filename = PANDOC_STATE.input_files[1] or "cleaned_notes.txt" 
    
    local ext = input_filename:match("^.+(%..+)$")
    if ext ~= ".txt" and ext ~= ".md" then
        print("SUCCESS: PDF generated! (Skipped self-cleaning to protect " .. tostring(ext) .. " file).")
        return doc
    end
    
    local file, err = io.open(input_filename, "w")
    if file then
        file:write(clean_text)
        file:close()
        print("SUCCESS: " .. input_filename .. " was cleaned and overwritten safely!")
    else
        print("ERROR writing to " .. input_filename .. ": " .. tostring(err))
    end
    
    return doc
end

return {
    { Pandoc = PreProcessor },
    {
        Str = Str, Math = Math, Image = Image, Figure = Figure, Link = Link,
        CodeBlock = CodeBlock, RawBlock = RawBlock, Pandoc = Pandoc
    }
}