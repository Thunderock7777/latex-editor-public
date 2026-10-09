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

**How to use it:** Highlight any webpage, drag and select, Wikipedia equation, or web text. Instead of pressing `Ctrl+C`, click the **Copy HTML** bookmarklet.
for AI responses you can directly copy paste using there provided option.For drag and select use the provided bookmark only

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

Because the Lua engine aggressively scrubs standard Markdown images (`![alt](url)`) to prevent compiler crashes from pasted web clutter, you must insert local screenshots or diagrams using the raw LaTeX backdoor.You can paste latex codes without any error problem without any protection.


\begin{figure}[H]
\centering
\realincludegraphics[width=0.85\textwidth]{your_image_name.png}
\caption{Your image caption goes here}
\end{figure}


---

## 📝 License & Author

Created by Abhik Biswas with the help of Gemini. Feel free to fork, modify, and adapt this pipeline for your own AI workflows, typesetting, and computational projects.

```

<FollowUp label="Review README structure" query="Does this updated README perfectly capture the primary AI/math copy-paste workflow you envisioned, or is there any specific wording you'd like adjusted?"/>

```
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

**How to use it:** Highlight any webpage, drag and select, Wikipedia equation, or web text. Instead of pressing `Ctrl+C`, click the **Copy HTML** bookmarklet.
for AI responses you can directly copy paste using there provided option.For drag and select use the provided bookmark only

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

Because the Lua engine aggressively scrubs standard Markdown images (`![alt](url)`) to prevent compiler crashes from pasted web clutter, you must insert local screenshots or diagrams using the raw LaTeX backdoor.You can paste latex codes without any error problem without any protection.


\begin{figure}[H]
\centering
\realincludegraphics[width=0.85\textwidth]{your_image_name.png}
\caption{Your image caption goes here}
\end{figure}


---

## 📝 License & Author

Created by Abhik Biswas with the help of Gemini. Feel free to fork, modify, and adapt this pipeline for your own AI workflows, typesetting, and computational projects.

```

<FollowUp label="Review README structure" query="Does this updated README perfectly capture the primary AI/math copy-paste workflow you envisioned, or is there any specific wording you'd like adjusted?"/>
```
"""Handwritten math/physics notes (PDF) -> LaTeX via Gemini, then compile + auto-patch.

Runs in Google Colab or as a normal script (needs XeLaTeX locally).

Key design points
- Page images are actually sent to the model (grayscale + autocontrast JPEG, high media resolution).
- Batches are transcribed in parallel, results cached per batch on disk -> re-running resumes automatically.
- Each batch is linted locally (brace / environment balance) and retried with feedback before compiling.
- One XeLaTeX pass in nonstop mode reports ALL errors; broken regions are patched in parallel.
- A slim preamble keeps compile times low.
"""
from __future__ import annotations

import os
import random
import re
import shutil
import subprocess
import sys
import time
from collections import Counter
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

# -------------------- Configuration --------------------
PDF_FILENAME = os.environ.get("PDF_FILENAME", "KC_SIR2.pdf")
MODEL = os.environ.get("GEMINI_MODEL", "gemini-3.5-flash-lite")  # swap for a stronger model if handwriting is very messy
PATCH_MODEL = MODEL

BATCH_SIZE = 2            # pages per request. Smaller = more accurate on messy handwriting, larger = fewer calls
MAX_WORKERS = 4           # parallel API requests (lower if you hit 429 rate limits)
RENDER_SCALE = 2.5        # PDF render scale (~180 dpi on A4). Raise to 3 for tiny handwriting
MAX_SIDE = 2400           # px cap on the longest image side
GRAYSCALE = True          # drops colour; set False if ink colour carries meaning (e.g. red corrections)
HIGH_RES_MEDIA = True     # ask Gemini to use its high media resolution for images
FORCE_RETRANSCRIBE = False  # True = ignore cached batches

TRANSCRIPTION_RETRIES = 4
PATCH_RETRIES = 3
MAX_PATCH_ITERATIONS = 5
PATCH_CONTEXT_LINES = 10

# -------------------- Dependencies --------------------
def ensure_python_package(package_name: str, import_name: str | None = None) -> None:
    try:
        __import__(import_name or package_name)
    except ImportError:
        print(f"Installing {package_name} ...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", package_name])


ensure_python_package("pypdfium2")
ensure_python_package("pillow", "PIL")
ensure_python_package("tqdm")
ensure_python_package("google-genai", "google.genai")

import io

import pypdfium2 as pdfium
from PIL import ImageOps
from tqdm.auto import tqdm
from google import genai
from google.genai import types

