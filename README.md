```markdown
# Auto-LaTeX Document Engine

A fully automated pipeline that converts standard text, Markdown, CSV, DOCX, and unstructured web HTML into beautifully typeset PDFs. Built primarily for frictionless AI workflows, computational physics, and academic research, this engine allows you to copy-paste messy AI responses, unstructured math equations, and Python code directly into a `.txt` file. The engine instantly cleans the input, executes the code, and generates a perfect PDF.

## 🌟 Salient Features

* **Frictionless AI & Web Math Extraction:** Copy complex math derivations directly from Wikipedia, physics blogs, or AI chatbots (like ChatGPT/Gemini). The engine natively unspools MathJax, KaTeX, and MediaWiki HTML, converting them into perfectly structured LaTeX equations.
* **Self-Cleaning `.txt` Notes:** When you paste ugly, unstructured HTML into a `.txt` or `.md` file, the pipeline doesn't just compile it—it permanently cleans it. Upon execution, the engine dynamically deletes the messy web code in your input file and overwrites it with pristine, raw LaTeX and Markdown.
* **Universal Document Routing:** Drag and drop `.csv` files to instantly generate beautifully formatted LaTeX tables, or drop a `.docx` Word document for immediate PDF conversion. Unrecognized formats are automatically detected and routed.
* **Native Python Execution:** Write Python code directly in your notes. The engine runs it in the background, captures your printed console output, and automatically injects Matplotlib graphs as high-quality PDFs.
* **Universal Web Firewall:** The Lua script silently vaporizes broken HTML tags, SVGs, and raw URLs before they can crash the LaTeX compiler, ensuring complete stability.

---

## 🔖 The "Copy HTML" Bookmarklet (Required Setup)

To extract math equations and AI responses without triggering compiler crashes from hidden web elements, you must use this surgical extraction bookmarklet.

1. Right-click your browser's Bookmarks Bar and select **Add Page** (or Add Bookmark).
2. Name it **Copy HTML**.
3. Paste this exact code into the **URL** box and save:

```javascript
javascript:(function(){var sel=window.getSelection();if(sel.rangeCount>0){var div=document.createElement('div');div.appendChild(sel.getRangeAt(0).cloneContents());navigator.clipboard.writeText(div.innerHTML).then(function(){alert('HTML Copied!');}).catch(function(){alert('Error copying HTML');});}else{alert('Select some text first!');}})();

```

**How to use it:** Highlight any AI response, Wikipedia equation, or web text. Instead of pressing `Ctrl+C`, click the **Copy HTML** bookmarklet.

---

## 🛠️ System Requirements & Installation

To run this pipeline locally, you must install three core dependencies and ensure they are added to your system's `PATH`.

### A. LaTeX (TeX Live)

1. Download and install [TeX Live](https://tug.org/texlive/?utm_source=gemini) (Recommended) or [MiKTeX](https://miktex.org/?utm_source=gemini).
2. Open your terminal or Command Prompt and install the specific packages required by the template:
```bash
tlmgr install pgfplots bookmark environ placeins microtype unicode-math

```



### B. Pandoc

1. Download the latest installer from the [Pandoc GitHub Releases page](https://github.com/jgm/pandoc/releases?utm_source=gemini).
2. Run the installer and verify that the option to add Pandoc to your system `PATH` is checked.

### C. Python & Scientific Libraries

1. Install [Python 3.x](https://www.python.org/downloads/?utm_source=gemini) and add it to your system `PATH`.
2. Open your terminal and install Matplotlib along with your computational libraries:
```bash
pip install matplotlib numpy scipy sympy pandas cupy

```



---

## 🚀 Usage Guide

### 1. Extracting AI Responses & Web Math (The `htmlcode` Block)

To perfectly capture unstructured math from the web or AI chats:

1. Highlight the text/math on the website and click your **Copy HTML** bookmarklet.
2. Open your `.txt` or `.md` notes file and paste the clipboard contents inside an `htmlcode` block:

```markdown
```htmlcode
<span class="mwe-math-element">...pasted messy html...</span>
```

```

3. Run the compiler. The Lua engine will safely extract the pure LaTeX, generate the PDF, and **automatically rewrite your `.txt` file** so the ugly HTML block is permanently replaced by clean text.

### 2. Compiling the Document

**Method A: Command Line (Recommended)**
Open your terminal in the directory and run the batch script followed by your filename:

```cmd
.\compile.bat filename.txt

```

**Method B: Drag and Drop**
Simply drag and drop your `.md`, `.txt`, `.csv`, or `.docx` file directly onto `compile.bat` in Windows File Explorer. The engine natively formats CSV data into LaTeX tables automatically.

### 3. Generating Python Plots & Printing Results

To run a computational script, wrap your code in a `python-run` block.

* **Printed Results:** Anything you `print()` in the script is automatically captured and formatted as a clean code block.
* **Plots:** Matplotlib graphs are automatically saved and injected directly below the printed output (no `plt.savefig()` needed).

```markdown
```python-run
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 10, 5)
y = np.sin(x)

print("Calculated Sine Values:")
print(np.round(y, 3))

plt.plot(x, y)
```

```

### 4. Inserting Local Images

Because the Lua engine aggressively scrubs standard Markdown images (`![alt](url)`) to prevent compiler crashes from pasted web clutter, you must insert local screenshots or diagrams using the raw LaTeX backdoor.

```latex
\begin{figure}[H]
\centering
\realincludegraphics[width=0.85\textwidth]{your_image_name.png}
\caption{Your image caption goes here}
\end{figure}

```

---

## 📝 License & Author

Created by Abhik Biswas with the help of Gemini. Feel free to fork, modify, and adapt this pipeline for your own AI workflows, typesetting, and computational projects.

```

<FollowUp label="Review README structure" query="Does this updated README perfectly capture the primary AI/math copy-paste workflow you envisioned, or is there any specific wording you'd like adjusted?"/>

```
