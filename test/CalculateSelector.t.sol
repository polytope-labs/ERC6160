pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/CalculateSelector.sol";

contract SelectorTest is Test {
    Calculate selectorContract;

    function setUp() public {
        selectorContract = new Calculate();
    }

    function testSelector() public {
        bytes4 IERC6160Ext20Selector = 0xbbb8b47e;
        bytes4 IERC6160Ext721Selector = 0xa75a5a72;
        bytes4 IERC6160Ext1155Selector = 0x9f77104c;

        assertEq(bytes32(selectorContract.calculateSelectorIERC6160Ext20()), bytes32(IERC6160Ext20Selector));
        assertEq(bytes32(selectorContract.calculateSelectorIERC6160Ext721()), bytes32(IERC6160Ext721Selector));
        assertEq(bytes32(selectorContract.calculateSelectorIERC6160Ext1155()), bytes32(IERC6160Ext1155Selector));

        console.logBytes4(selectorContract.calculateSelectorIERC6160Ext20());
        console.logBytes4(selectorContract.calculateSelectorIERC6160Ext721());
        console.logBytes4(selectorContract.calculateSelectorIERC6160Ext1155());
    }
}
