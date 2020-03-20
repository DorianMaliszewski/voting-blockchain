# 5BLOC

## Students that does this project

- Dorian Maliszewski
- Emilien Gauthier
- Aymeric Nosjean
- Antoine Franc
- Frédéric Malphat

## Initialisation

- This is the way of how we initialize the projet
> truffle unbox pet-shop

- Making some codes
> truffle migrate

## Deploy the modification on the application

> truffle migrate --reset

By using the *--reset* option you reset the blockchain too.

## Launching the frontend

> npm run dev

## Migrate existing contracts 

> truffle migrate --reset

## Test in console

- To open a truffle console
> truffle console

- To store the instance of the Election application
> Election.deployed().then(function(instance) { app = instance})

- To get accounts 
> web3.eth.getAccounts()


## Testing

- Make sure you have deployed the last version of the application :
> truffle migrate --reset

- Then test all
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

- On the frontend : 
  - Your Account is null : 
    - Check Metamask configuration :
      - CLick on the icon
      - CLick on the icon top right
      - Go to "Paramètres"
      - Go to "Connections"
      - Check that localhost is allowed or add it by typing "localhost" and click on "Connect"
      - Reload the page
  - You don't have the event that reload the page when submitting a vote :
    - Known issue by Metamask on Chrome : Close the browser and reopen it


## To add

- Retirer des private pour des externals/internals et modifiers