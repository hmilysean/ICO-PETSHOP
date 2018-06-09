pragma solidity ^0.4.16;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

interface token {
    //function getCurrentOwner() returns (address);
    // function transferOwnership(address newOwner);
    function buy(address receiver, uint256 amount) external;
    function checkBalance(address sender, uint256 amount) external returns(bool isEnught);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) ;
}

interface dog {
    function adoptDog(address receiver, unit256 dogCode) external;
}
/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive. The contract requires a MintableToken that will be
 * minted as contributions arrive, note that the crowdsale contract
 * must be owner of the token in order to be able to mint it.
 */
contract DogCrowdsale {
  using SafeMath for uint256;

  // The token being sold
  token public tokenReward;

  address public owner;

  dog public dogMarket;
  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function DogCrowdsale(address _owner,address _token) public {
    require(_token != address(0));
    require(_owner != address(0));
    owner = _owner;
    tokenReward = token(_token);
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyDogs(msg.sender);
  }

  // low level token purchase function
  function buyDogs(address beneficiary) public payable {
    require(beneficiary != address(0));
// 宠物编号
    uint256 dogNum = msg.dogNum;
// 支付费用
    uint256 weiAmount = msg.value*1000;
    uint256 tokens = weiAmount; //getTokenAmount(weiAmount);

    bool IsEnught = tokenReward.checkBalance(beneficiary,tokens);

    if (IsEnught) {
        dogMarket.adoptDog(beneficiary,dogNum);
        tokenReward.transferFrom(beneficiary,owner,tokens);
        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    }
    //forwardFunds();
  }

  // @return true if crowdsale event has ended
  // function hasEnded() public view returns (bool) {
  //   return now > endTime;
  // }

  // Override this method to have a way to add business logic to your crowdsale when buying
  // function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
  //   return weiAmount.mul(rate);
  // }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
//   function validPurchase() internal view returns (bool) {
//     //bool withinPeriod = now >= startTime && now <= endTime;
//     //bool nonZeroPurchase = msg.value != 0;
//     //return withinPeriod && nonZeroPurchase;
//      return true;
//   }

  // function transferOwnership(address _newOwner) public {
  //   require(msg.sender == wallet); // Only the owner of the crowdsale contract should be able to call this function.

  //   // I assume the crowdsale contract holds a reference to the token contract.
  //   tokenReward.transferOwnership(msg.sender);
  // }

}