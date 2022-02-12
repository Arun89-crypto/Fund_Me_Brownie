from brownie import MockV3Aggregator, accounts, network, config

DECIMALS = 8
STARTING_PRICE = 20000000000
LOCAL_BLOCKCHAIN_ENVS = ["development", "ganache-local-gui"]
FORKED_LOCAL_ENVS = ["mainnet-fork", "mainnet-fork-dev"]


def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVS or network.show_active() in FORKED_LOCAL_ENVS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying mocks.....")
    if(len(MockV3Aggregator)) <= 0:
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {
            "from": get_account()
        })
    print("Mocks deployed.....")
