import os
import sys
import getopt

CURRENTDIR = os.path.dirname(__file__)
DEPLOYMDIR = os.path.join(CURRENTDIR, "../deployments")

command_helper = """Usage:
  start.py -t <pv|ca|orderer|peer|cli>

Options:
  -h, --help            Get help options.
  -t, --type            Specify type for deploy kubernetes service.
                        (types are pv, ca, orderer, peer, cli)
"""


def start(type):
    all_files = os.listdir(DEPLOYMDIR)
    # filter only matched keyword
    selected_configs = [f for f in all_files if type in f]
    for selected_config in selected_configs:
        run(selected_config)


def run(configure_name):
    os.system("kubectl apply -f " + os.path.join(DEPLOYMDIR, configure_name))


def main(argv):
    try:
        opts, _ = getopt.getopt(sys.argv[1:], "ht:", ["help", "type="])
    except getopt.GetoptError:
        print(command_helper)
        sys.exit(2)

    if len(opts) == 0:
        print(command_helper)
        sys.exit(0)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(command_helper)
            sys.exit(0)
        elif opt in ("-t", "--type"):
            switcher = {
                "pv": "persistent_volume",
                "ca": "deployment_ca",
                "orderer": "deployment_orderer",
                "peer": "deployment_peer",
                "cli": "deployment_cli",
            }
            try:
                start(switcher[arg])
            except:
                print(command_helper)
                sys.exit(1)


main(sys.argv[1:])
