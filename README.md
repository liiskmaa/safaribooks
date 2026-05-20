# SafariBooks
Download and save your favorite books from [O'Reilly Learning](https://learning.oreilly.com) as EPUB files.  
This is for *personal* and *educational* use only. Please read [O'Reilly's Terms of Service](https://learning.oreilly.com/terms/) before using.

> **This is a fork of [lorenzodifuccia/safaribooks](https://github.com/lorenzodifuccia/safaribooks).** The original project stopped working when O'Reilly shut down their v1 API. This fork fixes that by migrating to the current v2 API, so downloads work again.

If this fork saved you some time, you can buy me a coffee:  
<a href='https://ko-fi.com/jaanek' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi6.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com'/></a>

Support the original author too:  
<a href='https://ko-fi.com/Y8Y0MPEGU' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi6.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com'/></a>

---

## What you need to know first

**Login with email and password no longer works** — O'Reilly changed how their authentication works. The only way to use this tool today is to copy your session cookies from the browser. It takes about 30 seconds and is described below.

---

## Prerequisites

You need these installed on your machine:

- **Python 3.6 or newer** — check with `python3 --version`
- **pip** — usually comes with Python, check with `pip3 --version`
- **Git** — to clone the repo, or just [download the ZIP](https://github.com/lorenzodifuccia/safaribooks/archive/refs/heads/master.zip) instead

**Don't have Python?**
- macOS: install via [Homebrew](https://brew.sh) with `brew install python`, or download from [python.org](https://www.python.org/downloads/)
- Windows: download from [python.org](https://www.python.org/downloads/) — tick "Add Python to PATH" during install
- Linux: `sudo apt install python3 python3-pip` (Debian/Ubuntu) or `sudo dnf install python3` (Fedora)

**[Calibre](https://calibre-ebook.com/)** — a free e-book manager. The `download_book.sh` script uses Calibre's `ebook-convert` tool to automatically convert books after downloading, so Calibre must be installed for it to work. If you use `safaribooks.py` directly without the shell script, Calibre is still recommended — it converts the raw EPUB to a cleaner format that reads much better on Kindles and other e-readers.

---

## Installation

```shell
git clone https://github.com/lorenzodifuccia/safaribooks.git
cd safaribooks/
pip3 install -r requirements.txt
```

That's it. No compilation, no configuration files.

---

## Step 1 — Get your session cookies

You need to be logged in to [learning.oreilly.com](https://learning.oreilly.com) in your browser first.

**Option A — Browser console (quick, works everywhere)**

1. Open [learning.oreilly.com](https://learning.oreilly.com) in your browser
2. Open the developer console (`F12` → Console tab, or right-click → Inspect → Console)
3. Paste and run this:
```javascript
var o={};document.cookie.split(/\s*;\s*/).forEach(function(p){p=p.split(/\s*=\s*/);o[p[0]]=p.splice(1).join('=')});console.log(JSON.stringify(o))
```
4. Copy the output and save it as `cookies.json` in the safaribooks folder

**Option B — Automatic extraction script (Chrome or Firefox)**

```shell
pip3 install browser_cookie3
python3 retrieve_cookies.py
```

This reads cookies directly from your browser. If it says "permission denied" on macOS, go to **System Settings → Privacy & Security → Full Disk Access** and add your Terminal app, then try again.

> **Cookies expire.** If you get an authentication error, just redo this step to refresh `cookies.json`.

---

## Step 2 — Download a book

Find your book on [learning.oreilly.com](https://learning.oreilly.com) and copy the ID from the URL — it's the number at the end:

```
https://learning.oreilly.com/library/view/book-name/9781098166298/
                                                    ↑ this part
```

Then run:

```shell
./download_book.sh BOOK_ID
```

This downloads the book and automatically converts it to a clean EPUB using Calibre. The final file lands in the `Books/` folder.

**If you don't have Calibre installed** and just want the raw download:

```shell
python3 safaribooks.py BOOK_ID
```

#### Options (when using `safaribooks.py` directly)

| Option | What it does |
|---|---|
| `--kindle` | Better formatting for Kindle and other e-readers (prevents tables from overflowing) |
| `--preserve-log` | Keep the log file even if everything went fine |

#### A note on EPUB quality

The raw EPUB from `safaribooks.py` works but has some quirks — CSS and formatting may look off on e-readers. The converted version from `download_book.sh` is cleaner and more compatible. For Kindle specifically, convert to AZW3 or MOBI in Calibre and check "Ignore margins" in the conversion settings:

![Calibre IgnoreMargins](https://github.com/lorenzodifuccia/cloudflare/raw/master/Images/safaribooks/safaribooks_calibre_IgnoreMargins.png)

---

## Troubleshooting

**"Authentication issue" or "book not found"** — Your cookies have expired. Redo Step 1.

**"No module named requests"** — Run `pip3 install -r requirements.txt` first.

**"Operation not permitted" when running retrieve_cookies.py on Mac** — Go to System Settings → Privacy & Security → Full Disk Access and add Terminal.

**Book downloads but images are missing** — This can happen if cookies expire mid-download. Refresh `cookies.json` and run again — already downloaded chapters will be skipped.

---

## Proxies

You can route traffic through a proxy by setting the `HTTPS_PROXY` environment variable, or by enabling the `USE_PROXY` flag inside `safaribooks.py`.

---

For any problems, feel free to open an issue on GitHub.

*Lorenzo Di Fuccia*