try:
    from google.colab import userdata, files  # type: ignore
    IN_COLAB = True
except ImportError:
    userdata = files = None
    IN_COLAB = False

# -------------------- Paths --------------------
pdf_path = Path(PDF_FILENAME)
base_name = pdf_path.stem
tex_path = Path(f"{base_name}.tex")
log_path = Path(f"{base_name}.log")
pdf_output_path = Path(f"{base_name}.pdf")
cache_dir = Path(f"{base_name}_cache")

# Slim preamble: no tikz/pgfplots/longtable (diagrams are emitted as comments), so it compiles fast.
# unicode-math supplies \mathbb, \therefore, \hbar etc., so amssymb is intentionally NOT loaded.
LATEX_PREAMBLE = r"""% !TeX program = xelatex
\documentclass[a4paper, 12pt]{article}
\usepackage[a4paper, margin=2.5cm]{geometry}
\usepackage{amsmath, mathtools, cancel}
\usepackage{unicode-math}
\usepackage{fancyhdr}
\setlength{\headheight}{14.5pt}
\pagestyle{fancy}
\fancyhf{}
\lhead{Notes}
\rhead{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\usepackage{graphicx}
\usepackage{microtype}
\usepackage[colorlinks=true, urlcolor=blue, linkcolor=blue]{hyperref}
\allowdisplaybreaks

\begin{document}
"""

SYSTEM_PROMPT = r"""You are an expert physics/maths editor and LaTeX typesetter. You receive photos/scans of HANDWRITTEN, often messy student notes and convert them into clean, textbook-quality LaTeX.

PRIORITIES: (1) mathematical fidelity, (2) scientific clarity, (3) professional typesetting.

READING MESSY HANDWRITING
- Use physical and mathematical context to disambiguate characters (e.g. \nu vs v, \rho vs p, 1 vs l vs |, 0 vs \theta vs \phi, \epsilon vs \varepsilon, x vs \times, minus signs vs dashes).
- Check dimensional consistency and index structure while reading, but NEVER change the author's mathematics, even if it looks wrong. If the source looks erroneous, transcribe it as written and add `% REVIEW: possible error in source - <short reason>`.
- If a symbol or word is genuinely unreadable, give your best reading and add `% REVIEW: unclear in source - <what you read>`. Do not silently guess.
- Ignore scratch work that is clearly crossed out. Ignore page numbers, scan artefacts, shadows and bleed-through from the opposite page.
- Arrows, braces and circled terms linking equations are part of the reasoning: express them with \underbrace/\overbrace, \implies, \Rightarrow, \cancel or short connecting text.
- Margin notes and side calculations: include them as ordinary text at the logical point (prefix side calculations with a short phrase such as "Side note:").

CONTENT RULES
- Preserve every equation, symbol, sign, index, limit, constant, assumption, example and derivation step, in the original order. Do not invent, omit, simplify or reorder.
- Turn fragments into concise, formal sentences when the meaning is clear; never add explanations the notes do not support.
- Use \section/\subsection* only for genuine topic changes. Do not repeat headings that merely continue from a previous page.
- Diagrams: emit `DIAGRAM: <brief factual description>` and nothing else. Do not invent details.
- The first page of a batch may continue a sentence or derivation from the previous page, and the last page may continue on the next; do not close or restart anything artificially.

TYPESETTING
- equation for key single equations, align for chained steps, gather for unrelated displays, multline for long equations; starred forms when numbering is pointless. Short expressions inline.
- Break long equations at operators; align on = or the main relation.
- Use \text{...} for words inside math, \mathrm{d} for differentials, \hbar, \partial, \nabla, \langle\psi|, |\psi\rangle, \mathbb{Z} etc.
- Use only plain LaTeX plus amsmath, mathtools, cancel and unicode-math (do not use \usepackage for anything else, do not use tikz, physics or siunitx commands).

OUTPUT RULES
- Return RAW LaTeX BODY ONLY: no Markdown fences, no commentary, no \documentclass, no \usepackage, no \begin{document}/\end{document}.
- Balance every brace and environment.
- Never summarise, truncate or skip pages."""

# -------------------- Helpers --------------------
def get_api_key() -> str:
    key = None
    if IN_COLAB and userdata is not None:
        try:
            key = userdata.get("GEMINI_API_KEY")
        except Exception:
            key = None
    key = key or os.environ.get("GEMINI_API_KEY")
    if not key:
        import getpass
        key = getpass.getpass("Enter your Google AI Studio API key: ").strip()
    if not key:
        raise RuntimeError("No Gemini API key provided.")
    return key


