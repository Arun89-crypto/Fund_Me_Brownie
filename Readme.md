<img src="Brownie%20Fund%20Me%20aa8ab6a55308470182e8349a0ff8e559/main.png" />

# Brownie Fund Me

In this session we will deploy our fund me contract on etherium network with Brownie

### What we have to do in order to download our chainlink packages in our project ?

Because unlike remix here brownie doesn’t know that how to import these packages but brownie does know that from where it can download the packages so we have to specify that in “**brownie-config.yaml**” file

```yaml
dependencies:
  # - <organisation/repo>@<version>
  - smartcontractkit/chainlink-brownie-contracts@1.1.1
compiler:
  solc:
    remappings:
      - "@chainlink=smartcontractkit/chainlink-brownie-contracts@1.1.1"
dotenv: .env
wallets:
  from_key: ${PRIVATE_KEY}
```

## How to deploy our contract on Rinkeby Test Network with our source code visible →

### Manual Method :

![Screenshot 2022-02-09 at 3.36.23 PM.png](Brownie%20Fund%20Me%20aa8ab6a55308470182e8349a0ff8e559/Screenshot_2022-02-09_at_3.36.23_PM.png)

Click “Verify and Publish” and further enter the required details

### Automatic Method :

- Login on etherscan main website
- Generate a API key for verification
- Add API key in your “.env” file
- while publishing your contract write “publish_source” as true Eg:
  ```python
  fund_me = FundMe.deploy({"from": account}, publish_source=True)
  ```

## Now in order to develop our contract we need to have price feed but we are not going to deploy our contract again and again on the Rinkeby chain so we need a mock →

### Here we will see how to use mock contract in development

- Make a folder named “Test” in contracts folder
- Make a contract with name “Mock_anything”
- Now go to Github link → https://github.com/smartcontractkit/chainlink-mix
- find the mock contract which we need
- And paste it in the file made in our test folder
- And import it whenever needed in a file

## Now we have tested our network in local networks and now we need to test it on a virtual Real Blockchain on our system we use a technique called “Mainnet Forking”

- First We need to add our network in brownie-config.yaml file
- We need to setup our account at “Alchemy”

[Login](https://dashboard.alchemyapi.io/)

- Now we need to copy the keys from our application dashboard

![Screenshot 2022-02-12 at 7.43.59 PM.png](Brownie%20Fund%20Me%20aa8ab6a55308470182e8349a0ff8e559/Screenshot_2022-02-12_at_7.43.59_PM.png)

- Add the url to our network adding command

```bash
brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork
=URL_HERE accounts=10 mnemonic=brownie port=8545
```

- Now we can run and deploy both on our mainnet-fork network

### our final brownie config file →

```yaml
dependencies:
  # - <organisation/repo>@<version>
  - smartcontractkit/chainlink-brownie-contracts@1.1.1
compiler:
  solc:
    remappings:
      - "@chainlink=smartcontractkit/chainlink-brownie-contracts@1.1.1"
dotenv: .env
networks:
  rinkeby:
    eth_usd_price_feed: "0x839F42a69Cc24F391DC4F09273f494578653edEC"
    verify: True
  mainnet-fork-dev:
    eth_usd_price_feed: "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419"
    verify: False
  development:
    verify: False
  ganache-local-gui:
    verify: False
wallets:
  from_key: ${PRIVATE_KEY}
```

# 🎉 Our another Brownie contract completed
