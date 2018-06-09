pragma solidity ^0.4.0;

import "truffle/DeployedAddresses.sol";
import "truffle/Assert.sol";
import "../contracts/DogMarket.sol";      // 被测试合约

contract DogMarketTest {
        DogMarket market = DogMarket(DeployedAddresses.DogMarket());

        function testAdopt() public {
            uint petId = uint(11);
            uint dogId = market.adoptDog(petId);
             Assert.equal(petId, dogId, "Owner of pet ID 11.");
        }
}