def ensure_xelatex() -> None:
    if shutil.which("xelatex"):
        return
    if IN_COLAB and shutil.which("apt-get"):
        print("Installing a minimal XeLaTeX toolchain (1-3 min) ...")
        subprocess.run(["apt-get", "update", "-qq"], check=True)
        subprocess.run(
            ["apt-get", "install", "-y", "-qq", "--no-install-recommends",
             "texlive-xetex", "texlive-latex-recommended", "texlive-latex-extra",
             "texlive-fonts-recommended", "texlive-fonts-extra", "lmodern"],
            check=True,
        )
    else:
        raise RuntimeError("xelatex not found. Install a TeX distribution that includes it.")


def clean_model_text(text: str) -> str:
    """Strip Markdown fences and any preamble/document wrappers the model added anyway."""
    if not text:
        return ""
    text = text.strip()
    text = re.sub(r"^```[a-zA-Z]*[ \t]*\n?", "", text)
    text = re.sub(r"\n?```[ \t]*$", "", text)
    text = re.sub(r"^[ \t]*\\(?:documentclass|usepackage)(?:\[[^\]]*\])?\{[^}]*\}[^\n]*$", "", text, flags=re.M)
    text = re.sub(r"\\(?:begin|end)\{document\}", "", text)
    return text.strip()


def lint_latex(text: str) -> list[str]:
    """Cheap local checks for unbalanced braces / environments."""
    body = re.sub(r"(?<!\\)%.*", "", text)
    problems = []
    opens = len(re.findall(r"(?<!\\)\{", body))
    closes = len(re.findall(r"(?<!\\)\}", body))
    if opens != closes:
        problems.append(f"unbalanced braces ({opens} '{{' vs {closes} '}}')")
    begins = Counter(re.findall(r"\\begin\{([^}]+)\}", body))
    ends = Counter(re.findall(r"\\end\{([^}]+)\}", body))
    for env in sorted(set(begins) | set(ends)):
        if begins[env] != ends[env]:
            problems.append(f"environment '{env}': {begins[env]} begin vs {ends[env]} end")
    return problems


def sleep_backoff(attempt: int, base: float = 8.0) -> None:
    time.sleep(base * (2 ** attempt) + random.uniform(0, 3))


# -------------------- Stage 1: transcription --------------------
def cache_file(start: int, end: int) -> Path:
    return cache_dir / f"pages_{start + 1:04d}_{end:04d}.tex"


def render_batch(pdf, start: int, end: int) -> list[bytes]:
    """Render pages to compact, high-contrast JPEG bytes (best for pen-on-paper scans)."""
    out = []
    for i in range(start, end):
        img = pdf[i].render(scale=RENDER_SCALE).to_pil()
        if GRAYSCALE:
            img = ImageOps.autocontrast(img.convert("L"), cutoff=1)
        else:
            img = ImageOps.autocontrast(img.convert("RGB"), cutoff=1)
        img.thumbnail((MAX_SIDE, MAX_SIDE))
        buf = io.BytesIO()
        img.save(buf, format="JPEG", quality=90, optimize=True)
        out.append(buf.getvalue())
        img.close()
    return out


def transcribe_batch(client, pages: list[bytes], start: int, end: int, total: int) -> str | None:
    """Transcribe one batch. Returns cleaned LaTeX or None on failure."""
    cfg_kwargs = dict(system_instruction=SYSTEM_PROMPT, temperature=0.1)
    if HIGH_RES_MEDIA:
        cfg_kwargs["media_resolution"] = types.MediaResolution.MEDIA_RESOLUTION_HIGH
    config = types.GenerateContentConfig(**cfg_kwargs)

    parts: list = []
    for i, data in enumerate(pages):
        parts.append(f"[Page {start + i + 1} of {total}]")
        parts.append(types.Part.from_bytes(data=data, mime_type="image/jpeg"))
    base_instruction = (
        f"Transcribe pages {start + 1}-{end} (of {total}) in order into LaTeX body content. "
        "Return only LaTeX."
    )

    best: str | None = None
    hint = ""
    for attempt in range(TRANSCRIPTION_RETRIES):
        try:
            response = client.models.generate_content(
                model=MODEL, contents=parts + [base_instruction + hint], config=config
            )
            text = clean_model_text(getattr(response, "text", None) or "")
            if not text:
                raise RuntimeError("empty response")
            best = text
            problems = lint_latex(text)
            if not problems:
                return text
            if attempt < TRANSCRIPTION_RETRIES - 1:
                hint = ("\n\nYour previous attempt had LaTeX structure problems: "
                        + "; ".join(problems) + ". Fix them; keep all content.")
                continue
            return text  # last attempt: accept, the patch stage will deal with it
        except Exception as exc:
            if attempt < TRANSCRIPTION_RETRIES - 1:
                tqdm.write(f"⚠️ pages {start + 1}-{end}: {str(exc)[:120]} - retrying")
                sleep_backoff(attempt)
            else:
                tqdm.write(f"❌ pages {start + 1}-{end} failed: {str(exc)[:160]}")
    return best


