import re

def main(*args):
    print('Main ' + str(args))
    pass

def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    return any(re.search(vim_id, p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)

def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if is_window_vim(window, "zellij"):
        direction = args[1]
        if direction == 'top':
            direction = 'up'
        elif direction == 'bottom':
            direction = 'down'
        window.write_to_child(bytes('zellij action move-focus ' + direction + '\n', 'utf-8'))
        # raise Exception("Zellij not supported yet")  
    
    print('XD ' + str(args))
    boss.active_tab.neighboring_window(args[1])

handle_result.no_ui = True
