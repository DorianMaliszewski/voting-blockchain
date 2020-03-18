# 5BLOC

## Initialisation

truffle unbox pet-shop
touch contracts/Election.sol
truffle migrate



## Migrate existing contracts 

> truffle migrate --reset

## Test in console

truffle console

> Election.deployed().then(function(instance) { app = instance})
> web3.eth.getAccounts()


## Testing

> truffle test

## Connect an account to Metamask

- Go to ganache
- Choose an account to take
- Click on the key icon on the right
- Copy the private key
- Go to Metamask icon
- Click on the top right icon
- Go to "Importer un compte"
- Paste the private key

## Troubleshooting

- ON the frontend : Your Account is null : 
  - Check Metamask configuration :
    - CLick on the icon
    - CLick on the icon top right
    - Go to "Paramètres"
    - Go to "Connections"
    - Check that localhost is allowed or add it by typing "localhost" and click on "Connect"
    - Reload the page