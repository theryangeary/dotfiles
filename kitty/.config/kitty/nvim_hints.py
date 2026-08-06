import re
import shlex
import traceback

LOG = '/tmp/nvim_hints.log'

def _log(msg):
    with open(LOG, 'a') as f:
        f.write(msg + '\n')

_EXTS = (
    # longer alternatives first to avoid c matching conf/cpp, ex matching exs
    r'proto|swift|scala|bash|fish|scss|sass|yaml|yml|toml|html|'
    r'lock|makefile|dockerfile|'
    r'conf|cfg|ini|log|env|mod|sum|'
    r'java|json|'
    r'jsx|tsx|'
    r'cpp|hpp|'
    r'exs|'
    r'zsh|lua|vim|php|css|sql|'
    r'hcl|'
    r'py|go|js|ts|rb|rs|kt|el|ex|cs|sh|md|txt|tf|mk|'
    r'hpp|h|c'
)
# file.ext or path/to/file.ext or file.ext:line or file.ext:line:col
_FILE_RE = re.compile(
    r'(?:[^\s:\[\]()\'"{}]+/)?' +   # optional path prefix (no brackets/parens)
    r'[^\s:\[\]()\'"{}]{2,}' +      # filename (min 2 chars, no brackets/parens)
    r'\.(?:' + _EXTS + r')' +       # known extension only
    r'(?::\d+(?::\d+)?)?'           # optional :line[:col]
)

def mark(text, args, Mark, extra_cli_args, *a):
    marks = []
    for idx, m in enumerate(_FILE_RE.finditer(text)):
        marks.append(Mark(idx, m.start(), m.end(), m.group(), {}))
    return marks

def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    try:
        m = data['match'][0]
        if not m:
            return

        parts = m.split(':')
        path = parts[0]
        line = parts[1] if len(parts) >= 2 and parts[1].isdigit() else None

        nvim_cmd = ['/opt/homebrew/bin/nvim']
        if line:
            nvim_cmd.append(f'+{line}')
        nvim_cmd.append(path)

        shell_cmd = ' '.join(shlex.quote(a) for a in nvim_cmd)
        boss.set_clipboard_text(m)
        boss.call_remote_control(None, ('launch', '--type=window', '--cwd=current', '--', '/bin/zsh', '-l', '-c', shell_cmd))
    except Exception:
        _log(traceback.format_exc())
