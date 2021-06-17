const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
it("... should let you create new Items.", async () => {
    const itemManagerInstance = await ItemManager.deployed();
    const itemName = "test1";
    const itemPrice = 500;

    const results = await itemManagerInstance.createItem(itemName, itemPrice, { from: accounts[0] });
    console.log("result", results.logs[0].args)
    assert.equal(results.logs[0].args._item_index, 0, "There should be one item index in there")
    const item = await itemManagerInstance.items(0);
    assert.equal(item._identifier, itemName, "The item has a different identifier");
});
});

