import re

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut


def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    return any(re.search(vim_id, p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    direction = args[1]
    key_mapping = args[2]
    vim_id = args[3] if len(args) > 3 else "n?vim"

    print(' - Window name: ' + str(window.child.foreground_processes))
    print(' -- Direction: ' + direction)
    print(' -- Key mapping: ' + key_mapping)
    print(' -- Vim ID: ' + vim_id)
    if window is None:
        return
    if is_window_vim(window, vim_id):
        print(vim_id)
        for keymap in key_mapping.split(">"):
            encoded = encode_key_mapping(window, keymap)
            print('\tSequence ' + str(encoded))
            window.write_to_child(encoded)
    elif is_window_vim(window, "zellij"):
        direction = args[1]
        if direction == 'top':
            encoded = encode_key_mapping(window, 'alt+k')
        elif direction == 'bottom':
            encoded = encode_key_mapping(window, 'alt+j')
        elif direction == 'left':
            encoded = encode_key_mapping(window, 'alt+h')
        elif direction == 'right':
            encoded = encode_key_mapping(window, 'alt+l')
        print('\tZellij Sequence ' + str(encoded))
        window.write_to_child(encoded)

        # window.write_to_child(bytes('zellij action move-focus ' + direction + '\n\r', 'utf-8'))
        # env = window.child.final_env()
        # boss.launch('--env ZELLIJ_SESSION_NAME=' + env['ZELLIJ_SESSION_NAME'], 'zellij', 'action move-focus ' + direction + '\n')
    else:
        print('\tMoving window ' + direction)
        boss.active_tab.neighboring_window(direction)
