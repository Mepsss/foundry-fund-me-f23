// 1) Deploy mocks when wer are on a local anvil chain
// 2) Keep track of contract adress across different chains

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local anvil, we deploy mock
    // otehrwise, we use the real thing
    //create a struct called NetworkConfig with members priceFeed (an adress)
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }
    //states the current network
    NetworkConfig public activeNetWorkConfig;

    //chainid is  a global variable that refers to the current network
    // 11155111 is sepolia (see chainlist.org)
    constructor() {
        if (block.chainid == 11155111) {
            activeNetWorkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetWorkConfig = getMainnetEthConfig();
        } else {
            activeNetWorkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 //from chainlink docs price feed adresses
        });
        return ethConfig;
    }

    //muste be public to be called from the script aka use vm.startBroadcast()
    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetWorkConfig.priceFeed != address(0)) {
            //did i already set a pricefeed?
            return activeNetWorkConfig;
        }
        //price feed adress
        // 1. Deploy Mocks
        // 2. Return the mocks address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
