```markdown
# Auto-LaTeX Document Engine

A fully automated pipeline that converts standard text, Markdown, and HTML notes into beautifully typeset PDFs. Built for computational physics and academic workflows, this engine features a native Python execution environment for inline numerical simulations, alongside a universal Lua firewall that scrubs crashing web elements while perfectly preserving local images.

## ✨ Features
* **Multi-Format Compilation:** Instantly compile `.md`, `.txt`, `.htm`, and `.html` files into `.tex` and `.pdf` documents with a single command or drag-and-drop.
* **Native Python Execution:** Write Python code directly in your notes. The engine runs it in the background, captures your printed console output, and automatically injects Matplotlib graphs as high-quality PDFs.
* **Universal Web Firewall:** Save webpages as HTML or copy massive text blocks from the web. The Lua script silently vaporizes broken HTML tags, SVGs, and raw URLs before they can crash the LaTeX compiler.
* **Smart Cleanup:** Automatically sweeps intermediate build files (`.aux`, `.log`, `.out`) into a dedicated `bin/` directory, keeping your workspace completely clean.

---

## 🛠️ Step 1: System Requirements & Installation

To run this pipeline locally, you must install three core dependencies and ensure they are added to your system's `PATH`.

### A. LaTeX (TeX Live)
You need a LaTeX distribution that includes the **XeLaTeX** compiler and standard typesetting packages.
1. Download and install [TeX Live](https://tug.org/texlive/) (Recommended) or [MiKTeX](https://miktex.org/).
2. Ensure the installation path is added to your system's `PATH`.
3. Open your terminal or Command Prompt and install the specific packages required by the template:
   ```bash
   tlmgr install pgfplots bookmark environ placeins microtype unicode-math

```

### B. Pandoc

Pandoc acts as the conversion bridge between your raw text/HTML and the LaTeX compiler.

1. Download the latest installer from the [Pandoc GitHub Releases page](https://github.com/jgm/pandoc/releases?utm_source=gemini).
2. Run the installer and verify that the option to add Pandoc to your system `PATH` is checked.

### C. Python & Scientific Libraries

The pipeline executes embedded Python code to run simulations, print results, and generate plots natively.

1. Install [Python 3.x](https://www.python.org/downloads/?utm_source=gemini) and add it to your system `PATH`.
2. Open your terminal and install Matplotlib along with any computational libraries you use:
```bash
pip install matplotlib numpy scipy sympy pandas cupy

```



---

## 📂 Step 2: Repository Setup

Clone this repository or download the core files into a dedicated directory for your notes. The pipeline relies on three main files:

1. **`compile.bat`**: The execution script. It manages the pipeline, invokes Pandoc and XeLaTeX, and sweeps the garbage files.
2. **`custom-template.tex`**: The LaTeX skeleton. It formats the typography, loads required packages (including TikZ/pgfplots), and establishes a smart kill-switch to block unstable web SVGs.
3. **`fix-groups.lua`**: The Pandoc Lua engine. It acts as an absolute firewall that extracts your Python code, captures terminal printouts, generates PDF plots, and safely injects local images via a custom LaTeX backdoor.

---

## 🚀 Step 3: Usage Guide

### 1. Compiling a Document

You can write your notes in a standard `.txt` or `.md` file, or save an entire webpage as an `.html` / `.htm` file in the same directory as the script. There are two ways to compile:

**Method A: Command Line (Recommended)**
Open your terminal in the directory and run the batch script followed by your filename:

```cmd
.\compile.bat filename.extension

```

**Method B: Drag and Drop**
Simply drag and drop your `.md`, `.txt`, or `.html` file directly onto `compile.bat` in Windows File Explorer.

The generated PDF will appear instantly in the same folder.

### 2. Generating Python Plots & Printing Results

To run a computational script, wrap your code in a `python-run` block. The Lua engine will execute it automatically.

* **Printed Results:** Anything you `print()` in the script (like data arrays, variables, or text strings) is automatically captured and formatted as a clean code block in the final PDF.
* **Plots:** Matplotlib graphs are automatically saved and injected directly below the printed output. *Note: Do not include `plt.savefig()` manually; the engine handles it.*

```python
~~~python-run
import numpy as np

# Simulate a 1D state-space model or wave function
x = np.linspace(0, 10, 5)
y = np.sin(x)

# This array will be printed into the PDF
print("Calculated Sine Values:")
print(np.round(y, 3))

# This plot will be injected below the text
plt.plot(x, y)
~~~

```

### 3. Inserting Local Images

Because the Lua engine aggressively scrubs standard Markdown images (`![alt](url)`) to prevent compiler crashes from pasted web-clutter, you must insert local screenshots or diagrams using the raw LaTeX backdoor.

Place your image file in the same folder as your notes and paste this exact block:

```latex
\begin{figure}[H]
\centering
\realincludegraphics[width=0.85\textwidth]{your_image_name.png}
\caption{Your image caption goes here}
\end{figure}

```

---

## 📝 License & Author

Created by Abhik Biswas. Feel free to fork, modify, and adapt this pipeline for your own typesetting and computational workflows.

```

<FollowUp label="Repository Launch" query="Are you ready to initialize your local Git repository and push this to GitHub?"/>

```
