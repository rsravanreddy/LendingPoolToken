pragma solidity ^0.4.18;


import "./Ownable.sol";
import './SafeMath.sol';

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
    using SafeMath for uint256;

    event Pause();
    event Unpause();

    bool public paused = false;
    address public crowdsale;

    /*
    * @dev Freezing certain number of tokens bought during bonus.
    */
    mapping (address => uint256) public frozen;
    uint public unfreezeTimestamp;

    function Pausable() public {
        unfreezeTimestamp = now + 60 days; //default 60 days from contract deploy date as a defensive mechanism. Will be updated once the crowdsale starts.
    }

    function setUnfreezeTimestamp(uint _unfreezeTimestamp) onlyOwner public {
        require(now < _unfreezeTimestamp);
        unfreezeTimestamp = _unfreezeTimestamp;
    }

    function increaseFrozen(address _owner,uint256 _incrementalAmount) public returns (bool)  {
        require(msg.sender == crowdsale || msg.sender == owner);
        require(_incrementalAmount>0);
        frozen[_owner] = frozen[_owner].add(_incrementalAmount);
        return true;
    }

    function decreaseFrozen(address _owner,uint256 _incrementalAmount) public returns (bool)  {
        require(msg.sender == crowdsale || msg.sender == owner);
        require(_incrementalAmount>0);
        frozen[_owner] = frozen[_owner].sub(_incrementalAmount);
        return true;
    }

    function setCrowdsale(address _crowdsale) onlyOwner public {
        crowdsale=_crowdsale;
    }

    /**
     * @dev Modifier to make a function callable only when there are unfrozen tokens.
     */
    modifier frozenTransferCheck(address _to, uint256 _value, uint256 balance) {
        if (now < unfreezeTimestamp){
            require(_value <= balance.sub(frozen[msg.sender]) );
        }
        _;
    }

    modifier frozenTransferFromCheck(address _from, address _to, uint256 _value, uint256 balance) {
        if(now < unfreezeTimestamp) {
            require(_value <= balance.sub(frozen[_from]) );
        }
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused. [Exception: crowdsale contract]
     */
    modifier whenNotPaused() {
        require(!paused || msg.sender == crowdsale);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() onlyOwner whenNotPaused public {
        require(msg.sender != address(0));
        paused = true;
        Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() onlyOwner whenPaused public {
        require(msg.sender != address(0));
        paused = false;
        Unpause();
    }
}
