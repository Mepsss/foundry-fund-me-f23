# About

This is a crowd sourcing app!  
Coded with a LOT of help of Patrick Collins.

- [About](#about)
- [Getting started](#getting-started)
  - [Requirements](#requirements)
  - [Deploy](#deploy)
  - [Testing](#testing)
    - [uint and integration tests](#uint-and-integration-tests)
    - [Test coverage](#test-coverage)
- [Thank you!](#thank-you)


# Getting started

## Requirements
- **git** - [Installation guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
- **foundry** - [Installation guide](https://medium.com/@regodefies/foundry-installation-on-windows-10-309407e39dee)
- **Patrick Collins amazing guide** - [guide](https://www.youtube.com/watch?v=6oFvqLfRnsU&list=PLGgX0nKkYFzLbHjhAgi1qZQ6VWqW1sG1_&index=1)
[![Foundry Full Course part 2](https://img.youtube.com/vi/sas02qSFZ74/0.jpg)](https://www.youtube.com/watch?v=sas02qSFZ74)
Click the image to watch the video.




## Deploy

```
forge scripta/DeployFundMe.s.sol
```

## Testing

### uint and integration tests 
```
//only use this pattern to run single tests, the old one in the video using -m is deprecated
forge test --match-test testFunctionName
```
or
```
//to run all tests
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test coverage
```
forge coverage
```

#Deploying to a testnet or mainnet

1. Setup enviroment variables in .env
2. Get testnet ETH
3. Deploy 
```
//remember to only use worthless private keys this way
forge script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private key $SEPOLIA_PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

#Scripts 

After deploying you can run the scripts. 

Using cast deployed  locally example:
```
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```
or 
```
forge script script/FundFundMe.s.sol --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
```

#Withdraw

```
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>
```


# Thank you!

If you appreciated this, feel free to follow or donate to Patrick Collins for putting out this amazing free course.

Patricks ETH/Arbitrum/Optimism/Polygon/etc Address: 0x9680201d9c93d65a3603d2088d125e955c73BD65

<table>
  <tr>
    <td align="center">
      <a href="https://twitter.com/PatrickAlphaC">
        <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white" alt="Patrick Collins Twitter">
      </a>
    </td>
    <td align="center">
      <a href="https://www.youtube.com/channel/UCn-3f8tw_E1jZvhuHatROwA">
        <img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="Patrick Collins YouTube">
      </a>
    </td>
    <td align="center">
      <a href="https://www.linkedin.com/in/patrickalphac/">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="Patrick Collins LinkedIn">
      </a>
    </td>
    <td align="center">
      <a href="https://medium.com/@patrick.collins_58673/">
        <img src="https://img.shields.io/badge/Medium-000000?style=for-the-badge&logo=medium&logoColor=white" alt="Patrick Collins Medium">
      </a>
    </td>
  </tr>
</table>