def transcribe_pdf(client) -> list[tuple[int, int]]:
    """Transcribe all uncached batches in parallel. Returns the list of all batches."""
    cache_dir.mkdir(exist_ok=True)
    with pdfium.PdfDocument(str(pdf_path)) as pdf:
        total = len(pdf)
        batches = [(s, min(s + BATCH_SIZE, total)) for s in range(0, total, BATCH_SIZE)]
        todo = [b for b in batches if FORCE_RETRANSCRIBE or not cache_file(*b).exists()]
        print(f"PDF has {total} pages -> {len(batches)} batches "
              f"({len(batches) - len(todo)} cached, {len(todo)} to do).")
        if not todo:
            return batches

        with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool, \
                tqdm(total=len(todo), desc="Transcribing") as bar:
            futures = {}
            # Render in this thread (pdfium isn't thread-safe) while workers call the API.
            for s, e in todo:
                futures[pool.submit(transcribe_batch, client, render_batch(pdf, s, e), s, e, total)] = (s, e)
            for fut in as_completed(futures):
                s, e = futures[fut]
                try:
                    text = fut.result()
                except Exception as exc:
                    tqdm.write(f"❌ pages {s + 1}-{e}: {exc}")
                    text = None
                if text:
                    cache_file(s, e).write_text(text + "\n", encoding="utf-8")
                bar.update(1)
    return batches


