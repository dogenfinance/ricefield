Rice Field
==========

For Dogen team.


Rice Token
----------
Rice token is a regular ownable ERC20 but is not transferable (excluding mint and burn).  
It also keeps track of two addresses (changable by owner)  
- Rice Field
- Rice Market  

Rice Market will be the ERC1155 contract that calls the `spend` function to burn a user's RICE in exchange for an ERC1155.  

Rice Field
----------
An 0.8.0 Sushi fork that farms Rice Token. All the usual bells and whistles

 Truffle Launch instrusctions
-----------------------------
- Install dependancies `npm i`
- Dev wallet setup. Enter your seed phrase into `secrets.json` under mnemonic
- Make sure that dev wallet has BNB for gas
- Config. Change config values in `migrations/2_migrate_contracts.js`
- Deploy testnet `truffle deploy --network bscTest`
- Deploy mainnet `truffle deploy --network bsc`