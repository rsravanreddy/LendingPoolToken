pragma solidity ^0.4.11;
/**
 *Token smart contract
 */
import "./lib/SafeMath.sol";
import "./lib/PausableToken.sol";

/**
 * @title LendingPoolToken
 */

contract LendingPoolToken is PausableToken {

    string public constant name = "Lpt";
    string public constant symbol = "LPT";
    uint public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY = 100000000*(10**decimals); // 100 million x 18 decimals to represent in wei

    /**
     * @dev Contructor that gives msg.sender all the  tokens.
     */
    function LendingPoolToken() public {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }
}