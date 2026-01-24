# home/modules/browsers/qutebrowser/gemini-config.py
import os
import subprocess
from qutebrowser.api import interceptor

config_path = os.path.expanduser("~/.cache/style/qutebrowser-theme.py")

if os.path.exists(config_path):
    config.source(config_path)

# --- 1. MINIMAL UI ---
config.load_autoconfig(False)
c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36'
c.statusbar.show = 'never'
c.tabs.show = 'never'
c.scrolling.bar = 'never'

config.bind('<Ctrl-d>', 'fake-key <PgDown>', mode='normal')
config.bind('<Ctrl-u>', 'fake-key <PgUp>', mode='normal')

config.bind('<Ctrl-d>', 'fake-key <PgDown>', mode='insert')
config.bind('<Ctrl-u>', 'fake-key <PgUp>', mode='insert')

# --- 2. LOCK NAVIGATION (The Failsafe Way) ---
# Instead of unbinding (which crashes if the key isn't there),
# we bind the keys to 'nop', which means "do nothing".
# This works 100% of the time.

keys_to_disable = ['o', 'O', 'go', 'gO', 'xo', 'xO', 'w', 'B']

for key in keys_to_disable:
    config.bind(key, 'nop')

# --- 3. REDIRECT EXTERNAL LINKS ---
def filter_traffic(info: interceptor.Request):
    if info.resource_type != interceptor.ResourceType.main_frame:
        return

    url = info.request_url
    host = url.host()
    
    allowed_hosts = [
        "gemini.google.com",
        "accounts.google.com",
        "myaccount.google.com",
        "gds.google.com"
    ]

    if any(allowed in host for allowed in allowed_hosts):
        return 

    info.block()
    subprocess.Popen(['qutebrowser', url.toString()])

interceptor.register(filter_traffic)

