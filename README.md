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

 Truffle Launch Instructions
-----------------------------
- Install dependancies `npm i`
- Dev wallet setup. Enter your seed phrase into `secrets.json` under mnemonic
- Make sure that dev wallet has BNB for gas
- Config. Change config values in `migrations/2_migrate_contracts.js`
- Deploy testnet `truffle deploy --network bscTest`
- Deploy mainnet `truffle deploy --network bsc`

Documentation
=============

Rice Token
----------
This is the ERC-20 token for RICE  
Contains all [ERC-20 Functions](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)
As well as [Ownable Functions](https://docs.openzeppelin.com/contracts/2.x/api/ownership)

DEV FUNCTIONS:
The following functions are owner only and only serve to change the addresses of RiceField/RiceMarket in case of a migration
- `setRiceFeild(address)`
- `setRiceMarket(address)`

Rice Field
----------
Is Ownable as defined in these [docs](https://docs.openzeppelin.com/contracts/2.x/api/ownership): 
This is the Rice farm where various LP tokens can be used to farm RICE. This is likely almost identical to master DOG contract.  
- `rice()` returns the RICE token address
- `devaddr()` returns the dev address (NOT THE SAME AS OWNER)
- `bonusEndBlock()` returns the end of the bonus block. No bonus in current deployment
- `ricePerBlock()` returns the number of rice emited pre block
- `BONUS_MULTIPLIER()` returns 10
- `poolInfo()` Returns pool info struct for a particular farming pool. Struct data is defined bellow
- - `lpToken` the address of the LP token for the pool
- - `allocPoint` RICE to distribute per block.
- - `lastRewardBlock` Last block number that RICE distribution occurs.
- - `accRicePerShare` Rice distributed per share of pool times e12
- `userInfo()` Returns struct for a particular user see bellow
- - `amount` How many LP tokens provided by the user
- - `rewardDebt` RICE reward owed to user
- `totalAllocPoint()` sum of allocation points in all pools
- `startBlock()` start of farming
- `poolLength()` returns the number of pools made
- `add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate)` creates a new pool with the allocation points and token specified. Only for owner to call.
- `set(uint256 _pid, uint256 _allocPoint, bool _withUpdate)` changes a pool (PIDs) allocation points only owner
- `setMigrator(IMigratorChef _migrator)` sets migrator contract in case of migration. Only owner
- `migrate(uint256 _pid)` Anyone can call. Migrates a pool according to migrator's rules
- `getMultiplier(uint256 _from, uint256 _to)` returns rewards if BONUS_MULTIPLIER accross blocks
- `pendingRice(uint256 _pid, address _user)` returns the RICE ready to be claimed for a user at a particular pool
- `massUpdatePools()` updates all the pools with rewards
- `updatePool(uint256 _pid)` updates a single pool
- `deposit(uint256 _pid, uint256 _amount)` user calls and deposits LP into a pool to start farming RICE
- `withdraw(uint256 _pid, uint256 _amount)` Withdrawls deposited LP tokens
- `emergencyWithdraw(uint256 _pid)` withdrawls with no rewards in case of emergency
- `dev(address _devaddr)` update the dev address. This is new to Rice Field and the dev gets 10% of farming rewards

Rice Market
-----------
Is Ownable as well. Look above for ownable docs.  
Is also an ERC-1155. Documentation for that is [here](https://docs.openzeppelin.com/contracts/4.x/erc1155)

- `RICE()` Returns RICE contract instance
- `latest()` Returns the latest NFT. As NFT IDs are incremental starting at 1
- `updateURI(string)` Only owner can call. Changes the NFT URI
- `drop(uint128 _ammount, uint _startPrice, uint _endPrice)` only owner can call. Drops new NFT with an amount, start price and end price. Price changes linearly
- `buy(uint ID)` for user to buy an NFT of the set ID by burning rice at the current price. NO APPROVAL required
- `getPrice(uint ID)` returns the current price of an NFT
- `isAvailable(uint ID)` returns true if an NFT is available. False if it's sold out