pragma solidity 0.6.0;
import "./ItemManager.sol";

contract Item {
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    //Create a fallback function that will receive funds with no populated message data.
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        //The transfer function only can do 23000 gas, but they are cases when more is required such as calling a function in a parentContract
        // address(parentContract).transfer(msg.value)
        //As of version 8(i think) you can set the amount of gas you want to use and value is between curly braces.
        (bool success, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasn't successful.");
    }
    
    fallback() external payable {}
}