def assemble_tex(batches: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """Join cached batches in page order. Returns batches that are missing."""
    chunks, missing = [LATEX_PREAMBLE], []
    for s, e in batches:
        f = cache_file(s, e)
        if f.exists():
            chunks.append(f.read_text(encoding="utf-8"))
        else:
            missing.append((s, e))
            chunks.append(f"% REVIEW: pages {s + 1}-{e} could not be transcribed.\n"
                          f"\\par\\textbf{{[Pages {s + 1}--{e} not transcribed]}}\n")
    chunks.append("\n\\end{document}\n")
    tex_path.write_text("\n".join(chunks), encoding="utf-8")
    return missing


# -------------------- Stage 2: compile + patch --------------------
def compile_latex() -> tuple[bool, str]:
    """One nonstop XeLaTeX pass (reports every error, not just the first)."""
    pdf_output_path.unlink(missing_ok=True)
    try:
        result = subprocess.run(
            ["xelatex", "-interaction=nonstopmode", str(tex_path)],
            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            check=False, timeout=600, errors="ignore",
        )
        output, code = result.stdout or "", result.returncode
    except subprocess.TimeoutExpired:
        return False, "xelatex timed out"
    for ext in (".aux", ".out"):
        Path(f"{base_name}{ext}").unlink(missing_ok=True)
    return (code == 0 and pdf_output_path.exists()), output


def extract_latex_errors(log: str) -> list[dict]:
    lines = log.splitlines()
    found: dict[int, dict] = {}
    for i, line in enumerate(lines):
        if not line.startswith("!"):
            continue
        context = "\n".join(lines[max(0, i - 1): i + 8])
        for cand in lines[i + 1: i + 10]:
            m = re.match(r"^l\.(\d+)", cand.strip())
            if m:
                found.setdefault(int(m.group(1)), {"line": int(m.group(1)), "log_text": context})
                break
    return sorted(found.values(), key=lambda d: d["line"])


def fix_snippet(client, snippet: str, compiler_messages: str) -> str | None:
    config = types.GenerateContentConfig(temperature=0.0)
    prompt = [
        "You are an expert LaTeX (XeLaTeX, amsmath, mathtools, cancel, unicode-math) debugger. "
        "Fix the errors in the snippet using the compiler feedback. Return the FULL corrected snippet.",
        "Preserve all mathematics and text exactly; only repair structure: unclosed/mismatched environments "
        "or braces, undefined macros (replace with standard equivalents), misplaced & or \\\\, "
        "bad math-mode usage, unescaped special characters.",
        "Output raw LaTeX only. No Markdown fences, no commentary, no preamble or document markers.",
        f"=== COMPILER ERRORS ===\n{compiler_messages}\n\n=== BROKEN SNIPPET ===\n{snippet}",
    ]
    for attempt in range(PATCH_RETRIES):
        try:
            response = client.models.generate_content(model=PATCH_MODEL, contents=prompt, config=config)
            fixed = clean_model_text(getattr(response, "text", None) or "")
            # Guard against the model dropping content.
            if not fixed or len(fixed) < 0.6 * len(snippet.strip()):
                raise RuntimeError("patch too short / empty")
            return fixed + "\n"
        except Exception:
            if attempt < PATCH_RETRIES - 1:
                sleep_backoff(attempt, base=3.0)
    return None


def patch_latex(client) -> bool:
    for iteration in range(1, MAX_PATCH_ITERATIONS + 1):
        print(f"\n--- Compile / patch iteration {iteration} of {MAX_PATCH_ITERATIONS} ---")
        ok, output = compile_latex()
        if ok:
            print("✅ XeLaTeX compilation succeeded.")
            return True

        log = log_path.read_text(encoding="utf-8", errors="ignore") if log_path.exists() else output
        errors = extract_latex_errors(log)
        if not errors:
            print("❌ Compile failed but no line-numbered errors were found. Tail of output:")
            print(output[-3000:])
            return False
        if iteration == MAX_PATCH_ITERATIONS:
            break

        tex_lines = tex_path.read_text(encoding="utf-8").splitlines(keepends=True)
        n = len(tex_lines)

        # Group errors so each patch window is disjoint from the next.
        groups: list[list[dict]] = []
        for err in errors:
            if groups and err["line"] - groups[-1][-1]["line"] <= 2 * PATCH_CONTEXT_LINES + 1:
                groups[-1].append(err)
            else:
                groups.append([err])
        print(f"{len(errors)} error(s) in {len(groups)} region(s); patching in parallel.")

        jobs = []
        for g in groups:
            lo = max(0, g[0]["line"] - 1 - PATCH_CONTEXT_LINES)
            hi = min(n, g[-1]["line"] + PATCH_CONTEXT_LINES)
            jobs.append((lo, hi, "".join(tex_lines[lo:hi]), "\n---\n".join(e["log_text"] for e in g)))

        results = []
        with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
            futs = {pool.submit(fix_snippet, client, sn, msg): (lo, hi) for lo, hi, sn, msg in jobs}
            for fut in tqdm(as_completed(futs), total=len(futs), desc="Patching"):
                lo, hi = futs[fut]
                fixed = fut.result()
                if fixed:
                    results.append((lo, hi, fixed))
                else:
                    tqdm.write(f"⚠️ could not patch lines {lo + 1}-{hi}")

        if not results:
            print("❌ No patches could be generated.")
            return False
        for lo, hi, fixed in sorted(results, reverse=True):  # bottom-up keeps indices valid
            tex_lines[lo:hi] = [fixed]
        tex_path.write_text("".join(tex_lines), encoding="utf-8")

    print("❌ Still failing after the maximum number of patch iterations.")
    return False


def download_outputs() -> None:
    if IN_COLAB and files is not None:
        files.download(str(tex_path))
        if pdf_output_path.exists():
            files.download(str(pdf_output_path))
    else:
        print(f"Saved: {tex_path.resolve()}")
        if pdf_output_path.exists():
            print(f"Saved: {pdf_output_path.resolve()}")


def main() -> None:
    if not pdf_path.is_file():
        print(f"ERROR: '{PDF_FILENAME}' not found in {Path.cwd()}")
        return
    if BATCH_SIZE < 1 or MAX_WORKERS < 1:
        raise ValueError("BATCH_SIZE and MAX_WORKERS must be >= 1.")

    ensure_xelatex()
    client = genai.Client(api_key=get_api_key())

    print("\n=== STAGE 1: TRANSCRIPTION ===")
    batches = transcribe_pdf(client)
    missing = assemble_tex(batches)
    if missing:
        spans = ", ".join(f"{s + 1}-{e}" for s, e in missing)
        print(f"⚠️ Missing pages: {spans}. Re-run the script to retry only these batches.")

    reviews = len(re.findall(r"% REVIEW", tex_path.read_text(encoding="utf-8")))
    if reviews:
        print(f"ℹ️ {reviews} '% REVIEW' flag(s) in the .tex - search for them to check unclear handwriting.")

    print("\n=== STAGE 2: COMPILE + PATCH ===")
    ok = patch_latex(client)
    print("\n✅ Done." if ok and not missing else "\n⚠️ Finished with issues (see messages above).")
    download_outputs()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted. Cached batches are kept; re-run to resume.")

