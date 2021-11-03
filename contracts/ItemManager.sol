pragma solidity 0.6.0;
import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    enum SupplyChainState{Created, Paid, Delivered}
    
    struct Supply_Chain_Item {
        //Reference item to be payable
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    mapping(uint => Supply_Chain_Item) public items;
    
    uint numberOfItems;
    
    
    event SupplyChainChange(uint indexed _index, ItemManager.SupplyChainState indexed _state, address indexed _itemAddress);
    
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner {
        Item item = new Item(this, _itemPrice, numberOfItems);
        items[numberOfItems]._item = item;
        items[numberOfItems]._identifier = _identifier;
        items[numberOfItems]._itemPrice = _itemPrice;
        items[numberOfItems]._state = SupplyChainState.Created;
        emit SupplyChainChange(numberOfItems, items[numberOfItems]._state, address(item));
        numberOfItems++;
    }
    
    function triggerPayment(uint _index) public payable onlyOwner {
        require(items[_index]._itemPrice == msg.value, "Can't accept partial payments.");
        require(items[_index]._state == SupplyChainState.Created, "Item is further up the supply chain.");
        
        items[_index]._state = SupplyChainState.Paid;
        emit SupplyChainChange(_index, items[_index]._state, address(items[_index]._item));
    }
    
    function triggerDelivery(uint _index) public onlyOwner {
        require(items[_index]._state == SupplyChainState.Paid, "Item is further up the supply chain.");

        items[_index]._state = SupplyChainState.Delivered;
        emit SupplyChainChange(_index, items[_index]._state, address(items[_index]._item));
    }
}