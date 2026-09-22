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
    -- Safely parse pasted HTML web blocks
    if el.classes:includes("htmlcode") then
        local doc = pandoc.read(el.text, "html")
        
        local math_cleaner = {
            Span = function(span)
                if span.classes:includes("mwe-math-mathml-inline") or span.classes:includes("mwe-math-mathml-a11y") then
                    return {}
                end
                if span.classes:includes("mwe-math-element") then
                    local tex = nil
                    for _, inline in ipairs(span.content) do
                        if inline.t == "Image" then
                            tex = pandoc.utils.stringify(inline.caption)
                        elseif inline.t == "Math" and not tex then
                            tex = inline.text
                        end
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
        
        local cleaned_blocks = pandoc.walk_block(pandoc.Div(doc.blocks), math_cleaner).content
        return cleaned_blocks
    end

    -- Python execution and plot generation
    if el.classes:includes("python-run") then
        plot_counter = plot_counter + 1
        local py_file = "auto_plot_" .. plot_counter .. ".py"
        local pdf_file = "auto_plot_" .. plot_counter .. ".pdf"

        local file = io.open(py_file, "w")
        file:write(el.text)
        file:write("\n\nimport matplotlib.pyplot as plt\n")
        file:write("plt.savefig('" .. pdf_file .. "', format='pdf', bbox_inches='tight')\n")
        file:close()

        -- Execute Python and capture BOTH standard output and crash tracebacks (2>&1)
        local handle = io.popen("python " .. py_file .. " 2>&1")
        local print_output = handle:read("*a")
        handle:close()

        -- AUTO-INSTALLER: Check if it crashed because of a missing module
        for i = 1, 2 do -- Try max 2 times to prevent infinite loops
            local missing_module = print_output:match("ModuleNotFoundError: No module named '([^']+)'")
            if missing_module then
                print("\n[Auto-Installer] Missing module detected: " .. missing_module)
                print("[Auto-Installer] Attempting to download and install via pip...\n")
                
                -- Run pip install automatically
                os.execute("pip install " .. missing_module)
                
                -- Retry the Python script after installation
                handle = io.popen("python " .. py_file .. " 2>&1")
                print_output = handle:read("*a")
                handle:close()
            else
                break -- No missing modules, exit the retry loop
            end
        end

        -- SAFETY FIX 1: Keep the original Python code block
        local output_blocks = { el }
        
        -- Print whatever Python spit out (Results OR the Crash Traceback)
        if print_output and print_output:match("%S") then
            print_output = print_output:gsub("%s+$", "") 
            table.insert(output_blocks, pandoc.CodeBlock(print_output))
        end

        -- Check if the PDF graph was successfully created
        local check_pdf = io.open(pdf_file, "r")
        if check_pdf then
            check_pdf:close()
            local tex_injection = '\n\\begin{figure}[H]\n\\centering\n\\realincludegraphics[width=0.85\\textwidth]{' .. pdf_file .. '}\n\\end{figure}\n'
            table.insert(output_blocks, pandoc.RawBlock('tex', tex_injection))
        else
            -- If it failed, inject a warning instead of a broken image to protect the LaTeX compiler
            local error_msg = '\n\\textbf{\\color{red}Warning: Graph could not be generated. See Python traceback above.}\n'
            table.insert(output_blocks, pandoc.RawBlock('tex', error_msg))
        end

        return output_blocks
    end
    
    return el
end

-- 3. Output the perfectly clean Text file (SAFELY)
function Pandoc(doc)
    local clean_text = pandoc.write(doc, "markdown")
    
    -- Dynamically grab the input file name
    local input_filename = PANDOC_STATE.input_files[1] 
    
    -- Fallback just in case Pandoc is fed from standard input rather than a file
    if not input_filename then 
        input_filename = "cleaned_notes.txt" 
    end
    
    -- SAFETY FIX 2: Only allow self-cleaning on .txt and .md files. Protect CSV and DOCX!
    local ext = input_filename:match("^.+(%..+)$")
    if ext ~= ".txt" and ext ~= ".md" then
        print("SUCCESS: PDF generated! (Skipped self-cleaning to protect " .. tostring(ext) .. " file).")
        return doc
    end
    
    local file, err = io.open(input_filename, "w")
    if file then
        file:write(clean_text)
        file:close()
        print("SUCCESS: " .. input_filename .. " was cleaned and overwritten!")
    else
        print("ERROR writing to " .. input_filename .. ": " .. tostring(err))
    end
    
    return doc
end

-- 4. Explicitly return the filter table so Pandoc registers every function
return {
    Str = Str,
    Math = Math,
    Image = Image,
    Figure = Figure,
    Link = Link,
    CodeBlock = CodeBlock,
    Pandoc = Pandoc
}
