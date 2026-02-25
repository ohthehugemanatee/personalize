#!/bin/bash
# Position Edge hover popup near cursor with edge-aware placement.
# Called by sway for_window rule. Popup starts at opacity 0; this script
# moves it beside the cursor and reveals it.
# Default: left of cursor, above. Post-move correction flips if needed.
sleep 0.05
python3 -u - << 'PYEOF'
import json, subprocess

GAP = 8
SEL = '[app_id="^$"]'

def smsg(*a):
    return subprocess.run(['swaymsg', *a], capture_output=True, text=True)

def smsg_json(*a):
    return json.loads(smsg('-r', *a).stdout)

def find_popup(node):
    if node.get('app_id') == '' and 'user_on' in node.get('floating', ''):
        return node
    for c in node.get('nodes', []) + node.get('floating_nodes', []):
        r = find_popup(c)
        if r: return r

tree = smsg_json('-t', 'get_tree')
popup = find_popup(tree)
if not popup:
    exit()

pw = popup['rect']['width']
ph = popup['rect']['height']
dx = pw // 2 + GAP

# Place LEFT of cursor, ABOVE cursor
parts = [f'{SEL} move position cursor', f'move left {dx}px', f'move up {ph // 2 + GAP}px', 'opacity 1']
smsg(', '.join(parts))

# Post-move edge correction: flip if overflowing left/top edge
tree2 = smsg_json('-t', 'get_tree')
outputs = smsg_json('-t', 'get_outputs')
popup2 = find_popup(tree2)
if not popup2:
    exit()

pr = popup2['rect']
px, py = pr['x'], pr['y']

for o in outputs:
    r = o['rect']
    ox, oy, ow, oh = r['x'], r['y'], r['width'], r['height']
    if ox <= px + pw // 2 < ox + ow or px < ox:
        corrections = []
        if px < ox + 4:
            corrections.append(f'{SEL} move right {pw + 2 * GAP}px')
        if py < oy + 4:
            corrections.append(f'{SEL} move down {ph + 2 * GAP}px')
        if corrections:
            smsg(', '.join(corrections))
        break
PYEOF
