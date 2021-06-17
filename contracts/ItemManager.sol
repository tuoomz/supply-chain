pragma solidity ^0.6.0;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable{ 

    enum SupplyChainState{Created, Paid, Deilvered}
    
    struct S_Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        address _itemAddress;
        SupplyChainState _state;
    }
    
    mapping(uint => S_Item) public items;
    
    event SupplyChainStep(uint _item_index, uint step, address _itemAddress);

    uint itemIndex;

    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._itemAddress));
        itemIndex ++;
    }
    
    function triggerPayment(uint _itemIndex) public payable {
        Item item = items[_itemIndex]._item;
        require(address(item) == msg.sender, "Only Items are allowed to update themselves");
        require(item.priceInWei() == msg.value, "Exact payment required");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item not avaliable");
    
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[itemIndex]._itemAddress));
    }
    
    function triggerDelivery(uint256 _index) public onlyOwner{ 
        require(items[_index]._state == SupplyChainState.Paid, "Needs to be paid for");
        items[_index]._state = SupplyChainState.Deilvered;
        emit SupplyChainStep(_index, uint(items[_index]._state), address(items[itemIndex]._itemAddress));
    }
}