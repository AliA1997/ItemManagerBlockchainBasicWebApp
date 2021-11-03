const ItemManager = artifacts.require('./ItemManager.sol');

contract("ItemManager", accounts => {
    it("It should be able to add an item", async () => {
        // Works similar to web3 contract instance but is a truffle contract instance
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = 'Test Item';
        const itemPrice = 100;

        const result =  await itemManagerInstance.createItem(itemName, itemPrice, { from: accounts[0] });
        console.log(result.logs[0].args);
        const item = await itemManagerInstance.items(0);
        console.log(result.logs[0].args);
        assert.equal(result.logs[0].args._index, 0, "It not the first item");
        console.log("ITEM:", item);
        assert.equal(item._identifier, itemName, "The identifier was diffeent");
    });
})