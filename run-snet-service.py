import pathlib
import subprocess
import signal
import time
import sys
import argparse


def main():
    parser = argparse.ArgumentParser(prog="run-snet-service")
    parser.add_argument("--daemon-config-path-mainnet", help="Path to daemon configuration file for mainnet", required=False)
    parser.add_argument("--daemon-config-path-mainnet-2", help="Path to daemon configuration file for mainnet-2", required=False)
    parser.add_argument("--daemon-config-path-mainnet_3", help="Path to daemon configuration file for mainnet_3", required=True)
    parser.add_argument("--daemon-config-path-ropsten", help="Path to daemon configuration file for ropsten",
                        required=False)
    args = parser.parse_args(sys.argv[1:])
    daemons = {'mainnet':args.daemon_config_path_mainnet,'mainnet-2':args.daemon_config_path_mainnet_2,'mainnet_3':args.daemon_config_path_mainnet_3,'ropsten':args.daemon_config_path_ropsten}
    snetd_p = []

    def handle_signal(signum, frame):
        for i,_ in enumerate(daemons.keys()):
            snetd_p[i].send_signal(signum)
        service_p.send_signal(signum)
        for i,_ in enumerate(daemons.keys()):
            snetd_p[i].wait()
        service_p.wait()
        exit(0)

    signal.signal(signal.SIGTERM, handle_signal)
    signal.signal(signal.SIGINT, handle_signal)

    root_path = pathlib.Path(__file__).absolute().parent.parent
    for daemon in daemons.keys():
        snetd_p.append(start_snetd(root_path, daemons[daemon]))
    service_p = start_service(root_path)

    while True:
        for i, daemon in enumerate(daemons.keys()):
            if snetd_p[i].poll() is not None:
                snetd_p[i] = start_snetd(root_path, daemons[daemon])
        if service_p.poll() is not None:
            service_p = start_service(root_path)
        time.sleep(5)


def start_snetd(cwd, daemon_config_path=None):
    cmd = ["./snetd-linux-amd64"]
    if daemon_config_path is not None:
        if daemon_config_path == 'snet.config.example.mainnet-2.json':
            cmd = ["./snetd-linux-amd64-2"]
            cmd.extend(["--config", daemon_config_path])
        elif daemon_config_path == 'snet.config.example.mainnet_3.json':
            cmd = ["./snetd-linux-amd64-3"]
            cmd.extend(["--config", daemon_config_path])
        else:
            cmd.extend(["--config", daemon_config_path])
    return subprocess.Popen(cmd)


def start_service(cwd):
    return subprocess.Popen(["python3.6", "script.py"])


if __name__ == "__main__":
    main()
