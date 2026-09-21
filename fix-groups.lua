-- 1. Vaporize raw text strings that are just URLs, or contain group tags
function Str(el)
    local text = el.text or ""
    if text:match("\\begingroup") or text:match("\\endgroup") then return {} end
    if text:match("^http") then return {} end
    return el
end

-- 2. Vaporize raw HTML that tries to embed web content
function RawInline(el)
    local text = el.text or ""
    if text:match("begingroup") or text:match("endgroup") then return {} end
    if text:match("http") then return {} end
    return el
end

-- 3. Vaporize Math blocks containing group tags
function Math(el)
    local text = el.text or ""
    if text:match("begingroup") or text:match("endgroup") then return {} end
    return el
end

-- 4. Unconditionally vaporize all Markdown Images and Figures
function Image(el) return {} end
function Figure(el) return {} end

-- 5. Strip URLs from hyperlinks but KEEP the readable text (e.g., "Physics" stays)
function Link(el)
    return el.content
end

-- 6. Execute Python, capture printed output, and generate the PDF graph
local plot_counter = 0

function CodeBlock(el)
    if el.classes:includes("python-run") then
        plot_counter = plot_counter + 1
        local py_file = "auto_plot_" .. plot_counter .. ".py"
        local pdf_file = "auto_plot_" .. plot_counter .. ".pdf"

        local file = io.open(py_file, "w")
        file:write(el.text)
        file:write("\n\nimport matplotlib.pyplot as plt\n")
        file:write("plt.savefig('" .. pdf_file .. "', format='pdf', bbox_inches='tight')\n")
        file:close()

        -- Use io.popen to run Python AND capture any print() statements (Runs ONLY once)
        local handle = io.popen("python " .. py_file)
        local print_output = handle:read("*a")
        handle:close()

        local output_blocks = {}

        -- If Python printed anything (like an array), create a code block for it
        if print_output and print_output:match("%S") then
            print_output = print_output:gsub("%s+$", "") -- Clean up trailing blank lines
            table.insert(output_blocks, pandoc.CodeBlock(print_output))
        end

        -- Inject the PDF graph right below the printed text
        local tex_injection = '\n\\begin{figure}[H]\n\\centering\n\\realincludegraphics[width=0.85\\textwidth]{' .. pdf_file .. '}\n\\end{figure}\n'
        table.insert(output_blocks, pandoc.RawBlock('tex', tex_injection))

        -- Return both the text output and the graph to the document
        return output_blocks
    end
    return el
end