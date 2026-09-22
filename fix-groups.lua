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

        local output_blocks = { el } -- Keep original source code
        local generated_stuff = {}   -- Container for the graphs/prints
        
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

        -- Wrap the outputs in a special Div so we can delete it from the Text file later!
        local output_div = pandoc.Div(generated_stuff, pandoc.Attr("", {"py-auto-generated"}))
        table.insert(output_blocks, output_div)

        return output_blocks
    end
    
    return el
end

-- 3. Output the perfectly clean Text file (SAFELY)
function Pandoc(doc)
    -- Create a copy of the AST specifically for the text file
    -- We walk through and DELETE the Python graphs so they don't multiply!
    local text_doc = pandoc.walk_block(pandoc.Div(doc.blocks), {
        Div = function(div)
            if div.classes:includes("py-auto-generated") then
                return {} -- Vaporize the outputs from the .txt file!
            end
            return div
        end
    })

    local clean_text = pandoc.write(pandoc.Pandoc(text_doc.content, doc.meta), "markdown")
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
        print("SUCCESS: " .. input_filename .. " was cleaned and overwritten!")
    else
        print("ERROR writing to " .. input_filename .. ": " .. tostring(err))
    end
    
    -- Return the ORIGINAL doc (with the plots intact) to the PDF compiler!
    return doc
end

return {
    Str = Str, Math = Math, Image = Image, Figure = Figure, Link = Link,
    CodeBlock = CodeBlock, Pandoc = Pandoc
}
