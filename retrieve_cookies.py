import json

# See: https://github.com/lorenzodifuccia/safaribooks/issues/358

try:
    from safaribooks import COOKIES_FILE
except ImportError:
    COOKIES_FILE = "cookies.json"

try:
    import browser_cookie3
except ImportError:
    raise ImportError("Please run this program via: uv run --with browser_cookie3 python retrieve_cookies.py")

BROWSER_LOADERS = [
    ("Chrome",  lambda: browser_cookie3.chrome(domain_name=".oreilly.com")),
    ("Firefox", lambda: browser_cookie3.firefox(domain_name=".oreilly.com")),
    ("Safari",  lambda: browser_cookie3.safari(domain_name=".oreilly.com")),
]

def get_oreilly_cookies():
    for name, loader in BROWSER_LOADERS:
        try:
            cj = loader()
            cookies = {c.name: c.value for c in cj}
            if cookies:
                print(f"Loaded cookies from {name} ({len(cookies)} cookies found)")
                return cookies
            print(f"{name}: no oreilly.com cookies found, trying next browser...")
        except PermissionError as e:
            print(f"{name}: permission denied ({e}), trying next browser...")
        except Exception as e:
            print(f"{name}: failed ({e}), trying next browser...")
    raise RuntimeError(
        "Could not load oreilly.com cookies from any browser.\n"
        "Make sure you are logged in to learning.oreilly.com in Chrome or Firefox,\n"
        "or grant Full Disk Access to Terminal in System Settings → Privacy & Security."
    )

def main():
    cookies = get_oreilly_cookies()
    with open(COOKIES_FILE, "w") as f:
        json.dump(cookies, f)
    print(f"Cookies saved to {COOKIES_FILE}")

if __name__ == "__main__":
    main()